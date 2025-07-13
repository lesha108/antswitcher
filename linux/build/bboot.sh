#!/bin/sh

source /tools/Xilinx/Vivado/2022.2/settings64.sh
bootgen -image ./boot.bif -o i ./BOOT.bin -log debug
