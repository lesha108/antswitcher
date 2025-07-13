vlib work
vlib activehdl

vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_vip_v1_1_13
vlib activehdl/processing_system7_vip_v1_0_15
vlib activehdl/xil_defaultlib
vlib activehdl/xlconstant_v1_1_7
vlib activehdl/xlslice_v1_0_2
vlib activehdl/axi_lite_ipif_v3_0_4
vlib activehdl/lib_pkg_v1_0_2
vlib activehdl/lib_srl_fifo_v1_0_2
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/axi_uartlite_v2_0_31
vlib activehdl/generic_baseblocks_v2_1_0
vlib activehdl/axi_register_slice_v2_1_27
vlib activehdl/fifo_generator_v13_2_7
vlib activehdl/axi_data_fifo_v2_1_26
vlib activehdl/axi_crossbar_v2_1_28
vlib activehdl/proc_sys_reset_v5_0_13
vlib activehdl/util_vector_logic_v2_0_2
vlib activehdl/axi_protocol_converter_v2_1_27

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_13 activehdl/axi_vip_v1_1_13
vmap processing_system7_vip_v1_0_15 activehdl/processing_system7_vip_v1_0_15
vmap xil_defaultlib activehdl/xil_defaultlib
vmap xlconstant_v1_1_7 activehdl/xlconstant_v1_1_7
vmap xlslice_v1_0_2 activehdl/xlslice_v1_0_2
vmap axi_lite_ipif_v3_0_4 activehdl/axi_lite_ipif_v3_0_4
vmap lib_pkg_v1_0_2 activehdl/lib_pkg_v1_0_2
vmap lib_srl_fifo_v1_0_2 activehdl/lib_srl_fifo_v1_0_2
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap axi_uartlite_v2_0_31 activehdl/axi_uartlite_v2_0_31
vmap generic_baseblocks_v2_1_0 activehdl/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_27 activehdl/axi_register_slice_v2_1_27
vmap fifo_generator_v13_2_7 activehdl/fifo_generator_v13_2_7
vmap axi_data_fifo_v2_1_26 activehdl/axi_data_fifo_v2_1_26
vmap axi_crossbar_v2_1_28 activehdl/axi_crossbar_v2_1_28
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13
vmap util_vector_logic_v2_0_2 activehdl/util_vector_logic_v2_0_2
vmap axi_protocol_converter_v2_1_27 activehdl/axi_protocol_converter_v2_1_27

vlog -work xilinx_vip  -sv2k12 "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
"F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_13  -sv2k12 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_15  -sv2k12 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_processing_system7_0_0/sim/system_bd_processing_system7_0_0.v" \

vlog -work xlconstant_v1_1_7  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/badb/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_xlconstant_0_0/sim/system_bd_xlconstant_0_0.v" \

vlog -work xlslice_v1_0_2  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/11d0/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_xlslice_0_0/sim/system_bd_xlslice_0_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_pkg_v1_0_2 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_31 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/67a1/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/system_bd/ip/system_bd_axi_uartlite_0_0/sim/system_bd_axi_uartlite_0_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_27  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_7  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_7 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_7  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_26  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_28  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_xbar_0/sim/system_bd_xbar_0.v" \

vcom -work proc_sys_reset_v5_0_13 -93  \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/system_bd/ip/system_bd_rst_ps7_0_50M_0/sim/system_bd_rst_ps7_0_50M_0.vhd" \

vlog -work util_vector_logic_v2_0_2  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/3d84/hdl/util_vector_logic_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_0_0/sim/system_bd_util_vector_logic_0_0.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_1_0/sim/system_bd_util_vector_logic_1_0.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_2_0/sim/system_bd_util_vector_logic_2_0.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_0/sim/system_bd_util_vector_logic_3_0.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_1/sim/system_bd_util_vector_logic_3_1.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_2/sim/system_bd_util_vector_logic_3_2.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_3/sim/system_bd_util_vector_logic_3_3.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_4/sim/system_bd_util_vector_logic_3_4.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_3_5/sim/system_bd_util_vector_logic_3_5.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_1_1/sim/system_bd_util_vector_logic_1_1.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_0_1/sim/system_bd_util_vector_logic_0_1.v" \
"../../../bd/system_bd/ip/system_bd_util_vector_logic_10_0/sim/system_bd_util_vector_logic_10_0.v" \
"../../../bd/system_bd/ipshared/64fb/src/seq144.v" \
"../../../bd/system_bd/ipshared/64fb/hdl/sequencerip_v1_0_S00_AXI.v" \
"../../../bd/system_bd/ipshared/64fb/hdl/sequencerip_v1_0.v" \
"../../../bd/system_bd/ip/system_bd_sequencerip_0_0/sim/system_bd_sequencerip_0_0.v" \
"../../../bd/system_bd/sim/system_bd.v" \
"../../../bd/system_bd/ip/system_bd_ad_iobuf_0_0/sim/system_bd_ad_iobuf_0_0.v" \
"../../../bd/system_bd/ip/system_bd_ad_iobuf_1_0/sim/system_bd_ad_iobuf_1_0.v" \

vlog -work axi_protocol_converter_v2_1_27  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../../s9base.gen/sources_1/bd/system_bd/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl" "+incdir+../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl" "+incdir+F:/Xilinx/Vivado/2022.2/data/xilinx_vip/include" \
"../../../bd/system_bd/ip/system_bd_auto_pc_0/sim/system_bd_auto_pc_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

