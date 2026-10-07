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

    def compare(self, value: int, readout: int, field_in: str, field_out: str, size: int):
        for i in range(size):
            try:
                assert self.check_nth_bit(value,i) == self.check_nth_bit(readout, i)
            except AssertionError:
                print(Fore.GREEN)
                print(f"ERROR in bit {i} for IN = {self.check_nth_bit(value,i)}. Loop: (IN/OUT) {field_in}/{field_out}.")
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
        
        self.mapping = dict["registers"]
        
        super().__init__(self.chip)

    def parameters(self, size):
        """ Returns test range for given register size
        """
        return range(2**size)

    def registers(self):
        return [
            # (OUT_reg, OUT_field, IN_reg, IN_field)
            ("OUT0", "TX", "IN0", "RX", self.parameters(2), 2),
            ("OUT0", "GPIO_OUT", "IN0", "GPIO_IN", self.parameters(2), 2),
        ]

bdaq = BDAQCoreTest()
bdaq.loop()