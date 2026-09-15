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

chip = Dut("bdaq_core.yaml")
chip.init()

chip["GPIO1"]["LED"] = 0 
chip["GPIO1"].write()

for i in range(100):
    chip["GPIO1"]["LED"] = i
    chip["GPIO1"].write()
    time.sleep(0.1)
    chip["GPIO2"].read()
    print(chip["GPIO2"]["LOOP_BACK"].tovalue())



""" start = 0
for i in range(10):
    time.sleep(1)

    fifo_data = chip["FIFO"].get_data()
    data_size = len(fifo_data)
    data_gen = np.linspace(start, data_size - 1 + start, data_size, dtype=np.int32)

    comp = fifo_data == data_gen
    logging.info("%s: %.2f Mbits checked. OK?: %s" % (i, float(32 * data_size) / pow(10, 6), comp.all()))
    start += data_size

chip["GPIO1"]["LED"] = 0  # stop data source
chip["GPIO1"].write()

logging.info("Starting speed test ...")

testduration = 10
total_len = 0
tick = 0
tick_old = 0
start_time = time.time()

chip["GPIO1"]["LED"] = 1
chip["GPIO1"].write()

while time.time() - start_time < testduration:
    data = chip["FIFO"].get_data()
    total_len += len(data) * 4 * 8
    time.sleep(0.01)
    tick = int(time.time() - start_time)
    if tick != tick_old:
        logging.info("Time: %f s" % (time.time() - start_time))
        tick_old = tick

chip["GPIO1"]["LED"] = 0x0  # stop data source
chip["GPIO1"].write()

logging.info(
    "Bytes received: %s, average data rate: %s Mbit/s" % (total_len, round((total_len / 1e6 / testduration), 2))
)
 """