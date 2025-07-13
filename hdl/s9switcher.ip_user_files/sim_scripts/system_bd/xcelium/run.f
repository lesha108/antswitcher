-makelib xcelium_lib/xilinx_vip -sv \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "F:/Xilinx/Vivado/2022.2/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xpm -sv \
  "F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "F:/Xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_13 -sv \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ffc2/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_15 -sv \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ee60/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_processing_system7_0_0/sim/system_bd_processing_system7_0_0.v" \
-endlib
-makelib xcelium_lib/xlconstant_v1_1_7 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/badb/hdl/xlconstant_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_xlconstant_0_0/sim/system_bd_xlconstant_0_0.v" \
-endlib
-makelib xcelium_lib/xlslice_v1_0_2 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/11d0/hdl/xlslice_v1_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_xlslice_0_0/sim/system_bd_xlslice_0_0.v" \
-endlib
-makelib xcelium_lib/axi_lite_ipif_v3_0_4 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_pkg_v1_0_2 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_srl_fifo_v1_0_2 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/axi_uartlite_v2_0_31 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/67a1/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_axi_uartlite_0_0/sim/system_bd_axi_uartlite_0_0.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_27 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/f0b4/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_7 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/83df/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_26 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/3111/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_28 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/c40e/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_xbar_0/sim/system_bd_xbar_0.v" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_rst_ps7_0_50M_0/sim/system_bd_rst_ps7_0_50M_0.vhd" \
-endlib
-makelib xcelium_lib/util_vector_logic_v2_0_2 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/3d84/hdl/util_vector_logic_v2_0_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
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
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_27 \
  "../../../../s9base.gen/sources_1/bd/system_bd/ipshared/aeb3/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/system_bd/ip/system_bd_auto_pc_0/sim/system_bd_auto_pc_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

