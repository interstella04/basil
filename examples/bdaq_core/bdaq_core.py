# ------------------------------------------------------------
# SiTCP throughput test
# Reads data for a couple of seconds and displays the data rate
#
# Copyright (c) All rights reserved
# SiLab, Physics Institute, University of Bonn
# ------------------------------------------------------------
#
import logging
import time

import numpy as np

from basil.dut import Dut
import yaml

from colorama import Fore, Back, Style
import re

from dataclasses import dataclass, field

@dataclass(frozen=True)
class LoopCase:
    out_reg: str
    out_field: str
    in_reg: str
    in_field: str
    size: int
    values: list
    bit_names_out: dict = field(default_factory=dict)
    bit_names_in: dict = field(default_factory=dict)

class LoopBackTest():

    def __init__(self, chip):
        self.chip = chip

    def write(self, register: str, field: str, value: int):
        """ Write access.

        :rtype: None
        """

        self.chip[register][field] = value
        self.chip[register].write()

    def read(self, register: str, field: str):
        """ Read access.

        :rtype: int
        """

        self.chip[register].read()
        readout = self.chip[register][field].tovalue()

        return readout

    def compare(self, case: LoopCase, value: int, readout: int):
        for i in range(case.size):
            if self.check_nth_bit(value, i) != self.check_nth_bit(readout, i):
                self.errormessage(case, value, i)

    def errormessage(self, case: LoopCase, value: int, bit: int):
        """ Prints Error Message for each kind of test. With correct mapping on where the error happened.
        """
        raise NotImplementedError
                
    def registers(self):
        """Return an iterable of test cases.
        Each case: (write_register, write_field, read_register, read_field, values)
        """
        raise NotImplementedError

    def loop(self):
        for case in self.registers():
            for value in case.values:
                self.write(case.out_reg, case.out_field, value)
                readout = self.read(case.in_reg, case.in_field)
                self.compare(case, value, readout)
    
        print("Check complete!")

    def check_nth_bit(self, num: int, n: int):
        return (num>>n)&1

class BDAQCoreTest(LoopBackTest):

    def __init__(self):
        self.chip = Dut("bdaq_core.yaml")
        self.chip.init()
        print("Chip initialized !")
        with open("bdaq_core.yaml", "r") as f:
            dict = yaml.safe_load(f)
        
        self.conf = dict["registers"]
        
        super().__init__(self.chip)

    def parameters(self, size):
        """ Returns test range for given register size
        """
        return range(2**size)
        
    def errormessage(self, case: LoopCase, value: int, bit: int):
        """ Constructs Error message. 
        """
        out_label = case.bit_names_out.get(bit, f"{case.out_field}[{bit}]")
        in_label = case.bit_names_in.get(bit, f"{case.in_field}[{bit}]")
        expected = self.check_nth_bit(value, bit)
        print(Fore.GREEN)
        print(f"ERROR: {out_label} -> {in_label}: "
              f"wrote {expected} ({'HIGH' if expected else 'LOW'}), read {1 - expected}")
        print(Style.RESET_ALL)

    def bit_names(self, reg, fld, size):
        """ Small helper function to make registers() more readable
        """
        names = self.wiring.get(f"{reg}.{fld}", [])
        if names and len(names) != size:
            raise ValueError(f"{reg}.{fld}: {len(names)} names for a {size}-bit field")
        return dict(enumerate(names))

    def registers(self):
        """ Returns list with entries like
        (out_name, field_out, in_name, field_in, parameters, size)
        """

        with open("board_connections.yaml") as f:
            self.wiring = yaml.safe_load(f)

        regs = {r["name"]: r for r in self.conf} # 
        cases = []

        for name, out_reg in regs.items():
            m = re.fullmatch(r"OUT(\d+)", name) # See if name matches OUTn pattern if not, m is None and loop continues 
            if not m:
                continue

            in_name = f"IN{m.group(1)}" # returns \d from match
            if in_name not in regs:
                raise KeyError(f"{name} has no matching {in_name} in the YAML")
            in_reg = regs[in_name]

            out_fields = sorted(out_reg["fields"], key=lambda f: f["offset"])
            in_fields = sorted(in_reg["fields"], key=lambda f: f["offset"]) # Sorts fields by offset, to avoid the matching of the GPIO slots being dependant of the order in which they are in the yaml
            assert len(out_fields) == len(in_fields), \
                f"{name} and {in_name} have a different number of fields"
                # test if same number of fields are in IN and OUT, if not then something is missing

            for fo, fi in zip(out_fields, in_fields):
                assert fo["size"] == fi["size"], \
                    f"size mismatch: {name}.{fo['name']} vs {in_name}.{fi['name']}"
                    # Fields must have same size, otherwise something was typed in wrongly
                
                cases.append(LoopCase(
                    out_reg=name, out_field=fo["name"],
                    in_reg=in_name, in_field=fi["name"],
                    size=fo["size"], values=self.parameters(fo["size"]),
                    bit_names_out=self.bit_names(name, fo["name"], fo["size"]),
                    bit_names_in=self.bit_names(in_name, fi["name"], fi["size"]),
                ))
        return cases

bdaq = BDAQCoreTest()
bdaq.loop()