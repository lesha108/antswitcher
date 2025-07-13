//Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2.2 (win64) Build 3788238 Tue Feb 21 20:00:34 MST 2023
//Date        : Fri Apr 25 20:16:39 2025
//Host        : LESHA2023 running 64-bit major release  (build 9200)
//Command     : generate_target system_bd_wrapper.bd
//Design      : system_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_bd_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    Dout_0,
    FAULT_I,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    I2C0_SCL,
    I2C0_SDA,
    LED_D5,
    LED_D6,
    LED_D7,
    LED_D8,
    PTT1_I,
    PTT2_I,
    SPI0_MOSI_O_0,
    SPI0_SCLK_O_0,
    SPI0_SS_O_0,
    a144_O,
    a430_O,
    lna144_O,
    lna430_O,
    pa144_O,
    pa430_O,
    ulite_rx_I_0,
    ulite_tx_O_0);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  output [1:0]Dout_0;
  input FAULT_I;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  inout [0:0]I2C0_SCL;
  inout [0:0]I2C0_SDA;
  output [0:0]LED_D5;
  output [0:0]LED_D6;
  output [0:0]LED_D7;
  output [0:0]LED_D8;
  input PTT1_I;
  input PTT2_I;
  output SPI0_MOSI_O_0;
  output SPI0_SCLK_O_0;
  output SPI0_SS_O_0;
  output [0:0]a144_O;
  output [0:0]a430_O;
  output [0:0]lna144_O;
  output [0:0]lna430_O;
  output [0:0]pa144_O;
  output [0:0]pa430_O;
  input ulite_rx_I_0;
  output ulite_tx_O_0;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire [1:0]Dout_0;
  wire FAULT_I;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [0:0]I2C0_SCL;
  wire [0:0]I2C0_SDA;
  wire [0:0]LED_D5;
  wire [0:0]LED_D6;
  wire [0:0]LED_D7;
  wire [0:0]LED_D8;
  wire PTT1_I;
  wire PTT2_I;
  wire SPI0_MOSI_O_0;
  wire SPI0_SCLK_O_0;
  wire SPI0_SS_O_0;
  wire [0:0]a144_O;
  wire [0:0]a430_O;
  wire [0:0]lna144_O;
  wire [0:0]lna430_O;
  wire [0:0]pa144_O;
  wire [0:0]pa430_O;
  wire ulite_rx_I_0;
  wire ulite_tx_O_0;

  system_bd system_bd_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .Dout_0(Dout_0),
        .FAULT_I(FAULT_I),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .I2C0_SCL(I2C0_SCL),
        .I2C0_SDA(I2C0_SDA),
        .LED_D5(LED_D5),
        .LED_D6(LED_D6),
        .LED_D7(LED_D7),
        .LED_D8(LED_D8),
        .PTT1_I(PTT1_I),
        .PTT2_I(PTT2_I),
        .SPI0_MOSI_O_0(SPI0_MOSI_O_0),
        .SPI0_SCLK_O_0(SPI0_SCLK_O_0),
        .SPI0_SS_O_0(SPI0_SS_O_0),
        .a144_O(a144_O),
        .a430_O(a430_O),
        .lna144_O(lna144_O),
        .lna430_O(lna430_O),
        .pa144_O(pa144_O),
        .pa430_O(pa430_O),
        .ulite_rx_I_0(ulite_rx_I_0),
        .ulite_tx_O_0(ulite_tx_O_0));
endmodule
