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

class BDAQCoreTest():

    def __init__(self):
        self.chip = Dut("bdaq_core.yaml")
        self.chip.init()
        print("Chip initialized !")

    def test_lemo_connectors(self):
        print("Starting Lemo Loop Back ...")

        for i in range(4):
            try:
                self.chip["GPIO_TXI"]["TXI"] = i
                self.chip["GPIO_TXI"].write()
                self.chip["GPIO_TXI"].read()
                print(self.chip["GPIO_TXI"]["TXI"].tovalue())
                self.chip["GPIO_RXI"].read()
                print(self.chip["GPIO_RXI"]["RXI"].tovalue())
            except:
                pass

    def LED_Test(self):
        print("LED Test")

        for i in range(20):
            self.chip["GPIO1"]["LED"] = i
            self.chip["GPIO1"].write()
            time.sleep(0.1)

        return

    def run(self):
        self.LED_Test()
        self.test_lemo_connectors()
        return


bdaq = BDAQCoreTest()
bdaq.run()