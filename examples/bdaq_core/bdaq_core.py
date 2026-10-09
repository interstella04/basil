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

    def compare(self, value: int, readout: int, field_out: str, field_in: str, size: int):
        for i in range(size):
            try:
                assert self.check_nth_bit(value,i) == self.check_nth_bit(readout, i)
            except AssertionError:
                print(Fore.GREEN)
                print(f"ERROR for IN = {self.check_nth_bit(value,i)}. Loop: (OUT/IN) {field_out}/{field_in}.")
                print(Style.RESET_ALL)
                
    def registers(self):
        """Return an iterable of test cases.
        Each case: (write_register, write_field, read_register, read_field, values)
        """
        raise NotImplementedError

    def loop(self):
        for write_reg, write_field, read_reg, read_field, values, size in self.registers():
            for value in values:
                self.write(write_reg, write_field, value)
                readout = self.read(read_reg, read_field)
                self.compare(value, readout, write_field, read_field, size)

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

    def registers(self):
        """ Returns list with entries like
        (out_name, field_out, in_name, field_in, parameters, size)
        """
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
                cases.append((
                    name, fo["name"],
                    in_name, fi["name"],
                    self.parameters(fo["size"]),
                    fo["size"],
                ))

        return cases

bdaq = BDAQCoreTest()
bdaq.loop()