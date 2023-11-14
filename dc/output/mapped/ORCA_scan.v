/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : R-2020.09-SP5-4
// Date      : Fri Oct 20 18:49:21 2023
/////////////////////////////////////////////////////////////


module CLKMUX ( FAST_CLK, SLOW_CLK, SEL, TESTMODE, BYPASS, CLK );
  input FAST_CLK, SLOW_CLK, SEL, TESTMODE, BYPASS;
  output CLK;
  wire   N0, N1, SLOW_EN, N2, FAST_EN, N3, N4, GATE_CLK, N5, N6, N7, N8, N9,
         N10, N11;

  \**SEQGEN**  FAST_EN_reg ( .clear(1'b0), .preset(1'b0), .next_state(N2), 
        .clocked_on(N1), .data_in(1'b0), .enable(1'b0), .Q(FAST_EN), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  SLOW_EN_reg ( .clear(1'b0), .preset(1'b0), .next_state(N4), 
        .clocked_on(N3), .data_in(1'b0), .enable(1'b0), .Q(SLOW_EN), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  SELECT_OP C19 ( .DATA1(SLOW_CLK), .DATA2(GATE_CLK), .CONTROL1(N0), 
        .CONTROL2(N6), .Z(CLK) );
  GTECH_BUF B_0 ( .A(N5), .Z(N0) );
  GTECH_NOT I_0 ( .A(FAST_CLK), .Z(N1) );
  GTECH_AND2 C23 ( .A(SEL), .B(N7), .Z(N2) );
  GTECH_NOT I_1 ( .A(SLOW_EN), .Z(N7) );
  GTECH_NOT I_2 ( .A(SLOW_CLK), .Z(N3) );
  GTECH_AND2 C26 ( .A(N8), .B(N9), .Z(N4) );
  GTECH_NOT I_3 ( .A(SEL), .Z(N8) );
  GTECH_NOT I_4 ( .A(FAST_EN), .Z(N9) );
  GTECH_OR2 C29 ( .A(N10), .B(N11), .Z(GATE_CLK) );
  GTECH_AND2 C30 ( .A(FAST_CLK), .B(FAST_EN), .Z(N10) );
  GTECH_AND2 C31 ( .A(SLOW_CLK), .B(SLOW_EN), .Z(N11) );
  GTECH_AND2 C32 ( .A(TESTMODE), .B(BYPASS), .Z(N5) );
  GTECH_NOT I_5 ( .A(N5), .Z(N6) );
endmodule


module CLOCK_GEN ( pclk, sdram_clk, sys_clk, sys_clk_fb, pclk_fb, sdram_clk_fb, 
        test_mode, scan_enable, pll_bypass, powersave, o_pclk, o_sdram_clk, 
        o_sys_clk, o_sys_2x_clk );
  input pclk, sdram_clk, sys_clk, sys_clk_fb, pclk_fb, sdram_clk_fb, test_mode,
         scan_enable, pll_bypass, powersave;
  output o_pclk, o_sdram_clk, o_sys_clk, o_sys_2x_clk;
  wire   N0, N1, N2, N3, N4, N5, net_pclk, net_sdram_clk, net_sys_clk,
         net_sys_2x_clk, N6, net_ps_sys_2x_clk, N7, dft_pclk, dft_sdram_clk,
         N8;
  wire   [0:1] PLL_CLKSEL;

  PLL I_PLL_PCI ( .REF_CLK(pclk), .FB_CLK(pclk_fb), .CLK_1X(net_pclk) );
  PLL I_PLL_SD ( .REF_CLK(sdram_clk), .FB_CLK(sdram_clk_fb), .CLK_1X(
        net_sdram_clk) );
  PLL I_CLKMUL ( .REF_CLK(sys_clk), .FB_CLK(sys_clk_fb), .CLK_1X(net_sys_clk), 
        .CLK_2X(net_sys_2x_clk) );
  \**SEQGEN**  PLL_CLKSEL_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        1'b0), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        PLL_CLKSEL[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(pll_bypass) );
  \**SEQGEN**  PLL_CLKSEL_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        1'b0), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        PLL_CLKSEL[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(pll_bypass) );
  CLKMUX I_PCI_CLKMUX ( .FAST_CLK(net_pclk), .SLOW_CLK(pclk), .SEL(
        PLL_CLKSEL[0]), .TESTMODE(test_mode), .BYPASS(pll_bypass), .CLK(
        dft_pclk) );
  CLKMUX I_SDR_CLKMUX ( .FAST_CLK(net_sdram_clk), .SLOW_CLK(sdram_clk), .SEL(
        PLL_CLKSEL[1]), .TESTMODE(test_mode), .BYPASS(pll_bypass), .CLK(
        dft_sdram_clk) );
  GTECH_NOT I_0 ( .A(pll_bypass), .Z(N8) );
  SELECT_OP C50 ( .DATA1(net_sys_clk), .DATA2(net_sys_2x_clk), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(net_ps_sys_2x_clk) );
  GTECH_BUF B_0 ( .A(powersave), .Z(N0) );
  GTECH_BUF B_1 ( .A(N6), .Z(N1) );
  SELECT_OP C51 ( .DATA1(sys_clk), .DATA2(net_sys_clk), .CONTROL1(N2), 
        .CONTROL2(N3), .Z(o_sys_clk) );
  GTECH_BUF B_2 ( .A(test_mode), .Z(N2) );
  GTECH_BUF B_3 ( .A(N7), .Z(N3) );
  SELECT_OP C52 ( .DATA1(sys_clk), .DATA2(net_ps_sys_2x_clk), .CONTROL1(N2), 
        .CONTROL2(N3), .Z(o_sys_2x_clk) );
  SELECT_OP C53 ( .DATA1(net_pclk), .DATA2(dft_pclk), .CONTROL1(N4), 
        .CONTROL2(N5), .Z(o_pclk) );
  GTECH_BUF B_4 ( .A(N8), .Z(N4) );
  GTECH_BUF B_5 ( .A(pll_bypass), .Z(N5) );
  SELECT_OP C54 ( .DATA1(net_sdram_clk), .DATA2(dft_sdram_clk), .CONTROL1(N4), 
        .CONTROL2(N5), .Z(o_sdram_clk) );
  GTECH_NOT I_1 ( .A(powersave), .Z(N6) );
  GTECH_NOT I_2 ( .A(test_mode), .Z(N7) );
endmodule


module RESET_BLOCK ( pclk, sys_clk, sys_2x_clk, sdram_clk, prst_n, test_mode, 
        pci_rst_n, sdram_rst_n, sys_rst_n, sys_2x_rst_n );
  input pclk, sys_clk, sys_2x_clk, sdram_clk, prst_n, test_mode;
  output pci_rst_n, sdram_rst_n, sys_rst_n, sys_2x_rst_n;
  wire   N0, N1, prst_ff, pci_rst_n_buf, sdram_rst_ff, sdram_rst_n_buf,
         sys_rst_ff, sys_rst_n_buf, sys_2x_rst_ff, sys_2x_rst_n_buf, N2, N3;

  \**SEQGEN**  pci_rst_n_buf_reg ( .clear(N2), .preset(1'b0), .next_state(
        prst_ff), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pci_rst_n_buf), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  prst_ff_reg ( .clear(N2), .preset(1'b0), .next_state(1'b1), 
        .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(prst_ff), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sdram_rst_n_buf_reg ( .clear(N2), .preset(1'b0), .next_state(
        sdram_rst_ff), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sdram_rst_n_buf), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sdram_rst_ff_reg ( .clear(N2), .preset(1'b0), .next_state(1'b1), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sdram_rst_ff), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sys_rst_n_buf_reg ( .clear(N2), .preset(1'b0), .next_state(
        sys_rst_ff), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sys_rst_n_buf), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sys_rst_ff_reg ( .clear(N2), .preset(1'b0), .next_state(1'b1), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(sys_rst_ff), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sys_2x_rst_n_buf_reg ( .clear(N2), .preset(1'b0), .next_state(
        sys_2x_rst_ff), .clocked_on(sys_2x_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sys_2x_rst_n_buf), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sys_2x_rst_ff_reg ( .clear(N2), .preset(1'b0), .next_state(1'b1), .clocked_on(sys_2x_clk), .data_in(1'b0), .enable(1'b0), .Q(sys_2x_rst_ff), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(prst_n), .Z(N2) );
  GTECH_NOT I_1 ( .A(test_mode), .Z(N3) );
  SELECT_OP C73 ( .DATA1(pci_rst_n_buf), .DATA2(prst_n), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(pci_rst_n) );
  GTECH_BUF B_0 ( .A(N3), .Z(N0) );
  GTECH_BUF B_1 ( .A(test_mode), .Z(N1) );
  SELECT_OP C74 ( .DATA1(sdram_rst_n_buf), .DATA2(prst_n), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(sdram_rst_n) );
  SELECT_OP C75 ( .DATA1(sys_rst_n_buf), .DATA2(prst_n), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(sys_rst_n) );
  SELECT_OP C76 ( .DATA1(sys_2x_rst_n_buf), .DATA2(prst_n), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(sys_2x_rst_n) );
endmodule


module PCI_CORE ( pclk, pci_rst_n, pidsel, pgnt_n, pad_in, pad_out, pad_en, 
        ppar_in, ppar_out, ppar_en, pc_be_in, pc_be_out, pc_be_en, pframe_n_in, 
        pframe_n_out, pframe_n_en, ptrdy_n_in, ptrdy_n_out, ptrdy_n_en, 
        pirdy_n_in, pirdy_n_out, pirdy_n_en, pdevsel_n_in, pdevsel_n_out, 
        pdevsel_n_en, pstop_n_in, pstop_n_out, pstop_n_en, pperr_n_in, 
        pperr_n_out, pperr_n_en, pserr_n_in, pserr_n_out, pserr_n_en, preq_n, 
        pm66en, read_data, write_data, read_push, read_full, write_pop, 
        write_empty, cmd_valid, cmd, cmd_in_valid, cmd_in );
  input [15:0] pad_in;
  output [15:0] pad_out;
  input [3:0] pc_be_in;
  output [3:0] pc_be_out;
  output [31:0] read_data;
  input [31:0] write_data;
  output [3:0] cmd;
  input [3:0] cmd_in;
  input pclk, pci_rst_n, pidsel, pgnt_n, ppar_in, pframe_n_in, ptrdy_n_in,
         pirdy_n_in, pdevsel_n_in, pstop_n_in, pperr_n_in, pserr_n_in, pm66en,
         read_full, write_empty, cmd_in_valid;
  output pad_en, ppar_out, ppar_en, pc_be_en, pframe_n_out, pframe_n_en,
         ptrdy_n_out, ptrdy_n_en, pirdy_n_out, pirdy_n_en, pdevsel_n_out,
         pdevsel_n_en, pstop_n_out, pstop_n_en, pperr_n_out, pperr_n_en,
         pserr_n_out, pserr_n_en, preq_n, read_push, write_pop, cmd_valid;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, d_out_p_bus_0, N24, N25, N26,
         N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40,
         N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54,
         N55, N56, N57, N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68,
         N69, N70, N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82,
         N83, N84, N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96,
         N97, N98, N99, N100, N101, N102, N103, N104, N105, N106, N107, N108,
         N109, N110, N111, N112, N113, N114, N115, N116, N117, N118, N119,
         N120, N121, N122, N123, N124, N125, N126, N127, N128, N129, N130,
         N131, N132, N133, N134, N135, N136, N137, N138, N139, N140, N141,
         N142, N143, N144, N145, N146, N147, N148, N149, N150, N151, N152,
         N153, N154, N155, N156, N157, N158, N159, N160, N161, N162, N163,
         N164, N165, N166, N167, N168, N169, N170, N171, N172, N173, N174,
         N175, N176, N177, N178, N179, N180, N181, N182, N183, N184, N185,
         N186, N187, N188, N189, N190, N191, N192, N193, N194, N195, N196,
         N197, N198, N199, N200, N201, N202, N203, N204, N205, N206, N207,
         N208, N209, N210, N211, N212, N213, N214, N215, N216, N217, N218,
         N219, N220, N221, N222, N223, N224, N225, N226, N227, N228, N229,
         N230, N231, N232, N233, N234, N235, N236, N237, N238, N239, N240,
         N241, N242, N243, N244, N245, N246, N247, N248, N249, N250, N251,
         N252, N253;
  wire   [3:3] d_out_p_bus;
  wire   [31:0] mega_shift;

  \**SEQGEN**  pad_en_reg ( .clear(N251), .preset(1'b0), .next_state(N24), 
        .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pad_en), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  pc_be_en_reg ( .clear(N251), .preset(1'b0), .next_state(N25), 
        .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pc_be_en), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  GTECH_OR2 C22 ( .A(N43), .B(N47), .Z(N26) );
  GTECH_OR2 C23 ( .A(pc_be_in[1]), .B(pc_be_in[0]), .Z(N27) );
  GTECH_OR2 C24 ( .A(N26), .B(N27), .Z(N28) );
  GTECH_OR2 C28 ( .A(pc_be_in[3]), .B(pc_be_in[2]), .Z(N30) );
  GTECH_OR2 C29 ( .A(N48), .B(N44), .Z(N31) );
  GTECH_OR2 C30 ( .A(N30), .B(N31), .Z(N32) );
  GTECH_OR2 C34 ( .A(N43), .B(pc_be_in[2]), .Z(N34) );
  GTECH_OR2 C35 ( .A(N48), .B(pc_be_in[0]), .Z(N35) );
  GTECH_OR2 C36 ( .A(N34), .B(N35), .Z(N36) );
  GTECH_OR2 C40 ( .A(pc_be_in[3]), .B(N47), .Z(N38) );
  GTECH_OR2 C41 ( .A(pc_be_in[1]), .B(N44), .Z(N39) );
  GTECH_OR2 C42 ( .A(N38), .B(N39), .Z(N40) );
  GTECH_AND2 C44 ( .A(pc_be_in[3]), .B(pc_be_in[0]), .Z(N42) );
  GTECH_AND2 C47 ( .A(N43), .B(N44), .Z(N45) );
  GTECH_AND2 C48 ( .A(pc_be_in[2]), .B(pc_be_in[1]), .Z(N46) );
  GTECH_AND2 C51 ( .A(N47), .B(N48), .Z(N49) );
  GTECH_OR2 C105 ( .A(cmd_in[2]), .B(N68), .Z(N51) );
  GTECH_OR2 C106 ( .A(N58), .B(N73), .Z(N52) );
  GTECH_OR2 C107 ( .A(N51), .B(cmd_in[0]), .Z(N53) );
  GTECH_OR2 C108 ( .A(N52), .B(N53), .Z(N54) );
  GTECH_OR2 C121 ( .A(N90), .B(N70), .Z(N56) );
  GTECH_OR2 C129 ( .A(read_full), .B(N88), .Z(N58) );
  GTECH_OR2 C132 ( .A(N58), .B(N82), .Z(N59) );
  GTECH_OR2 C134 ( .A(N59), .B(N70), .Z(N60) );
  GTECH_AND2 C136 ( .A(read_full), .B(write_empty), .Z(N62) );
  GTECH_AND2 C137 ( .A(cmd_in_valid), .B(cmd_in[3]), .Z(N63) );
  GTECH_AND2 C138 ( .A(cmd_in[2]), .B(cmd_in[1]), .Z(N64) );
  GTECH_AND2 C139 ( .A(N62), .B(N63), .Z(N65) );
  GTECH_AND2 C140 ( .A(N64), .B(cmd_in[0]), .Z(N66) );
  GTECH_AND2 C141 ( .A(N65), .B(N66), .Z(N67) );
  GTECH_OR2 C149 ( .A(N95), .B(N68), .Z(N69) );
  GTECH_OR2 C151 ( .A(N69), .B(N96), .Z(N70) );
  GTECH_OR2 C152 ( .A(N100), .B(N70), .Z(N71) );
  GTECH_OR2 C158 ( .A(cmd_in_valid), .B(N81), .Z(N73) );
  GTECH_OR2 C160 ( .A(N97), .B(N73), .Z(N74) );
  GTECH_OR2 C162 ( .A(N74), .B(N85), .Z(N75) );
  GTECH_OR2 C167 ( .A(cmd_in_valid), .B(cmd_in[3]), .Z(N77) );
  GTECH_OR2 C169 ( .A(N97), .B(N77), .Z(N78) );
  GTECH_OR2 C171 ( .A(N78), .B(N85), .Z(N79) );
  GTECH_OR2 C178 ( .A(N94), .B(N81), .Z(N82) );
  GTECH_OR2 C179 ( .A(cmd_in[2]), .B(cmd_in[1]), .Z(N83) );
  GTECH_OR2 C180 ( .A(N97), .B(N82), .Z(N84) );
  GTECH_OR2 C181 ( .A(N83), .B(N96), .Z(N85) );
  GTECH_OR2 C182 ( .A(N84), .B(N85), .Z(N86) );
  GTECH_OR2 C189 ( .A(N93), .B(N88), .Z(N89) );
  GTECH_OR2 C192 ( .A(N89), .B(N98), .Z(N90) );
  GTECH_OR2 C194 ( .A(N90), .B(N101), .Z(N91) );
  GTECH_OR2 C200 ( .A(N93), .B(write_empty), .Z(N97) );
  GTECH_OR2 C201 ( .A(N94), .B(cmd_in[3]), .Z(N98) );
  GTECH_OR2 C202 ( .A(N95), .B(cmd_in[1]), .Z(N99) );
  GTECH_OR2 C203 ( .A(N97), .B(N98), .Z(N100) );
  GTECH_OR2 C204 ( .A(N99), .B(N96), .Z(N101) );
  GTECH_OR2 C205 ( .A(N100), .B(N101), .Z(N102) );
  \**SEQGEN**  d_out_p_bus_reg_22_ ( .clear(N251), .preset(1'b0), .next_state(
        N136), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pc_be_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_21_ ( .clear(N251), .preset(1'b0), .next_state(
        N135), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pc_be_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_20_ ( .clear(N251), .preset(1'b0), .next_state(
        N134), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pc_be_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_19_ ( .clear(N251), .preset(1'b0), .next_state(
        N133), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pc_be_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_18_ ( .clear(N251), .preset(1'b0), .next_state(
        N132), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(preq_n), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_17_ ( .clear(N251), .preset(1'b0), .next_state(
        N131), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pserr_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_16_ ( .clear(N251), .preset(1'b0), .next_state(
        N130), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pserr_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_15_ ( .clear(N251), .preset(1'b0), .next_state(
        N129), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pperr_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_14_ ( .clear(N251), .preset(1'b0), .next_state(
        N128), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pperr_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_13_ ( .clear(N251), .preset(1'b0), .next_state(
        N127), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pstop_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_12_ ( .clear(N251), .preset(1'b0), .next_state(
        N126), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pstop_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_11_ ( .clear(N251), .preset(1'b0), .next_state(
        N125), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pdevsel_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_10_ ( .clear(N251), .preset(1'b0), .next_state(
        N124), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pdevsel_n_out), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_9_ ( .clear(N251), .preset(1'b0), .next_state(
        N123), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(pirdy_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_8_ ( .clear(N251), .preset(1'b0), .next_state(
        N122), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pirdy_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_7_ ( .clear(N251), .preset(1'b0), .next_state(
        N121), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(ptrdy_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_6_ ( .clear(N251), .preset(1'b0), .next_state(
        N120), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        ptrdy_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_5_ ( .clear(N251), .preset(1'b0), .next_state(
        N119), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pframe_n_en), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_4_ ( .clear(N251), .preset(1'b0), .next_state(
        N118), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pframe_n_out), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_3_ ( .clear(N251), .preset(1'b0), .next_state(
        N117), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        d_out_p_bus[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_2_ ( .clear(N251), .preset(1'b0), .next_state(
        N116), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(ppar_en), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_1_ ( .clear(N251), .preset(1'b0), .next_state(
        N115), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(ppar_out), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_p_bus_reg_0_ ( .clear(N251), .preset(1'b0), .next_state(
        N114), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        d_out_p_bus_0), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_AND2 C312 ( .A(ppar_in), .B(pstop_n_in), .Z(N137) );
  GTECH_OR2 C323 ( .A(N188), .B(N163), .Z(N139) );
  GTECH_OR2 C324 ( .A(N164), .B(N156), .Z(N140) );
  GTECH_OR2 C325 ( .A(N139), .B(N140), .Z(N141) );
  GTECH_OR2 C326 ( .A(N141), .B(pm66en), .Z(N142) );
  GTECH_OR2 C335 ( .A(N182), .B(N171), .Z(N144) );
  GTECH_OR2 C336 ( .A(N172), .B(N183), .Z(N145) );
  GTECH_OR2 C339 ( .A(N144), .B(N145), .Z(N146) );
  GTECH_OR2 C341 ( .A(N146), .B(N150), .Z(N147) );
  GTECH_OR2 C342 ( .A(N147), .B(pm66en), .Z(N148) );
  GTECH_OR2 C355 ( .A(N164), .B(N191), .Z(N150) );
  GTECH_OR2 C356 ( .A(N192), .B(N150), .Z(N151) );
  GTECH_OR2 C357 ( .A(N151), .B(N187), .Z(N152) );
  GTECH_OR2 C365 ( .A(N172), .B(ptrdy_n_in), .Z(N154) );
  GTECH_OR2 C366 ( .A(N173), .B(N184), .Z(N155) );
  GTECH_OR2 C367 ( .A(pperr_n_in), .B(N186), .Z(N156) );
  GTECH_OR2 C368 ( .A(N188), .B(N154), .Z(N157) );
  GTECH_OR2 C369 ( .A(N155), .B(N156), .Z(N158) );
  GTECH_OR2 C370 ( .A(N157), .B(N158), .Z(N159) );
  GTECH_OR2 C371 ( .A(N159), .B(pm66en), .Z(N160) );
  GTECH_OR2 C374 ( .A(pidsel), .B(pgnt_n), .Z(N162) );
  GTECH_OR2 C375 ( .A(pframe_n_in), .B(ptrdy_n_in), .Z(N163) );
  GTECH_OR2 C376 ( .A(N173), .B(pdevsel_n_in), .Z(N164) );
  GTECH_OR2 C377 ( .A(pperr_n_in), .B(pserr_n_in), .Z(N165) );
  GTECH_OR2 C378 ( .A(N162), .B(N163), .Z(N166) );
  GTECH_OR2 C379 ( .A(N164), .B(N165), .Z(N167) );
  GTECH_OR2 C380 ( .A(N166), .B(N167), .Z(N168) );
  GTECH_OR2 C381 ( .A(N168), .B(pm66en), .Z(N169) );
  GTECH_AND2 C392 ( .A(N182), .B(N171), .Z(N174) );
  GTECH_AND2 C393 ( .A(N172), .B(N183), .Z(N175) );
  GTECH_AND2 C394 ( .A(N173), .B(N184), .Z(N176) );
  GTECH_AND2 C395 ( .A(N185), .B(N186), .Z(N177) );
  GTECH_AND2 C396 ( .A(N174), .B(N175), .Z(N178) );
  GTECH_AND2 C397 ( .A(N176), .B(N177), .Z(N179) );
  GTECH_AND2 C398 ( .A(N178), .B(N179), .Z(N180) );
  GTECH_AND2 C399 ( .A(N180), .B(N187), .Z(N181) );
  GTECH_OR2 C406 ( .A(N182), .B(pgnt_n), .Z(N188) );
  GTECH_OR2 C407 ( .A(pframe_n_in), .B(N183), .Z(N189) );
  GTECH_OR2 C408 ( .A(pirdy_n_in), .B(N184), .Z(N190) );
  GTECH_OR2 C409 ( .A(N185), .B(N186), .Z(N191) );
  GTECH_OR2 C410 ( .A(N188), .B(N189), .Z(N192) );
  GTECH_OR2 C411 ( .A(N190), .B(N191), .Z(N193) );
  GTECH_OR2 C412 ( .A(N192), .B(N193), .Z(N194) );
  GTECH_OR2 C413 ( .A(N194), .B(N187), .Z(N195) );
  \**SEQGEN**  d_out_i_bus_reg_6_ ( .clear(N251), .preset(1'b0), .next_state(
        N217), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(cmd[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_5_ ( .clear(N251), .preset(1'b0), .next_state(
        N216), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(cmd[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_4_ ( .clear(N251), .preset(1'b0), .next_state(
        N215), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(cmd[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_3_ ( .clear(N251), .preset(1'b0), .next_state(
        N214), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(cmd[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_2_ ( .clear(N251), .preset(1'b0), .next_state(
        N213), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(cmd_valid), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_1_ ( .clear(N251), .preset(1'b0), .next_state(
        N212), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(write_pop), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  d_out_i_bus_reg_0_ ( .clear(N251), .preset(1'b0), .next_state(
        N211), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(read_push), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_15_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[31]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_14_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[30]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_13_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[29]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_12_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[28]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_11_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[27]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_10_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[26]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_9_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[25]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_8_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[24]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_7_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[23]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_6_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[22]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_5_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[21]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_4_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[20]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_3_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[19]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_2_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[18]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_1_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[17]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pad_out_buf_reg_0_ ( .clear(N251), .preset(1'b0), .next_state(
        mega_shift[16]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), .Q(
        pad_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__15_ ( .clear(N251), .preset(1'b0), 
        .next_state(N250), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__14_ ( .clear(N251), .preset(1'b0), 
        .next_state(N249), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__13_ ( .clear(N251), .preset(1'b0), 
        .next_state(N248), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__12_ ( .clear(N251), .preset(1'b0), 
        .next_state(N247), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__11_ ( .clear(N251), .preset(1'b0), 
        .next_state(N246), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__10_ ( .clear(N251), .preset(1'b0), 
        .next_state(N245), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__9_ ( .clear(N251), .preset(1'b0), 
        .next_state(N244), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__8_ ( .clear(N251), .preset(1'b0), 
        .next_state(N243), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__7_ ( .clear(N251), .preset(1'b0), 
        .next_state(N242), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__6_ ( .clear(N251), .preset(1'b0), 
        .next_state(N241), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__5_ ( .clear(N251), .preset(1'b0), 
        .next_state(N240), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__4_ ( .clear(N251), .preset(1'b0), 
        .next_state(N239), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__3_ ( .clear(N251), .preset(1'b0), 
        .next_state(N238), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__2_ ( .clear(N251), .preset(1'b0), 
        .next_state(N237), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__1_ ( .clear(N251), .preset(1'b0), 
        .next_state(N236), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__0_ ( .clear(N251), .preset(1'b0), 
        .next_state(N235), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__15_ ( .clear(N251), .preset(1'b0), 
        .next_state(N234), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__14_ ( .clear(N251), .preset(1'b0), 
        .next_state(N233), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__13_ ( .clear(N251), .preset(1'b0), 
        .next_state(N232), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__12_ ( .clear(N251), .preset(1'b0), 
        .next_state(N231), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__11_ ( .clear(N251), .preset(1'b0), 
        .next_state(N230), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__10_ ( .clear(N251), .preset(1'b0), 
        .next_state(N229), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__9_ ( .clear(N251), .preset(1'b0), 
        .next_state(N228), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__8_ ( .clear(N251), .preset(1'b0), 
        .next_state(N227), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__7_ ( .clear(N251), .preset(1'b0), 
        .next_state(N226), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__6_ ( .clear(N251), .preset(1'b0), 
        .next_state(N225), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__5_ ( .clear(N251), .preset(1'b0), 
        .next_state(N224), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__4_ ( .clear(N251), .preset(1'b0), 
        .next_state(N223), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__3_ ( .clear(N251), .preset(1'b0), 
        .next_state(N222), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__2_ ( .clear(N251), .preset(1'b0), 
        .next_state(N221), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__1_ ( .clear(N251), .preset(1'b0), 
        .next_state(N220), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__0_ ( .clear(N251), .preset(1'b0), 
        .next_state(N219), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(pci_rst_n), .Z(N251) );
  MULT_UNS_OP mult_50_C248_rn ( .A(mega_shift[15:8]), .B(mega_shift[7:0]), .Z(
        {N250, N249, N248, N247, N246, N245, N244, N243, N242, N241, N240, 
        N239, N238, N237, N236, N235}) );
  SELECT_OP C595 ( .DATA1({pad_in, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, pad_in}), .DATA3({pad_in[15:8], 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, pad_in[7:0], 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA4({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, pad_in[15:8], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, pad_in[7:0]}), .DATA5({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0}), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .CONTROL4(N3), 
        .CONTROL5(N4), .Z(read_data) );
  GTECH_BUF B_0 ( .A(N29), .Z(N0) );
  GTECH_BUF B_1 ( .A(N33), .Z(N1) );
  GTECH_BUF B_2 ( .A(N37), .Z(N2) );
  GTECH_BUF B_3 ( .A(N41), .Z(N3) );
  GTECH_BUF B_4 ( .A(N50), .Z(N4) );
  SELECT_OP C596 ( .DATA1({1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b0, 1'b1}), .DATA2({1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b1, 1'b0, 1'b1}), .DATA3({1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 
        1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 
        1'b0, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA4({1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 
        1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA5({1'b0, 1'b1, 1'b0, 1'b0, 
        1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 
        1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA6({1'b0, 1'b1, 1'b0, 
        1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 
        1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA7({1'b0, 1'b1, 
        1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA8({1'b0, 
        1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1}), .DATA9({
        1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 
        1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1}), 
        .DATA10({1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 
        1'b1}), .DATA11({write_data[18:0], cmd_in}), .CONTROL1(N5), .CONTROL2(
        N6), .CONTROL3(N7), .CONTROL4(N8), .CONTROL5(N9), .CONTROL6(N10), 
        .CONTROL7(N11), .CONTROL8(N12), .CONTROL9(N13), .CONTROL10(N14), 
        .CONTROL11(N113), .Z({N136, N135, N134, N133, N132, N131, N130, N129, 
        N128, N127, N126, N125, N124, N123, N122, N121, N120, N119, N118, N117, 
        N116, N115, N114}) );
  GTECH_BUF B_5 ( .A(N55), .Z(N5) );
  GTECH_BUF B_6 ( .A(N57), .Z(N6) );
  GTECH_BUF B_7 ( .A(N61), .Z(N7) );
  GTECH_BUF B_8 ( .A(N67), .Z(N8) );
  GTECH_BUF B_9 ( .A(N72), .Z(N9) );
  GTECH_BUF B_10 ( .A(N76), .Z(N10) );
  GTECH_BUF B_11 ( .A(N80), .Z(N11) );
  GTECH_BUF B_12 ( .A(N87), .Z(N12) );
  GTECH_BUF B_13 ( .A(N92), .Z(N13) );
  GTECH_BUF B_14 ( .A(N103), .Z(N14) );
  SELECT_OP C597 ( .DATA1({1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1}), .DATA2(
        {1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0}), .DATA3({1'b1, 1'b1, 1'b0, 
        1'b1, 1'b1, 1'b0, 1'b1}), .DATA4({1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 
        1'b0}), .DATA5({1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1}), .DATA6({
        1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1}), .DATA7({1'b0, 1'b0, 1'b1, 
        1'b1, 1'b1, 1'b0, 1'b0}), .DATA8(pad_in[6:0]), .CONTROL1(N15), 
        .CONTROL2(N16), .CONTROL3(N17), .CONTROL4(N18), .CONTROL5(N19), 
        .CONTROL6(N20), .CONTROL7(N21), .CONTROL8(N203), .Z({N210, N209, N208, 
        N207, N206, N205, N204}) );
  GTECH_BUF B_15 ( .A(N143), .Z(N15) );
  GTECH_BUF B_16 ( .A(N149), .Z(N16) );
  GTECH_BUF B_17 ( .A(N153), .Z(N17) );
  GTECH_BUF B_18 ( .A(N161), .Z(N18) );
  GTECH_BUF B_19 ( .A(N170), .Z(N19) );
  GTECH_BUF B_20 ( .A(N181), .Z(N20) );
  GTECH_BUF B_21 ( .A(N196), .Z(N21) );
  SELECT_OP C598 ( .DATA1({N210, N209, N208, N207, N206, N205, N204}), .DATA2(
        pad_in[6:0]), .CONTROL1(N22), .CONTROL2(N138), .Z({N217, N216, N215, 
        N214, N213, N212, N211}) );
  GTECH_BUF B_22 ( .A(N137), .Z(N22) );
  SELECT_OP C599 ( .DATA1(write_data[31:16]), .DATA2(write_data[15:0]), 
        .CONTROL1(N23), .CONTROL2(N218), .Z({N234, N233, N232, N231, N230, 
        N229, N228, N227, N226, N225, N224, N223, N222, N221, N220, N219}) );
  GTECH_BUF B_23 ( .A(cmd_in[1]), .Z(N23) );
  GTECH_NOT I_1 ( .A(d_out_p_bus_0), .Z(N24) );
  GTECH_NOT I_2 ( .A(d_out_p_bus[3]), .Z(N25) );
  GTECH_NOT I_3 ( .A(N28), .Z(N29) );
  GTECH_NOT I_4 ( .A(N32), .Z(N33) );
  GTECH_NOT I_5 ( .A(N36), .Z(N37) );
  GTECH_NOT I_6 ( .A(N40), .Z(N41) );
  GTECH_NOT I_7 ( .A(pc_be_in[3]), .Z(N43) );
  GTECH_NOT I_8 ( .A(pc_be_in[0]), .Z(N44) );
  GTECH_NOT I_9 ( .A(pc_be_in[2]), .Z(N47) );
  GTECH_NOT I_10 ( .A(pc_be_in[1]), .Z(N48) );
  GTECH_OR2 C612 ( .A(N42), .B(N253), .Z(N50) );
  GTECH_OR2 C613 ( .A(N45), .B(N252), .Z(N253) );
  GTECH_OR2 C614 ( .A(N46), .B(N49), .Z(N252) );
  GTECH_NOT I_11 ( .A(N54), .Z(N55) );
  GTECH_NOT I_12 ( .A(N56), .Z(N57) );
  GTECH_NOT I_13 ( .A(N60), .Z(N61) );
  GTECH_NOT I_14 ( .A(cmd_in[1]), .Z(N68) );
  GTECH_NOT I_15 ( .A(N71), .Z(N72) );
  GTECH_NOT I_16 ( .A(N75), .Z(N76) );
  GTECH_NOT I_17 ( .A(N79), .Z(N80) );
  GTECH_NOT I_18 ( .A(cmd_in[3]), .Z(N81) );
  GTECH_NOT I_19 ( .A(N86), .Z(N87) );
  GTECH_NOT I_20 ( .A(write_empty), .Z(N88) );
  GTECH_NOT I_21 ( .A(N91), .Z(N92) );
  GTECH_NOT I_22 ( .A(read_full), .Z(N93) );
  GTECH_NOT I_23 ( .A(cmd_in_valid), .Z(N94) );
  GTECH_NOT I_24 ( .A(cmd_in[2]), .Z(N95) );
  GTECH_NOT I_25 ( .A(cmd_in[0]), .Z(N96) );
  GTECH_NOT I_26 ( .A(N102), .Z(N103) );
  GTECH_OR2 C646 ( .A(N57), .B(N55), .Z(N104) );
  GTECH_OR2 C647 ( .A(N61), .B(N104), .Z(N105) );
  GTECH_OR2 C648 ( .A(N67), .B(N105), .Z(N106) );
  GTECH_OR2 C649 ( .A(N72), .B(N106), .Z(N107) );
  GTECH_OR2 C650 ( .A(N76), .B(N107), .Z(N108) );
  GTECH_OR2 C651 ( .A(N80), .B(N108), .Z(N109) );
  GTECH_OR2 C652 ( .A(N87), .B(N109), .Z(N110) );
  GTECH_OR2 C653 ( .A(N92), .B(N110), .Z(N111) );
  GTECH_OR2 C654 ( .A(N103), .B(N111), .Z(N112) );
  GTECH_NOT I_27 ( .A(N112), .Z(N113) );
  GTECH_NOT I_28 ( .A(N137), .Z(N138) );
  GTECH_NOT I_29 ( .A(N142), .Z(N143) );
  GTECH_NOT I_30 ( .A(N148), .Z(N149) );
  GTECH_NOT I_31 ( .A(N152), .Z(N153) );
  GTECH_NOT I_32 ( .A(N160), .Z(N161) );
  GTECH_NOT I_33 ( .A(N169), .Z(N170) );
  GTECH_NOT I_34 ( .A(pgnt_n), .Z(N171) );
  GTECH_NOT I_35 ( .A(pframe_n_in), .Z(N172) );
  GTECH_NOT I_36 ( .A(pirdy_n_in), .Z(N173) );
  GTECH_NOT I_37 ( .A(pidsel), .Z(N182) );
  GTECH_NOT I_38 ( .A(ptrdy_n_in), .Z(N183) );
  GTECH_NOT I_39 ( .A(pdevsel_n_in), .Z(N184) );
  GTECH_NOT I_40 ( .A(pperr_n_in), .Z(N185) );
  GTECH_NOT I_41 ( .A(pserr_n_in), .Z(N186) );
  GTECH_NOT I_42 ( .A(pm66en), .Z(N187) );
  GTECH_NOT I_43 ( .A(N195), .Z(N196) );
  GTECH_OR2 C680 ( .A(N149), .B(N143), .Z(N197) );
  GTECH_OR2 C681 ( .A(N153), .B(N197), .Z(N198) );
  GTECH_OR2 C682 ( .A(N161), .B(N198), .Z(N199) );
  GTECH_OR2 C683 ( .A(N170), .B(N199), .Z(N200) );
  GTECH_OR2 C684 ( .A(N181), .B(N200), .Z(N201) );
  GTECH_OR2 C685 ( .A(N196), .B(N201), .Z(N202) );
  GTECH_NOT I_44 ( .A(N202), .Z(N203) );
  GTECH_BUF B_24 ( .A(pci_rst_n) );
  GTECH_NOT I_45 ( .A(cmd_in[1]), .Z(N218) );
endmodule


module PCI_FIFO ( fifo_clk_push, fifo_clk_pop, fifo_rst_n, test_mode, 
        fifo_push_req_n, fifo_pop_req_n, fifo_data_in, push_empty_fifo, 
        push_ae_fifo, push_hf_fifo, push_af_fifo, push_full_fifo, 
        push_error_fifo, pop_empty_fifo, pop_ae_fifo, pop_hf_fifo, pop_af_fifo, 
        pop_full_fifo, pop_error_fifo, data_out_fifo );
  input [31:0] fifo_data_in;
  output [31:0] data_out_fifo;
  input fifo_clk_push, fifo_clk_pop, fifo_rst_n, test_mode, fifo_push_req_n,
         fifo_pop_req_n;
  output push_empty_fifo, push_ae_fifo, push_hf_fifo, push_af_fifo,
         push_full_fifo, push_error_fifo, pop_empty_fifo, pop_ae_fifo,
         pop_hf_fifo, pop_af_fifo, pop_full_fifo, pop_error_fifo;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, we_n, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42,
         N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56,
         N57, N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70,
         N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84,
         N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98,
         N99, N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8;
  wire   [2:0] wr_addr;
  wire   [2:0] rd_addr;
  wire   [255:0] reg_array;
  wire   [31:0] data_out_sync;

  DW_fifoctl_s2_sf PCI_FIFO_CTL ( .clk_push(fifo_clk_push), .clk_pop(
        fifo_clk_pop), .rst_n(fifo_rst_n), .push_req_n(fifo_push_req_n), 
        .pop_req_n(fifo_pop_req_n), .we_n(we_n), .push_empty(push_empty_fifo), 
        .push_ae(push_ae_fifo), .push_hf(push_hf_fifo), .push_af(push_af_fifo), 
        .push_full(push_full_fifo), .push_error(push_error_fifo), .pop_empty(
        pop_empty_fifo), .pop_ae(pop_ae_fifo), .pop_hf(pop_hf_fifo), .pop_af(
        pop_af_fifo), .pop_full(pop_full_fifo), .pop_error(pop_error_fifo), 
        .wr_addr(wr_addr), .rd_addr(rd_addr), .push_word_count({
        SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4}), .pop_word_count({SYNOPSYS_UNCONNECTED_5, 
        SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8}), .test(test_mode) );
  \**SEQGEN**  reg_array_reg_0__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[255]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[254]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[253]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[252]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[251]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[250]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[249]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[248]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[247]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[246]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[245]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[244]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[243]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[242]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[241]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[240]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[239]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[238]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[237]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[236]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[235]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[234]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[233]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[232]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[231]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[230]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[229]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[228]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[227]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[226]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[225]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[224]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_1__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[223]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[222]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[221]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[220]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[219]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[218]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[217]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[216]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[215]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[214]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[213]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[212]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[211]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[210]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[209]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[208]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[207]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[206]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[205]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[204]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[203]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[202]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[201]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[200]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[199]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[198]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[197]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[196]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[195]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[194]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[193]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[192]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_2__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[191]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[190]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[189]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[188]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[187]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[186]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[185]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[184]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[183]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[182]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[181]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[180]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[179]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[178]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[177]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[176]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[175]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[174]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[173]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[172]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[171]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[170]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[169]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[168]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[167]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[166]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[165]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[164]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[163]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[162]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[161]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[160]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_3__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[159]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[158]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[157]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[156]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[155]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[154]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[153]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[152]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[151]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[150]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[149]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[148]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[147]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[146]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[145]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[144]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[143]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[142]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[141]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[140]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[139]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[138]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[137]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[136]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[135]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[134]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[133]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[132]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[131]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[130]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[129]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[128]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_4__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[127]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[126]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[125]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[124]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[123]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[122]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[121]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[120]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[119]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[118]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[117]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[116]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[115]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[114]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[113]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[112]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[111]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[110]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[109]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[108]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[107]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[106]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[105]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[104]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[103]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[102]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[101]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[100]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[99]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[98]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[97]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[96]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_5__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[95]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[94]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[93]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[92]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[91]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[90]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[89]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[88]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[87]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[86]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[85]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[84]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[83]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[82]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[81]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[80]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[79]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[78]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[77]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[76]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[75]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[74]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[73]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[72]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[71]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[70]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[69]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[68]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[67]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[66]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[65]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[64]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_6__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[63]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[62]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[61]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[60]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[59]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[58]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[57]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[56]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[55]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[54]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[53]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[52]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[51]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_7__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[31]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[30]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[29]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[28]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[27]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[26]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[25]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[24]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[23]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[22]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[21]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[20]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[19]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  data_out_sync_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N120), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N121), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N122), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N123), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N124), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N125), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N126), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N127), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N128), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N129), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N130), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N131), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N132), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N133), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N134), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N135), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N136), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N137), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N138), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N139), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N140), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N141), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N142), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N143), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N144), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N145), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N146), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N147), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N148), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N149), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N150), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N151), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[31]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[31]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[30]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[30]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[29]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[29]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[28]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[28]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[27]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[27]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[26]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[26]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[25]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[25]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[24]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[24]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[23]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[23]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[22]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[22]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[21]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[21]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[20]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[20]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[19]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[19]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[18]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[18]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[17]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[17]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[16]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[16]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[15]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[15]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[14]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[14]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[13]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[13]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[12]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[12]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[11]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[10]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[9]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[8]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[7]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[6]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[5]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[4]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[3]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[2]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[1]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  rd_data_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[0]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(fifo_rst_n), .Z(N152) );
  GTECH_NOT I_1 ( .A(we_n), .Z(N153) );
  GTECH_AND2 C1069 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N154) );
  GTECH_AND2 C1070 ( .A(N154), .B(wr_addr[2]), .Z(N39) );
  GTECH_AND2 C1071 ( .A(N0), .B(wr_addr[1]), .Z(N155) );
  GTECH_NOT I_2 ( .A(wr_addr[0]), .Z(N0) );
  GTECH_AND2 C1072 ( .A(N155), .B(wr_addr[2]), .Z(N38) );
  GTECH_AND2 C1073 ( .A(wr_addr[0]), .B(N1), .Z(N156) );
  GTECH_NOT I_3 ( .A(wr_addr[1]), .Z(N1) );
  GTECH_AND2 C1074 ( .A(N156), .B(wr_addr[2]), .Z(N37) );
  GTECH_AND2 C1075 ( .A(N2), .B(N3), .Z(N157) );
  GTECH_NOT I_4 ( .A(wr_addr[0]), .Z(N2) );
  GTECH_NOT I_5 ( .A(wr_addr[1]), .Z(N3) );
  GTECH_AND2 C1076 ( .A(N157), .B(wr_addr[2]), .Z(N36) );
  GTECH_AND2 C1077 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N158) );
  GTECH_AND2 C1078 ( .A(N158), .B(N4), .Z(N35) );
  GTECH_NOT I_6 ( .A(wr_addr[2]), .Z(N4) );
  GTECH_AND2 C1079 ( .A(N5), .B(wr_addr[1]), .Z(N159) );
  GTECH_NOT I_7 ( .A(wr_addr[0]), .Z(N5) );
  GTECH_AND2 C1080 ( .A(N159), .B(N6), .Z(N34) );
  GTECH_NOT I_8 ( .A(wr_addr[2]), .Z(N6) );
  GTECH_AND2 C1081 ( .A(wr_addr[0]), .B(N7), .Z(N160) );
  GTECH_NOT I_9 ( .A(wr_addr[1]), .Z(N7) );
  GTECH_AND2 C1082 ( .A(N160), .B(N8), .Z(N33) );
  GTECH_NOT I_10 ( .A(wr_addr[2]), .Z(N8) );
  GTECH_AND2 C1083 ( .A(N9), .B(N10), .Z(N161) );
  GTECH_NOT I_11 ( .A(wr_addr[0]), .Z(N9) );
  GTECH_NOT I_12 ( .A(wr_addr[1]), .Z(N10) );
  GTECH_AND2 C1084 ( .A(N161), .B(N11), .Z(N32) );
  GTECH_NOT I_13 ( .A(wr_addr[2]), .Z(N11) );
  GTECH_AND2 C1085 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N162) );
  GTECH_AND2 C1086 ( .A(N162), .B(wr_addr[2]), .Z(N79) );
  GTECH_AND2 C1087 ( .A(N12), .B(wr_addr[1]), .Z(N163) );
  GTECH_NOT I_14 ( .A(wr_addr[0]), .Z(N12) );
  GTECH_AND2 C1088 ( .A(N163), .B(wr_addr[2]), .Z(N78) );
  GTECH_AND2 C1089 ( .A(wr_addr[0]), .B(N13), .Z(N164) );
  GTECH_NOT I_15 ( .A(wr_addr[1]), .Z(N13) );
  GTECH_AND2 C1090 ( .A(N164), .B(wr_addr[2]), .Z(N77) );
  GTECH_AND2 C1091 ( .A(N14), .B(N15), .Z(N165) );
  GTECH_NOT I_16 ( .A(wr_addr[0]), .Z(N14) );
  GTECH_NOT I_17 ( .A(wr_addr[1]), .Z(N15) );
  GTECH_AND2 C1092 ( .A(N165), .B(wr_addr[2]), .Z(N76) );
  GTECH_AND2 C1093 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N166) );
  GTECH_AND2 C1094 ( .A(N166), .B(N16), .Z(N75) );
  GTECH_NOT I_18 ( .A(wr_addr[2]), .Z(N16) );
  GTECH_AND2 C1095 ( .A(N17), .B(wr_addr[1]), .Z(N167) );
  GTECH_NOT I_19 ( .A(wr_addr[0]), .Z(N17) );
  GTECH_AND2 C1096 ( .A(N167), .B(N18), .Z(N74) );
  GTECH_NOT I_20 ( .A(wr_addr[2]), .Z(N18) );
  GTECH_AND2 C1097 ( .A(wr_addr[0]), .B(N19), .Z(N168) );
  GTECH_NOT I_21 ( .A(wr_addr[1]), .Z(N19) );
  GTECH_AND2 C1098 ( .A(N168), .B(N20), .Z(N73) );
  GTECH_NOT I_22 ( .A(wr_addr[2]), .Z(N20) );
  GTECH_AND2 C1099 ( .A(N21), .B(N22), .Z(N169) );
  GTECH_NOT I_23 ( .A(wr_addr[0]), .Z(N21) );
  GTECH_NOT I_24 ( .A(wr_addr[1]), .Z(N22) );
  GTECH_AND2 C1100 ( .A(N169), .B(N23), .Z(N72) );
  GTECH_NOT I_25 ( .A(wr_addr[2]), .Z(N23) );
  SELECT_OP C1101 ( .DATA1({N32, N33, N34, N35, N36, N37, N38, N39}), .DATA2({
        N72, N73, N74, N75, N76, N77, N78, N79}), .CONTROL1(N24), .CONTROL2(
        N25), .Z({N119, N118, N117, N116, N115, N114, N113, N80}) );
  GTECH_BUF B_0 ( .A(N153), .Z(N24) );
  GTECH_BUF B_1 ( .A(we_n), .Z(N25) );
  SELECT_OP C1102 ( .DATA1(fifo_data_in), .DATA2({N40, N41, N42, N43, N44, N45, 
        N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, 
        N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71}), 
        .CONTROL1(N24), .CONTROL2(N25), .Z({N112, N111, N110, N109, N108, N107, 
        N106, N105, N104, N103, N102, N101, N100, N99, N98, N97, N96, N95, N94, 
        N93, N92, N91, N90, N89, N88, N87, N86, N85, N84, N83, N82, N81}) );
  MUX_OP C1103 ( .D0({reg_array[224], reg_array[225], reg_array[226], 
        reg_array[227], reg_array[228], reg_array[229], reg_array[230], 
        reg_array[231], reg_array[232], reg_array[233], reg_array[234], 
        reg_array[235], reg_array[236], reg_array[237], reg_array[238], 
        reg_array[239], reg_array[240], reg_array[241], reg_array[242], 
        reg_array[243], reg_array[244], reg_array[245], reg_array[246], 
        reg_array[247], reg_array[248], reg_array[249], reg_array[250], 
        reg_array[251], reg_array[252], reg_array[253], reg_array[254], 
        reg_array[255]}), .D1({reg_array[192], reg_array[193], reg_array[194], 
        reg_array[195], reg_array[196], reg_array[197], reg_array[198], 
        reg_array[199], reg_array[200], reg_array[201], reg_array[202], 
        reg_array[203], reg_array[204], reg_array[205], reg_array[206], 
        reg_array[207], reg_array[208], reg_array[209], reg_array[210], 
        reg_array[211], reg_array[212], reg_array[213], reg_array[214], 
        reg_array[215], reg_array[216], reg_array[217], reg_array[218], 
        reg_array[219], reg_array[220], reg_array[221], reg_array[222], 
        reg_array[223]}), .D2({reg_array[160], reg_array[161], reg_array[162], 
        reg_array[163], reg_array[164], reg_array[165], reg_array[166], 
        reg_array[167], reg_array[168], reg_array[169], reg_array[170], 
        reg_array[171], reg_array[172], reg_array[173], reg_array[174], 
        reg_array[175], reg_array[176], reg_array[177], reg_array[178], 
        reg_array[179], reg_array[180], reg_array[181], reg_array[182], 
        reg_array[183], reg_array[184], reg_array[185], reg_array[186], 
        reg_array[187], reg_array[188], reg_array[189], reg_array[190], 
        reg_array[191]}), .D3({reg_array[128], reg_array[129], reg_array[130], 
        reg_array[131], reg_array[132], reg_array[133], reg_array[134], 
        reg_array[135], reg_array[136], reg_array[137], reg_array[138], 
        reg_array[139], reg_array[140], reg_array[141], reg_array[142], 
        reg_array[143], reg_array[144], reg_array[145], reg_array[146], 
        reg_array[147], reg_array[148], reg_array[149], reg_array[150], 
        reg_array[151], reg_array[152], reg_array[153], reg_array[154], 
        reg_array[155], reg_array[156], reg_array[157], reg_array[158], 
        reg_array[159]}), .D4({reg_array[96], reg_array[97], reg_array[98], 
        reg_array[99], reg_array[100], reg_array[101], reg_array[102], 
        reg_array[103], reg_array[104], reg_array[105], reg_array[106], 
        reg_array[107], reg_array[108], reg_array[109], reg_array[110], 
        reg_array[111], reg_array[112], reg_array[113], reg_array[114], 
        reg_array[115], reg_array[116], reg_array[117], reg_array[118], 
        reg_array[119], reg_array[120], reg_array[121], reg_array[122], 
        reg_array[123], reg_array[124], reg_array[125], reg_array[126], 
        reg_array[127]}), .D5({reg_array[64], reg_array[65], reg_array[66], 
        reg_array[67], reg_array[68], reg_array[69], reg_array[70], 
        reg_array[71], reg_array[72], reg_array[73], reg_array[74], 
        reg_array[75], reg_array[76], reg_array[77], reg_array[78], 
        reg_array[79], reg_array[80], reg_array[81], reg_array[82], 
        reg_array[83], reg_array[84], reg_array[85], reg_array[86], 
        reg_array[87], reg_array[88], reg_array[89], reg_array[90], 
        reg_array[91], reg_array[92], reg_array[93], reg_array[94], 
        reg_array[95]}), .D6({reg_array[32], reg_array[33], reg_array[34], 
        reg_array[35], reg_array[36], reg_array[37], reg_array[38], 
        reg_array[39], reg_array[40], reg_array[41], reg_array[42], 
        reg_array[43], reg_array[44], reg_array[45], reg_array[46], 
        reg_array[47], reg_array[48], reg_array[49], reg_array[50], 
        reg_array[51], reg_array[52], reg_array[53], reg_array[54], 
        reg_array[55], reg_array[56], reg_array[57], reg_array[58], 
        reg_array[59], reg_array[60], reg_array[61], reg_array[62], 
        reg_array[63]}), .D7({reg_array[0], reg_array[1], reg_array[2], 
        reg_array[3], reg_array[4], reg_array[5], reg_array[6], reg_array[7], 
        reg_array[8], reg_array[9], reg_array[10], reg_array[11], 
        reg_array[12], reg_array[13], reg_array[14], reg_array[15], 
        reg_array[16], reg_array[17], reg_array[18], reg_array[19], 
        reg_array[20], reg_array[21], reg_array[22], reg_array[23], 
        reg_array[24], reg_array[25], reg_array[26], reg_array[27], 
        reg_array[28], reg_array[29], reg_array[30], reg_array[31]}), .S0(N26), 
        .S1(N27), .S2(N28), .Z({N71, N70, N69, N68, N67, N66, N65, N64, N63, 
        N62, N61, N60, N59, N58, N57, N56, N55, N54, N53, N52, N51, N50, N49, 
        N48, N47, N46, N45, N44, N43, N42, N41, N40}) );
  GTECH_BUF B_2 ( .A(wr_addr[0]), .Z(N26) );
  GTECH_BUF B_3 ( .A(wr_addr[1]), .Z(N27) );
  GTECH_BUF B_4 ( .A(wr_addr[2]), .Z(N28) );
  MUX_OP C1104 ( .D0({reg_array[224], reg_array[225], reg_array[226], 
        reg_array[227], reg_array[228], reg_array[229], reg_array[230], 
        reg_array[231], reg_array[232], reg_array[233], reg_array[234], 
        reg_array[235], reg_array[236], reg_array[237], reg_array[238], 
        reg_array[239], reg_array[240], reg_array[241], reg_array[242], 
        reg_array[243], reg_array[244], reg_array[245], reg_array[246], 
        reg_array[247], reg_array[248], reg_array[249], reg_array[250], 
        reg_array[251], reg_array[252], reg_array[253], reg_array[254], 
        reg_array[255]}), .D1({reg_array[192], reg_array[193], reg_array[194], 
        reg_array[195], reg_array[196], reg_array[197], reg_array[198], 
        reg_array[199], reg_array[200], reg_array[201], reg_array[202], 
        reg_array[203], reg_array[204], reg_array[205], reg_array[206], 
        reg_array[207], reg_array[208], reg_array[209], reg_array[210], 
        reg_array[211], reg_array[212], reg_array[213], reg_array[214], 
        reg_array[215], reg_array[216], reg_array[217], reg_array[218], 
        reg_array[219], reg_array[220], reg_array[221], reg_array[222], 
        reg_array[223]}), .D2({reg_array[160], reg_array[161], reg_array[162], 
        reg_array[163], reg_array[164], reg_array[165], reg_array[166], 
        reg_array[167], reg_array[168], reg_array[169], reg_array[170], 
        reg_array[171], reg_array[172], reg_array[173], reg_array[174], 
        reg_array[175], reg_array[176], reg_array[177], reg_array[178], 
        reg_array[179], reg_array[180], reg_array[181], reg_array[182], 
        reg_array[183], reg_array[184], reg_array[185], reg_array[186], 
        reg_array[187], reg_array[188], reg_array[189], reg_array[190], 
        reg_array[191]}), .D3({reg_array[128], reg_array[129], reg_array[130], 
        reg_array[131], reg_array[132], reg_array[133], reg_array[134], 
        reg_array[135], reg_array[136], reg_array[137], reg_array[138], 
        reg_array[139], reg_array[140], reg_array[141], reg_array[142], 
        reg_array[143], reg_array[144], reg_array[145], reg_array[146], 
        reg_array[147], reg_array[148], reg_array[149], reg_array[150], 
        reg_array[151], reg_array[152], reg_array[153], reg_array[154], 
        reg_array[155], reg_array[156], reg_array[157], reg_array[158], 
        reg_array[159]}), .D4({reg_array[96], reg_array[97], reg_array[98], 
        reg_array[99], reg_array[100], reg_array[101], reg_array[102], 
        reg_array[103], reg_array[104], reg_array[105], reg_array[106], 
        reg_array[107], reg_array[108], reg_array[109], reg_array[110], 
        reg_array[111], reg_array[112], reg_array[113], reg_array[114], 
        reg_array[115], reg_array[116], reg_array[117], reg_array[118], 
        reg_array[119], reg_array[120], reg_array[121], reg_array[122], 
        reg_array[123], reg_array[124], reg_array[125], reg_array[126], 
        reg_array[127]}), .D5({reg_array[64], reg_array[65], reg_array[66], 
        reg_array[67], reg_array[68], reg_array[69], reg_array[70], 
        reg_array[71], reg_array[72], reg_array[73], reg_array[74], 
        reg_array[75], reg_array[76], reg_array[77], reg_array[78], 
        reg_array[79], reg_array[80], reg_array[81], reg_array[82], 
        reg_array[83], reg_array[84], reg_array[85], reg_array[86], 
        reg_array[87], reg_array[88], reg_array[89], reg_array[90], 
        reg_array[91], reg_array[92], reg_array[93], reg_array[94], 
        reg_array[95]}), .D6({reg_array[32], reg_array[33], reg_array[34], 
        reg_array[35], reg_array[36], reg_array[37], reg_array[38], 
        reg_array[39], reg_array[40], reg_array[41], reg_array[42], 
        reg_array[43], reg_array[44], reg_array[45], reg_array[46], 
        reg_array[47], reg_array[48], reg_array[49], reg_array[50], 
        reg_array[51], reg_array[52], reg_array[53], reg_array[54], 
        reg_array[55], reg_array[56], reg_array[57], reg_array[58], 
        reg_array[59], reg_array[60], reg_array[61], reg_array[62], 
        reg_array[63]}), .D7({reg_array[0], reg_array[1], reg_array[2], 
        reg_array[3], reg_array[4], reg_array[5], reg_array[6], reg_array[7], 
        reg_array[8], reg_array[9], reg_array[10], reg_array[11], 
        reg_array[12], reg_array[13], reg_array[14], reg_array[15], 
        reg_array[16], reg_array[17], reg_array[18], reg_array[19], 
        reg_array[20], reg_array[21], reg_array[22], reg_array[23], 
        reg_array[24], reg_array[25], reg_array[26], reg_array[27], 
        reg_array[28], reg_array[29], reg_array[30], reg_array[31]}), .S0(N29), 
        .S1(N30), .S2(N31), .Z({N151, N150, N149, N148, N147, N146, N145, N144, 
        N143, N142, N141, N140, N139, N138, N137, N136, N135, N134, N133, N132, 
        N131, N130, N129, N128, N127, N126, N125, N124, N123, N122, N121, N120}) );
  GTECH_BUF B_5 ( .A(rd_addr[0]), .Z(N29) );
  GTECH_BUF B_6 ( .A(rd_addr[1]), .Z(N30) );
  GTECH_BUF B_7 ( .A(rd_addr[2]), .Z(N31) );
endmodule


module PCI_TOP ( pclk, pci_rst_n, pidsel, pgnt_n, pad_in, pad_out, pad_en, 
        ppar_in, ppar_out, ppar_en, pc_be_in, pc_be_out, pc_be_en, pframe_n_in, 
        pframe_n_out, pframe_n_en, ptrdy_n_in, ptrdy_n_out, ptrdy_n_en, 
        pirdy_n_in, pirdy_n_out, pirdy_n_en, pdevsel_n_in, pdevsel_n_out, 
        pdevsel_n_en, pstop_n_in, pstop_n_out, pstop_n_en, pperr_n_in, 
        pperr_n_out, pperr_n_en, pserr_n_in, pserr_n_out, pserr_n_en, preq_n, 
        pm66en, cmd_valid, cmd, cmd_in_valid, cmd_in, sys_clk, sys_rst_n, 
        test_mode, rfifo_pop, rfifo_empty, wfifo_push, wfifo_full, 
        pci_read_data, pci_write_data );
  input [15:0] pad_in;
  output [15:0] pad_out;
  input [3:0] pc_be_in;
  output [3:0] pc_be_out;
  output [3:0] cmd;
  input [3:0] cmd_in;
  output [31:0] pci_read_data;
  input [31:0] pci_write_data;
  input pclk, pci_rst_n, pidsel, pgnt_n, ppar_in, pframe_n_in, ptrdy_n_in,
         pirdy_n_in, pdevsel_n_in, pstop_n_in, pperr_n_in, pserr_n_in, pm66en,
         cmd_in_valid, sys_clk, sys_rst_n, test_mode, rfifo_pop, wfifo_push;
  output pad_en, ppar_out, ppar_en, pc_be_en, pframe_n_out, pframe_n_en,
         ptrdy_n_out, ptrdy_n_en, pirdy_n_out, pirdy_n_en, pdevsel_n_out,
         pdevsel_n_en, pstop_n_out, pstop_n_en, pperr_n_out, pperr_n_en,
         pserr_n_out, pserr_n_en, preq_n, cmd_valid, rfifo_empty, wfifo_full;
  wire   net_pci_read_push, net_pci_read_full, net_pci_write_pop,
         net_pci_write_empty;
  wire   [31:0] net_pci_read_data;
  wire   [31:0] net_pci_write_data;

  PCI_CORE I_PCI_CORE ( .pclk(pclk), .pci_rst_n(pci_rst_n), .pidsel(pidsel), 
        .pgnt_n(pgnt_n), .pad_in(pad_in), .pad_out(pad_out), .pad_en(pad_en), 
        .ppar_in(ppar_in), .ppar_out(ppar_out), .ppar_en(ppar_en), .pc_be_in(
        pc_be_in), .pc_be_out(pc_be_out), .pc_be_en(pc_be_en), .pframe_n_in(
        pframe_n_in), .pframe_n_out(pframe_n_out), .pframe_n_en(pframe_n_en), 
        .ptrdy_n_in(ptrdy_n_in), .ptrdy_n_out(ptrdy_n_out), .ptrdy_n_en(
        ptrdy_n_en), .pirdy_n_in(pirdy_n_in), .pirdy_n_out(pirdy_n_out), 
        .pirdy_n_en(pirdy_n_en), .pdevsel_n_in(pdevsel_n_in), .pdevsel_n_out(
        pdevsel_n_out), .pdevsel_n_en(pdevsel_n_en), .pstop_n_in(pstop_n_in), 
        .pstop_n_out(pstop_n_out), .pstop_n_en(pstop_n_en), .pperr_n_in(
        pperr_n_in), .pperr_n_out(pperr_n_out), .pperr_n_en(pperr_n_en), 
        .pserr_n_in(pserr_n_in), .pserr_n_out(pserr_n_out), .pserr_n_en(
        pserr_n_en), .preq_n(preq_n), .pm66en(pm66en), .read_data(
        net_pci_read_data), .write_data(net_pci_write_data), .read_push(
        net_pci_read_push), .read_full(net_pci_read_full), .write_pop(
        net_pci_write_pop), .write_empty(net_pci_write_empty), .cmd_valid(
        cmd_valid), .cmd(cmd), .cmd_in_valid(cmd_in_valid), .cmd_in(cmd_in) );
  PCI_FIFO I_PCI_READ_FIFO ( .fifo_clk_push(pclk), .fifo_clk_pop(sys_clk), 
        .fifo_rst_n(pci_rst_n), .test_mode(test_mode), .fifo_push_req_n(
        net_pci_read_push), .fifo_pop_req_n(rfifo_pop), .fifo_data_in(
        net_pci_read_data), .push_full_fifo(net_pci_read_full), 
        .pop_empty_fifo(rfifo_empty), .data_out_fifo(pci_read_data) );
  PCI_FIFO I_PCI_WRITE_FIFO ( .fifo_clk_push(sys_clk), .fifo_clk_pop(pclk), 
        .fifo_rst_n(sys_rst_n), .test_mode(test_mode), .fifo_push_req_n(
        wfifo_push), .fifo_pop_req_n(net_pci_write_pop), .fifo_data_in(
        pci_write_data), .push_full_fifo(wfifo_full), .pop_empty_fifo(
        net_pci_write_empty), .data_out_fifo(net_pci_write_data) );
endmodule


module PARSER ( sys_clk, pclk, sys_rst_n, pcmd, pcmd_valid, pcmd_out, 
        pcmd_out_valid, blender_op, blender_clk_en, context_en, context_cmd, 
        fifo_read_pop, fifo_read_empty, fifo_write_push, fifo_write_full, 
        risc_Instrn_lo, risc_Xecutng_Instrn_lo, pci_w_mux_select, 
        sd_w_mux_select, parser_sd_rfifo_pop, sd_rfifo_parser_empty, 
        parser_sd_wfifo_push, sd_wfifo_parser_full );
  input [3:0] pcmd;
  output [3:0] pcmd_out;
  output [3:0] blender_op;
  output [7:0] context_cmd;
  output [7:0] risc_Instrn_lo;
  input [15:0] risc_Xecutng_Instrn_lo;
  output [1:0] pci_w_mux_select;
  output [1:0] sd_w_mux_select;
  input sys_clk, pclk, sys_rst_n, pcmd_valid, fifo_read_empty, fifo_write_full,
         sd_rfifo_parser_empty, sd_wfifo_parser_full;
  output pcmd_out_valid, blender_clk_en, context_en, fifo_read_pop,
         fifo_write_push, parser_sd_rfifo_pop, parser_sd_wfifo_push;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, r_pcmd_valid,
         sync_pcmd_valid, sync_pcmd_out_valid, i_pcmd_out_valid, N12, N13, N14,
         N15, N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28,
         N29, N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42,
         N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56,
         N57, N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70,
         N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84,
         N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98,
         N99, N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149;
  wire   [3:0] r_pcmd;
  wire   [3:0] sync_pcmd;
  wire   [3:0] sync_pcmd_out;
  wire   [3:0] i_pcmd_out;
  wire   [19:0] i_reg;
  assign context_cmd[3] = blender_op[3];
  assign context_cmd[2] = blender_op[2];
  assign context_cmd[1] = blender_op[1];
  assign context_cmd[0] = blender_op[0];

  \**SEQGEN**  r_pcmd_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd[3]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(r_pcmd[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd[2]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(r_pcmd[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd[1]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(r_pcmd[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd[0]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(r_pcmd[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        pcmd[3]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sync_pcmd[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        pcmd[2]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sync_pcmd[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        pcmd[1]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sync_pcmd[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        pcmd[0]), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sync_pcmd[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_valid_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd_valid), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(r_pcmd_valid), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_valid_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        pcmd_valid), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        sync_pcmd_valid), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_out_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd_out[3]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(pcmd_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_out_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd_out[2]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(pcmd_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_out_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd_out[1]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(pcmd_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_out_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_pcmd_out[0]), .clocked_on(pclk), .data_in(1'b0), .enable(1'b0), 
        .Q(pcmd_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_out_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(i_pcmd_out[3]), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_pcmd_out[3]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_out_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(i_pcmd_out[2]), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_pcmd_out[2]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_out_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(i_pcmd_out[1]), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_pcmd_out[1]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_out_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(i_pcmd_out[0]), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_pcmd_out[0]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  r_pcmd_out_valid_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(sync_pcmd_out_valid), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(pcmd_out_valid), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_pcmd_out_valid_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(i_pcmd_out_valid), .clocked_on(pclk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_pcmd_out_valid), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  blender_clk_en_reg ( .clear(N149), .preset(1'b0), .next_state(
        N12), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        blender_clk_en), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N32), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N31), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N30), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N29), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N28), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N27), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N26), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N25), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N24), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N23), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N22), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N21), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N20), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N19), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N18), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N17), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N16), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N15), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N14), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_reg_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N13), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(i_reg[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  i_pcmd_out_valid_reg ( .clear(N149), .preset(1'b0), 
        .next_state(N37), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(i_pcmd_out_valid), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  i_pcmd_out_reg_3_ ( .clear(N149), .preset(1'b0), .next_state(
        N36), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        i_pcmd_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  i_pcmd_out_reg_2_ ( .clear(N149), .preset(1'b0), .next_state(
        N35), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        i_pcmd_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  i_pcmd_out_reg_1_ ( .clear(N149), .preset(1'b0), .next_state(
        N34), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        i_pcmd_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  i_pcmd_out_reg_0_ ( .clear(N149), .preset(1'b0), .next_state(
        N33), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        i_pcmd_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_OR2 C61 ( .A(r_pcmd[3]), .B(N39), .Z(N41) );
  GTECH_OR2 C62 ( .A(r_pcmd[1]), .B(N40), .Z(N42) );
  GTECH_OR2 C63 ( .A(N41), .B(N42), .Z(N43) );
  GTECH_OR2 C67 ( .A(N45), .B(r_pcmd[2]), .Z(N47) );
  GTECH_OR2 C68 ( .A(N46), .B(r_pcmd[0]), .Z(N48) );
  GTECH_OR2 C69 ( .A(N47), .B(N48), .Z(N49) );
  GTECH_OR2 C73 ( .A(N45), .B(N39), .Z(N51) );
  GTECH_OR2 C74 ( .A(r_pcmd[1]), .B(r_pcmd[0]), .Z(N52) );
  GTECH_OR2 C75 ( .A(N51), .B(N52), .Z(N53) );
  GTECH_OR2 C79 ( .A(r_pcmd[3]), .B(r_pcmd[2]), .Z(N55) );
  GTECH_OR2 C80 ( .A(N46), .B(N40), .Z(N56) );
  GTECH_OR2 C81 ( .A(N55), .B(N56), .Z(N57) );
  GTECH_OR2 C85 ( .A(N45), .B(r_pcmd[2]), .Z(N59) );
  GTECH_OR2 C86 ( .A(r_pcmd[1]), .B(N40), .Z(N60) );
  GTECH_OR2 C87 ( .A(N59), .B(N60), .Z(N61) );
  \**SEQGEN**  out_bus_reg_19_ ( .clear(N149), .preset(1'b0), .next_state(N120), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(context_cmd[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_18_ ( .clear(N149), .preset(1'b0), .next_state(N119), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(context_cmd[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_17_ ( .clear(N149), .preset(1'b0), .next_state(N118), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(context_cmd[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_16_ ( .clear(N149), .preset(1'b0), .next_state(N117), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(context_cmd[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_15_ ( .clear(N149), .preset(1'b0), .next_state(N116), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(parser_sd_wfifo_push), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  out_bus_reg_14_ ( .clear(N149), .preset(1'b0), .next_state(N115), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(parser_sd_rfifo_pop), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_13_ ( .clear(N149), .preset(1'b0), .next_state(N114), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(fifo_write_push), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_12_ ( .clear(N149), .preset(1'b0), .next_state(N113), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(fifo_read_pop), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_11_ ( .clear(N149), .preset(1'b0), .next_state(N112), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(blender_op[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_10_ ( .clear(N149), .preset(1'b0), .next_state(N111), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(blender_op[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_9_ ( .clear(N149), .preset(1'b0), .next_state(N110), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(blender_op[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_8_ ( .clear(N149), .preset(1'b0), .next_state(N109), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(blender_op[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_7_ ( .clear(N149), .preset(1'b0), .next_state(N108), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_6_ ( .clear(N149), .preset(1'b0), .next_state(N107), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_5_ ( .clear(N149), .preset(1'b0), .next_state(N106), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_4_ ( .clear(N149), .preset(1'b0), .next_state(N105), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_3_ ( .clear(N149), .preset(1'b0), .next_state(N104), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_2_ ( .clear(N149), .preset(1'b0), .next_state(N103), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_1_ ( .clear(N149), .preset(1'b0), .next_state(N102), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_bus_reg_0_ ( .clear(N149), .preset(1'b0), .next_state(N101), 
        .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), .Q(
        risc_Instrn_lo[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_OR2 C211 ( .A(N127), .B(N134), .Z(N121) );
  GTECH_OR2 C217 ( .A(N133), .B(N128), .Z(N123) );
  GTECH_OR2 C221 ( .A(risc_Xecutng_Instrn_lo[1]), .B(N125), .Z(N127) );
  GTECH_OR2 C222 ( .A(N126), .B(sd_wfifo_parser_full), .Z(N128) );
  GTECH_OR2 C223 ( .A(N127), .B(N128), .Z(N129) );
  GTECH_OR2 C227 ( .A(N131), .B(risc_Xecutng_Instrn_lo[0]), .Z(N133) );
  GTECH_OR2 C228 ( .A(sd_rfifo_parser_empty), .B(N132), .Z(N134) );
  GTECH_OR2 C229 ( .A(N133), .B(N134), .Z(N135) );
  GTECH_AND2 C231 ( .A(risc_Xecutng_Instrn_lo[1]), .B(
        risc_Xecutng_Instrn_lo[0]), .Z(N137) );
  GTECH_AND2 C232 ( .A(sd_rfifo_parser_empty), .B(sd_wfifo_parser_full), .Z(
        N138) );
  GTECH_AND2 C233 ( .A(N137), .B(N138), .Z(N139) );
  \**SEQGEN**  sd_w_mux_select_reg_1_ ( .clear(N149), .preset(1'b0), 
        .next_state(N148), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_w_mux_select[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sd_w_mux_select_reg_0_ ( .clear(N149), .preset(1'b0), 
        .next_state(N147), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_w_mux_select[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pci_w_mux_select_reg_1_ ( .clear(N149), .preset(1'b0), 
        .next_state(N146), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(pci_w_mux_select[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  pci_w_mux_select_reg_0_ ( .clear(N149), .preset(1'b0), 
        .next_state(N145), .clocked_on(sys_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(pci_w_mux_select[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(sys_rst_n), .Z(N149) );
  ADD_UNS_OP add_143 ( .A(i_reg[10:7]), .B(i_reg[3:0]), .Z({N36, N35, N34, N33}) );
  SELECT_OP C267 ( .DATA1({1'b0, i_reg[19:4]}), .DATA2({1'b0, i_reg[18:3]}), 
        .DATA3({1'b0, i_reg[17:9], i_reg[6:0]}), .DATA4({1'b0, i_reg[16:1]}), 
        .DATA5({1'b0, i_reg[19:10], i_reg[5:0]}), .DATA6({1'b1, N68, N69, N70, 
        N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83}), 
        .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(
        N4), .CONTROL6(N67), .Z({N100, N99, N98, N97, N96, N95, N94, N93, N92, 
        N91, N90, N89, N88, N87, N86, N85, N84}) );
  GTECH_BUF B_0 ( .A(N44), .Z(N0) );
  GTECH_BUF B_1 ( .A(N50), .Z(N1) );
  GTECH_BUF B_2 ( .A(N54), .Z(N2) );
  GTECH_BUF B_3 ( .A(N58), .Z(N3) );
  GTECH_BUF B_4 ( .A(N62), .Z(N4) );
  SELECT_OP C268 ( .DATA1({N100, N100, N100, N100, N99, N98, N97, N96, N95, 
        N94, N93, N92, N91, N90, N89, N88, N87, N86, N85, N84}), .DATA2(i_reg), 
        .CONTROL1(N5), .CONTROL2(N6), .Z({N120, N119, N118, N117, N116, N115, 
        N114, N113, N112, N111, N110, N109, N108, N107, N106, N105, N104, N103, 
        N102, N101}) );
  GTECH_BUF B_5 ( .A(r_pcmd_valid), .Z(N5) );
  GTECH_BUF B_6 ( .A(N38), .Z(N6) );
  SELECT_OP C269 ( .DATA1({1'b0, 1'b1}), .DATA2({1'b1, 1'b0}), .DATA3({1'b0, 
        1'b0}), .DATA4({1'b1, 1'b1}), .DATA5({1'b1, 1'b1}), .DATA6({1'b0, 1'b1}), .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .CONTROL5(N11), 
        .CONTROL6(N144), .Z({N146, N145}) );
  GTECH_BUF B_7 ( .A(N122), .Z(N7) );
  GTECH_BUF B_8 ( .A(N124), .Z(N8) );
  GTECH_BUF B_9 ( .A(N130), .Z(N9) );
  GTECH_BUF B_10 ( .A(N136), .Z(N10) );
  GTECH_BUF B_11 ( .A(N139), .Z(N11) );
  SELECT_OP C270 ( .DATA1({1'b1, 1'b0}), .DATA2({1'b0, 1'b1}), .DATA3({1'b1, 
        1'b1}), .DATA4({1'b0, 1'b0}), .DATA5({1'b1, 1'b1}), .DATA6({1'b0, 1'b1}), .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .CONTROL5(N11), 
        .CONTROL6(N144), .Z({N148, N147}) );
  GTECH_AND2 C273 ( .A(risc_Instrn_lo[0]), .B(blender_op[0]), .Z(context_en)
         );
  GTECH_AND2 C274 ( .A(r_pcmd_valid), .B(r_pcmd[2]), .Z(N12) );
  GTECH_XOR2 C275 ( .A(sd_wfifo_parser_full), .B(sd_rfifo_parser_empty), .Z(
        N13) );
  GTECH_XOR2 C276 ( .A(sd_rfifo_parser_empty), .B(risc_Xecutng_Instrn_lo[0]), 
        .Z(N14) );
  GTECH_XOR2 C277 ( .A(risc_Xecutng_Instrn_lo[0]), .B(
        risc_Xecutng_Instrn_lo[1]), .Z(N15) );
  GTECH_XOR2 C278 ( .A(risc_Xecutng_Instrn_lo[1]), .B(
        risc_Xecutng_Instrn_lo[2]), .Z(N16) );
  GTECH_XOR2 C279 ( .A(risc_Xecutng_Instrn_lo[2]), .B(
        risc_Xecutng_Instrn_lo[3]), .Z(N17) );
  GTECH_XOR2 C280 ( .A(risc_Xecutng_Instrn_lo[3]), .B(
        risc_Xecutng_Instrn_lo[4]), .Z(N18) );
  GTECH_XOR2 C281 ( .A(risc_Xecutng_Instrn_lo[4]), .B(
        risc_Xecutng_Instrn_lo[5]), .Z(N19) );
  GTECH_XOR2 C282 ( .A(risc_Xecutng_Instrn_lo[5]), .B(
        risc_Xecutng_Instrn_lo[6]), .Z(N20) );
  GTECH_XOR2 C283 ( .A(risc_Xecutng_Instrn_lo[6]), .B(
        risc_Xecutng_Instrn_lo[7]), .Z(N21) );
  GTECH_XOR2 C284 ( .A(risc_Xecutng_Instrn_lo[7]), .B(
        risc_Xecutng_Instrn_lo[8]), .Z(N22) );
  GTECH_XOR2 C285 ( .A(risc_Xecutng_Instrn_lo[8]), .B(
        risc_Xecutng_Instrn_lo[9]), .Z(N23) );
  GTECH_XOR2 C286 ( .A(risc_Xecutng_Instrn_lo[9]), .B(
        risc_Xecutng_Instrn_lo[10]), .Z(N24) );
  GTECH_XOR2 C287 ( .A(risc_Xecutng_Instrn_lo[10]), .B(
        risc_Xecutng_Instrn_lo[11]), .Z(N25) );
  GTECH_XOR2 C288 ( .A(risc_Xecutng_Instrn_lo[11]), .B(
        risc_Xecutng_Instrn_lo[12]), .Z(N26) );
  GTECH_XOR2 C289 ( .A(risc_Xecutng_Instrn_lo[12]), .B(
        risc_Xecutng_Instrn_lo[13]), .Z(N27) );
  GTECH_XOR2 C290 ( .A(risc_Xecutng_Instrn_lo[13]), .B(
        risc_Xecutng_Instrn_lo[14]), .Z(N28) );
  GTECH_XOR2 C291 ( .A(risc_Xecutng_Instrn_lo[14]), .B(
        risc_Xecutng_Instrn_lo[15]), .Z(N29) );
  GTECH_XOR2 C292 ( .A(risc_Xecutng_Instrn_lo[15]), .B(fifo_write_full), .Z(
        N30) );
  GTECH_XOR2 C293 ( .A(fifo_write_full), .B(fifo_read_empty), .Z(N31) );
  GTECH_XOR2 C294 ( .A(sd_wfifo_parser_full), .B(fifo_read_empty), .Z(N32) );
  GTECH_BUF B_12 ( .A(sys_rst_n) );
  GTECH_XOR2 C297 ( .A(i_reg[17]), .B(i_reg[13]), .Z(N37) );
  GTECH_NOT I_1 ( .A(r_pcmd_valid), .Z(N38) );
  GTECH_NOT I_2 ( .A(r_pcmd[2]), .Z(N39) );
  GTECH_NOT I_3 ( .A(r_pcmd[0]), .Z(N40) );
  GTECH_NOT I_4 ( .A(N43), .Z(N44) );
  GTECH_NOT I_5 ( .A(r_pcmd[3]), .Z(N45) );
  GTECH_NOT I_6 ( .A(r_pcmd[1]), .Z(N46) );
  GTECH_NOT I_7 ( .A(N49), .Z(N50) );
  GTECH_NOT I_8 ( .A(N53), .Z(N54) );
  GTECH_NOT I_9 ( .A(N57), .Z(N58) );
  GTECH_NOT I_10 ( .A(N61), .Z(N62) );
  GTECH_OR2 C321 ( .A(N50), .B(N44), .Z(N63) );
  GTECH_OR2 C322 ( .A(N54), .B(N63), .Z(N64) );
  GTECH_OR2 C323 ( .A(N58), .B(N64), .Z(N65) );
  GTECH_OR2 C324 ( .A(N62), .B(N65), .Z(N66) );
  GTECH_NOT I_11 ( .A(N66), .Z(N67) );
  GTECH_NOT I_12 ( .A(i_reg[19]), .Z(N68) );
  GTECH_NOT I_13 ( .A(i_reg[18]), .Z(N69) );
  GTECH_NOT I_14 ( .A(i_reg[17]), .Z(N70) );
  GTECH_NOT I_15 ( .A(i_reg[16]), .Z(N71) );
  GTECH_NOT I_16 ( .A(i_reg[15]), .Z(N72) );
  GTECH_NOT I_17 ( .A(i_reg[14]), .Z(N73) );
  GTECH_NOT I_18 ( .A(i_reg[13]), .Z(N74) );
  GTECH_NOT I_19 ( .A(i_reg[12]), .Z(N75) );
  GTECH_NOT I_20 ( .A(i_reg[11]), .Z(N76) );
  GTECH_NOT I_21 ( .A(i_reg[10]), .Z(N77) );
  GTECH_NOT I_22 ( .A(i_reg[9]), .Z(N78) );
  GTECH_NOT I_23 ( .A(i_reg[8]), .Z(N79) );
  GTECH_NOT I_24 ( .A(i_reg[7]), .Z(N80) );
  GTECH_NOT I_25 ( .A(i_reg[6]), .Z(N81) );
  GTECH_NOT I_26 ( .A(i_reg[5]), .Z(N82) );
  GTECH_NOT I_27 ( .A(i_reg[4]), .Z(N83) );
  GTECH_NOT I_28 ( .A(N121), .Z(N122) );
  GTECH_NOT I_29 ( .A(N123), .Z(N124) );
  GTECH_NOT I_30 ( .A(risc_Xecutng_Instrn_lo[0]), .Z(N125) );
  GTECH_NOT I_31 ( .A(sd_rfifo_parser_empty), .Z(N126) );
  GTECH_NOT I_32 ( .A(N129), .Z(N130) );
  GTECH_NOT I_33 ( .A(risc_Xecutng_Instrn_lo[1]), .Z(N131) );
  GTECH_NOT I_34 ( .A(sd_wfifo_parser_full), .Z(N132) );
  GTECH_NOT I_35 ( .A(N135), .Z(N136) );
  GTECH_OR2 C355 ( .A(N124), .B(N122), .Z(N140) );
  GTECH_OR2 C356 ( .A(N130), .B(N140), .Z(N141) );
  GTECH_OR2 C357 ( .A(N136), .B(N141), .Z(N142) );
  GTECH_OR2 C358 ( .A(N139), .B(N142), .Z(N143) );
  GTECH_NOT I_36 ( .A(N143), .Z(N144) );
endmodule


module CONTEXT_MEM ( sys_clk, sys_rst_n, context_en, cmd, pci_data_in, 
        pci_context_data );
  input [7:0] cmd;
  input [31:0] pci_data_in;
  output [31:0] pci_context_data;
  input sys_clk, sys_rst_n, context_en;

  assign pci_context_data[31] = pci_data_in[31];
  assign pci_context_data[30] = pci_data_in[30];
  assign pci_context_data[29] = pci_data_in[29];
  assign pci_context_data[28] = pci_data_in[28];
  assign pci_context_data[27] = pci_data_in[27];
  assign pci_context_data[26] = pci_data_in[26];
  assign pci_context_data[25] = pci_data_in[25];
  assign pci_context_data[24] = pci_data_in[24];
  assign pci_context_data[23] = pci_data_in[23];
  assign pci_context_data[22] = pci_data_in[22];
  assign pci_context_data[21] = pci_data_in[21];
  assign pci_context_data[20] = pci_data_in[20];
  assign pci_context_data[19] = pci_data_in[19];
  assign pci_context_data[18] = pci_data_in[18];
  assign pci_context_data[17] = pci_data_in[17];
  assign pci_context_data[16] = pci_data_in[16];
  assign pci_context_data[15] = pci_data_in[15];
  assign pci_context_data[14] = pci_data_in[14];
  assign pci_context_data[13] = pci_data_in[13];
  assign pci_context_data[12] = pci_data_in[12];
  assign pci_context_data[11] = pci_data_in[11];
  assign pci_context_data[10] = pci_data_in[10];
  assign pci_context_data[9] = pci_data_in[9];
  assign pci_context_data[8] = pci_data_in[8];
  assign pci_context_data[7] = pci_data_in[7];
  assign pci_context_data[6] = pci_data_in[6];
  assign pci_context_data[5] = pci_data_in[5];
  assign pci_context_data[4] = pci_data_in[4];
  assign pci_context_data[3] = pci_data_in[3];
  assign pci_context_data[2] = pci_data_in[2];
  assign pci_context_data[1] = pci_data_in[1];
  assign pci_context_data[0] = pci_data_in[0];

endmodule


module ALU ( reset_n, clk, Oprnd_A, Oprnd_B, ALU_OP, Latch_Result, Latch_Flags, 
        Lachd_Result, Zro_Flag, Neg_Flag, Carry_Flag );
  input [15:0] Oprnd_A;
  input [15:0] Oprnd_B;
  input [5:0] ALU_OP;
  output [15:0] Lachd_Result;
  input reset_n, clk, Latch_Result, Latch_Flags;
  output Zro_Flag, Neg_Flag, Carry_Flag;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, ALU_Zro, ALU_Neg, N25,
         N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37, N38, N39,
         N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53,
         N54, N55, N56, N57, N58, N59, N60, N61, N62, N63, N64, N65, N66, N67,
         N68, N69, N70, N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81,
         N82, N83, N84, N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95,
         N96, N97, N98, N99, N100, N101, N102, N103, N104, N105, N106, N107,
         N108, N109, N110, N111, N112, N113, N114, N115, N116, N117, N118,
         N119, N120, N121, N122, N123, N124, N125, N126, N127, N128, N129,
         N130, N131, N132, N133, N134, N135, N136, N137, N138, N139, N140,
         N141, N142, N143, N144, N145, N146, N147, N148, N149, N150, N151,
         N152, N153, N154, N155, N156, N157, N158, N159, N160, N161, N162,
         N163, N164, N165, N166, N167, N168, N169, N170, N171, N172, N173,
         N174, N175, N176, N177, N178, N179, N180, N181, N182, N183, N184,
         N185, N186, N187, N188, N189, N190, N191, N192, N193, N194, N195,
         N196, N197, N198, N199, N200, N201, N202, N203, N204, N205, N206,
         N207, N208, N209, N210, N211, N212, N213, N214, N215, N216, N217,
         N218, N219, N220, N221, N222, N223, N224, N225, N226, N227, N228,
         N229, N230, N231, N232, N233, N234, N235, N236, N237, N238, N239,
         N240, N241, N242, N243, N244, N245, N246, N247, N248, N249, N250,
         N251, N252, N253, N254, N255, N256, N257, N258, N259, N260, N261,
         N262, N263, N264, N265, N266, N267, N268, N269, N270, N271, N272,
         N273, N274, N275, N276, N277, N278, N279, N280, N281, N282, N283,
         N284, N285, N286, N287, N288, N289, N290, N291, N292, N293, N294,
         N295, N296, N297, N298, N299, N300, N301, N302, N303, N304, N305,
         N306, N307, N308, N309, N310, N311, N312, N313, N314, N315, N316,
         N317, N318, N319, N320, N321, N322, N323, N324, N325, N326, N327,
         N328, N329, N330, N331, N332, N333, N334, N335, N336, N337, N338,
         N339, N340, N341, N342, N343, N344, N345, N346, N347, N348, N349,
         N350, N351, N352, N353, N354, N355, N356, N357, N358, N359, N360,
         N361, N362, N363, N364, N365, N366, N367, N368, N369, N370, N371,
         N372, N373, N374, N375, N376, N377, N378, N379, N380, N381, N382,
         N383, N384, N385, N386, N387, N388, N389, N390, N391, N392, N393,
         N394, N395, N396, N397, N398, N399, N400, N401, N402, N403, N404,
         N405, N406, N407, N408, N409, N410, N411, N412, N413, N414, N415,
         N416, N417, N418, N419, N420, N421, N422, N423, N424, N425, N426,
         N427, N428, N429, N430, N431, N432, N433, N434, N435, N436, N437,
         N438, N439, N440, N441, N442, N443, N444, N445, N446, N447, N448,
         N449, N450, N451, N452, N453, N454, N455, N456, N457, N458, N459,
         N460;
  wire   [15:0] Result;

  \**SEQGEN**  Lachd_Result_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[15]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[14]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[13]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[12]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Result[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Lachd_Result[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[9]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[8]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[7]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[6]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[5]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[4]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Lachd_Result_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        Result[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Lachd_Result[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Result) );
  \**SEQGEN**  Carry_Flag_reg ( .clear(N456), .preset(1'b0), .next_state(1'b0), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Carry_Flag), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(Latch_Flags) );
  \**SEQGEN**  Zro_Flag_reg ( .clear(N456), .preset(1'b0), .next_state(ALU_Zro), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Zro_Flag), .synch_clear(
        1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        Latch_Flags) );
  \**SEQGEN**  Neg_Flag_reg ( .clear(N456), .preset(1'b0), .next_state(ALU_Neg), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Neg_Flag), .synch_clear(
        1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        Latch_Flags) );
  GTECH_AND2 C74 ( .A(N39), .B(N100), .Z(N27) );
  GTECH_AND2 C75 ( .A(N40), .B(N34), .Z(N28) );
  GTECH_AND2 C76 ( .A(N27), .B(N28), .Z(N29) );
  GTECH_AND2 C77 ( .A(N29), .B(N41), .Z(N30) );
  GTECH_OR2 C81 ( .A(N35), .B(N59), .Z(N31) );
  GTECH_OR2 C82 ( .A(N31), .B(N41), .Z(N32) );
  GTECH_OR2 C85 ( .A(ALU_OP[4]), .B(ALU_OP[3]), .Z(N35) );
  GTECH_OR2 C86 ( .A(ALU_OP[2]), .B(N34), .Z(N36) );
  GTECH_OR2 C87 ( .A(N35), .B(N36), .Z(N37) );
  GTECH_OR2 C88 ( .A(N37), .B(ALU_OP[0]), .Z(N38) );
  GTECH_OR2 C92 ( .A(N39), .B(ALU_OP[3]), .Z(N42) );
  GTECH_OR2 C93 ( .A(N40), .B(ALU_OP[1]), .Z(N43) );
  GTECH_OR2 C94 ( .A(N42), .B(N43), .Z(N44) );
  GTECH_OR2 C95 ( .A(N44), .B(N41), .Z(N45) );
  GTECH_OR2 C100 ( .A(N40), .B(N34), .Z(N46) );
  GTECH_OR2 C101 ( .A(N35), .B(N46), .Z(N47) );
  GTECH_OR2 C102 ( .A(N47), .B(N41), .Z(N48) );
  GTECH_OR2 C109 ( .A(N37), .B(N41), .Z(N50) );
  GTECH_OR2 C115 ( .A(N35), .B(N43), .Z(N52) );
  GTECH_OR2 C116 ( .A(N52), .B(N41), .Z(N53) );
  GTECH_OR2 C122 ( .A(N52), .B(ALU_OP[0]), .Z(N55) );
  GTECH_OR2 C129 ( .A(N47), .B(ALU_OP[0]), .Z(N57) );
  GTECH_OR2 C133 ( .A(ALU_OP[2]), .B(ALU_OP[1]), .Z(N59) );
  GTECH_OR2 C134 ( .A(N42), .B(N59), .Z(N60) );
  GTECH_OR2 C135 ( .A(N60), .B(ALU_OP[0]), .Z(N61) );
  GTECH_OR2 C142 ( .A(N60), .B(N41), .Z(N63) );
  GTECH_OR2 C148 ( .A(N42), .B(N36), .Z(N65) );
  GTECH_OR2 C149 ( .A(N65), .B(ALU_OP[0]), .Z(N66) );
  GTECH_OR2 C157 ( .A(N65), .B(N41), .Z(N68) );
  GTECH_OR2 C161 ( .A(N39), .B(N100), .Z(N70) );
  GTECH_OR2 C163 ( .A(N70), .B(N59), .Z(N71) );
  GTECH_OR2 C164 ( .A(N71), .B(ALU_OP[0]), .Z(N72) );
  GTECH_OR2 C172 ( .A(N71), .B(N41), .Z(N74) );
  GTECH_OR2 C179 ( .A(N70), .B(N36), .Z(N76) );
  GTECH_OR2 C180 ( .A(N76), .B(ALU_OP[0]), .Z(N77) );
  GTECH_OR2 C189 ( .A(N76), .B(N41), .Z(N79) );
  GTECH_OR2 C196 ( .A(N44), .B(ALU_OP[0]), .Z(N81) );
  GTECH_OR2 C203 ( .A(N42), .B(N46), .Z(N83) );
  GTECH_OR2 C204 ( .A(N83), .B(ALU_OP[0]), .Z(N84) );
  GTECH_OR2 C213 ( .A(N83), .B(N41), .Z(N86) );
  GTECH_OR2 C220 ( .A(N70), .B(N43), .Z(N88) );
  GTECH_OR2 C221 ( .A(N88), .B(ALU_OP[0]), .Z(N89) );
  GTECH_OR2 C230 ( .A(N88), .B(N41), .Z(N91) );
  GTECH_OR2 C238 ( .A(N70), .B(N46), .Z(N93) );
  GTECH_OR2 C239 ( .A(N93), .B(ALU_OP[0]), .Z(N94) );
  GTECH_AND2 C241 ( .A(ALU_OP[4]), .B(ALU_OP[3]), .Z(N96) );
  GTECH_AND2 C242 ( .A(ALU_OP[2]), .B(ALU_OP[1]), .Z(N97) );
  GTECH_AND2 C243 ( .A(N96), .B(N97), .Z(N98) );
  GTECH_AND2 C244 ( .A(N98), .B(ALU_OP[0]), .Z(N99) );
  GTECH_OR2 C246 ( .A(ALU_OP[4]), .B(N100), .Z(N101) );
  GTECH_OR2 C647 ( .A(Result[14]), .B(Result[15]), .Z(N439) );
  GTECH_OR2 C648 ( .A(Result[13]), .B(N439), .Z(N440) );
  GTECH_OR2 C649 ( .A(Result[12]), .B(N440), .Z(N441) );
  GTECH_OR2 C650 ( .A(Result[11]), .B(N441), .Z(N442) );
  GTECH_OR2 C651 ( .A(Result[10]), .B(N442), .Z(N443) );
  GTECH_OR2 C652 ( .A(Result[9]), .B(N443), .Z(N444) );
  GTECH_OR2 C653 ( .A(Result[8]), .B(N444), .Z(N445) );
  GTECH_OR2 C654 ( .A(Result[7]), .B(N445), .Z(N446) );
  GTECH_OR2 C655 ( .A(Result[6]), .B(N446), .Z(N447) );
  GTECH_OR2 C656 ( .A(Result[5]), .B(N447), .Z(N448) );
  GTECH_OR2 C657 ( .A(Result[4]), .B(N448), .Z(N449) );
  GTECH_OR2 C658 ( .A(Result[3]), .B(N449), .Z(N450) );
  GTECH_OR2 C659 ( .A(Result[2]), .B(N450), .Z(N451) );
  GTECH_OR2 C660 ( .A(Result[1]), .B(N451), .Z(N452) );
  GTECH_OR2 C661 ( .A(Result[0]), .B(N452), .Z(N453) );
  GTECH_NOT I_0 ( .A(N453), .Z(N454) );
  LT_TC_OP lt_161 ( .A(Result), .B(1'b0), .Z(N455) );
  GTECH_NOT I_1 ( .A(reset_n), .Z(N456) );
  ADD_UNS_OP add_85 ( .A(Oprnd_A), .B(Oprnd_B), .Z({N118, N117, N116, N115, 
        N114, N113, N112, N111, N110, N109, N108, N107, N106, N105, N104, N103}) );
  ADD_UNS_OP add_88 ( .A(Oprnd_B), .B(1'b1), .Z({N134, N133, N132, N131, N130, 
        N129, N128, N127, N126, N125, N124, N123, N122, N121, N120, N119}) );
  ADD_UNS_OP add_88_2 ( .A(Oprnd_A), .B({N134, N133, N132, N131, N130, N129, 
        N128, N127, N126, N125, N124, N123, N122, N121, N120, N119}), .Z({N150, 
        N149, N148, N147, N146, N145, N144, N143, N142, N141, N140, N139, N138, 
        N137, N136, N135}) );
  ADD_UNS_OP add_94 ( .A(Oprnd_A), .B(1'b1), .Z({N166, N165, N164, N163, N162, 
        N161, N160, N159, N158, N157, N156, N155, N154, N153, N152, N151}) );
  SUB_UNS_OP sub_97 ( .A(Oprnd_A), .B(Oprnd_B), .Z({N182, N181, N180, N179, 
        N178, N177, N176, N175, N174, N173, N172, N171, N170, N169, N168, N167}) );
  SUB_TC_OP sub_103 ( .A(Oprnd_A), .B({1'b0, 1'b1}), .Z({N230, N229, N228, 
        N227, N226, N225, N224, N223, N222, N221, N220, N219, N218, N217, N216, 
        N215}) );
  ADD_UNS_OP add_100 ( .A(Oprnd_B), .B(1'b1), .Z({N198, N197, N196, N195, N194, 
        N193, N192, N191, N190, N189, N188, N187, N186, N185, N184, N183}) );
  SUB_UNS_OP sub_100 ( .A(Oprnd_A), .B({N198, N197, N196, N195, N194, N193, 
        N192, N191, N190, N189, N188, N187, N186, N185, N184, N183}), .Z({N214, 
        N213, N212, N211, N210, N209, N208, N207, N206, N205, N204, N203, N202, 
        N201, N200, N199}) );
  SELECT_OP C677 ( .DATA1({N118, N117, N116, N115, N114, N113, N112, N111, 
        N110, N109, N108, N107, N106, N105, N104, N103}), .DATA2({N150, N149, 
        N148, N147, N146, N145, N144, N143, N142, N141, N140, N139, N138, N137, 
        N136, N135}), .DATA3(Oprnd_A), .DATA4({N166, N165, N164, N163, N162, 
        N161, N160, N159, N158, N157, N156, N155, N154, N153, N152, N151}), 
        .DATA5({N182, N181, N180, N179, N178, N177, N176, N175, N174, N173, 
        N172, N171, N170, N169, N168, N167}), .DATA6({N214, N213, N212, N211, 
        N210, N209, N208, N207, N206, N205, N204, N203, N202, N201, N200, N199}), .DATA7({N230, N229, N228, N227, N226, N225, N224, N223, N222, N221, N220, 
        N219, N218, N217, N216, N215}), .DATA8({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA9({N231, N232, N233, N234, N235, N236, N237, N238, N239, N240, 
        N241, N242, N243, N244, N245, N246}), .DATA10({N247, N248, N249, N250, 
        N251, N252, N253, N254, N255, N256, N257, N258, N259, N260, N261, N262}), .DATA11(Oprnd_B), .DATA12({N263, N264, N265, N266, N267, N268, N269, N270, 
        N271, N272, N273, N274, N275, N276, N277, N278}), .DATA13({N279, N280, 
        N281, N282, N283, N284, N285, N286, N287, N288, N289, N290, N291, N292, 
        N293, N294}), .DATA14({N295, N296, N297, N298, N299, N300, N301, N302, 
        N303, N304, N305, N306, N307, N308, N309, N310}), .DATA15({N311, N312, 
        N313, N314, N315, N316, N317, N318, N319, N320, N321, N322, N323, N324, 
        N325, N326}), .DATA16({N327, N328, N329, N330, N331, N332, N333, N334, 
        N335, N336, N337, N338, N339, N340, N341, N342}), .DATA17({N343, N344, 
        N345, N346, N347, N348, N349, N350, N351, N352, N353, N354, N355, N356, 
        N357, N358}), .DATA18({N359, N360, N361, N362, N363, N364, N365, N366, 
        N367, N368, N369, N370, N371, N372, N373, N374}), .DATA19({N375, N376, 
        N377, N378, N379, N380, N381, N382, N383, N384, N385, N386, N387, N388, 
        N389, N390}), .DATA20({N391, N392, N393, N394, N395, N396, N397, N398, 
        N399, N400, N401, N402, N403, N404, N405, N406}), .DATA21({N407, N408, 
        N409, N410, N411, N412, N413, N414, N415, N416, N417, N418, N419, N420, 
        N421, N422}), .DATA22({1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1}), .DATA23({1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .CONTROL4(
        N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(N6), .CONTROL8(N7), 
        .CONTROL9(N8), .CONTROL10(N9), .CONTROL11(N10), .CONTROL12(N11), 
        .CONTROL13(N12), .CONTROL14(N13), .CONTROL15(N14), .CONTROL16(N15), 
        .CONTROL17(N16), .CONTROL18(N17), .CONTROL19(N18), .CONTROL20(N19), 
        .CONTROL21(N20), .CONTROL22(N21), .CONTROL23(N22), .Z({N438, N437, 
        N436, N435, N434, N433, N432, N431, N430, N429, N428, N427, N426, N425, 
        N424, N423}) );
  GTECH_BUF B_0 ( .A(N30), .Z(N0) );
  GTECH_BUF B_1 ( .A(N33), .Z(N1) );
  GTECH_BUF B_2 ( .A(N49), .Z(N2) );
  GTECH_BUF B_3 ( .A(N51), .Z(N3) );
  GTECH_BUF B_4 ( .A(N54), .Z(N4) );
  GTECH_BUF B_5 ( .A(N56), .Z(N5) );
  GTECH_BUF B_6 ( .A(N58), .Z(N6) );
  GTECH_BUF B_7 ( .A(N62), .Z(N7) );
  GTECH_BUF B_8 ( .A(N64), .Z(N8) );
  GTECH_BUF B_9 ( .A(N67), .Z(N9) );
  GTECH_BUF B_10 ( .A(N69), .Z(N10) );
  GTECH_BUF B_11 ( .A(N73), .Z(N11) );
  GTECH_BUF B_12 ( .A(N75), .Z(N12) );
  GTECH_BUF B_13 ( .A(N78), .Z(N13) );
  GTECH_BUF B_14 ( .A(N80), .Z(N14) );
  GTECH_BUF B_15 ( .A(N82), .Z(N15) );
  GTECH_BUF B_16 ( .A(N85), .Z(N16) );
  GTECH_BUF B_17 ( .A(N87), .Z(N17) );
  GTECH_BUF B_18 ( .A(N90), .Z(N18) );
  GTECH_BUF B_19 ( .A(N92), .Z(N19) );
  GTECH_BUF B_20 ( .A(N95), .Z(N20) );
  GTECH_BUF B_21 ( .A(N99), .Z(N21) );
  GTECH_BUF B_22 ( .A(N102), .Z(N22) );
  SELECT_OP C678 ( .DATA1({N438, N437, N436, N435, N434, N433, N432, N431, 
        N430, N429, N428, N427, N426, N425, N424, N423}), .DATA2({1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .CONTROL1(N23), .CONTROL2(N24), .Z(Result) );
  GTECH_BUF B_23 ( .A(N25), .Z(N23) );
  GTECH_BUF B_24 ( .A(ALU_OP[5]), .Z(N24) );
  GTECH_NOT I_2 ( .A(ALU_OP[5]), .Z(N25) );
  GTECH_BUF B_25 ( .A(N25), .Z(N26) );
  GTECH_NOT I_3 ( .A(N32), .Z(N33) );
  GTECH_NOT I_4 ( .A(ALU_OP[1]), .Z(N34) );
  GTECH_NOT I_5 ( .A(ALU_OP[4]), .Z(N39) );
  GTECH_NOT I_6 ( .A(ALU_OP[2]), .Z(N40) );
  GTECH_NOT I_7 ( .A(ALU_OP[0]), .Z(N41) );
  GTECH_OR2 C692 ( .A(N459), .B(N460), .Z(N49) );
  GTECH_OR2 C693 ( .A(N457), .B(N458), .Z(N459) );
  GTECH_NOT I_8 ( .A(N38), .Z(N457) );
  GTECH_NOT I_9 ( .A(N45), .Z(N458) );
  GTECH_NOT I_10 ( .A(N48), .Z(N460) );
  GTECH_NOT I_11 ( .A(N50), .Z(N51) );
  GTECH_NOT I_12 ( .A(N53), .Z(N54) );
  GTECH_NOT I_13 ( .A(N55), .Z(N56) );
  GTECH_NOT I_14 ( .A(N57), .Z(N58) );
  GTECH_NOT I_15 ( .A(N61), .Z(N62) );
  GTECH_NOT I_16 ( .A(N63), .Z(N64) );
  GTECH_NOT I_17 ( .A(N66), .Z(N67) );
  GTECH_NOT I_18 ( .A(N68), .Z(N69) );
  GTECH_NOT I_19 ( .A(N72), .Z(N73) );
  GTECH_NOT I_20 ( .A(N74), .Z(N75) );
  GTECH_NOT I_21 ( .A(N77), .Z(N78) );
  GTECH_NOT I_22 ( .A(N79), .Z(N80) );
  GTECH_NOT I_23 ( .A(N81), .Z(N82) );
  GTECH_NOT I_24 ( .A(N84), .Z(N85) );
  GTECH_NOT I_25 ( .A(N86), .Z(N87) );
  GTECH_NOT I_26 ( .A(N89), .Z(N90) );
  GTECH_NOT I_27 ( .A(N91), .Z(N92) );
  GTECH_NOT I_28 ( .A(N94), .Z(N95) );
  GTECH_NOT I_29 ( .A(ALU_OP[3]), .Z(N100) );
  GTECH_NOT I_30 ( .A(N101), .Z(N102) );
  GTECH_AND2 C740 ( .A(N26), .B(N30) );
  GTECH_AND2 C741 ( .A(N26), .B(N33) );
  GTECH_AND2 C742 ( .A(N26), .B(N51) );
  GTECH_AND2 C743 ( .A(N26), .B(N54) );
  GTECH_AND2 C744 ( .A(N26), .B(N56) );
  GTECH_AND2 C745 ( .A(N26), .B(N58) );
  GTECH_AND2 C746 ( .A(Oprnd_A[15]), .B(Oprnd_B[15]), .Z(N231) );
  GTECH_AND2 C747 ( .A(Oprnd_A[14]), .B(Oprnd_B[14]), .Z(N232) );
  GTECH_AND2 C748 ( .A(Oprnd_A[13]), .B(Oprnd_B[13]), .Z(N233) );
  GTECH_AND2 C749 ( .A(Oprnd_A[12]), .B(Oprnd_B[12]), .Z(N234) );
  GTECH_AND2 C750 ( .A(Oprnd_A[11]), .B(Oprnd_B[11]), .Z(N235) );
  GTECH_AND2 C751 ( .A(Oprnd_A[10]), .B(Oprnd_B[10]), .Z(N236) );
  GTECH_AND2 C752 ( .A(Oprnd_A[9]), .B(Oprnd_B[9]), .Z(N237) );
  GTECH_AND2 C753 ( .A(Oprnd_A[8]), .B(Oprnd_B[8]), .Z(N238) );
  GTECH_AND2 C754 ( .A(Oprnd_A[7]), .B(Oprnd_B[7]), .Z(N239) );
  GTECH_AND2 C755 ( .A(Oprnd_A[6]), .B(Oprnd_B[6]), .Z(N240) );
  GTECH_AND2 C756 ( .A(Oprnd_A[5]), .B(Oprnd_B[5]), .Z(N241) );
  GTECH_AND2 C757 ( .A(Oprnd_A[4]), .B(Oprnd_B[4]), .Z(N242) );
  GTECH_AND2 C758 ( .A(Oprnd_A[3]), .B(Oprnd_B[3]), .Z(N243) );
  GTECH_AND2 C759 ( .A(Oprnd_A[2]), .B(Oprnd_B[2]), .Z(N244) );
  GTECH_AND2 C760 ( .A(Oprnd_A[1]), .B(Oprnd_B[1]), .Z(N245) );
  GTECH_AND2 C761 ( .A(Oprnd_A[0]), .B(Oprnd_B[0]), .Z(N246) );
  GTECH_AND2 C762 ( .A(N295), .B(Oprnd_B[15]), .Z(N247) );
  GTECH_AND2 C763 ( .A(N296), .B(Oprnd_B[14]), .Z(N248) );
  GTECH_AND2 C764 ( .A(N297), .B(Oprnd_B[13]), .Z(N249) );
  GTECH_AND2 C765 ( .A(N298), .B(Oprnd_B[12]), .Z(N250) );
  GTECH_AND2 C766 ( .A(N299), .B(Oprnd_B[11]), .Z(N251) );
  GTECH_AND2 C767 ( .A(N300), .B(Oprnd_B[10]), .Z(N252) );
  GTECH_AND2 C768 ( .A(N301), .B(Oprnd_B[9]), .Z(N253) );
  GTECH_AND2 C769 ( .A(N302), .B(Oprnd_B[8]), .Z(N254) );
  GTECH_AND2 C770 ( .A(N303), .B(Oprnd_B[7]), .Z(N255) );
  GTECH_AND2 C771 ( .A(N304), .B(Oprnd_B[6]), .Z(N256) );
  GTECH_AND2 C772 ( .A(N305), .B(Oprnd_B[5]), .Z(N257) );
  GTECH_AND2 C773 ( .A(N306), .B(Oprnd_B[4]), .Z(N258) );
  GTECH_AND2 C774 ( .A(N307), .B(Oprnd_B[3]), .Z(N259) );
  GTECH_AND2 C775 ( .A(N308), .B(Oprnd_B[2]), .Z(N260) );
  GTECH_AND2 C776 ( .A(N309), .B(Oprnd_B[1]), .Z(N261) );
  GTECH_AND2 C777 ( .A(N310), .B(Oprnd_B[0]), .Z(N262) );
  GTECH_AND2 C778 ( .A(N295), .B(N375), .Z(N263) );
  GTECH_AND2 C779 ( .A(N296), .B(N376), .Z(N264) );
  GTECH_AND2 C780 ( .A(N297), .B(N377), .Z(N265) );
  GTECH_AND2 C781 ( .A(N298), .B(N378), .Z(N266) );
  GTECH_AND2 C782 ( .A(N299), .B(N379), .Z(N267) );
  GTECH_AND2 C783 ( .A(N300), .B(N380), .Z(N268) );
  GTECH_AND2 C784 ( .A(N301), .B(N381), .Z(N269) );
  GTECH_AND2 C785 ( .A(N302), .B(N382), .Z(N270) );
  GTECH_AND2 C786 ( .A(N303), .B(N383), .Z(N271) );
  GTECH_AND2 C787 ( .A(N304), .B(N384), .Z(N272) );
  GTECH_AND2 C788 ( .A(N305), .B(N385), .Z(N273) );
  GTECH_AND2 C789 ( .A(N306), .B(N386), .Z(N274) );
  GTECH_AND2 C790 ( .A(N307), .B(N387), .Z(N275) );
  GTECH_AND2 C791 ( .A(N308), .B(N388), .Z(N276) );
  GTECH_AND2 C792 ( .A(N309), .B(N389), .Z(N277) );
  GTECH_AND2 C793 ( .A(N310), .B(N390), .Z(N278) );
  GTECH_NOT I_31 ( .A(N343), .Z(N279) );
  GTECH_NOT I_32 ( .A(N344), .Z(N280) );
  GTECH_NOT I_33 ( .A(N345), .Z(N281) );
  GTECH_NOT I_34 ( .A(N346), .Z(N282) );
  GTECH_NOT I_35 ( .A(N347), .Z(N283) );
  GTECH_NOT I_36 ( .A(N348), .Z(N284) );
  GTECH_NOT I_37 ( .A(N349), .Z(N285) );
  GTECH_NOT I_38 ( .A(N350), .Z(N286) );
  GTECH_NOT I_39 ( .A(N351), .Z(N287) );
  GTECH_NOT I_40 ( .A(N352), .Z(N288) );
  GTECH_NOT I_41 ( .A(N353), .Z(N289) );
  GTECH_NOT I_42 ( .A(N354), .Z(N290) );
  GTECH_NOT I_43 ( .A(N355), .Z(N291) );
  GTECH_NOT I_44 ( .A(N356), .Z(N292) );
  GTECH_NOT I_45 ( .A(N357), .Z(N293) );
  GTECH_NOT I_46 ( .A(N358), .Z(N294) );
  GTECH_NOT I_47 ( .A(Oprnd_A[15]), .Z(N295) );
  GTECH_NOT I_48 ( .A(Oprnd_A[14]), .Z(N296) );
  GTECH_NOT I_49 ( .A(Oprnd_A[13]), .Z(N297) );
  GTECH_NOT I_50 ( .A(Oprnd_A[12]), .Z(N298) );
  GTECH_NOT I_51 ( .A(Oprnd_A[11]), .Z(N299) );
  GTECH_NOT I_52 ( .A(Oprnd_A[10]), .Z(N300) );
  GTECH_NOT I_53 ( .A(Oprnd_A[9]), .Z(N301) );
  GTECH_NOT I_54 ( .A(Oprnd_A[8]), .Z(N302) );
  GTECH_NOT I_55 ( .A(Oprnd_A[7]), .Z(N303) );
  GTECH_NOT I_56 ( .A(Oprnd_A[6]), .Z(N304) );
  GTECH_NOT I_57 ( .A(Oprnd_A[5]), .Z(N305) );
  GTECH_NOT I_58 ( .A(Oprnd_A[4]), .Z(N306) );
  GTECH_NOT I_59 ( .A(Oprnd_A[3]), .Z(N307) );
  GTECH_NOT I_60 ( .A(Oprnd_A[2]), .Z(N308) );
  GTECH_NOT I_61 ( .A(Oprnd_A[1]), .Z(N309) );
  GTECH_NOT I_62 ( .A(Oprnd_A[0]), .Z(N310) );
  GTECH_OR2 C826 ( .A(N295), .B(Oprnd_B[15]), .Z(N311) );
  GTECH_OR2 C827 ( .A(N296), .B(Oprnd_B[14]), .Z(N312) );
  GTECH_OR2 C828 ( .A(N297), .B(Oprnd_B[13]), .Z(N313) );
  GTECH_OR2 C829 ( .A(N298), .B(Oprnd_B[12]), .Z(N314) );
  GTECH_OR2 C830 ( .A(N299), .B(Oprnd_B[11]), .Z(N315) );
  GTECH_OR2 C831 ( .A(N300), .B(Oprnd_B[10]), .Z(N316) );
  GTECH_OR2 C832 ( .A(N301), .B(Oprnd_B[9]), .Z(N317) );
  GTECH_OR2 C833 ( .A(N302), .B(Oprnd_B[8]), .Z(N318) );
  GTECH_OR2 C834 ( .A(N303), .B(Oprnd_B[7]), .Z(N319) );
  GTECH_OR2 C835 ( .A(N304), .B(Oprnd_B[6]), .Z(N320) );
  GTECH_OR2 C836 ( .A(N305), .B(Oprnd_B[5]), .Z(N321) );
  GTECH_OR2 C837 ( .A(N306), .B(Oprnd_B[4]), .Z(N322) );
  GTECH_OR2 C838 ( .A(N307), .B(Oprnd_B[3]), .Z(N323) );
  GTECH_OR2 C839 ( .A(N308), .B(Oprnd_B[2]), .Z(N324) );
  GTECH_OR2 C840 ( .A(N309), .B(Oprnd_B[1]), .Z(N325) );
  GTECH_OR2 C841 ( .A(N310), .B(Oprnd_B[0]), .Z(N326) );
  GTECH_AND2 C842 ( .A(Oprnd_A[15]), .B(N375), .Z(N327) );
  GTECH_AND2 C843 ( .A(Oprnd_A[14]), .B(N376), .Z(N328) );
  GTECH_AND2 C844 ( .A(Oprnd_A[13]), .B(N377), .Z(N329) );
  GTECH_AND2 C845 ( .A(Oprnd_A[12]), .B(N378), .Z(N330) );
  GTECH_AND2 C846 ( .A(Oprnd_A[11]), .B(N379), .Z(N331) );
  GTECH_AND2 C847 ( .A(Oprnd_A[10]), .B(N380), .Z(N332) );
  GTECH_AND2 C848 ( .A(Oprnd_A[9]), .B(N381), .Z(N333) );
  GTECH_AND2 C849 ( .A(Oprnd_A[8]), .B(N382), .Z(N334) );
  GTECH_AND2 C850 ( .A(Oprnd_A[7]), .B(N383), .Z(N335) );
  GTECH_AND2 C851 ( .A(Oprnd_A[6]), .B(N384), .Z(N336) );
  GTECH_AND2 C852 ( .A(Oprnd_A[5]), .B(N385), .Z(N337) );
  GTECH_AND2 C853 ( .A(Oprnd_A[4]), .B(N386), .Z(N338) );
  GTECH_AND2 C854 ( .A(Oprnd_A[3]), .B(N387), .Z(N339) );
  GTECH_AND2 C855 ( .A(Oprnd_A[2]), .B(N388), .Z(N340) );
  GTECH_AND2 C856 ( .A(Oprnd_A[1]), .B(N389), .Z(N341) );
  GTECH_AND2 C857 ( .A(Oprnd_A[0]), .B(N390), .Z(N342) );
  GTECH_XOR2 C858 ( .A(Oprnd_A[15]), .B(Oprnd_B[15]), .Z(N343) );
  GTECH_XOR2 C859 ( .A(Oprnd_A[14]), .B(Oprnd_B[14]), .Z(N344) );
  GTECH_XOR2 C860 ( .A(Oprnd_A[13]), .B(Oprnd_B[13]), .Z(N345) );
  GTECH_XOR2 C861 ( .A(Oprnd_A[12]), .B(Oprnd_B[12]), .Z(N346) );
  GTECH_XOR2 C862 ( .A(Oprnd_A[11]), .B(Oprnd_B[11]), .Z(N347) );
  GTECH_XOR2 C863 ( .A(Oprnd_A[10]), .B(Oprnd_B[10]), .Z(N348) );
  GTECH_XOR2 C864 ( .A(Oprnd_A[9]), .B(Oprnd_B[9]), .Z(N349) );
  GTECH_XOR2 C865 ( .A(Oprnd_A[8]), .B(Oprnd_B[8]), .Z(N350) );
  GTECH_XOR2 C866 ( .A(Oprnd_A[7]), .B(Oprnd_B[7]), .Z(N351) );
  GTECH_XOR2 C867 ( .A(Oprnd_A[6]), .B(Oprnd_B[6]), .Z(N352) );
  GTECH_XOR2 C868 ( .A(Oprnd_A[5]), .B(Oprnd_B[5]), .Z(N353) );
  GTECH_XOR2 C869 ( .A(Oprnd_A[4]), .B(Oprnd_B[4]), .Z(N354) );
  GTECH_XOR2 C870 ( .A(Oprnd_A[3]), .B(Oprnd_B[3]), .Z(N355) );
  GTECH_XOR2 C871 ( .A(Oprnd_A[2]), .B(Oprnd_B[2]), .Z(N356) );
  GTECH_XOR2 C872 ( .A(Oprnd_A[1]), .B(Oprnd_B[1]), .Z(N357) );
  GTECH_XOR2 C873 ( .A(Oprnd_A[0]), .B(Oprnd_B[0]), .Z(N358) );
  GTECH_OR2 C874 ( .A(Oprnd_A[15]), .B(Oprnd_B[15]), .Z(N359) );
  GTECH_OR2 C875 ( .A(Oprnd_A[14]), .B(Oprnd_B[14]), .Z(N360) );
  GTECH_OR2 C876 ( .A(Oprnd_A[13]), .B(Oprnd_B[13]), .Z(N361) );
  GTECH_OR2 C877 ( .A(Oprnd_A[12]), .B(Oprnd_B[12]), .Z(N362) );
  GTECH_OR2 C878 ( .A(Oprnd_A[11]), .B(Oprnd_B[11]), .Z(N363) );
  GTECH_OR2 C879 ( .A(Oprnd_A[10]), .B(Oprnd_B[10]), .Z(N364) );
  GTECH_OR2 C880 ( .A(Oprnd_A[9]), .B(Oprnd_B[9]), .Z(N365) );
  GTECH_OR2 C881 ( .A(Oprnd_A[8]), .B(Oprnd_B[8]), .Z(N366) );
  GTECH_OR2 C882 ( .A(Oprnd_A[7]), .B(Oprnd_B[7]), .Z(N367) );
  GTECH_OR2 C883 ( .A(Oprnd_A[6]), .B(Oprnd_B[6]), .Z(N368) );
  GTECH_OR2 C884 ( .A(Oprnd_A[5]), .B(Oprnd_B[5]), .Z(N369) );
  GTECH_OR2 C885 ( .A(Oprnd_A[4]), .B(Oprnd_B[4]), .Z(N370) );
  GTECH_OR2 C886 ( .A(Oprnd_A[3]), .B(Oprnd_B[3]), .Z(N371) );
  GTECH_OR2 C887 ( .A(Oprnd_A[2]), .B(Oprnd_B[2]), .Z(N372) );
  GTECH_OR2 C888 ( .A(Oprnd_A[1]), .B(Oprnd_B[1]), .Z(N373) );
  GTECH_OR2 C889 ( .A(Oprnd_A[0]), .B(Oprnd_B[0]), .Z(N374) );
  GTECH_NOT I_63 ( .A(Oprnd_B[15]), .Z(N375) );
  GTECH_NOT I_64 ( .A(Oprnd_B[14]), .Z(N376) );
  GTECH_NOT I_65 ( .A(Oprnd_B[13]), .Z(N377) );
  GTECH_NOT I_66 ( .A(Oprnd_B[12]), .Z(N378) );
  GTECH_NOT I_67 ( .A(Oprnd_B[11]), .Z(N379) );
  GTECH_NOT I_68 ( .A(Oprnd_B[10]), .Z(N380) );
  GTECH_NOT I_69 ( .A(Oprnd_B[9]), .Z(N381) );
  GTECH_NOT I_70 ( .A(Oprnd_B[8]), .Z(N382) );
  GTECH_NOT I_71 ( .A(Oprnd_B[7]), .Z(N383) );
  GTECH_NOT I_72 ( .A(Oprnd_B[6]), .Z(N384) );
  GTECH_NOT I_73 ( .A(Oprnd_B[5]), .Z(N385) );
  GTECH_NOT I_74 ( .A(Oprnd_B[4]), .Z(N386) );
  GTECH_NOT I_75 ( .A(Oprnd_B[3]), .Z(N387) );
  GTECH_NOT I_76 ( .A(Oprnd_B[2]), .Z(N388) );
  GTECH_NOT I_77 ( .A(Oprnd_B[1]), .Z(N389) );
  GTECH_NOT I_78 ( .A(Oprnd_B[0]), .Z(N390) );
  GTECH_OR2 C906 ( .A(Oprnd_A[15]), .B(N375), .Z(N391) );
  GTECH_OR2 C907 ( .A(Oprnd_A[14]), .B(N376), .Z(N392) );
  GTECH_OR2 C908 ( .A(Oprnd_A[13]), .B(N377), .Z(N393) );
  GTECH_OR2 C909 ( .A(Oprnd_A[12]), .B(N378), .Z(N394) );
  GTECH_OR2 C910 ( .A(Oprnd_A[11]), .B(N379), .Z(N395) );
  GTECH_OR2 C911 ( .A(Oprnd_A[10]), .B(N380), .Z(N396) );
  GTECH_OR2 C912 ( .A(Oprnd_A[9]), .B(N381), .Z(N397) );
  GTECH_OR2 C913 ( .A(Oprnd_A[8]), .B(N382), .Z(N398) );
  GTECH_OR2 C914 ( .A(Oprnd_A[7]), .B(N383), .Z(N399) );
  GTECH_OR2 C915 ( .A(Oprnd_A[6]), .B(N384), .Z(N400) );
  GTECH_OR2 C916 ( .A(Oprnd_A[5]), .B(N385), .Z(N401) );
  GTECH_OR2 C917 ( .A(Oprnd_A[4]), .B(N386), .Z(N402) );
  GTECH_OR2 C918 ( .A(Oprnd_A[3]), .B(N387), .Z(N403) );
  GTECH_OR2 C919 ( .A(Oprnd_A[2]), .B(N388), .Z(N404) );
  GTECH_OR2 C920 ( .A(Oprnd_A[1]), .B(N389), .Z(N405) );
  GTECH_OR2 C921 ( .A(Oprnd_A[0]), .B(N390), .Z(N406) );
  GTECH_NOT I_79 ( .A(N231), .Z(N407) );
  GTECH_NOT I_80 ( .A(N232), .Z(N408) );
  GTECH_NOT I_81 ( .A(N233), .Z(N409) );
  GTECH_NOT I_82 ( .A(N234), .Z(N410) );
  GTECH_NOT I_83 ( .A(N235), .Z(N411) );
  GTECH_NOT I_84 ( .A(N236), .Z(N412) );
  GTECH_NOT I_85 ( .A(N237), .Z(N413) );
  GTECH_NOT I_86 ( .A(N238), .Z(N414) );
  GTECH_NOT I_87 ( .A(N239), .Z(N415) );
  GTECH_NOT I_88 ( .A(N240), .Z(N416) );
  GTECH_NOT I_89 ( .A(N241), .Z(N417) );
  GTECH_NOT I_90 ( .A(N242), .Z(N418) );
  GTECH_NOT I_91 ( .A(N243), .Z(N419) );
  GTECH_NOT I_92 ( .A(N244), .Z(N420) );
  GTECH_NOT I_93 ( .A(N245), .Z(N421) );
  GTECH_NOT I_94 ( .A(N246), .Z(N422) );
  GTECH_BUF B_26 ( .A(N454), .Z(ALU_Zro) );
  GTECH_BUF B_27 ( .A(N455), .Z(ALU_Neg) );
endmodule


module CONTROL ( clk, reset_n, Crnt_Instrn, Current_State, Neg_Flag, 
        Carry_Flag, Zro_Flag, Latch_Instr, Rd_Oprnd_A, Rd_Oprnd_B, Latch_Flags, 
        Latch_Result, Write_RegC, UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, 
        Reset_AluRegs, EndOfInstrn, PushEnbl, PopEnbl, OUT_VALID );
  input [31:0] Crnt_Instrn;
  input [2:0] Current_State;
  input clk, reset_n, Neg_Flag, Carry_Flag, Zro_Flag;
  output Latch_Instr, Rd_Oprnd_A, Rd_Oprnd_B, Latch_Flags, Latch_Result,
         Write_RegC, UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, Reset_AluRegs,
         EndOfInstrn, PushEnbl, PopEnbl, OUT_VALID;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, Neg, N20, Zro, Jmp, Take_Branch, N21, N22, N23,
         N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37,
         N38, N39, N40, Data_Imm_Or_RegB, Data_Imm_Or_ALU, N41, N42, N43, N44,
         N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58,
         N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71, N72,
         N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85, N86,
         N87, N88, N89, N90, N91, N92, N93, N94, N95, N96;

  GTECH_AND2 C38 ( .A(N59), .B(N23), .Z(N25) );
  GTECH_AND2 C39 ( .A(N25), .B(N24), .Z(N26) );
  GTECH_OR2 C41 ( .A(Current_State[2]), .B(Current_State[1]), .Z(N27) );
  GTECH_OR2 C42 ( .A(N27), .B(N24), .Z(N28) );
  GTECH_OR2 C45 ( .A(Current_State[2]), .B(N23), .Z(N30) );
  GTECH_OR2 C46 ( .A(N30), .B(Current_State[0]), .Z(N31) );
  GTECH_OR2 C51 ( .A(N30), .B(N24), .Z(N33) );
  GTECH_OR2 C54 ( .A(N59), .B(Current_State[1]), .Z(N35) );
  GTECH_OR2 C55 ( .A(N35), .B(Current_State[0]), .Z(N36) );
  GTECH_AND2 C57 ( .A(Current_State[2]), .B(Current_State[0]), .Z(N38) );
  GTECH_AND2 C58 ( .A(Current_State[2]), .B(Current_State[1]), .Z(N39) );
  GTECH_OR2 C70 ( .A(Crnt_Instrn[31]), .B(N65), .Z(N41) );
  GTECH_OR2 C73 ( .A(N68), .B(Crnt_Instrn[30]), .Z(N43) );
  GTECH_AND2 C75 ( .A(Crnt_Instrn[31]), .B(Crnt_Instrn[30]), .Z(N45) );
  GTECH_AND2 C78 ( .A(N68), .B(N65), .Z(N46) );
  \**SEQGEN**  UseData_Imm_Or_ALU_reg ( .clear(N58), .preset(1'b0), 
        .next_state(Data_Imm_Or_ALU), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(UseData_Imm_Or_ALU), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  UseData_Imm_Or_RegB_reg ( .clear(N58), .preset(1'b0), 
        .next_state(Data_Imm_Or_RegB), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(UseData_Imm_Or_RegB), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  EndOfInstrn_reg ( .clear(1'b0), .preset(1'b0), .next_state(N62), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(EndOfInstrn), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N58) );
  GTECH_NOT I_1 ( .A(Current_State[2]), .Z(N59) );
  GTECH_OR2 C219 ( .A(Current_State[1]), .B(N59), .Z(N60) );
  GTECH_OR2 C220 ( .A(Current_State[0]), .B(N60), .Z(N61) );
  GTECH_NOT I_2 ( .A(N61), .Z(N62) );
  GTECH_OR2 C222 ( .A(Crnt_Instrn[30]), .B(Crnt_Instrn[31]), .Z(N63) );
  GTECH_NOT I_3 ( .A(N63), .Z(N64) );
  GTECH_NOT I_4 ( .A(Crnt_Instrn[30]), .Z(N65) );
  GTECH_OR2 C225 ( .A(N65), .B(Crnt_Instrn[31]), .Z(N66) );
  GTECH_NOT I_5 ( .A(N66), .Z(N67) );
  GTECH_NOT I_6 ( .A(Crnt_Instrn[31]), .Z(N68) );
  GTECH_OR2 C228 ( .A(Crnt_Instrn[30]), .B(N68), .Z(N69) );
  GTECH_NOT I_7 ( .A(N69), .Z(N70) );
  GTECH_AND2 C236 ( .A(Crnt_Instrn[30]), .B(Crnt_Instrn[31]), .Z(N71) );
  GTECH_NOT I_8 ( .A(Crnt_Instrn[21]), .Z(N72) );
  GTECH_NOT I_9 ( .A(Crnt_Instrn[20]), .Z(N73) );
  GTECH_NOT I_10 ( .A(Crnt_Instrn[19]), .Z(N74) );
  GTECH_NOT I_11 ( .A(Crnt_Instrn[18]), .Z(N75) );
  GTECH_NOT I_12 ( .A(Crnt_Instrn[17]), .Z(N76) );
  GTECH_OR2 C250 ( .A(N72), .B(N87), .Z(N77) );
  GTECH_OR2 C251 ( .A(N73), .B(N77), .Z(N78) );
  GTECH_OR2 C252 ( .A(N74), .B(N78), .Z(N79) );
  GTECH_OR2 C253 ( .A(N75), .B(N79), .Z(N80) );
  GTECH_OR2 C254 ( .A(N76), .B(N80), .Z(N81) );
  GTECH_OR2 C255 ( .A(N84), .B(N81), .Z(N82) );
  GTECH_NOT I_13 ( .A(N82), .Z(N83) );
  GTECH_NOT I_14 ( .A(Crnt_Instrn[16]), .Z(N84) );
  GTECH_OR2 C264 ( .A(N84), .B(N92), .Z(N85) );
  GTECH_NOT I_15 ( .A(N85), .Z(N86) );
  GTECH_OR2 C266 ( .A(Crnt_Instrn[22]), .B(Crnt_Instrn[23]), .Z(N87) );
  GTECH_OR2 C267 ( .A(Crnt_Instrn[21]), .B(N87), .Z(N88) );
  GTECH_OR2 C268 ( .A(Crnt_Instrn[20]), .B(N88), .Z(N89) );
  GTECH_OR2 C269 ( .A(Crnt_Instrn[19]), .B(N89), .Z(N90) );
  GTECH_OR2 C270 ( .A(Crnt_Instrn[18]), .B(N90), .Z(N91) );
  GTECH_OR2 C271 ( .A(Crnt_Instrn[17]), .B(N91), .Z(N92) );
  GTECH_OR2 C272 ( .A(Crnt_Instrn[16]), .B(N92), .Z(N93) );
  GTECH_NOT I_16 ( .A(N93), .Z(N94) );
  SELECT_OP C274 ( .DATA1(N19), .DATA2(Neg_Flag), .CONTROL1(N0), .CONTROL2(N18), .Z(Neg) );
  GTECH_BUF B_0 ( .A(Crnt_Instrn[25]), .Z(N0) );
  SELECT_OP C275 ( .DATA1(N20), .DATA2(Zro_Flag), .CONTROL1(N0), .CONTROL2(N18), .Z(Zro) );
  GTECH_NOT I_17 ( .A(Crnt_Instrn[25]), .Z(Jmp) );
  SELECT_OP C277 ( .DATA1(Jmp), .DATA2(1'b0), .CONTROL1(N1), .CONTROL2(N2), 
        .Z(N21) );
  GTECH_BUF B_1 ( .A(N83), .Z(N1) );
  GTECH_BUF B_2 ( .A(N82), .Z(N2) );
  SELECT_OP C278 ( .DATA1(Zro), .DATA2(N21), .CONTROL1(N3), .CONTROL2(N4), .Z(
        N22) );
  GTECH_BUF B_3 ( .A(N86), .Z(N3) );
  GTECH_BUF B_4 ( .A(N85), .Z(N4) );
  SELECT_OP C279 ( .DATA1(Neg), .DATA2(N22), .CONTROL1(N5), .CONTROL2(N6), .Z(
        Take_Branch) );
  GTECH_BUF B_5 ( .A(N94), .Z(N5) );
  GTECH_BUF B_6 ( .A(N93), .Z(N6) );
  SELECT_OP C280 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .Z(N47)
         );
  GTECH_BUF B_7 ( .A(N42), .Z(N7) );
  GTECH_BUF B_8 ( .A(N44), .Z(N8) );
  GTECH_BUF B_9 ( .A(N45), .Z(N9) );
  GTECH_BUF B_10 ( .A(N46), .Z(N10) );
  SELECT_OP C281 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .Z(N48)
         );
  SELECT_OP C282 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .Z(N49)
         );
  SELECT_OP C283 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .Z(N50)
         );
  SELECT_OP C284 ( .DATA1(1'b1), .DATA2(N49), .CONTROL1(N11), .CONTROL2(N52), 
        .Z(N53) );
  GTECH_BUF B_11 ( .A(N51), .Z(N11) );
  SELECT_OP C285 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(N54), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(PushEnbl) );
  GTECH_BUF B_12 ( .A(N26), .Z(N12) );
  GTECH_BUF B_13 ( .A(N29), .Z(N13) );
  GTECH_BUF B_14 ( .A(N32), .Z(N14) );
  GTECH_BUF B_15 ( .A(N34), .Z(N15) );
  GTECH_BUF B_16 ( .A(N37), .Z(N16) );
  GTECH_BUF B_17 ( .A(N40), .Z(N17) );
  SELECT_OP C286 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(N55), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(PopEnbl) );
  SELECT_OP C287 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(N56), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Latch_Flags)
         );
  SELECT_OP C288 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(N57), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Latch_Result)
         );
  SELECT_OP C289 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(N53), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Rd_Oprnd_A)
         );
  SELECT_OP C290 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(N50), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Rd_Oprnd_B)
         );
  SELECT_OP C291 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(N47), .DATA4(N47), 
        .DATA5(N47), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(
        Data_Imm_Or_RegB) );
  SELECT_OP C292 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(N48), .DATA4(N48), 
        .DATA5(N48), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(
        Data_Imm_Or_ALU) );
  SELECT_OP C293 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Latch_Instr)
         );
  SELECT_OP C294 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Reset_AluRegs) );
  SELECT_OP C295 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(N63), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(Write_RegC)
         );
  SELECT_OP C296 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(N51), 
        .DATA5(1'b0), .DATA6(1'b0), .CONTROL1(N12), .CONTROL2(N13), .CONTROL3(
        N14), .CONTROL4(N15), .CONTROL5(N16), .CONTROL6(N17), .Z(OUT_VALID) );
  GTECH_NOT I_18 ( .A(Crnt_Instrn[25]), .Z(N18) );
  GTECH_NOT I_19 ( .A(Neg_Flag), .Z(N19) );
  GTECH_NOT I_20 ( .A(Zro_Flag), .Z(N20) );
  GTECH_NOT I_21 ( .A(Current_State[1]), .Z(N23) );
  GTECH_NOT I_22 ( .A(Current_State[0]), .Z(N24) );
  GTECH_NOT I_23 ( .A(N28), .Z(N29) );
  GTECH_NOT I_24 ( .A(N31), .Z(N32) );
  GTECH_NOT I_25 ( .A(N33), .Z(N34) );
  GTECH_NOT I_26 ( .A(N36), .Z(N37) );
  GTECH_OR2 C316 ( .A(N38), .B(N39), .Z(N40) );
  GTECH_NOT I_27 ( .A(N41), .Z(N42) );
  GTECH_NOT I_28 ( .A(N43), .Z(N44) );
  GTECH_AND2 C331 ( .A(N64), .B(Crnt_Instrn[24]), .Z(N51) );
  GTECH_NOT I_29 ( .A(N51), .Z(N52) );
  GTECH_AND2 C334 ( .A(N95), .B(Take_Branch), .Z(N54) );
  GTECH_AND2 C335 ( .A(N64), .B(Crnt_Instrn[28]), .Z(N95) );
  GTECH_AND2 C337 ( .A(N64), .B(Crnt_Instrn[27]), .Z(N55) );
  GTECH_OR2 C339 ( .A(N67), .B(N70), .Z(N56) );
  GTECH_OR2 C341 ( .A(N96), .B(N71), .Z(N57) );
  GTECH_OR2 C342 ( .A(N67), .B(N70), .Z(N96) );
endmodule


module DATA_PATH ( clk, reset_n, Reset_AluRegs, Rd_Oprnd_A, Rd_Oprnd_B, 
        UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, Latch_Flags, ALU_Zro, ALU_Neg, 
        ALU_Carry, PSW_Zro, PSW_Neg, PSW_Carry, Crnt_Instrn, RegPort_A, 
        RegPort_B, Op_Result, Zro_Flag, Neg_Flag, Carry_Flag, Addr_A, Oprnd_A, 
        Oprnd_B, RegPort_C );
  input [31:0] Crnt_Instrn;
  input [15:0] RegPort_A;
  input [15:0] RegPort_B;
  input [15:0] Op_Result;
  output [6:0] Addr_A;
  output [15:0] Oprnd_A;
  output [15:0] Oprnd_B;
  output [15:0] RegPort_C;
  input clk, reset_n, Reset_AluRegs, Rd_Oprnd_A, Rd_Oprnd_B,
         UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, Latch_Flags, ALU_Zro,
         ALU_Neg, ALU_Carry, PSW_Zro, PSW_Neg, PSW_Carry;
  output Zro_Flag, Neg_Flag, Carry_Flag;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, PSWL_Zro, PSWL_Neg, PSWL_Carry,
         N65, N66, N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77, N78,
         N79;

  \**SEQGEN**  Oprnd_A_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N28), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N27), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N26), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N25), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N24), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N23), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N22), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N21), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N20), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N19), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N18), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N17), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N16), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N15), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N14), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_A_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N13), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_A[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N12) );
  \**SEQGEN**  Oprnd_B_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N64), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N63), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N62), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N61), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N60), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N59), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N58), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N57), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N56), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N55), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N54), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N53), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N52), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N51), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N50), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  Oprnd_B_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N49), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Oprnd_B[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N48) );
  \**SEQGEN**  PSWL_Carry_reg ( .clear(N68), .preset(1'b0), .next_state(
        PSW_Carry), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        PSWL_Carry), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(Latch_Flags) );
  \**SEQGEN**  PSWL_Zro_reg ( .clear(N68), .preset(1'b0), .next_state(PSW_Zro), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PSWL_Zro), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(Latch_Flags) );
  \**SEQGEN**  PSWL_Neg_reg ( .clear(N68), .preset(1'b0), .next_state(PSW_Neg), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PSWL_Neg), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(Latch_Flags) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N68) );
  GTECH_NOT I_1 ( .A(Crnt_Instrn[27]), .Z(N69) );
  GTECH_OR2 C302 ( .A(Crnt_Instrn[29]), .B(N77), .Z(N70) );
  GTECH_OR2 C303 ( .A(Crnt_Instrn[28]), .B(N70), .Z(N71) );
  GTECH_OR2 C304 ( .A(N69), .B(N71), .Z(N72) );
  GTECH_OR2 C305 ( .A(Crnt_Instrn[26]), .B(N72), .Z(N73) );
  GTECH_OR2 C306 ( .A(Crnt_Instrn[25]), .B(N73), .Z(N74) );
  GTECH_OR2 C307 ( .A(Crnt_Instrn[24]), .B(N74), .Z(N75) );
  GTECH_NOT I_2 ( .A(N75), .Z(N76) );
  GTECH_OR2 C309 ( .A(Crnt_Instrn[30]), .B(Crnt_Instrn[31]), .Z(N77) );
  GTECH_NOT I_3 ( .A(N77), .Z(N78) );
  GTECH_NOT I_4 ( .A(UseData_Imm_Or_RegB), .Z(N79) );
  SELECT_OP C312 ( .DATA1(1'b1), .DATA2(Rd_Oprnd_A), .CONTROL1(N0), .CONTROL2(
        N1), .Z(N12) );
  GTECH_BUF B_0 ( .A(Reset_AluRegs), .Z(N0) );
  GTECH_BUF B_1 ( .A(N11), .Z(N1) );
  SELECT_OP C313 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(RegPort_A), 
        .CONTROL1(N0), .CONTROL2(N1), .Z({N28, N27, N26, N25, N24, N23, N22, 
        N21, N20, N19, N18, N17, N16, N15, N14, N13}) );
  SELECT_OP C314 ( .DATA1(1'b1), .DATA2(N79), .CONTROL1(N2), .CONTROL2(N3), 
        .Z(N30) );
  GTECH_BUF B_2 ( .A(UseData_Imm_Or_RegB), .Z(N2) );
  GTECH_BUF B_3 ( .A(N79), .Z(N3) );
  SELECT_OP C315 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        Crnt_Instrn[7:0]}), .DATA2(RegPort_B), .CONTROL1(N2), .CONTROL2(N3), 
        .Z({N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, 
        N33, N32, N31}) );
  SELECT_OP C316 ( .DATA1(N30), .DATA2(1'b0), .CONTROL1(N4), .CONTROL2(N5), 
        .Z(N47) );
  GTECH_BUF B_4 ( .A(Rd_Oprnd_B), .Z(N4) );
  GTECH_BUF B_5 ( .A(N29), .Z(N5) );
  SELECT_OP C317 ( .DATA1(1'b1), .DATA2(N47), .CONTROL1(N0), .CONTROL2(N1), 
        .Z(N48) );
  SELECT_OP C318 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N46, N45, 
        N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, N33, N32, N31}), 
        .CONTROL1(N0), .CONTROL2(N1), .Z({N64, N63, N62, N61, N60, N59, N58, 
        N57, N56, N55, N54, N53, N52, N51, N50, N49}) );
  SELECT_OP C319 ( .DATA1(Crnt_Instrn[15:0]), .DATA2(Op_Result), .CONTROL1(N6), 
        .CONTROL2(N7), .Z(RegPort_C) );
  GTECH_BUF B_6 ( .A(UseData_Imm_Or_ALU), .Z(N6) );
  GTECH_BUF B_7 ( .A(N65), .Z(N7) );
  SELECT_OP C320 ( .DATA1(PSWL_Zro), .DATA2(ALU_Zro), .CONTROL1(N8), 
        .CONTROL2(N9), .Z(Zro_Flag) );
  GTECH_BUF B_8 ( .A(N76), .Z(N8) );
  GTECH_BUF B_9 ( .A(N75), .Z(N9) );
  SELECT_OP C321 ( .DATA1(PSWL_Neg), .DATA2(ALU_Neg), .CONTROL1(N8), 
        .CONTROL2(N9), .Z(Neg_Flag) );
  SELECT_OP C322 ( .DATA1(PSWL_Carry), .DATA2(ALU_Carry), .CONTROL1(N8), 
        .CONTROL2(N9), .Z(Carry_Flag) );
  SELECT_OP C323 ( .DATA1(Crnt_Instrn[6:0]), .DATA2(Crnt_Instrn[14:8]), 
        .CONTROL1(N10), .CONTROL2(N67), .Z(Addr_A) );
  GTECH_BUF B_10 ( .A(N66), .Z(N10) );
  GTECH_NOT I_5 ( .A(Reset_AluRegs), .Z(N11) );
  GTECH_NOT I_6 ( .A(Rd_Oprnd_B), .Z(N29) );
  GTECH_NOT I_7 ( .A(UseData_Imm_Or_ALU), .Z(N65) );
  GTECH_AND2 C343 ( .A(N78), .B(Crnt_Instrn[24]), .Z(N66) );
  GTECH_NOT I_8 ( .A(N66), .Z(N67) );
endmodule


module INSTRN_LAT ( clk, Instrn, Latch_Instr, Crnt_Instrn_1, Crnt_Instrn_2 );
  input [31:0] Instrn;
  output [31:0] Crnt_Instrn_1;
  output [31:0] Crnt_Instrn_2;
  input clk, Latch_Instr;


  \**SEQGEN**  Crnt_Instrn_2_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[31]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[30]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[29]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[28]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[27]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[26]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[25]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[24]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[23]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[22]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[21]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[20]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[19]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[18]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[17]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[16]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[15]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[14]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[13]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[12]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_2[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[9]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[8]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[7]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[6]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[5]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[4]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_2_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_2[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[31]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[30]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[29]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[28]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[27]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[26]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[25]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[24]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[23]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[22]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[21]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[20]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[19]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[18]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[17]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[16]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[15]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[14]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[13]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[12]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[11]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[10]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(Crnt_Instrn_1[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[9]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[8]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[7]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[6]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[5]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[4]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
  \**SEQGEN**  Crnt_Instrn_1_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(Instrn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Crnt_Instrn_1[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(Latch_Instr) );
endmodule


module PRGRM_FSM ( clk, reset_n, CurrentState );
  output [2:0] CurrentState;
  input clk, reset_n;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22;
  wire   [2:0] Next_State;

  GTECH_AND2 C7 ( .A(N5), .B(N6), .Z(N8) );
  GTECH_AND2 C8 ( .A(N8), .B(N7), .Z(N9) );
  GTECH_OR2 C10 ( .A(CurrentState[2]), .B(CurrentState[1]), .Z(N10) );
  GTECH_OR2 C11 ( .A(N10), .B(N7), .Z(N11) );
  GTECH_OR2 C14 ( .A(CurrentState[2]), .B(N6), .Z(N13) );
  GTECH_OR2 C15 ( .A(N13), .B(CurrentState[0]), .Z(N14) );
  GTECH_OR2 C19 ( .A(CurrentState[2]), .B(N6), .Z(N16) );
  GTECH_OR2 C20 ( .A(N16), .B(N7), .Z(N17) );
  GTECH_OR2 C23 ( .A(N5), .B(CurrentState[1]), .Z(N19) );
  GTECH_OR2 C24 ( .A(N19), .B(CurrentState[0]), .Z(N20) );
  \**SEQGEN**  Current_State_reg_2_ ( .clear(N22), .preset(1'b0), .next_state(
        Next_State[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        CurrentState[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  Current_State_reg_1_ ( .clear(N22), .preset(1'b0), .next_state(
        Next_State[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        CurrentState[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  Current_State_reg_0_ ( .clear(N22), .preset(1'b0), .next_state(
        Next_State[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        CurrentState[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N22) );
  SELECT_OP C52 ( .DATA1({1'b0, 1'b0, 1'b1}), .DATA2({1'b0, 1'b1, 1'b0}), 
        .DATA3({1'b0, 1'b1, 1'b1}), .DATA4({1'b1, 1'b0, 1'b0}), .DATA5({1'b0, 
        1'b0, 1'b1}), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .CONTROL4(
        N3), .CONTROL5(N4), .Z(Next_State) );
  GTECH_BUF B_0 ( .A(N9), .Z(N0) );
  GTECH_BUF B_1 ( .A(N12), .Z(N1) );
  GTECH_BUF B_2 ( .A(N15), .Z(N2) );
  GTECH_BUF B_3 ( .A(N18), .Z(N3) );
  GTECH_BUF B_4 ( .A(N21), .Z(N4) );
  GTECH_NOT I_1 ( .A(CurrentState[2]), .Z(N5) );
  GTECH_NOT I_2 ( .A(CurrentState[1]), .Z(N6) );
  GTECH_NOT I_3 ( .A(CurrentState[0]), .Z(N7) );
  GTECH_NOT I_4 ( .A(N11), .Z(N12) );
  GTECH_NOT I_5 ( .A(N14), .Z(N15) );
  GTECH_NOT I_6 ( .A(N17), .Z(N18) );
  GTECH_NOT I_7 ( .A(N20), .Z(N21) );
endmodule


module PRGRM_DECODE ( Zro_Flag, Carry_Flag, Neg_Flag, CurrentState, 
        Crnt_Instrn, Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr );
  input [2:0] CurrentState;
  input [31:0] Crnt_Instrn;
  input Zro_Flag, Carry_Flag, Neg_Flag;
  output Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, Neg,
         N15, Carry, N16, Zro, Jmp, Take_Branch, N17, N18, N19, N20, N21, N22,
         N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50,
         N51, N52, N53, N54, N55, N56, N57;

  GTECH_OR2 C42 ( .A(N20), .B(CurrentState[1]), .Z(N21) );
  GTECH_OR2 C43 ( .A(N21), .B(CurrentState[0]), .Z(N22) );
  GTECH_OR2 C86 ( .A(Crnt_Instrn[30]), .B(Crnt_Instrn[31]), .Z(N29) );
  GTECH_NOT I_0 ( .A(N29), .Z(N30) );
  GTECH_NOT I_1 ( .A(Crnt_Instrn[21]), .Z(N31) );
  GTECH_NOT I_2 ( .A(Crnt_Instrn[20]), .Z(N32) );
  GTECH_NOT I_3 ( .A(Crnt_Instrn[19]), .Z(N33) );
  GTECH_NOT I_4 ( .A(Crnt_Instrn[18]), .Z(N34) );
  GTECH_OR2 C95 ( .A(N31), .B(N49), .Z(N35) );
  GTECH_OR2 C96 ( .A(N32), .B(N35), .Z(N36) );
  GTECH_OR2 C97 ( .A(N33), .B(N36), .Z(N37) );
  GTECH_OR2 C98 ( .A(N34), .B(N37), .Z(N38) );
  GTECH_OR2 C99 ( .A(N42), .B(N38), .Z(N39) );
  GTECH_OR2 C100 ( .A(N46), .B(N39), .Z(N40) );
  GTECH_NOT I_5 ( .A(N40), .Z(N41) );
  GTECH_NOT I_6 ( .A(Crnt_Instrn[17]), .Z(N42) );
  GTECH_OR2 C108 ( .A(N42), .B(N53), .Z(N43) );
  GTECH_OR2 C109 ( .A(Crnt_Instrn[16]), .B(N43), .Z(N44) );
  GTECH_NOT I_7 ( .A(N44), .Z(N45) );
  GTECH_NOT I_8 ( .A(Crnt_Instrn[16]), .Z(N46) );
  GTECH_OR2 C118 ( .A(N46), .B(N54), .Z(N47) );
  GTECH_NOT I_9 ( .A(N47), .Z(N48) );
  GTECH_OR2 C120 ( .A(Crnt_Instrn[22]), .B(Crnt_Instrn[23]), .Z(N49) );
  GTECH_OR2 C121 ( .A(Crnt_Instrn[21]), .B(N49), .Z(N50) );
  GTECH_OR2 C122 ( .A(Crnt_Instrn[20]), .B(N50), .Z(N51) );
  GTECH_OR2 C123 ( .A(Crnt_Instrn[19]), .B(N51), .Z(N52) );
  GTECH_OR2 C124 ( .A(Crnt_Instrn[18]), .B(N52), .Z(N53) );
  GTECH_OR2 C125 ( .A(Crnt_Instrn[17]), .B(N53), .Z(N54) );
  GTECH_OR2 C126 ( .A(Crnt_Instrn[16]), .B(N54), .Z(N55) );
  GTECH_NOT I_10 ( .A(N55), .Z(N56) );
  SELECT_OP C128 ( .DATA1(N14), .DATA2(Neg_Flag), .CONTROL1(N0), .CONTROL2(N13), .Z(Neg) );
  GTECH_BUF B_0 ( .A(Crnt_Instrn[25]), .Z(N0) );
  SELECT_OP C129 ( .DATA1(N15), .DATA2(Carry_Flag), .CONTROL1(N0), .CONTROL2(
        N13), .Z(Carry) );
  SELECT_OP C130 ( .DATA1(N16), .DATA2(Zro_Flag), .CONTROL1(N0), .CONTROL2(N13), .Z(Zro) );
  GTECH_NOT I_11 ( .A(Crnt_Instrn[25]), .Z(Jmp) );
  SELECT_OP C132 ( .DATA1(Jmp), .DATA2(1'b0), .CONTROL1(N1), .CONTROL2(N2), 
        .Z(N17) );
  GTECH_BUF B_1 ( .A(N41), .Z(N1) );
  GTECH_BUF B_2 ( .A(N40), .Z(N2) );
  SELECT_OP C133 ( .DATA1(Carry), .DATA2(N17), .CONTROL1(N3), .CONTROL2(N4), 
        .Z(N18) );
  GTECH_BUF B_3 ( .A(N45), .Z(N3) );
  GTECH_BUF B_4 ( .A(N44), .Z(N4) );
  SELECT_OP C134 ( .DATA1(Zro), .DATA2(N18), .CONTROL1(N5), .CONTROL2(N6), .Z(
        N19) );
  GTECH_BUF B_5 ( .A(N48), .Z(N5) );
  GTECH_BUF B_6 ( .A(N47), .Z(N6) );
  SELECT_OP C135 ( .DATA1(Neg), .DATA2(N19), .CONTROL1(N7), .CONTROL2(N8), .Z(
        Take_Branch) );
  GTECH_BUF B_7 ( .A(N56), .Z(N7) );
  GTECH_BUF B_8 ( .A(N55), .Z(N8) );
  SELECT_OP C136 ( .DATA1(N24), .DATA2(1'b0), .CONTROL1(N9), .CONTROL2(N10), 
        .Z(N25) );
  GTECH_BUF B_9 ( .A(N30), .Z(N9) );
  GTECH_BUF B_10 ( .A(N29), .Z(N10) );
  SELECT_OP C137 ( .DATA1(Crnt_Instrn[27]), .DATA2(1'b0), .CONTROL1(N9), 
        .CONTROL2(N10), .Z(N26) );
  GTECH_NOT I_12 ( .A(N27), .Z(N28) );
  SELECT_OP C139 ( .DATA1(N26), .DATA2(1'b0), .CONTROL1(N11), .CONTROL2(N12), 
        .Z(Ld_Rtn_Addr) );
  GTECH_BUF B_11 ( .A(N23), .Z(N11) );
  GTECH_BUF B_12 ( .A(N22), .Z(N12) );
  SELECT_OP C140 ( .DATA1(N25), .DATA2(1'b0), .CONTROL1(N11), .CONTROL2(N12), 
        .Z(Ld_Brnch_Addr) );
  SELECT_OP C141 ( .DATA1(N28), .DATA2(1'b0), .CONTROL1(N11), .CONTROL2(N12), 
        .Z(Incrmnt_PC) );
  GTECH_NOT I_13 ( .A(Crnt_Instrn[25]), .Z(N13) );
  GTECH_NOT I_14 ( .A(Neg_Flag), .Z(N14) );
  GTECH_NOT I_15 ( .A(Carry_Flag), .Z(N15) );
  GTECH_NOT I_16 ( .A(Zro_Flag), .Z(N16) );
  GTECH_NOT I_17 ( .A(CurrentState[2]), .Z(N20) );
  GTECH_NOT I_18 ( .A(N22), .Z(N23) );
  GTECH_AND2 C163 ( .A(N57), .B(Take_Branch), .Z(N24) );
  GTECH_OR2 C164 ( .A(Crnt_Instrn[29]), .B(Crnt_Instrn[28]), .Z(N57) );
  GTECH_OR2 C167 ( .A(Ld_Rtn_Addr), .B(Ld_Brnch_Addr), .Z(N27) );
endmodule


module PRGRM_CNT ( reset_n, clk, Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr, 
        Imm_Addr, Return_Addr, PC );
  input [7:0] Imm_Addr;
  input [7:0] Return_Addr;
  output [7:0] PC;
  input reset_n, clk, Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33;

  \**SEQGEN**  PCint_reg_7_ ( .clear(N33), .preset(1'b0), .next_state(N32), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_6_ ( .clear(N33), .preset(1'b0), .next_state(N31), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_5_ ( .clear(N33), .preset(1'b0), .next_state(N30), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_4_ ( .clear(N33), .preset(1'b0), .next_state(N29), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_3_ ( .clear(N33), .preset(1'b0), .next_state(N28), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_2_ ( .clear(N33), .preset(1'b0), .next_state(N27), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_1_ ( .clear(N33), .preset(1'b0), .next_state(N26), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  \**SEQGEN**  PCint_reg_0_ ( .clear(N33), .preset(1'b0), .next_state(N25), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(PC[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N24) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N33) );
  ADD_UNS_OP add_47 ( .A(PC), .B(1'b1), .Z({N13, N12, N11, N10, N9, N8, N7, N6}) );
  SELECT_OP C93 ( .DATA1(1'b1), .DATA2(Ld_Brnch_Addr), .CONTROL1(N0), 
        .CONTROL2(N1), .Z(N15) );
  GTECH_BUF B_0 ( .A(Ld_Rtn_Addr), .Z(N0) );
  GTECH_BUF B_1 ( .A(N14), .Z(N1) );
  SELECT_OP C94 ( .DATA1(Return_Addr), .DATA2(Imm_Addr), .CONTROL1(N0), 
        .CONTROL2(N1), .Z({N23, N22, N21, N20, N19, N18, N17, N16}) );
  SELECT_OP C95 ( .DATA1(1'b1), .DATA2(N15), .CONTROL1(N2), .CONTROL2(N3), .Z(
        N24) );
  GTECH_BUF B_2 ( .A(Incrmnt_PC), .Z(N2) );
  GTECH_BUF B_3 ( .A(N5), .Z(N3) );
  SELECT_OP C96 ( .DATA1({N13, N12, N11, N10, N9, N8, N7, N6}), .DATA2({N23, 
        N22, N21, N20, N19, N18, N17, N16}), .CONTROL1(N2), .CONTROL2(N3), .Z(
        {N32, N31, N30, N29, N28, N27, N26, N25}) );
  GTECH_BUF B_4 ( .A(reset_n), .Z(N4) );
  GTECH_NOT I_1 ( .A(Incrmnt_PC), .Z(N5) );
  GTECH_AND2 C104 ( .A(N4), .B(Incrmnt_PC) );
  GTECH_NOT I_2 ( .A(Ld_Rtn_Addr), .Z(N14) );
endmodule


module PRGRM_CNT_TOP ( clk, reset_n, Crnt_Instrn, Zro_Flag, Carry_Flag, 
        Neg_Flag, Return_Addr, Current_State, PC );
  input [31:0] Crnt_Instrn;
  input [7:0] Return_Addr;
  output [2:0] Current_State;
  output [7:0] PC;
  input clk, reset_n, Zro_Flag, Carry_Flag, Neg_Flag;
  wire   Incrmnt_PC, Ld_Brnch_Addr, Ld_Rtn_Addr;

  PRGRM_FSM I_PRGRM_FSM ( .clk(clk), .reset_n(reset_n), .CurrentState(
        Current_State) );
  PRGRM_DECODE I_PRGRM_DECODE ( .Zro_Flag(Zro_Flag), .Carry_Flag(Carry_Flag), 
        .Neg_Flag(Neg_Flag), .CurrentState(Current_State), .Crnt_Instrn(
        Crnt_Instrn), .Incrmnt_PC(Incrmnt_PC), .Ld_Brnch_Addr(Ld_Brnch_Addr), 
        .Ld_Rtn_Addr(Ld_Rtn_Addr) );
  PRGRM_CNT I_PRGRM_CNT ( .reset_n(reset_n), .clk(clk), .Incrmnt_PC(Incrmnt_PC), .Ld_Brnch_Addr(Ld_Brnch_Addr), .Ld_Rtn_Addr(Ld_Rtn_Addr), .Imm_Addr(
        Crnt_Instrn[7:0]), .Return_Addr(Return_Addr), .PC(PC) );
endmodule


module REG_FILE ( reset_n, clk, Addr_A, Addr_B, Addr_C, RegPort_C, Write_RegC, 
        RegPort_A, RegPort_B );
  input [6:0] Addr_A;
  input [6:0] Addr_B;
  input [6:0] Addr_C;
  input [15:0] RegPort_C;
  output [15:0] RegPort_A;
  output [15:0] RegPort_B;
  input reset_n, clk, Write_RegC;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49;
  wire   [63:0] Reg_Array;

  \**SEQGEN**  Reg_Array_reg_0__15_ ( .clear(N49), .preset(1'b0), .next_state(
        N45), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[63]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__14_ ( .clear(N49), .preset(1'b0), .next_state(
        N44), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[62]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__13_ ( .clear(N49), .preset(1'b0), .next_state(
        N43), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[61]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__12_ ( .clear(N49), .preset(1'b0), .next_state(
        N42), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[60]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__11_ ( .clear(N49), .preset(1'b0), .next_state(
        N41), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[59]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__10_ ( .clear(N49), .preset(1'b0), .next_state(
        N40), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[58]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__9_ ( .clear(N49), .preset(1'b0), .next_state(
        N39), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[57]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__8_ ( .clear(N49), .preset(1'b0), .next_state(
        N38), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[56]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__7_ ( .clear(N49), .preset(1'b0), .next_state(
        N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[55]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__6_ ( .clear(N49), .preset(1'b0), .next_state(
        N36), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[54]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__5_ ( .clear(N49), .preset(1'b0), .next_state(
        N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[53]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__4_ ( .clear(N49), .preset(1'b0), .next_state(
        N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[52]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__3_ ( .clear(N49), .preset(1'b0), .next_state(
        N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[51]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__2_ ( .clear(N49), .preset(1'b0), .next_state(
        N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__1_ ( .clear(N49), .preset(1'b0), .next_state(
        N31), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_0__0_ ( .clear(N49), .preset(1'b0), .next_state(
        N30), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N48) );
  \**SEQGEN**  Reg_Array_reg_1__15_ ( .clear(N49), .preset(1'b0), .next_state(
        N45), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__14_ ( .clear(N49), .preset(1'b0), .next_state(
        N44), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__13_ ( .clear(N49), .preset(1'b0), .next_state(
        N43), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__12_ ( .clear(N49), .preset(1'b0), .next_state(
        N42), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__11_ ( .clear(N49), .preset(1'b0), .next_state(
        N41), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__10_ ( .clear(N49), .preset(1'b0), .next_state(
        N40), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__9_ ( .clear(N49), .preset(1'b0), .next_state(
        N39), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__8_ ( .clear(N49), .preset(1'b0), .next_state(
        N38), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__7_ ( .clear(N49), .preset(1'b0), .next_state(
        N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__6_ ( .clear(N49), .preset(1'b0), .next_state(
        N36), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__5_ ( .clear(N49), .preset(1'b0), .next_state(
        N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__4_ ( .clear(N49), .preset(1'b0), .next_state(
        N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__3_ ( .clear(N49), .preset(1'b0), .next_state(
        N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__2_ ( .clear(N49), .preset(1'b0), .next_state(
        N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__1_ ( .clear(N49), .preset(1'b0), .next_state(
        N31), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_1__0_ ( .clear(N49), .preset(1'b0), .next_state(
        N30), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N47) );
  \**SEQGEN**  Reg_Array_reg_2__15_ ( .clear(N49), .preset(1'b0), .next_state(
        N45), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__14_ ( .clear(N49), .preset(1'b0), .next_state(
        N44), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__13_ ( .clear(N49), .preset(1'b0), .next_state(
        N43), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__12_ ( .clear(N49), .preset(1'b0), .next_state(
        N42), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__11_ ( .clear(N49), .preset(1'b0), .next_state(
        N41), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__10_ ( .clear(N49), .preset(1'b0), .next_state(
        N40), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__9_ ( .clear(N49), .preset(1'b0), .next_state(
        N39), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__8_ ( .clear(N49), .preset(1'b0), .next_state(
        N38), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__7_ ( .clear(N49), .preset(1'b0), .next_state(
        N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__6_ ( .clear(N49), .preset(1'b0), .next_state(
        N36), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__5_ ( .clear(N49), .preset(1'b0), .next_state(
        N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__4_ ( .clear(N49), .preset(1'b0), .next_state(
        N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__3_ ( .clear(N49), .preset(1'b0), .next_state(
        N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__2_ ( .clear(N49), .preset(1'b0), .next_state(
        N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__1_ ( .clear(N49), .preset(1'b0), .next_state(
        N31), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_2__0_ ( .clear(N49), .preset(1'b0), .next_state(
        N30), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N46) );
  \**SEQGEN**  Reg_Array_reg_3__15_ ( .clear(N49), .preset(1'b0), .next_state(
        N45), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__14_ ( .clear(N49), .preset(1'b0), .next_state(
        N44), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__13_ ( .clear(N49), .preset(1'b0), .next_state(
        N43), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__12_ ( .clear(N49), .preset(1'b0), .next_state(
        N42), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__11_ ( .clear(N49), .preset(1'b0), .next_state(
        N41), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__10_ ( .clear(N49), .preset(1'b0), .next_state(
        N40), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Reg_Array[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Reg_Array_reg_3__9_ ( .clear(N49), .preset(1'b0), .next_state(
        N39), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__8_ ( .clear(N49), .preset(1'b0), .next_state(
        N38), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__7_ ( .clear(N49), .preset(1'b0), .next_state(
        N37), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__6_ ( .clear(N49), .preset(1'b0), .next_state(
        N36), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__5_ ( .clear(N49), .preset(1'b0), .next_state(
        N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__4_ ( .clear(N49), .preset(1'b0), .next_state(
        N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__3_ ( .clear(N49), .preset(1'b0), .next_state(
        N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__2_ ( .clear(N49), .preset(1'b0), .next_state(
        N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__1_ ( .clear(N49), .preset(1'b0), .next_state(
        N31), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  \**SEQGEN**  Reg_Array_reg_3__0_ ( .clear(N49), .preset(1'b0), .next_state(
        N30), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(Reg_Array[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N29) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N49) );
  GTECH_AND2 C294 ( .A(Addr_C[0]), .B(Addr_C[1]), .Z(N29) );
  GTECH_AND2 C295 ( .A(N0), .B(Addr_C[1]), .Z(N46) );
  GTECH_NOT I_1 ( .A(Addr_C[0]), .Z(N0) );
  GTECH_AND2 C296 ( .A(Addr_C[0]), .B(N1), .Z(N47) );
  GTECH_NOT I_2 ( .A(Addr_C[1]), .Z(N1) );
  GTECH_AND2 C297 ( .A(N2), .B(N3), .Z(N48) );
  GTECH_NOT I_3 ( .A(Addr_C[0]), .Z(N2) );
  GTECH_NOT I_4 ( .A(Addr_C[1]), .Z(N3) );
  SELECT_OP C302 ( .DATA1(RegPort_C), .DATA2({N13, N14, N15, N16, N17, N18, 
        N19, N20, N21, N22, N23, N24, N25, N26, N27, N28}), .CONTROL1(N4), 
        .CONTROL2(N5), .Z({N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, 
        N35, N34, N33, N32, N31, N30}) );
  GTECH_BUF B_0 ( .A(Write_RegC), .Z(N4) );
  GTECH_BUF B_1 ( .A(N12), .Z(N5) );
  MUX_OP C303 ( .D0({Reg_Array[48], Reg_Array[49], Reg_Array[50], 
        Reg_Array[51], Reg_Array[52], Reg_Array[53], Reg_Array[54], 
        Reg_Array[55], Reg_Array[56], Reg_Array[57], Reg_Array[58], 
        Reg_Array[59], Reg_Array[60], Reg_Array[61], Reg_Array[62], 
        Reg_Array[63]}), .D1({Reg_Array[32], Reg_Array[33], Reg_Array[34], 
        Reg_Array[35], Reg_Array[36], Reg_Array[37], Reg_Array[38], 
        Reg_Array[39], Reg_Array[40], Reg_Array[41], Reg_Array[42], 
        Reg_Array[43], Reg_Array[44], Reg_Array[45], Reg_Array[46], 
        Reg_Array[47]}), .D2({Reg_Array[16], Reg_Array[17], Reg_Array[18], 
        Reg_Array[19], Reg_Array[20], Reg_Array[21], Reg_Array[22], 
        Reg_Array[23], Reg_Array[24], Reg_Array[25], Reg_Array[26], 
        Reg_Array[27], Reg_Array[28], Reg_Array[29], Reg_Array[30], 
        Reg_Array[31]}), .D3({Reg_Array[0], Reg_Array[1], Reg_Array[2], 
        Reg_Array[3], Reg_Array[4], Reg_Array[5], Reg_Array[6], Reg_Array[7], 
        Reg_Array[8], Reg_Array[9], Reg_Array[10], Reg_Array[11], 
        Reg_Array[12], Reg_Array[13], Reg_Array[14], Reg_Array[15]}), .S0(N6), 
        .S1(N7), .Z({N28, N27, N26, N25, N24, N23, N22, N21, N20, N19, N18, 
        N17, N16, N15, N14, N13}) );
  GTECH_BUF B_2 ( .A(Addr_C[0]), .Z(N6) );
  GTECH_BUF B_3 ( .A(Addr_C[1]), .Z(N7) );
  MUX_OP C304 ( .D0({Reg_Array[48], Reg_Array[49], Reg_Array[50], 
        Reg_Array[51], Reg_Array[52], Reg_Array[53], Reg_Array[54], 
        Reg_Array[55], Reg_Array[56], Reg_Array[57], Reg_Array[58], 
        Reg_Array[59], Reg_Array[60], Reg_Array[61], Reg_Array[62], 
        Reg_Array[63]}), .D1({Reg_Array[32], Reg_Array[33], Reg_Array[34], 
        Reg_Array[35], Reg_Array[36], Reg_Array[37], Reg_Array[38], 
        Reg_Array[39], Reg_Array[40], Reg_Array[41], Reg_Array[42], 
        Reg_Array[43], Reg_Array[44], Reg_Array[45], Reg_Array[46], 
        Reg_Array[47]}), .D2({Reg_Array[16], Reg_Array[17], Reg_Array[18], 
        Reg_Array[19], Reg_Array[20], Reg_Array[21], Reg_Array[22], 
        Reg_Array[23], Reg_Array[24], Reg_Array[25], Reg_Array[26], 
        Reg_Array[27], Reg_Array[28], Reg_Array[29], Reg_Array[30], 
        Reg_Array[31]}), .D3({Reg_Array[0], Reg_Array[1], Reg_Array[2], 
        Reg_Array[3], Reg_Array[4], Reg_Array[5], Reg_Array[6], Reg_Array[7], 
        Reg_Array[8], Reg_Array[9], Reg_Array[10], Reg_Array[11], 
        Reg_Array[12], Reg_Array[13], Reg_Array[14], Reg_Array[15]}), .S0(N8), 
        .S1(N9), .Z({RegPort_A[0], RegPort_A[1], RegPort_A[2], RegPort_A[3], 
        RegPort_A[4], RegPort_A[5], RegPort_A[6], RegPort_A[7], RegPort_A[8], 
        RegPort_A[9], RegPort_A[10], RegPort_A[11], RegPort_A[12], 
        RegPort_A[13], RegPort_A[14], RegPort_A[15]}) );
  GTECH_BUF B_4 ( .A(Addr_A[0]), .Z(N8) );
  GTECH_BUF B_5 ( .A(Addr_A[1]), .Z(N9) );
  MUX_OP C305 ( .D0({Reg_Array[48], Reg_Array[49], Reg_Array[50], 
        Reg_Array[51], Reg_Array[52], Reg_Array[53], Reg_Array[54], 
        Reg_Array[55], Reg_Array[56], Reg_Array[57], Reg_Array[58], 
        Reg_Array[59], Reg_Array[60], Reg_Array[61], Reg_Array[62], 
        Reg_Array[63]}), .D1({Reg_Array[32], Reg_Array[33], Reg_Array[34], 
        Reg_Array[35], Reg_Array[36], Reg_Array[37], Reg_Array[38], 
        Reg_Array[39], Reg_Array[40], Reg_Array[41], Reg_Array[42], 
        Reg_Array[43], Reg_Array[44], Reg_Array[45], Reg_Array[46], 
        Reg_Array[47]}), .D2({Reg_Array[16], Reg_Array[17], Reg_Array[18], 
        Reg_Array[19], Reg_Array[20], Reg_Array[21], Reg_Array[22], 
        Reg_Array[23], Reg_Array[24], Reg_Array[25], Reg_Array[26], 
        Reg_Array[27], Reg_Array[28], Reg_Array[29], Reg_Array[30], 
        Reg_Array[31]}), .D3({Reg_Array[0], Reg_Array[1], Reg_Array[2], 
        Reg_Array[3], Reg_Array[4], Reg_Array[5], Reg_Array[6], Reg_Array[7], 
        Reg_Array[8], Reg_Array[9], Reg_Array[10], Reg_Array[11], 
        Reg_Array[12], Reg_Array[13], Reg_Array[14], Reg_Array[15]}), .S0(N10), 
        .S1(N11), .Z({RegPort_B[0], RegPort_B[1], RegPort_B[2], RegPort_B[3], 
        RegPort_B[4], RegPort_B[5], RegPort_B[6], RegPort_B[7], RegPort_B[8], 
        RegPort_B[9], RegPort_B[10], RegPort_B[11], RegPort_B[12], 
        RegPort_B[13], RegPort_B[14], RegPort_B[15]}) );
  GTECH_BUF B_6 ( .A(Addr_B[0]), .Z(N10) );
  GTECH_BUF B_7 ( .A(Addr_B[1]), .Z(N11) );
  GTECH_NOT I_5 ( .A(Write_RegC), .Z(N12) );
endmodule


module STACK_FSM ( reset_n, clk, PushEnbl, PopEnbl, TOS, STACK_FULL );
  output [0:2] TOS;
  input reset_n, clk, PushEnbl, PopEnbl;
  output STACK_FULL;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72;
  wire   [1:0] Next_Stack;
  wire   [0:2] Next_TOS;
  wire   [1:0] Crnt_Stack;

  GTECH_AND2 C14 ( .A(N70), .B(N15), .Z(N16) );
  GTECH_OR2 C16 ( .A(Crnt_Stack[1]), .B(N15), .Z(N17) );
  GTECH_OR2 C19 ( .A(N70), .B(Crnt_Stack[0]), .Z(N19) );
  GTECH_AND2 C21 ( .A(Crnt_Stack[1]), .B(Crnt_Stack[0]), .Z(N21) );
  GTECH_AND2 C50 ( .A(TOS[1]), .B(TOS[0]), .Z(N27) );
  GTECH_AND2 C51 ( .A(TOS[2]), .B(N27), .Z(N28) );
  GTECH_NOT I_0 ( .A(TOS[2]), .Z(N39) );
  GTECH_OR2 C69 ( .A(TOS[1]), .B(TOS[0]), .Z(N40) );
  GTECH_OR2 C70 ( .A(N39), .B(N40), .Z(N41) );
  GTECH_NOT I_1 ( .A(N41), .Z(N42) );
  GTECH_AND2 C124 ( .A(TOS[1]), .B(TOS[0]), .Z(N62) );
  GTECH_AND2 C125 ( .A(TOS[2]), .B(N62), .Z(N63) );
  \**SEQGEN**  STACK_FULL_reg ( .clear(N69), .preset(1'b0), .next_state(N64), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(STACK_FULL), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  Crnt_Stack_reg_1_ ( .clear(N69), .preset(1'b0), .next_state(
        Next_Stack[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Crnt_Stack[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  Crnt_Stack_reg_0_ ( .clear(N69), .preset(1'b0), .next_state(
        Next_Stack[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Crnt_Stack[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  TOS_int_reg_0_ ( .clear(N69), .preset(1'b0), .next_state(
        Next_TOS[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        TOS[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N68) );
  \**SEQGEN**  TOS_int_reg_1_ ( .clear(N69), .preset(1'b0), .next_state(
        Next_TOS[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        TOS[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N68) );
  \**SEQGEN**  TOS_int_reg_2_ ( .clear(N69), .preset(1'b0), .next_state(
        Next_TOS[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        TOS[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N68) );
  GTECH_NOT I_2 ( .A(reset_n), .Z(N69) );
  GTECH_NOT I_3 ( .A(Crnt_Stack[1]), .Z(N70) );
  GTECH_OR2 C160 ( .A(Crnt_Stack[0]), .B(N70), .Z(N71) );
  GTECH_NOT I_4 ( .A(N71), .Z(N72) );
  ADD_TC_OP add_59 ( .A(TOS), .B({1'b0, 1'b1}), .Z({N32, N31, N30}) );
  SUB_TC_OP sub_67 ( .A(TOS), .B({1'b0, 1'b1}), .Z({N45, N44, N43}) );
  SELECT_OP C162 ( .DATA1({1'b0, 1'b1}), .DATA2({PopEnbl, PopEnbl}), 
        .CONTROL1(N0), .CONTROL2(N1), .Z({N24, N23}) );
  GTECH_BUF B_0 ( .A(PushEnbl), .Z(N0) );
  GTECH_BUF B_1 ( .A(N55), .Z(N1) );
  GTECH_NOT I_5 ( .A(N28), .Z(N33) );
  SELECT_OP C164 ( .DATA1({1'b1, 1'b1, 1'b1}), .DATA2({N32, N31, N30}), 
        .CONTROL1(N2), .CONTROL2(N29), .Z({N36, N35, N34}) );
  GTECH_BUF B_2 ( .A(N28), .Z(N2) );
  SELECT_OP C166 ( .DATA1({1'b0, 1'b0, 1'b0}), .DATA2({N45, N44, N43}), 
        .CONTROL1(N3), .CONTROL2(N4), .Z({N48, N47, N46}) );
  GTECH_BUF B_3 ( .A(N42), .Z(N3) );
  GTECH_BUF B_4 ( .A(N41), .Z(N4) );
  SELECT_OP C167 ( .DATA1(N41), .DATA2(1'b1), .CONTROL1(N5), .CONTROL2(N6), 
        .Z(N49) );
  GTECH_BUF B_5 ( .A(PopEnbl), .Z(N5) );
  GTECH_BUF B_6 ( .A(N22), .Z(N6) );
  SELECT_OP C168 ( .DATA1({N36, N35, N34}), .DATA2({N48, N47, N46}), 
        .CONTROL1(N0), .CONTROL2(N1), .Z({N52, N51, N50}) );
  SELECT_OP C169 ( .DATA1({N28, N33}), .DATA2({1'b0, N49}), .CONTROL1(N0), 
        .CONTROL2(N1), .Z({N54, N53}) );
  SELECT_OP C170 ( .DATA1(1'b1), .DATA2(N22), .CONTROL1(N0), .CONTROL2(N1), 
        .Z(N56) );
  SELECT_OP C171 ( .DATA1({1'b0, 1'b0, PushEnbl}), .DATA2({N52, N51, N50}), 
        .DATA3({1'b1, 1'b1, 1'b1}), .DATA4({1'b1, 1'b1, 1'b1}), .CONTROL1(N7), 
        .CONTROL2(N8), .CONTROL3(N9), .CONTROL4(N10), .Z({N59, N58, N57}) );
  GTECH_BUF B_7 ( .A(N16), .Z(N7) );
  GTECH_BUF B_8 ( .A(N18), .Z(N8) );
  GTECH_BUF B_9 ( .A(N20), .Z(N9) );
  GTECH_BUF B_10 ( .A(N21), .Z(N10) );
  SELECT_OP C172 ( .DATA1({N24, N23}), .DATA2({N54, N53}), .DATA3({N56, N23}), 
        .DATA4({1'b1, 1'b1}), .CONTROL1(N7), .CONTROL2(N8), .CONTROL3(N9), 
        .CONTROL4(N10), .Z({N61, N60}) );
  SELECT_OP C173 ( .DATA1({1'b1, 1'b1}), .DATA2({N61, N60}), .CONTROL1(N11), 
        .CONTROL2(N13), .Z(Next_Stack) );
  GTECH_BUF B_11 ( .A(N12), .Z(N11) );
  SELECT_OP C174 ( .DATA1({1'b0, 1'b0, 1'b0}), .DATA2({N59, N58, N57}), 
        .CONTROL1(N11), .CONTROL2(N13), .Z(Next_TOS) );
  GTECH_AND2 C177 ( .A(PushEnbl), .B(PopEnbl), .Z(N12) );
  GTECH_NOT I_6 ( .A(N12), .Z(N13) );
  GTECH_BUF B_12 ( .A(N13), .Z(N14) );
  GTECH_NOT I_7 ( .A(Crnt_Stack[0]), .Z(N15) );
  GTECH_NOT I_8 ( .A(N17), .Z(N18) );
  GTECH_NOT I_9 ( .A(N19), .Z(N20) );
  GTECH_NOT I_10 ( .A(PopEnbl), .Z(N22) );
  GTECH_AND2 C194 ( .A(N14), .B(N18), .Z(N25) );
  GTECH_AND2 C195 ( .A(N25), .B(PushEnbl), .Z(N26) );
  GTECH_NOT I_11 ( .A(N28), .Z(N29) );
  GTECH_AND2 C198 ( .A(N26), .B(N29) );
  GTECH_AND2 C199 ( .A(N25), .B(N55), .Z(N37) );
  GTECH_AND2 C200 ( .A(N37), .B(PopEnbl), .Z(N38) );
  GTECH_AND2 C203 ( .A(N38), .B(N41) );
  GTECH_NOT I_12 ( .A(PushEnbl), .Z(N55) );
  GTECH_AND2 C207 ( .A(N72), .B(N63), .Z(N64) );
  GTECH_AND2 C209 ( .A(N18), .B(N13), .Z(N65) );
  GTECH_AND2 C210 ( .A(N55), .B(N65), .Z(N66) );
  GTECH_AND2 C211 ( .A(N22), .B(N66), .Z(N67) );
  GTECH_NOT I_13 ( .A(N67), .Z(N68) );
endmodule


module STACK_MEM ( clk, PushEnbl, PopEnbl, Stack_Full, TOS, PushDataIn, 
        PopDataOut );
  input [0:2] TOS;
  input [3:0] PushDataIn;
  output [3:0] PopDataOut;
  input clk, PushEnbl, PopEnbl, Stack_Full;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39;
  wire   [0:2] Pop_Address;
  wire   [31:0] Stack_Mem;

  \**SEQGEN**  Stack_Mem_reg_0__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N31) );
  \**SEQGEN**  Stack_Mem_reg_0__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N31) );
  \**SEQGEN**  Stack_Mem_reg_0__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N31) );
  \**SEQGEN**  Stack_Mem_reg_0__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N31) );
  \**SEQGEN**  Stack_Mem_reg_1__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N30) );
  \**SEQGEN**  Stack_Mem_reg_1__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N30) );
  \**SEQGEN**  Stack_Mem_reg_1__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N30) );
  \**SEQGEN**  Stack_Mem_reg_1__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N30) );
  \**SEQGEN**  Stack_Mem_reg_2__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Stack_Mem_reg_2__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Stack_Mem_reg_2__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Stack_Mem_reg_2__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N29) );
  \**SEQGEN**  Stack_Mem_reg_3__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N28) );
  \**SEQGEN**  Stack_Mem_reg_3__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N28) );
  \**SEQGEN**  Stack_Mem_reg_3__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N28) );
  \**SEQGEN**  Stack_Mem_reg_3__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N28) );
  \**SEQGEN**  Stack_Mem_reg_4__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N27) );
  \**SEQGEN**  Stack_Mem_reg_4__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N27) );
  \**SEQGEN**  Stack_Mem_reg_4__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N27) );
  \**SEQGEN**  Stack_Mem_reg_4__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N27) );
  \**SEQGEN**  Stack_Mem_reg_5__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N26) );
  \**SEQGEN**  Stack_Mem_reg_5__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N26) );
  \**SEQGEN**  Stack_Mem_reg_5__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N26) );
  \**SEQGEN**  Stack_Mem_reg_5__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N26) );
  \**SEQGEN**  Stack_Mem_reg_6__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N25) );
  \**SEQGEN**  Stack_Mem_reg_6__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N25) );
  \**SEQGEN**  Stack_Mem_reg_6__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N25) );
  \**SEQGEN**  Stack_Mem_reg_6__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N25) );
  \**SEQGEN**  Stack_Mem_reg_7__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[3]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N24) );
  \**SEQGEN**  Stack_Mem_reg_7__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[2]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N24) );
  \**SEQGEN**  Stack_Mem_reg_7__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[1]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N24) );
  \**SEQGEN**  Stack_Mem_reg_7__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        PushDataIn[0]), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        Stack_Mem[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N24) );
  \**SEQGEN**  PopDataOut_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N32), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        PopDataOut[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(PopEnbl) );
  \**SEQGEN**  PopDataOut_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N33), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        PopDataOut[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(PopEnbl) );
  \**SEQGEN**  PopDataOut_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N34), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        PopDataOut[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(PopEnbl) );
  \**SEQGEN**  PopDataOut_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N35), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        PopDataOut[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(PopEnbl) );
  SUB_TC_OP sub_45_aco ( .A(TOS), .B({1'b0, N13}), .Z(Pop_Address) );
  GTECH_AND2 C107 ( .A(N36), .B(TOS[0]), .Z(N23) );
  GTECH_AND2 C109 ( .A(N37), .B(TOS[0]), .Z(N22) );
  GTECH_AND2 C111 ( .A(N38), .B(TOS[0]), .Z(N21) );
  GTECH_AND2 C113 ( .A(N39), .B(TOS[0]), .Z(N20) );
  GTECH_AND2 C114 ( .A(TOS[2]), .B(TOS[1]), .Z(N36) );
  GTECH_AND2 C115 ( .A(N36), .B(N0), .Z(N19) );
  GTECH_NOT I_0 ( .A(TOS[0]), .Z(N0) );
  GTECH_AND2 C116 ( .A(N1), .B(TOS[1]), .Z(N37) );
  GTECH_NOT I_1 ( .A(TOS[2]), .Z(N1) );
  GTECH_AND2 C117 ( .A(N37), .B(N2), .Z(N18) );
  GTECH_NOT I_2 ( .A(TOS[0]), .Z(N2) );
  GTECH_AND2 C118 ( .A(TOS[2]), .B(N3), .Z(N38) );
  GTECH_NOT I_3 ( .A(TOS[1]), .Z(N3) );
  GTECH_AND2 C119 ( .A(N38), .B(N4), .Z(N17) );
  GTECH_NOT I_4 ( .A(TOS[0]), .Z(N4) );
  GTECH_AND2 C120 ( .A(N5), .B(N6), .Z(N39) );
  GTECH_NOT I_5 ( .A(TOS[2]), .Z(N5) );
  GTECH_NOT I_6 ( .A(TOS[1]), .Z(N6) );
  GTECH_AND2 C121 ( .A(N39), .B(N7), .Z(N16) );
  GTECH_NOT I_7 ( .A(TOS[0]), .Z(N7) );
  SELECT_OP C123 ( .DATA1({N16, N17, N18, N19, N20, N21, N22, N23}), .DATA2({
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N8), 
        .CONTROL2(N9), .Z({N31, N30, N29, N28, N27, N26, N25, N24}) );
  GTECH_BUF B_0 ( .A(PushEnbl), .Z(N8) );
  GTECH_BUF B_1 ( .A(N15), .Z(N9) );
  MUX_OP C124 ( .D0({Stack_Mem[28], Stack_Mem[29], Stack_Mem[30], 
        Stack_Mem[31]}), .D1({Stack_Mem[24], Stack_Mem[25], Stack_Mem[26], 
        Stack_Mem[27]}), .D2({Stack_Mem[20], Stack_Mem[21], Stack_Mem[22], 
        Stack_Mem[23]}), .D3({Stack_Mem[16], Stack_Mem[17], Stack_Mem[18], 
        Stack_Mem[19]}), .D4({Stack_Mem[12], Stack_Mem[13], Stack_Mem[14], 
        Stack_Mem[15]}), .D5({Stack_Mem[8], Stack_Mem[9], Stack_Mem[10], 
        Stack_Mem[11]}), .D6({Stack_Mem[4], Stack_Mem[5], Stack_Mem[6], 
        Stack_Mem[7]}), .D7({Stack_Mem[0], Stack_Mem[1], Stack_Mem[2], 
        Stack_Mem[3]}), .S0(N10), .S1(N11), .S2(N12), .Z({N35, N34, N33, N32})
         );
  GTECH_BUF B_2 ( .A(Pop_Address[2]), .Z(N10) );
  GTECH_BUF B_3 ( .A(Pop_Address[1]), .Z(N11) );
  GTECH_BUF B_4 ( .A(Pop_Address[0]), .Z(N12) );
  GTECH_NOT I_8 ( .A(Stack_Full), .Z(N13) );
  GTECH_BUF B_5 ( .A(N13), .Z(N14) );
  GTECH_NOT I_9 ( .A(PushEnbl), .Z(N15) );
  GTECH_OR2 C135 ( .A(N14), .B(Stack_Full) );
endmodule


module STACK_TOP ( reset_n, clk, PushEnbl, PopEnbl, PushDataIn, PopDataOut, 
        STACK_FULL );
  input [11:0] PushDataIn;
  output [11:0] PopDataOut;
  input reset_n, clk, PushEnbl, PopEnbl;
  output STACK_FULL;

  wire   [0:2] TOS;

  STACK_FSM I_STACK_FSM ( .reset_n(reset_n), .clk(clk), .PushEnbl(PushEnbl), 
        .PopEnbl(PopEnbl), .TOS(TOS), .STACK_FULL(STACK_FULL) );
  STACK_MEM I1_STACK_MEM ( .clk(clk), .PushEnbl(PushEnbl), .PopEnbl(PopEnbl), 
        .Stack_Full(STACK_FULL), .TOS(TOS), .PushDataIn(PushDataIn[3:0]), 
        .PopDataOut(PopDataOut[3:0]) );
  STACK_MEM I2_STACK_MEM ( .clk(clk), .PushEnbl(PushEnbl), .PopEnbl(PopEnbl), 
        .Stack_Full(STACK_FULL), .TOS(TOS), .PushDataIn(PushDataIn[7:4]), 
        .PopDataOut(PopDataOut[7:4]) );
  STACK_MEM I3_STACK_MEM ( .clk(clk), .PushEnbl(PushEnbl), .PopEnbl(PopEnbl), 
        .Stack_Full(STACK_FULL), .TOS(TOS), .PushDataIn(PushDataIn[11:8]), 
        .PopDataOut(PopDataOut[11:8]) );
endmodule


module RISC_CORE ( clk, reset_n, Instrn, Xecutng_Instrn, EndOfInstrn, PSW, 
        Rd_Instr, RESULT_DATA, OUT_VALID, STACK_FULL );
  input [31:0] Instrn;
  output [31:0] Xecutng_Instrn;
  output [10:0] PSW;
  output [15:0] RESULT_DATA;
  input clk, reset_n;
  output EndOfInstrn, Rd_Instr, OUT_VALID, STACK_FULL;
  wire   Latch_Result, Latch_Flags, ALU_Neg, ALU_Carry, Rd_Oprnd_A, Rd_Oprnd_B,
         Write_RegC, UseData_Imm_Or_RegB, UseData_Imm_Or_ALU, Reset_AluRegs,
         PushEnbl, PopEnbl, SYNOPSYS_UNCONNECTED_1;
  wire   [11:11] PushDataIn;
  wire   [7:0] Return_Addr;
  wire   [10:8] PopDataOut;
  wire   [15:0] Oprnd_A;
  wire   [15:0] Oprnd_B;
  wire   [15:0] Op_Result;
  wire   [31:0] Crnt_Instrn_2;
  wire   [2:0] Current_State;
  wire   [15:0] RegPort_B;
  wire   [6:0] Addr_A;
  wire   [15:0] RegPort_C;

  ALU I_ALU ( .reset_n(reset_n), .clk(clk), .Oprnd_A(Oprnd_A), .Oprnd_B(
        Oprnd_B), .ALU_OP(Xecutng_Instrn[29:24]), .Latch_Result(Latch_Result), 
        .Latch_Flags(Latch_Flags), .Lachd_Result(Op_Result), .Zro_Flag(
        PushDataIn[11]), .Neg_Flag(ALU_Neg), .Carry_Flag(ALU_Carry) );
  CONTROL I_CONTROL ( .clk(clk), .reset_n(reset_n), .Crnt_Instrn(Crnt_Instrn_2), .Current_State(Current_State), .Neg_Flag(PSW[1]), .Carry_Flag(PSW[0]), 
        .Zro_Flag(PSW[2]), .Latch_Instr(Rd_Instr), .Rd_Oprnd_A(Rd_Oprnd_A), 
        .Rd_Oprnd_B(Rd_Oprnd_B), .Latch_Flags(Latch_Flags), .Latch_Result(
        Latch_Result), .Write_RegC(Write_RegC), .UseData_Imm_Or_RegB(
        UseData_Imm_Or_RegB), .UseData_Imm_Or_ALU(UseData_Imm_Or_ALU), 
        .Reset_AluRegs(Reset_AluRegs), .EndOfInstrn(EndOfInstrn), .PushEnbl(
        PushEnbl), .PopEnbl(PopEnbl), .OUT_VALID(OUT_VALID) );
  DATA_PATH I_DATA_PATH ( .clk(clk), .reset_n(reset_n), .Reset_AluRegs(
        Reset_AluRegs), .Rd_Oprnd_A(Rd_Oprnd_A), .Rd_Oprnd_B(Rd_Oprnd_B), 
        .UseData_Imm_Or_RegB(UseData_Imm_Or_RegB), .UseData_Imm_Or_ALU(
        UseData_Imm_Or_ALU), .Latch_Flags(Latch_Flags), .ALU_Zro(
        PushDataIn[11]), .ALU_Neg(ALU_Neg), .ALU_Carry(ALU_Carry), .PSW_Zro(
        PopDataOut[10]), .PSW_Neg(PopDataOut[9]), .PSW_Carry(PopDataOut[8]), 
        .Crnt_Instrn(Crnt_Instrn_2), .RegPort_A(RESULT_DATA), .RegPort_B(
        RegPort_B), .Op_Result(Op_Result), .Zro_Flag(PSW[2]), .Neg_Flag(PSW[1]), .Carry_Flag(PSW[0]), .Addr_A(Addr_A), .Oprnd_A(Oprnd_A), .Oprnd_B(Oprnd_B), 
        .RegPort_C(RegPort_C) );
  INSTRN_LAT I_INSTRN_LAT ( .clk(clk), .Instrn(Instrn), .Latch_Instr(Rd_Instr), 
        .Crnt_Instrn_1(Xecutng_Instrn), .Crnt_Instrn_2(Crnt_Instrn_2) );
  PRGRM_CNT_TOP I_PRGRM_CNT_TOP ( .clk(clk), .reset_n(reset_n), .Crnt_Instrn(
        Crnt_Instrn_2), .Zro_Flag(PSW[2]), .Carry_Flag(PSW[0]), .Neg_Flag(
        PSW[1]), .Return_Addr(Return_Addr), .Current_State(Current_State), 
        .PC(PSW[10:3]) );
  REG_FILE I_REG_FILE ( .reset_n(reset_n), .clk(clk), .Addr_A(Addr_A), 
        .Addr_B(Xecutng_Instrn[6:0]), .Addr_C(Xecutng_Instrn[22:16]), 
        .RegPort_C(RegPort_C), .Write_RegC(Write_RegC), .RegPort_A(RESULT_DATA), .RegPort_B(RegPort_B) );
  STACK_TOP I_STACK_TOP ( .reset_n(reset_n), .clk(clk), .PushEnbl(PushEnbl), 
        .PopEnbl(PopEnbl), .PushDataIn({PushDataIn[11], PSW[2:0], PSW[10:3]}), 
        .PopDataOut({SYNOPSYS_UNCONNECTED_1, PopDataOut, Return_Addr}), 
        .STACK_FULL(STACK_FULL) );
endmodule


module BLENDER ( clk, reset_n, clk_enable, test_mode, operation, op1, op2, 
        result );
  input [3:0] operation;
  input [31:0] op1;
  input [31:0] op2;
  output [31:0] result;
  input clk, reset_n, clk_enable, test_mode;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, latched_clk_en, gclk, trans1, trans2, trans3,
         rem_red, rem_blue, rem_green, c_trans1, c_trans2, c_trans3, c_rem_red,
         c_rem_blue, c_rem_green, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N223, N224, N225, N226, N227, N228, N229, N230, N231,
         N232, N233, N234, N235, N236, N237, N238, N239, N240, N241, N242,
         N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253,
         N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264,
         N265, N266, N267, N268, N269, N270, N271, N272, N273, N274, N275,
         N276, N277, N278, N279, N280, N281, N282, N283, N284, N285, N286,
         N287, N288, N289, N290, N291, N292, N293, N294, N295, N296, N297,
         N298, N299, N300, N301, N302, N303, N304, N305, N306, N307, N308,
         N309, N310, N311, N312, N313, N314, N315, N316, N317, N318, N319,
         N320, N321, N322, N323, N324, N325, N326, N327, N328, N329, N330,
         N331, N332, N333, N334, N335, N336, N337, N338, N339, N340, N341,
         N342, N343, N344, N345, N346, N347, N348, N349, N350, N351, N352,
         N353, N354, N355, N356, N357, N358, N359, N360, N361, N362, N363,
         N364, N365, N366, N367, N368, N369, N370, N371, N372, N373, N374,
         N375, N376, N377, N378, N379, N380, N381, N382, N383, N384, N385,
         N386, N387, N388, N389, N390, N391, N392, N393, N394, N395, N396,
         N397, N398, N399, N400, N401, N402, N403, N404, N405, N406, N407,
         N408, N409, N410, N411, N412, N413, N414, N415, N416, N417, N418,
         N419, N420, N421, N422, N423, N424, N425, N426, N427, N428, N429,
         N430, N431, N432, N433, N434, N435, N436, N437, N438, N439, N440,
         N441, N442, N443, N444, N445, N446, N447, N448, N449, N450, N451,
         N452, N453, N454, N455, N456, N457, N458, N459, N460, N461, N462,
         N463, N464, N465, N466, N467, N468, N469, N470, N471, N472, N473,
         N474, N475, N476, N477, N478, N479, N480, N481, N482, N483, N484,
         N485, N486, N487, N488, N489, N490, N491, N492, N493, N494, N495,
         N496, N497, N498, N499, N500, N501, N502, N503, N504, N505, N506,
         N507, N508, N509, N510, N511, N512, N513, N514, N515, N516, N517,
         N518, N519, N520, N521, N522, N523, N524, N525, N526, N527, N528,
         N529, N530, N531, N532, N533, N534, N535, N536, N537, N538, N539,
         N540, N541, N542, N543, N544, N545, N546, N547, N548, N549, N550,
         N551, N552, N553, N554, N555, N556, N557, N558, N559, N560, N561,
         N562, N563, N564, N565, N566, N567, N568, N569, N570, N571, N572,
         N573, N574, N575, N576, N577, N578, N579, N580, N581, N582, N583,
         N584, N585, N586, N587, N588, N589, N590, N591, N592, N593, N594,
         N595, N596, N597, N598, N599, N600, N601, N602, N603, N604, N605,
         N606, N607, N608, N609, N610, N611, N612, N613, N614, N615, N616,
         N617, N618, N619, N620, N621, N622, N623, N624, N625, N626, N627,
         N628, N629, N630, N631, N632, N633, N634, N635, N636, N637, N638,
         N639, N640, N641, N642, N643, N644, N645, N646, N647, N648, N649,
         N650, N651, N652, N653, N654, N655, N656, N657, N658, N659, N660,
         N661, N662, N663, N664, N665, N666, N667, N668, N669, N670, N671,
         N672, N673, N674, N675, N676, N677, N678, N679, N680, N681, N682,
         N683, N684, N685, N686, N687, N688, N689, N690, N691, N692, N693,
         N694, N695, N696, N697, N698, N699, N700, N701, N702, N703, N704,
         N705, N706, N707, N708, N709, N710, N711, N712, N713, N714, N715,
         N716, N717, N718, N719, N720, N721, N722, N723, N724, N725, N726,
         N727, N728, N729, N730, N731, N732, N733, N734, N735, N736, N737,
         N738, N739, N740, N741, N742, N743, N744, N745, N746, N747, N748,
         N749, N750, N751, N752, N753, N754, N755, N756, N757, N758, N759,
         N760, N761, N762, N763, N764, N765, N766, N767, N768, N769, N770,
         N771, N772, N773, N774, N775, N776, N777, N778, N779, N780, N781,
         N782, N783, N784, N785, N786, N787, N788, N789, N790, N791, N792,
         N793, N794, N795, N796, N797, N798, N799, N800, N801, N802, N803,
         N804, N805, N806, N807, N808, N809, N810, N811, N812, N813, N814,
         N815, N816, N817, N818, N819, N820, N821, N822, N823, N824, N825,
         N826, N827, N828, N829, N830, N831, N832, N833, N834, N835, N836,
         N837, N838, N839, N840, N841, N842, N843, N844, N845, N846, N847,
         N848, N849, N850, N851, N852, N853, N854, N855, N856, N857, N858,
         N859, N860, N861, N862, N863, N864, N865, N866, N867, N868, N869,
         N870, N871, N872, N873, N874, N875, N876, N877, N878, N879, N880,
         N881, N882, N883, N884, N885, N886, N887, N888, N889, N890, N891,
         N892, N893, N894, N895, N896, N897, N898, N899, N900, N901, N902,
         N903, N904, N905, N906, N907, N908, N909, N910, N911, N912, N913,
         N914, N915, N916, N917, N918, N919, N920, N921, N922, N923, N924,
         N925, N926, N927, N928, N929, N930, N931, N932;
  wire   [31:0] s1_op1;
  wire   [31:0] s1_op2;
  wire   [31:0] s2_op1;
  wire   [31:0] s2_op2;
  wire   [31:0] s3_op1;
  wire   [31:0] s3_op2;
  wire   [31:0] s4_op1;
  wire   [31:0] s4_op2;
  wire   [15:0] s5_result;
  wire   [63:0] mega_shift;

  \**SEQGEN**  latched_clk_en_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        1'b0), .clocked_on(1'b0), .data_in(clk_enable), .enable(N897), .Q(
        latched_clk_en), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b0) );
  \**SEQGEN**  rem_green_reg ( .clear(N896), .preset(1'b0), .next_state(
        c_rem_green), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        rem_green), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  trans1_reg ( .clear(N896), .preset(1'b0), .next_state(c_trans1), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(trans1), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  trans2_reg ( .clear(N896), .preset(1'b0), .next_state(c_trans2), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(trans2), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  trans3_reg ( .clear(N896), .preset(1'b0), .next_state(c_trans3), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(trans3), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  rem_red_reg ( .clear(N896), .preset(1'b0), .next_state(
        c_rem_red), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        rem_red), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  rem_blue_reg ( .clear(N896), .preset(1'b0), .next_state(
        c_rem_blue), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        rem_blue), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_OR2 C31 ( .A(operation[3]), .B(N46), .Z(N21) );
  GTECH_OR2 C32 ( .A(operation[1]), .B(N44), .Z(N22) );
  GTECH_OR2 C33 ( .A(N21), .B(N22), .Z(N23) );
  GTECH_OR2 C38 ( .A(N39), .B(N46), .Z(N25) );
  GTECH_OR2 C40 ( .A(N25), .B(N22), .Z(N26) );
  GTECH_OR2 C44 ( .A(N39), .B(operation[2]), .Z(N28) );
  GTECH_OR2 C45 ( .A(N43), .B(operation[0]), .Z(N29) );
  GTECH_OR2 C46 ( .A(N28), .B(N29), .Z(N30) );
  GTECH_OR2 C52 ( .A(N28), .B(N22), .Z(N32) );
  GTECH_OR2 C59 ( .A(N25), .B(N29), .Z(N34) );
  GTECH_AND2 C61 ( .A(operation[3]), .B(operation[2]), .Z(N36) );
  GTECH_AND2 C62 ( .A(operation[1]), .B(operation[0]), .Z(N37) );
  GTECH_AND2 C63 ( .A(N36), .B(N37), .Z(N38) );
  GTECH_AND2 C65 ( .A(N39), .B(operation[1]), .Z(N40) );
  GTECH_AND2 C67 ( .A(N46), .B(operation[1]), .Z(N41) );
  GTECH_AND2 C68 ( .A(N41), .B(operation[0]), .Z(N42) );
  GTECH_AND2 C71 ( .A(N43), .B(N44), .Z(N45) );
  GTECH_AND2 C74 ( .A(N39), .B(N46), .Z(N47) );
  \**SEQGEN**  s1_op2_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N178), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N177), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N176), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N175), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N174), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N173), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N172), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N171), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N170), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N169), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N168), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N167), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N166), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N165), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N164), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N163), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N162), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N161), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N160), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N159), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N158), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N157), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N156), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N155), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N154), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N153), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N152), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N151), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N150), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N149), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N148), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op2_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N147), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op2[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N146), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N145), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N144), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N143), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N142), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N141), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N140), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N139), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N138), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N137), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N136), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N135), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N134), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N133), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N132), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N131), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N130), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N129), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N128), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N127), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N126), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N125), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N124), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N123), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N122), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N121), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N120), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N119), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N118), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N117), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N116), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s1_op1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N115), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s1_op1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N373), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N372), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N371), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N370), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N369), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N368), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N367), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N366), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N365), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N364), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N363), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N362), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N361), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N360), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N359), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N358), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N357), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N356), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N355), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N354), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N353), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N352), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N351), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N350), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N349), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N348), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N347), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N346), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N345), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N344), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N343), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op2_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N342), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op2[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N341), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N340), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N339), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N338), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N337), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N336), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N335), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N334), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N333), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N332), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N331), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N330), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N329), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N328), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N327), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N326), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N325), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N324), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N323), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N322), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N321), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N320), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N319), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N318), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N317), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N316), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N315), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N314), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N313), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N312), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N311), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s2_op1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N310), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s2_op1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N570), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N569), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N568), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N567), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N566), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N565), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N564), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N563), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N562), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N561), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N560), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N559), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N558), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N557), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N556), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N555), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N554), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N553), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N552), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N551), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N550), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N549), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N548), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N547), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N546), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N545), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N544), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N543), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N542), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N541), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N540), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op2_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N539), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op2[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N538), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N537), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N536), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N535), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N534), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N533), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N532), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N531), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N530), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N529), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N528), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N527), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N526), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N525), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N524), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N523), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N522), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N521), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N520), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N519), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N518), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N517), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N516), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N515), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N514), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N513), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N512), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N511), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N510), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N509), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N508), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s3_op1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N507), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s3_op1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N863), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N862), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N861), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N860), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N859), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N858), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N857), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N856), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N855), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N854), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N853), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N852), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N851), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N850), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N849), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N848), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N847), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N846), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N845), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N844), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N843), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N842), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N841), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N840), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N839), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N838), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N837), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N836), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N835), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N834), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N833), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op2_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N832), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op2[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(N831), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[31]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(N830), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[30]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(N829), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[29]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(N828), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[28]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(N827), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[27]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(N826), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[26]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(N825), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[25]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(N824), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[24]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(N823), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[23]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(N822), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[22]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(N821), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[21]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(N820), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[20]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(N819), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[19]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(N818), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[18]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(N817), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[17]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(N816), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[16]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(N815), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[15]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(N814), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[14]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(N813), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[13]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(N812), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[12]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(N811), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[11]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(N810), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[10]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(N809), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(N808), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N807), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N806), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N805), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N804), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N803), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N802), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N801), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  s4_op1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N800), 
        .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(s4_op1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__31_ ( .clear(N896), .preset(1'b0), 
        .next_state(N895), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[63]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__30_ ( .clear(N896), .preset(1'b0), 
        .next_state(N894), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[62]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__29_ ( .clear(N896), .preset(1'b0), 
        .next_state(N893), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[61]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__28_ ( .clear(N896), .preset(1'b0), 
        .next_state(N892), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[60]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__27_ ( .clear(N896), .preset(1'b0), 
        .next_state(N891), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[59]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__26_ ( .clear(N896), .preset(1'b0), 
        .next_state(N890), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[58]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__25_ ( .clear(N896), .preset(1'b0), 
        .next_state(N889), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[57]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__24_ ( .clear(N896), .preset(1'b0), 
        .next_state(N888), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[56]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__23_ ( .clear(N896), .preset(1'b0), 
        .next_state(N887), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[55]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__22_ ( .clear(N896), .preset(1'b0), 
        .next_state(N886), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[54]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__21_ ( .clear(N896), .preset(1'b0), 
        .next_state(N885), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[53]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__20_ ( .clear(N896), .preset(1'b0), 
        .next_state(N884), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[52]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__19_ ( .clear(N896), .preset(1'b0), 
        .next_state(N883), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[51]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__18_ ( .clear(N896), .preset(1'b0), 
        .next_state(N882), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__17_ ( .clear(N896), .preset(1'b0), 
        .next_state(N881), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__16_ ( .clear(N896), .preset(1'b0), 
        .next_state(N880), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__15_ ( .clear(N896), .preset(1'b0), 
        .next_state(N879), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__14_ ( .clear(N896), .preset(1'b0), 
        .next_state(N878), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__13_ ( .clear(N896), .preset(1'b0), 
        .next_state(N877), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__12_ ( .clear(N896), .preset(1'b0), 
        .next_state(N876), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__11_ ( .clear(N896), .preset(1'b0), 
        .next_state(N875), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__10_ ( .clear(N896), .preset(1'b0), 
        .next_state(N874), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__9_ ( .clear(N896), .preset(1'b0), 
        .next_state(N873), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__8_ ( .clear(N896), .preset(1'b0), 
        .next_state(N872), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__7_ ( .clear(N896), .preset(1'b0), 
        .next_state(N871), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__6_ ( .clear(N896), .preset(1'b0), 
        .next_state(N870), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__5_ ( .clear(N896), .preset(1'b0), 
        .next_state(N869), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__4_ ( .clear(N896), .preset(1'b0), 
        .next_state(N868), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__3_ ( .clear(N896), .preset(1'b0), 
        .next_state(N867), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__2_ ( .clear(N896), .preset(1'b0), 
        .next_state(N866), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__1_ ( .clear(N896), .preset(1'b0), 
        .next_state(N865), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_0__0_ ( .clear(N896), .preset(1'b0), 
        .next_state(N864), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__31_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[15]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[31]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__30_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[14]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[30]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__29_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[13]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[29]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__28_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[12]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[28]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__27_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[11]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[27]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__26_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[10]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[26]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__25_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[9]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__24_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[8]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__23_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[7]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__22_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[6]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__21_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[5]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__20_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[4]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__19_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[3]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__18_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[2]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__17_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[1]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__16_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[0]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__15_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[15]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[15]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__14_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[14]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[14]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__13_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[13]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[13]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__12_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[12]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[12]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__11_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[11]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[11]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__10_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[10]), .clocked_on(gclk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift[10]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__9_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[9]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__8_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[8]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__7_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[7]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__6_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[6]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__5_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[5]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__4_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[4]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__3_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[3]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__2_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[2]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__1_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[1]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_reg_1__0_ ( .clear(N896), .preset(1'b0), 
        .next_state(s5_result[0]), .clocked_on(gclk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_31_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[63]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_30_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[62]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_29_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[61]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_28_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[60]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_27_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[59]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_26_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[58]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_25_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[57]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_24_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[56]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_23_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[55]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_22_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[54]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_21_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[53]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_20_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[52]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_19_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[51]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_18_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[50]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_17_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[49]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_16_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[48]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_15_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[47]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_14_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[46]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_13_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[45]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_12_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[44]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_11_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[43]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_10_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[42]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_9_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[41]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_8_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[40]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_7_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[39]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_6_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[38]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_5_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[37]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_4_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[36]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_3_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[35]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_2_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[34]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_1_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[33]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  result_reg_0_ ( .clear(N896), .preset(1'b0), .next_state(
        mega_shift[32]), .clocked_on(gclk), .data_in(1'b0), .enable(1'b0), .Q(
        result[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(reset_n), .Z(N896) );
  GTECH_NOT I_1 ( .A(clk), .Z(N897) );
  MULT_UNS_OP mult_57_C211_rn ( .A(mega_shift[31:16]), .B(mega_shift[15:0]), 
        .Z({N895, N894, N893, N892, N891, N890, N889, N888, N887, N886, N885, 
        N884, N883, N882, N881, N880, N879, N878, N877, N876, N875, N874, N873, 
        N872, N871, N870, N869, N868, N867, N866, N865, N864}) );
  SUB_TC_OP sub_163 ( .A(s2_op2), .B({1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1}), 
        .Z({N438, N437, N436, N435, N434, N433, N432, N431, N430, N429, N428, 
        N427, N426, N425, N424, N423, N422, N421, N420, N419, N418, N417, N416, 
        N415, N414, N413, N412, N411, N410, N409, N408, N407}) );
  ADD_TC_OP add_162 ( .A(s2_op1), .B({1'b0, 1'b1, 1'b1, 1'b1}), .Z({N406, N405, 
        N404, N403, N402, N401, N400, N399, N398, N397, N396, N395, N394, N393, 
        N392, N391, N390, N389, N388, N387, N386, N385, N384, N383, N382, N381, 
        N380, N379, N378, N377, N376, N375}) );
  SUB_TC_OP sub_166_aco ( .A(s2_op2), .B({1'b0, N440, N440, N440, N440, N440, 
        1'b0, 1'b0, N440, 1'b0, N440}), .Z({N506, N505, N504, N503, N502, N501, 
        N500, N499, N498, N497, N496, N495, N494, N493, N492, N491, N490, N489, 
        N488, N487, N486, N485, N484, N483, N482, N481, N480, N479, N478, N477, 
        N476, N475}) );
  ADD_TC_OP add_165_aco ( .A(s2_op1), .B({1'b0, N440, N440, 1'b0, N440, 1'b0, 
        N440, N440, 1'b0}), .Z({N474, N473, N472, N471, N470, N469, N468, N467, 
        N466, N465, N464, N463, N462, N461, N460, N459, N458, N457, N456, N455, 
        N454, N453, N452, N451, N450, N449, N448, N447, N446, N445, N444, N443}) );
  ADD_UNS_OP add_178 ( .A(s3_op1[31:16]), .B(s3_op1[15:0]), .Z({N588, N587, 
        N586, N585, N584, N583, N582, N581, N580, N579, N578, N577, N576, N575, 
        N574, N573}) );
  SUB_UNS_OP sub_178 ( .A(s3_op2[31:16]), .B(s3_op2[15:0]), .Z({N604, N603, 
        N602, N601, N600, N599, N598, N597, N596, N595, N594, N593, N592, N591, 
        N590, N589}) );
  ADD_UNS_OP add_179 ( .A(s3_op2[31:16]), .B(s3_op1[15:0]), .Z({N652, N651, 
        N650, N649, N648, N647, N646, N645, N644, N643, N642, N641, N640, N639, 
        N638, N637}) );
  SUB_UNS_OP sub_179 ( .A(s3_op2[31:16]), .B(s3_op1[15:0]), .Z({N668, N667, 
        N666, N665, N664, N663, N662, N661, N660, N659, N658, N657, N656, N655, 
        N654, N653}) );
  MULT_UNS_OP mult_178 ( .A({N588, N587, N586, N585, N584, N583, N582, N581, 
        N580, N579, N578, N577, N576, N575, N574, N573}), .B({N604, N603, N602, 
        N601, N600, N599, N598, N597, N596, N595, N594, N593, N592, N591, N590, 
        N589}), .Z({N636, N635, N634, N633, N632, N631, N630, N629, N628, N627, 
        N626, N625, N624, N623, N622, N621, N620, N619, N618, N617, N616, N615, 
        N614, N613, N612, N611, N610, N609, N608, N607, N606, N605}) );
  MULT_UNS_OP mult_179 ( .A({N652, N651, N650, N649, N648, N647, N646, N645, 
        N644, N643, N642, N641, N640, N639, N638, N637}), .B({N668, N667, N666, 
        N665, N664, N663, N662, N661, N660, N659, N658, N657, N656, N655, N654, 
        N653}), .Z({N700, N699, N698, N697, N696, N695, N694, N693, N692, N691, 
        N690, N689, N688, N687, N686, N685, N684, N683, N682, N681, N680, N679, 
        N678, N677, N676, N675, N674, N673, N672, N671, N670, N669}) );
  MULT_UNS_OP mult_181 ( .A(s3_op1[31:20]), .B(s3_op1[19:8]), .Z({N727, N726, 
        N725, N724, N723, N722, N721, N720, N719, N718, N717, N716, N715, N714, 
        N713, N712, N711, N710, N709, N708, N707, N706, N705, N704}) );
  MULT_UNS_OP mult_182 ( .A(s3_op2[31:20]), .B(s3_op2[19:8]), .Z({N751, N750, 
        N749, N748, N747, N746, N745, N744, N743, N742, N741, N740, N739, N738, 
        N737, N736, N735, N734, N733, N732, N731, N730, N729, N728}) );
  SELECT_OP C939 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b1), .DATA6(1'b0), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_trans1) );
  GTECH_BUF B_0 ( .A(N24), .Z(N0) );
  GTECH_BUF B_1 ( .A(N27), .Z(N1) );
  GTECH_BUF B_2 ( .A(N31), .Z(N2) );
  GTECH_BUF B_3 ( .A(N33), .Z(N3) );
  GTECH_BUF B_4 ( .A(N35), .Z(N4) );
  GTECH_BUF B_5 ( .A(N38), .Z(N5) );
  GTECH_BUF B_6 ( .A(N48), .Z(N6) );
  SELECT_OP C940 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b1), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_rem_red) );
  SELECT_OP C941 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_rem_blue) );
  SELECT_OP C942 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b1), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_rem_green) );
  SELECT_OP C943 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b1), .DATA4(1'b0), 
        .DATA5(1'b1), .DATA6(1'b0), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_trans2) );
  SELECT_OP C944 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b1), 
        .DATA5(1'b1), .DATA6(1'b0), .DATA7(1'b0), .CONTROL1(N0), .CONTROL2(N1), 
        .CONTROL3(N2), .CONTROL4(N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(
        N6), .Z(c_trans3) );
  SELECT_OP C945 ( .DATA1({op2[7:0], op1[31:24], op2[23:16], op1[15:8]}), 
        .DATA2(op1), .CONTROL1(N7), .CONTROL2(N8), .Z({N82, N81, N80, N79, N78, 
        N77, N76, N75, N74, N73, N72, N71, N70, N69, N68, N67, N66, N65, N64, 
        N63, N62, N61, N60, N59, N58, N57, N56, N55, N54, N53, N52, N51}) );
  GTECH_BUF B_7 ( .A(trans2), .Z(N7) );
  GTECH_BUF B_8 ( .A(N50), .Z(N8) );
  SELECT_OP C946 ( .DATA1({op1[7:0], op2[31:24], op1[23:16], op2[15:8]}), 
        .DATA2(op2), .CONTROL1(N7), .CONTROL2(N8), .Z({N114, N113, N112, N111, 
        N110, N109, N108, N107, N106, N105, N104, N103, N102, N101, N100, N99, 
        N98, N97, N96, N95, N94, N93, N92, N91, N90, N89, N88, N87, N86, N85, 
        N84, N83}) );
  SELECT_OP C947 ( .DATA1({op1[31:24], op2[23:16], op1[15:8], op2[7:0]}), 
        .DATA2({N82, N81, N80, N79, N78, N77, N76, N75, N74, N73, N72, N71, 
        N70, N69, N68, N67, N66, N65, N64, N63, N62, N61, N60, N59, N58, N57, 
        N56, N55, N54, N53, N52, N51}), .CONTROL1(N9), .CONTROL2(N10), .Z({
        N146, N145, N144, N143, N142, N141, N140, N139, N138, N137, N136, N135, 
        N134, N133, N132, N131, N130, N129, N128, N127, N126, N125, N124, N123, 
        N122, N121, N120, N119, N118, N117, N116, N115}) );
  GTECH_BUF B_9 ( .A(trans1), .Z(N9) );
  GTECH_BUF B_10 ( .A(N49), .Z(N10) );
  SELECT_OP C948 ( .DATA1({op2[31:24], op1[23:16], op2[15:8], op1[7:0]}), 
        .DATA2({N114, N113, N112, N111, N110, N109, N108, N107, N106, N105, 
        N104, N103, N102, N101, N100, N99, N98, N97, N96, N95, N94, N93, N92, 
        N91, N90, N89, N88, N87, N86, N85, N84, N83}), .CONTROL1(N9), 
        .CONTROL2(N10), .Z({N178, N177, N176, N175, N174, N173, N172, N171, 
        N170, N169, N168, N167, N166, N165, N164, N163, N162, N161, N160, N159, 
        N158, N157, N156, N155, N154, N153, N152, N151, N150, N149, N148, N147}) );
  SELECT_OP C949 ( .DATA1({s1_op2[7:0], s1_op2[23:16], 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, s1_op1[15:8]}), .DATA2(s1_op1), .CONTROL1(N11), 
        .CONTROL2(N12), .Z({N213, N212, N211, N210, N209, N208, N207, N206, 
        N205, N204, N203, N202, N201, N200, N199, N198, N197, N196, N195, N194, 
        N193, N192, N191, N190, N189, N188, N187, N186, N185, N184, N183, N182}) );
  GTECH_BUF B_11 ( .A(rem_blue), .Z(N11) );
  GTECH_BUF B_12 ( .A(N181), .Z(N12) );
  SELECT_OP C950 ( .DATA1({s1_op1[7:0], s1_op1[23:16], 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, s1_op2[15:8]}), .DATA2(s1_op2), .CONTROL1(N11), 
        .CONTROL2(N12), .Z({N245, N244, N243, N242, N241, N240, N239, N238, 
        N237, N236, N235, N234, N233, N232, N231, N230, N229, N228, N227, N226, 
        N225, N224, N223, N222, N221, N220, N219, N218, N217, N216, N215, N214}) );
  SELECT_OP C951 ( .DATA1({s1_op2[7:0], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, s1_op2[23:16], s1_op1[15:8]}), .DATA2({N213, N212, N211, 
        N210, N209, N208, N207, N206, N205, N204, N203, N202, N201, N200, N199, 
        N198, N197, N196, N195, N194, N193, N192, N191, N190, N189, N188, N187, 
        N186, N185, N184, N183, N182}), .CONTROL1(N13), .CONTROL2(N14), .Z({
        N277, N276, N275, N274, N273, N272, N271, N270, N269, N268, N267, N266, 
        N265, N264, N263, N262, N261, N260, N259, N258, N257, N256, N255, N254, 
        N253, N252, N251, N250, N249, N248, N247, N246}) );
  GTECH_BUF B_13 ( .A(rem_green), .Z(N13) );
  GTECH_BUF B_14 ( .A(N180), .Z(N14) );
  SELECT_OP C952 ( .DATA1({s1_op1[7:0], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, s1_op1[23:16], s1_op2[15:8]}), .DATA2({N245, N244, N243, 
        N242, N241, N240, N239, N238, N237, N236, N235, N234, N233, N232, N231, 
        N230, N229, N228, N227, N226, N225, N224, N223, N222, N221, N220, N219, 
        N218, N217, N216, N215, N214}), .CONTROL1(N13), .CONTROL2(N14), .Z({
        N309, N308, N307, N306, N305, N304, N303, N302, N301, N300, N299, N298, 
        N297, N296, N295, N294, N293, N292, N291, N290, N289, N288, N287, N286, 
        N285, N284, N283, N282, N281, N280, N279, N278}) );
  SELECT_OP C953 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        s1_op2[23:16], s1_op1[15:8], s1_op2[7:0]}), .DATA2({N277, N276, N275, 
        N274, N273, N272, N271, N270, N269, N268, N267, N266, N265, N264, N263, 
        N262, N261, N260, N259, N258, N257, N256, N255, N254, N253, N252, N251, 
        N250, N249, N248, N247, N246}), .CONTROL1(N15), .CONTROL2(N16), .Z({
        N341, N340, N339, N338, N337, N336, N335, N334, N333, N332, N331, N330, 
        N329, N328, N327, N326, N325, N324, N323, N322, N321, N320, N319, N318, 
        N317, N316, N315, N314, N313, N312, N311, N310}) );
  GTECH_BUF B_15 ( .A(rem_red), .Z(N15) );
  GTECH_BUF B_16 ( .A(N179), .Z(N16) );
  SELECT_OP C954 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        s1_op1[23:16], s1_op2[15:8], s1_op1[7:0]}), .DATA2({N309, N308, N307, 
        N306, N305, N304, N303, N302, N301, N300, N299, N298, N297, N296, N295, 
        N294, N293, N292, N291, N290, N289, N288, N287, N286, N285, N284, N283, 
        N282, N281, N280, N279, N278}), .CONTROL1(N15), .CONTROL2(N16), .Z({
        N373, N372, N371, N370, N369, N368, N367, N366, N365, N364, N363, N362, 
        N361, N360, N359, N358, N357, N356, N355, N354, N353, N352, N351, N350, 
        N349, N348, N347, N346, N345, N344, N343, N342}) );
  SELECT_OP C957 ( .DATA1({N406, N405, N404, N403, N402, N401, N400, N399, 
        N398, N397, N396, N395, N394, N393, N392, N391, N390, N389, N388, N387, 
        N386, N385, N384, N383, N382, N381, N380, N379, N378, N377, N376, N375}), .DATA2({N474, N473, N472, N471, N470, N469, N468, N467, N466, N465, N464, 
        N463, N462, N461, N460, N459, N458, N457, N456, N455, N454, N453, N452, 
        N451, N450, N449, N448, N447, N446, N445, N444, N443}), .CONTROL1(N17), 
        .CONTROL2(N18), .Z({N538, N537, N536, N535, N534, N533, N532, N531, 
        N530, N529, N528, N527, N526, N525, N524, N523, N522, N521, N520, N519, 
        N518, N517, N516, N515, N514, N513, N512, N511, N510, N509, N508, N507}) );
  GTECH_BUF B_17 ( .A(trans3), .Z(N17) );
  GTECH_BUF B_18 ( .A(N374), .Z(N18) );
  SELECT_OP C958 ( .DATA1({N438, N437, N436, N435, N434, N433, N432, N431, 
        N430, N429, N428, N427, N426, N425, N424, N423, N422, N421, N420, N419, 
        N418, N417, N416, N415, N414, N413, N412, N411, N410, N409, N408, N407}), .DATA2({N506, N505, N504, N503, N502, N501, N500, N499, N498, N497, N496, 
        N495, N494, N493, N492, N491, N490, N489, N488, N487, N486, N485, N484, 
        N483, N482, N481, N480, N479, N478, N477, N476, N475}), .CONTROL1(N17), 
        .CONTROL2(N18), .Z({N570, N569, N568, N567, N566, N565, N564, N563, 
        N562, N561, N560, N559, N558, N557, N556, N555, N554, N553, N552, N551, 
        N550, N549, N548, N547, N546, N545, N544, N543, N542, N541, N540, N539}) );
  SELECT_OP C959 ( .DATA1({N727, N726, N725, N724, N723, N722, N721, N720, 
        N719, N718, N717, N716, N715, N714, N713, N712, N711, N710, N709, N708, 
        N707, N706, N705, N704}), .DATA2(s3_op1[31:8]), .CONTROL1(N19), 
        .CONTROL2(N703), .Z({N775, N774, N773, N772, N771, N770, N769, N768, 
        N767, N766, N765, N764, N763, N762, N761, N760, N759, N758, N757, N756, 
        N755, N754, N753, N752}) );
  GTECH_BUF B_19 ( .A(N702), .Z(N19) );
  SELECT_OP C960 ( .DATA1({N751, N750, N749, N748, N747, N746, N745, N744, 
        N743, N742, N741, N740, N739, N738, N737, N736, N735, N734, N733, N732, 
        N731, N730, N729, N728}), .DATA2(s3_op2[31:8]), .CONTROL1(N19), 
        .CONTROL2(N703), .Z({N799, N798, N797, N796, N795, N794, N793, N792, 
        N791, N790, N789, N788, N787, N786, N785, N784, N783, N782, N781, N780, 
        N779, N778, N777, N776}) );
  SELECT_OP C961 ( .DATA1({N636, N635, N634, N633, N632, N631, N630, N629, 
        N628, N627, N626, N625, N624, N623, N622, N621, N620, N619, N618, N617, 
        N616, N615, N614, N613, N612, N611, N610, N609, N608, N607, N606, N605}), .DATA2({N775, N774, N773, N772, N771, N770, N769, N768, N767, N766, N765, 
        N764, N763, N762, N761, N760, N759, N758, N757, N756, N755, N754, N753, 
        N752, s3_op1[7:0]}), .CONTROL1(N20), .CONTROL2(N572), .Z({N831, N830, 
        N829, N828, N827, N826, N825, N824, N823, N822, N821, N820, N819, N818, 
        N817, N816, N815, N814, N813, N812, N811, N810, N809, N808, N807, N806, 
        N805, N804, N803, N802, N801, N800}) );
  GTECH_BUF B_20 ( .A(N571), .Z(N20) );
  SELECT_OP C962 ( .DATA1({N700, N699, N698, N697, N696, N695, N694, N693, 
        N692, N691, N690, N689, N688, N687, N686, N685, N684, N683, N682, N681, 
        N680, N679, N678, N677, N676, N675, N674, N673, N672, N671, N670, N669}), .DATA2({N799, N798, N797, N796, N795, N794, N793, N792, N791, N790, N789, 
        N788, N787, N786, N785, N784, N783, N782, N781, N780, N779, N778, N777, 
        N776, s3_op2[7:0]}), .CONTROL1(N20), .CONTROL2(N572), .Z({N863, N862, 
        N861, N860, N859, N858, N857, N856, N855, N854, N853, N852, N851, N850, 
        N849, N848, N847, N846, N845, N844, N843, N842, N841, N840, N839, N838, 
        N837, N836, N835, N834, N833, N832}) );
  GTECH_AND2 C968 ( .A(clk), .B(N898), .Z(gclk) );
  GTECH_OR2 C969 ( .A(latched_clk_en), .B(test_mode), .Z(N898) );
  GTECH_NOT I_2 ( .A(N23), .Z(N24) );
  GTECH_NOT I_3 ( .A(N26), .Z(N27) );
  GTECH_NOT I_4 ( .A(N30), .Z(N31) );
  GTECH_NOT I_5 ( .A(N32), .Z(N33) );
  GTECH_NOT I_6 ( .A(N34), .Z(N35) );
  GTECH_NOT I_7 ( .A(operation[3]), .Z(N39) );
  GTECH_NOT I_8 ( .A(operation[1]), .Z(N43) );
  GTECH_NOT I_9 ( .A(operation[0]), .Z(N44) );
  GTECH_NOT I_10 ( .A(operation[2]), .Z(N46) );
  GTECH_OR2 C979 ( .A(N40), .B(N900), .Z(N48) );
  GTECH_OR2 C980 ( .A(N42), .B(N899), .Z(N900) );
  GTECH_OR2 C981 ( .A(N45), .B(N47), .Z(N899) );
  GTECH_NOT I_11 ( .A(trans1), .Z(N49) );
  GTECH_NOT I_12 ( .A(trans2), .Z(N50) );
  GTECH_NOT I_13 ( .A(rem_red), .Z(N179) );
  GTECH_NOT I_14 ( .A(rem_green), .Z(N180) );
  GTECH_NOT I_15 ( .A(rem_blue), .Z(N181) );
  GTECH_NOT I_16 ( .A(trans3), .Z(N374) );
  GTECH_BUF B_21 ( .A(trans3) );
  GTECH_BUF B_22 ( .A(N374), .Z(N439) );
  GTECH_AND2 C1009 ( .A(trans1), .B(trans2), .Z(N440) );
  GTECH_NOT I_17 ( .A(N440), .Z(N441) );
  GTECH_AND2 C1012 ( .A(N439), .B(N440), .Z(N442) );
  GTECH_AND2 C1013 ( .A(rem_green), .B(rem_red), .Z(N571) );
  GTECH_NOT I_18 ( .A(N571), .Z(N572) );
  GTECH_BUF B_23 ( .A(N571) );
  GTECH_BUF B_24 ( .A(N572), .Z(N701) );
  GTECH_AND2 C1018 ( .A(trans2), .B(trans3), .Z(N702) );
  GTECH_NOT I_19 ( .A(N702), .Z(N703) );
  GTECH_AND2 C1021 ( .A(N701), .B(N702) );
  GTECH_XOR2 C1022 ( .A(N901), .B(N902), .Z(s5_result[0]) );
  GTECH_XOR2 C1023 ( .A(s4_op1[0]), .B(s4_op2[0]), .Z(N901) );
  GTECH_XOR2 C1024 ( .A(s4_op1[1]), .B(s4_op2[1]), .Z(N902) );
  GTECH_XOR2 C1025 ( .A(N903), .B(N904), .Z(s5_result[1]) );
  GTECH_XOR2 C1026 ( .A(s4_op1[2]), .B(s4_op2[2]), .Z(N903) );
  GTECH_XOR2 C1027 ( .A(s4_op1[3]), .B(s4_op2[3]), .Z(N904) );
  GTECH_XOR2 C1028 ( .A(N905), .B(N906), .Z(s5_result[2]) );
  GTECH_XOR2 C1029 ( .A(s4_op1[4]), .B(s4_op2[4]), .Z(N905) );
  GTECH_XOR2 C1030 ( .A(s4_op1[5]), .B(s4_op2[5]), .Z(N906) );
  GTECH_XOR2 C1031 ( .A(N907), .B(N908), .Z(s5_result[3]) );
  GTECH_XOR2 C1032 ( .A(s4_op1[6]), .B(s4_op2[6]), .Z(N907) );
  GTECH_XOR2 C1033 ( .A(s4_op1[7]), .B(s4_op2[7]), .Z(N908) );
  GTECH_XOR2 C1034 ( .A(N909), .B(N910), .Z(s5_result[4]) );
  GTECH_XOR2 C1035 ( .A(s4_op1[8]), .B(s4_op2[8]), .Z(N909) );
  GTECH_XOR2 C1036 ( .A(s4_op1[9]), .B(s4_op2[9]), .Z(N910) );
  GTECH_XOR2 C1037 ( .A(N911), .B(N912), .Z(s5_result[5]) );
  GTECH_XOR2 C1038 ( .A(s4_op1[10]), .B(s4_op2[10]), .Z(N911) );
  GTECH_XOR2 C1039 ( .A(s4_op1[11]), .B(s4_op2[11]), .Z(N912) );
  GTECH_XOR2 C1040 ( .A(N913), .B(N914), .Z(s5_result[6]) );
  GTECH_XOR2 C1041 ( .A(s4_op1[12]), .B(s4_op2[12]), .Z(N913) );
  GTECH_XOR2 C1042 ( .A(s4_op1[13]), .B(s4_op2[13]), .Z(N914) );
  GTECH_XOR2 C1043 ( .A(N915), .B(N916), .Z(s5_result[7]) );
  GTECH_XOR2 C1044 ( .A(s4_op1[14]), .B(s4_op2[14]), .Z(N915) );
  GTECH_XOR2 C1045 ( .A(s4_op1[15]), .B(s4_op2[15]), .Z(N916) );
  GTECH_XOR2 C1046 ( .A(N917), .B(N918), .Z(s5_result[8]) );
  GTECH_XOR2 C1047 ( .A(s4_op1[16]), .B(s4_op2[16]), .Z(N917) );
  GTECH_XOR2 C1048 ( .A(s4_op1[17]), .B(s4_op2[17]), .Z(N918) );
  GTECH_XOR2 C1049 ( .A(N919), .B(N920), .Z(s5_result[9]) );
  GTECH_XOR2 C1050 ( .A(s4_op1[18]), .B(s4_op2[18]), .Z(N919) );
  GTECH_XOR2 C1051 ( .A(s4_op1[19]), .B(s4_op2[19]), .Z(N920) );
  GTECH_XOR2 C1052 ( .A(N921), .B(N922), .Z(s5_result[10]) );
  GTECH_XOR2 C1053 ( .A(s4_op1[20]), .B(s4_op2[20]), .Z(N921) );
  GTECH_XOR2 C1054 ( .A(s4_op1[21]), .B(s4_op2[21]), .Z(N922) );
  GTECH_XOR2 C1055 ( .A(N923), .B(N924), .Z(s5_result[11]) );
  GTECH_XOR2 C1056 ( .A(s4_op1[22]), .B(s4_op2[22]), .Z(N923) );
  GTECH_XOR2 C1057 ( .A(s4_op1[23]), .B(s4_op2[23]), .Z(N924) );
  GTECH_XOR2 C1058 ( .A(N925), .B(N926), .Z(s5_result[12]) );
  GTECH_XOR2 C1059 ( .A(s4_op1[24]), .B(s4_op2[24]), .Z(N925) );
  GTECH_XOR2 C1060 ( .A(s4_op1[25]), .B(s4_op2[25]), .Z(N926) );
  GTECH_XOR2 C1061 ( .A(N927), .B(N928), .Z(s5_result[13]) );
  GTECH_XOR2 C1062 ( .A(s4_op1[26]), .B(s4_op2[26]), .Z(N927) );
  GTECH_XOR2 C1063 ( .A(s4_op1[27]), .B(s4_op2[27]), .Z(N928) );
  GTECH_XOR2 C1064 ( .A(N929), .B(N930), .Z(s5_result[14]) );
  GTECH_XOR2 C1065 ( .A(s4_op1[28]), .B(s4_op2[28]), .Z(N929) );
  GTECH_XOR2 C1066 ( .A(s4_op1[29]), .B(s4_op2[29]), .Z(N930) );
  GTECH_XOR2 C1067 ( .A(N931), .B(N932), .Z(s5_result[15]) );
  GTECH_XOR2 C1068 ( .A(s4_op1[30]), .B(s4_op2[30]), .Z(N931) );
  GTECH_XOR2 C1069 ( .A(s4_op1[31]), .B(s4_op2[31]), .Z(N932) );
  GTECH_BUF B_25 ( .A(reset_n) );
  GTECH_OR2 C1072 ( .A(N442), .B(N441) );
  GTECH_OR2 C1073 ( .A(N442), .B(N441) );
endmodule


module SDRAM_IF ( sdram_clk, sdram_rst_n, risc_OUT_VALID, risc_STACK_FULL, 
        risc_EndOfInstrn, risc_PSW, risc_Rd_Instr, sd_A, sd_CK, sd_CKn, sd_LD, 
        sd_RW, sd_BWS, sd_DQ_in, sd_DQ_out, sd_DQ_en, sd_wfifo_pop, 
        sd_wfifo_empty, sd_rfifo_push, sd_rfifo_full, sd_rfifo_DQ_out, 
        sd_wfifo_DQ_in );
  input [10:0] risc_PSW;
  output [9:0] sd_A;
  output [1:0] sd_BWS;
  input [15:0] sd_DQ_in;
  output [15:0] sd_DQ_out;
  output [15:0] sd_DQ_en;
  output [31:0] sd_rfifo_DQ_out;
  input [31:0] sd_wfifo_DQ_in;
  input sdram_clk, sdram_rst_n, risc_OUT_VALID, risc_STACK_FULL,
         risc_EndOfInstrn, risc_Rd_Instr, sd_wfifo_empty, sd_rfifo_full;
  output sd_CK, sd_CKn, sd_LD, sd_RW, sd_wfifo_pop, sd_rfifo_push;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N223, N224, N225, N226, N227, N228, N229, N230, N231,
         N232, N233, N234, N235, N236, N237, N238, N239, N240, N241, N242,
         N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253,
         N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264,
         N265, N266, N267, N268, N269, N270, N271, N272, N273, N274, N275,
         N276, N277, N278, N279, N280, N281, N282, N283, N284, N285, N286,
         N287, N288, N289, N290, N291, N292, N293, N294, N295, N296, N297,
         N298, N299, N300, N301, N302, N303, N304, N305, N306, N307, N308,
         N309, N310, N311, N312, N313, N314, N315, N316, N317, N318, N319,
         N320, N321, N322, N323, N324, N325, N326, N327, N328, N329, N330,
         N331, N332, N333, N334, N335, N336, N337, N338, N339, N340, N341,
         N342, N343, N344, N345, N346, N347, N348, N349, N350, N351, N352,
         N353, N354, N355, N356, N357, N358, N359, N360, N361, N362, N363,
         N364, N365, N366, N367, N368, N369, N370, N371, N372, N373, N374,
         N375, N376, N377, N378, N379, N380, N381, N382, N383, N384, N385,
         N386, N387, N388, N389, N390, N391, N392, N393, N394, N395, N396,
         N397, N398, N399, N400, N401, N402, N403, N404, N405, N406, N407,
         N408, N409, N410, N411, N412, N413, N414, N415, N416, N417, N418,
         N419, N420, N421, N422, N423, N424, N425, N426, N427, N428, N429,
         N430, N431, N432, N433, N434, N435, N436, N437, N438, N439, N440,
         N441, N442, N443, N444, N445, N446, N447, N448, N449, N450, N451,
         N452, N453, N454, N455, N456, N457, N458, N459, N460, N461, N462,
         N463, N464, N465, N466, N467, N468, N469, N470, N471, N472, N473,
         N474, N475, N476, N477, N478, N479, N480, N481, N482, N483, N484,
         N485, N486, N487, N488, N489, N490, N491, N492, N493, N494, N495,
         N496, N497, N498, N499, N500, N501, N502, N503, N504, N505, N506,
         N507, N508, N509, N510, N511, N512, N513, N514, N515, N516, N517,
         N518, N519, N520, N521, N522, N523, N524, N525, N526, N527, N528,
         N529, N530, N531, N532, N533, N534, N535, N536, N537, N538, N539,
         N540, N541, N542, N543, N544, N545, N546, N547, N548, N549, N550,
         N551, N552, N553, N554, N555, N556, N557, N558, N559, N560, N561,
         N562, N563, N564, N565, N566, N567, N568, N569, N570, N571, N572,
         N573, N574, N575, N576, N577, N578, N579, N580, N581, N582, N583,
         N584, N585, N586, N587, N588, N589, N590, N591, N592, N593, N594,
         N595, N596, N597, N598, N599, N600, N601, N602, N603, N604, N605,
         N606, N607, N608, N609, N610, N611, N612, N613, N614, N615, N616,
         N617, N618, N619, N620, N621, N622, N623, N624, N625, N626, N627,
         N628, N629, N630, N631, N632, N633, N634, N635, N636, N637, N638,
         N639, N640, N641, N642, N643, N644, N645, N646, N647, N648, N649,
         N650, N651, N652, N653, N654, N655, N656, N657, N658, N659, N660,
         N661, N662, N663, N664, N665, N666, N667, N668, N669, N670, N671,
         N672, N673, N674, N675, N676, N677, N678, N679, N680, N681, N682,
         N683, N684, N685, N686, N687, N688, N689, N690, N691, N692, N693,
         N694, N695, N696, N697, N698, N699, N700, N701, N702, N703, N704,
         N705, N706, N707, N708, N709, N710, N711, N712, N713, N714, N715,
         N716, N717, N718, N719, N720, N721, N722, N723, N724, N725, N726,
         N727, N728, N729, N730, N731, N732, N733, N734, N735, N736, N737,
         N738, N739, N740, N741, N742, N743, N744, N745, N746, N747, N748,
         N749, N750, N751, N752, N753, N754, N755, N756, N757, N758, N759,
         N760;
  wire   [15:0] c_out_control;
  wire   [14:0] control_bus;
  wire   [14:0] sync_control_bus;
  wire   [31:0] mega_shift_0;
  wire   [15:0] DQ_out_0;
  wire   [31:0] mega_shift_1;
  wire   [15:0] DQ_out_1;

  \**SEQGEN**  sd_DQ_en_reg_15_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_14_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_13_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_12_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_11_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_10_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_9_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[9]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_8_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[8]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_7_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_6_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_5_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_4_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_3_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_2_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_1_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  sd_DQ_en_reg_0_ ( .clear(N760), .preset(1'b0), .next_state(N7), 
        .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(sd_DQ_en[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[14]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(control_bus[14]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[13]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(control_bus[13]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[12]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(control_bus[12]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[11]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(control_bus[11]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[10]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(control_bus[10]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[9]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[8]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[7]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[6]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[5]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[4]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[3]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[2]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[1]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  control_bus_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sync_control_bus[0]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(control_bus[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[10]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[14]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[9]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[13]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[8]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[12]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[7]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[6]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[5]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[9]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[4]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[8]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[3]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[7]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[2]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[6]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[1]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[5]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_PSW[0]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[4]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_OUT_VALID), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[3]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_STACK_FULL), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[2]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_EndOfInstrn), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[1]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  sync_control_bus_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(risc_Rd_Instr), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(sync_control_bus[0]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_15_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[15]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_rfifo_push), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_14_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[14]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_wfifo_pop), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_13_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[13]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_BWS[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_12_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[12]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_BWS[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_11_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[11]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_RW), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_10_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[10]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_LD), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_9_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[9]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_8_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[8]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_7_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[7]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_6_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[6]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_5_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[5]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_4_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[4]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_3_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[3]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_2_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[2]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_1_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[1]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  out_control_reg_0_ ( .clear(N760), .preset(1'b0), .next_state(
        c_out_control[0]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(sd_A[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_OR2 C112 ( .A(control_bus[14]), .B(N8), .Z(N15) );
  GTECH_OR2 C113 ( .A(control_bus[12]), .B(N9), .Z(N16) );
  GTECH_OR2 C114 ( .A(control_bus[10]), .B(N10), .Z(N17) );
  GTECH_OR2 C115 ( .A(control_bus[8]), .B(N11), .Z(N18) );
  GTECH_OR2 C116 ( .A(control_bus[6]), .B(N12), .Z(N19) );
  GTECH_OR2 C117 ( .A(control_bus[4]), .B(N13), .Z(N20) );
  GTECH_OR2 C118 ( .A(control_bus[2]), .B(N14), .Z(N21) );
  GTECH_OR2 C119 ( .A(control_bus[0]), .B(N126), .Z(N22) );
  GTECH_OR2 C120 ( .A(N15), .B(N16), .Z(N23) );
  GTECH_OR2 C121 ( .A(N17), .B(N18), .Z(N24) );
  GTECH_OR2 C122 ( .A(N19), .B(N20), .Z(N25) );
  GTECH_OR2 C123 ( .A(N21), .B(N22), .Z(N26) );
  GTECH_OR2 C124 ( .A(N23), .B(N24), .Z(N27) );
  GTECH_OR2 C125 ( .A(N25), .B(N26), .Z(N28) );
  GTECH_OR2 C126 ( .A(N27), .B(N28), .Z(N29) );
  GTECH_OR2 C127 ( .A(N29), .B(sd_wfifo_empty), .Z(N30) );
  GTECH_OR2 C138 ( .A(N32), .B(control_bus[13]), .Z(N40) );
  GTECH_OR2 C139 ( .A(N33), .B(control_bus[11]), .Z(N41) );
  GTECH_OR2 C140 ( .A(N34), .B(control_bus[9]), .Z(N42) );
  GTECH_OR2 C141 ( .A(N35), .B(control_bus[7]), .Z(N43) );
  GTECH_OR2 C142 ( .A(N36), .B(control_bus[5]), .Z(N44) );
  GTECH_OR2 C143 ( .A(N37), .B(control_bus[3]), .Z(N45) );
  GTECH_OR2 C144 ( .A(N38), .B(control_bus[1]), .Z(N46) );
  GTECH_OR2 C145 ( .A(N39), .B(sd_rfifo_full), .Z(N47) );
  GTECH_OR2 C146 ( .A(N40), .B(N41), .Z(N48) );
  GTECH_OR2 C147 ( .A(N42), .B(N43), .Z(N49) );
  GTECH_OR2 C148 ( .A(N44), .B(N45), .Z(N50) );
  GTECH_OR2 C149 ( .A(N46), .B(N47), .Z(N51) );
  GTECH_OR2 C150 ( .A(N48), .B(N49), .Z(N52) );
  GTECH_OR2 C151 ( .A(N50), .B(N51), .Z(N53) );
  GTECH_OR2 C152 ( .A(N52), .B(N53), .Z(N54) );
  GTECH_OR2 C153 ( .A(N54), .B(N108), .Z(N55) );
  GTECH_OR2 C166 ( .A(control_bus[14]), .B(N8), .Z(N57) );
  GTECH_OR2 C167 ( .A(N33), .B(control_bus[11]), .Z(N58) );
  GTECH_OR2 C168 ( .A(N34), .B(N10), .Z(N59) );
  GTECH_OR2 C169 ( .A(control_bus[8]), .B(N11), .Z(N60) );
  GTECH_OR2 C170 ( .A(N36), .B(control_bus[5]), .Z(N61) );
  GTECH_OR2 C171 ( .A(N37), .B(N13), .Z(N62) );
  GTECH_OR2 C172 ( .A(control_bus[2]), .B(N14), .Z(N63) );
  GTECH_OR2 C173 ( .A(N39), .B(sd_rfifo_full), .Z(N64) );
  GTECH_OR2 C174 ( .A(N57), .B(N58), .Z(N65) );
  GTECH_OR2 C175 ( .A(N59), .B(N60), .Z(N66) );
  GTECH_OR2 C176 ( .A(N61), .B(N62), .Z(N67) );
  GTECH_OR2 C177 ( .A(N63), .B(N64), .Z(N68) );
  GTECH_OR2 C178 ( .A(N65), .B(N66), .Z(N69) );
  GTECH_OR2 C179 ( .A(N67), .B(N68), .Z(N70) );
  GTECH_OR2 C180 ( .A(N69), .B(N70), .Z(N71) );
  GTECH_OR2 C181 ( .A(N71), .B(N108), .Z(N72) );
  GTECH_OR2 C189 ( .A(N32), .B(control_bus[13]), .Z(N74) );
  GTECH_OR2 C190 ( .A(control_bus[12]), .B(N9), .Z(N75) );
  GTECH_OR2 C191 ( .A(control_bus[10]), .B(control_bus[9]), .Z(N76) );
  GTECH_OR2 C192 ( .A(N35), .B(control_bus[7]), .Z(N77) );
  GTECH_OR2 C193 ( .A(control_bus[6]), .B(N12), .Z(N78) );
  GTECH_OR2 C194 ( .A(control_bus[4]), .B(control_bus[3]), .Z(N79) );
  GTECH_OR2 C195 ( .A(N38), .B(control_bus[1]), .Z(N80) );
  GTECH_OR2 C196 ( .A(control_bus[0]), .B(N126), .Z(N81) );
  GTECH_OR2 C197 ( .A(N74), .B(N75), .Z(N82) );
  GTECH_OR2 C198 ( .A(N76), .B(N77), .Z(N83) );
  GTECH_OR2 C199 ( .A(N78), .B(N79), .Z(N84) );
  GTECH_OR2 C200 ( .A(N80), .B(N81), .Z(N85) );
  GTECH_OR2 C201 ( .A(N82), .B(N83), .Z(N86) );
  GTECH_OR2 C202 ( .A(N84), .B(N85), .Z(N87) );
  GTECH_OR2 C203 ( .A(N86), .B(N87), .Z(N88) );
  GTECH_OR2 C204 ( .A(N88), .B(sd_wfifo_empty), .Z(N89) );
  GTECH_OR2 C218 ( .A(N32), .B(N8), .Z(N91) );
  GTECH_OR2 C219 ( .A(control_bus[12]), .B(N9), .Z(N92) );
  GTECH_OR2 C220 ( .A(N34), .B(control_bus[9]), .Z(N93) );
  GTECH_OR2 C221 ( .A(N35), .B(N11), .Z(N94) );
  GTECH_OR2 C222 ( .A(control_bus[6]), .B(N12), .Z(N95) );
  GTECH_OR2 C223 ( .A(N37), .B(control_bus[3]), .Z(N96) );
  GTECH_OR2 C224 ( .A(N38), .B(N14), .Z(N97) );
  GTECH_OR2 C225 ( .A(control_bus[0]), .B(N126), .Z(N98) );
  GTECH_OR2 C226 ( .A(N91), .B(N92), .Z(N99) );
  GTECH_OR2 C227 ( .A(N93), .B(N94), .Z(N100) );
  GTECH_OR2 C228 ( .A(N95), .B(N96), .Z(N101) );
  GTECH_OR2 C229 ( .A(N97), .B(N98), .Z(N102) );
  GTECH_OR2 C230 ( .A(N99), .B(N100), .Z(N103) );
  GTECH_OR2 C231 ( .A(N101), .B(N102), .Z(N104) );
  GTECH_OR2 C232 ( .A(N103), .B(N104), .Z(N105) );
  GTECH_OR2 C233 ( .A(N105), .B(N108), .Z(N106) );
  GTECH_OR2 C244 ( .A(N32), .B(N8), .Z(N109) );
  GTECH_OR2 C245 ( .A(N33), .B(control_bus[11]), .Z(N110) );
  GTECH_OR2 C246 ( .A(N34), .B(control_bus[9]), .Z(N111) );
  GTECH_OR2 C247 ( .A(N35), .B(control_bus[7]), .Z(N112) );
  GTECH_OR2 C248 ( .A(control_bus[6]), .B(control_bus[5]), .Z(N113) );
  GTECH_OR2 C249 ( .A(N37), .B(N13), .Z(N114) );
  GTECH_OR2 C250 ( .A(control_bus[2]), .B(N14), .Z(N115) );
  GTECH_OR2 C251 ( .A(control_bus[0]), .B(sd_rfifo_full), .Z(N116) );
  GTECH_OR2 C252 ( .A(N109), .B(N110), .Z(N117) );
  GTECH_OR2 C253 ( .A(N111), .B(N112), .Z(N118) );
  GTECH_OR2 C254 ( .A(N113), .B(N114), .Z(N119) );
  GTECH_OR2 C255 ( .A(N115), .B(N116), .Z(N120) );
  GTECH_OR2 C256 ( .A(N117), .B(N118), .Z(N121) );
  GTECH_OR2 C257 ( .A(N119), .B(N120), .Z(N122) );
  GTECH_OR2 C258 ( .A(N121), .B(N122), .Z(N123) );
  GTECH_OR2 C259 ( .A(N123), .B(N108), .Z(N124) );
  GTECH_OR2 C269 ( .A(control_bus[14]), .B(N8), .Z(N127) );
  GTECH_OR2 C270 ( .A(control_bus[12]), .B(control_bus[11]), .Z(N128) );
  GTECH_OR2 C271 ( .A(N34), .B(control_bus[9]), .Z(N129) );
  GTECH_OR2 C272 ( .A(N35), .B(N11), .Z(N130) );
  GTECH_OR2 C273 ( .A(control_bus[6]), .B(N12), .Z(N131) );
  GTECH_OR2 C274 ( .A(control_bus[4]), .B(N13), .Z(N132) );
  GTECH_OR2 C275 ( .A(control_bus[2]), .B(control_bus[1]), .Z(N133) );
  GTECH_OR2 C276 ( .A(N39), .B(N126), .Z(N134) );
  GTECH_OR2 C277 ( .A(N127), .B(N128), .Z(N135) );
  GTECH_OR2 C278 ( .A(N129), .B(N130), .Z(N136) );
  GTECH_OR2 C279 ( .A(N131), .B(N132), .Z(N137) );
  GTECH_OR2 C280 ( .A(N133), .B(N134), .Z(N138) );
  GTECH_OR2 C281 ( .A(N135), .B(N136), .Z(N139) );
  GTECH_OR2 C282 ( .A(N137), .B(N138), .Z(N140) );
  GTECH_OR2 C283 ( .A(N139), .B(N140), .Z(N141) );
  GTECH_OR2 C284 ( .A(N141), .B(sd_wfifo_empty), .Z(N142) );
  \**SEQGEN**  DQ_in_0_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[15]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[14]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[13]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[12]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[11]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[10]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[9]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[8]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[7]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[6]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[5]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[4]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[3]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[2]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[1]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_0_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[0]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), 
        .Q(sd_rfifo_DQ_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[15]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[14]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[13]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[12]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[11]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[10]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[9]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[8]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[7]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[6]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[5]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[4]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[3]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[2]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[1]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_in_1_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        sd_DQ_in[0]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), .Q(
        sd_rfifo_DQ_out[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_15_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[31]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_14_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[30]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_13_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[29]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_12_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[28]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_11_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[27]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_10_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[26]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_9_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[25]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_8_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[24]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_7_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[23]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_6_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[22]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_5_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[21]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_4_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[20]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_3_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[19]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_2_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[18]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_1_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[17]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_0_reg_0_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_0[16]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(DQ_out_0[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__15_ ( .clear(N760), .preset(1'b0), 
        .next_state(N519), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__14_ ( .clear(N760), .preset(1'b0), 
        .next_state(N504), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__13_ ( .clear(N760), .preset(1'b0), 
        .next_state(N489), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__12_ ( .clear(N760), .preset(1'b0), 
        .next_state(N474), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__11_ ( .clear(N760), .preset(1'b0), 
        .next_state(N459), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__10_ ( .clear(N760), .preset(1'b0), 
        .next_state(N444), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__9_ ( .clear(N760), .preset(1'b0), 
        .next_state(N429), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__8_ ( .clear(N760), .preset(1'b0), 
        .next_state(N414), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__7_ ( .clear(N760), .preset(1'b0), 
        .next_state(N399), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__6_ ( .clear(N760), .preset(1'b0), 
        .next_state(N384), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__5_ ( .clear(N760), .preset(1'b0), 
        .next_state(N369), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__4_ ( .clear(N760), .preset(1'b0), 
        .next_state(N354), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__3_ ( .clear(N760), .preset(1'b0), 
        .next_state(N339), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__2_ ( .clear(N760), .preset(1'b0), 
        .next_state(N324), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__1_ ( .clear(N760), .preset(1'b0), 
        .next_state(N309), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_0__0_ ( .clear(N760), .preset(1'b0), 
        .next_state(N294), .clocked_on(sdram_clk), .data_in(1'b0), .enable(
        1'b0), .Q(mega_shift_0[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__15_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[15]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__14_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[14]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__13_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[13]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__12_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[12]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__11_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[11]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__10_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[10]), .clocked_on(sdram_clk), .data_in(1'b0), .enable(1'b0), .Q(mega_shift_0[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__9_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[9]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[9]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__8_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[8]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[8]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__7_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[7]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[7]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__6_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[6]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[6]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__5_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[5]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[5]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__4_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[4]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[4]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__3_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[3]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[3]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__2_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[2]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[2]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__1_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[1]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[1]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_0_reg_1__0_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[0]), .clocked_on(sdram_clk), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_0[0]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_15_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[31]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_14_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[30]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_13_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[29]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_12_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[28]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_11_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[27]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_10_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[26]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_9_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[25]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_8_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[24]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_7_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[23]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_6_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[22]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_5_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[21]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_4_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[20]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_3_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[19]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_2_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[18]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_1_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[17]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  DQ_out_1_reg_0_ ( .clear(N760), .preset(1'b0), .next_state(
        mega_shift_1[16]), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(DQ_out_1[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__15_ ( .clear(N760), .preset(1'b0), 
        .next_state(N759), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__14_ ( .clear(N760), .preset(1'b0), 
        .next_state(N744), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__13_ ( .clear(N760), .preset(1'b0), 
        .next_state(N729), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__12_ ( .clear(N760), .preset(1'b0), 
        .next_state(N714), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__11_ ( .clear(N760), .preset(1'b0), 
        .next_state(N699), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__10_ ( .clear(N760), .preset(1'b0), 
        .next_state(N684), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__9_ ( .clear(N760), .preset(1'b0), 
        .next_state(N669), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__8_ ( .clear(N760), .preset(1'b0), 
        .next_state(N654), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__7_ ( .clear(N760), .preset(1'b0), 
        .next_state(N639), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__6_ ( .clear(N760), .preset(1'b0), 
        .next_state(N624), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__5_ ( .clear(N760), .preset(1'b0), 
        .next_state(N609), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__4_ ( .clear(N760), .preset(1'b0), 
        .next_state(N594), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__3_ ( .clear(N760), .preset(1'b0), 
        .next_state(N579), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__2_ ( .clear(N760), .preset(1'b0), 
        .next_state(N564), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__1_ ( .clear(N760), .preset(1'b0), 
        .next_state(N549), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_0__0_ ( .clear(N760), .preset(1'b0), 
        .next_state(N534), .clocked_on(N279), .data_in(1'b0), .enable(1'b0), 
        .Q(mega_shift_1[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__15_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[31]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[15]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__14_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[30]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[14]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__13_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[29]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[13]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__12_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[28]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[12]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__11_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[27]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__10_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[26]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__9_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[25]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[9]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__8_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[24]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[8]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__7_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[23]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[7]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__6_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[22]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[6]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__5_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[21]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[5]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__4_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[20]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[4]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__3_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[19]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[3]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__2_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[18]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[2]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__1_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[17]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[1]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  mega_shift_1_reg_1__0_ ( .clear(N760), .preset(1'b0), 
        .next_state(sd_wfifo_DQ_in[16]), .clocked_on(N279), .data_in(1'b0), 
        .enable(1'b0), .Q(mega_shift_1[0]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  MUX21X2 sd_mux_dq_out_15 ( .A1(DQ_out_0[15]), .A2(DQ_out_1[15]), .S0(
        sdram_clk), .Y(sd_DQ_out[15]) );
  MUX21X2 sd_mux_dq_out_14 ( .A1(DQ_out_0[14]), .A2(DQ_out_1[14]), .S0(
        sdram_clk), .Y(sd_DQ_out[14]) );
  MUX21X2 sd_mux_dq_out_13 ( .A1(DQ_out_0[13]), .A2(DQ_out_1[13]), .S0(
        sdram_clk), .Y(sd_DQ_out[13]) );
  MUX21X2 sd_mux_dq_out_12 ( .A1(DQ_out_0[12]), .A2(DQ_out_1[12]), .S0(
        sdram_clk), .Y(sd_DQ_out[12]) );
  MUX21X2 sd_mux_dq_out_11 ( .A1(DQ_out_0[11]), .A2(DQ_out_1[11]), .S0(
        sdram_clk), .Y(sd_DQ_out[11]) );
  MUX21X2 sd_mux_dq_out_10 ( .A1(DQ_out_0[10]), .A2(DQ_out_1[10]), .S0(
        sdram_clk), .Y(sd_DQ_out[10]) );
  MUX21X2 sd_mux_dq_out_9 ( .A1(DQ_out_0[9]), .A2(DQ_out_1[9]), .S0(sdram_clk), 
        .Y(sd_DQ_out[9]) );
  MUX21X2 sd_mux_dq_out_8 ( .A1(DQ_out_0[8]), .A2(DQ_out_1[8]), .S0(sdram_clk), 
        .Y(sd_DQ_out[8]) );
  MUX21X2 sd_mux_dq_out_7 ( .A1(DQ_out_0[7]), .A2(DQ_out_1[7]), .S0(sdram_clk), 
        .Y(sd_DQ_out[7]) );
  MUX21X2 sd_mux_dq_out_6 ( .A1(DQ_out_0[6]), .A2(DQ_out_1[6]), .S0(sdram_clk), 
        .Y(sd_DQ_out[6]) );
  MUX21X2 sd_mux_dq_out_5 ( .A1(DQ_out_0[5]), .A2(DQ_out_1[5]), .S0(sdram_clk), 
        .Y(sd_DQ_out[5]) );
  MUX21X2 sd_mux_dq_out_4 ( .A1(DQ_out_0[4]), .A2(DQ_out_1[4]), .S0(sdram_clk), 
        .Y(sd_DQ_out[4]) );
  MUX21X2 sd_mux_dq_out_3 ( .A1(DQ_out_0[3]), .A2(DQ_out_1[3]), .S0(sdram_clk), 
        .Y(sd_DQ_out[3]) );
  MUX21X2 sd_mux_dq_out_2 ( .A1(DQ_out_0[2]), .A2(DQ_out_1[2]), .S0(sdram_clk), 
        .Y(sd_DQ_out[2]) );
  MUX21X2 sd_mux_dq_out_1 ( .A1(DQ_out_0[1]), .A2(DQ_out_1[1]), .S0(sdram_clk), 
        .Y(sd_DQ_out[1]) );
  MUX21X2 sd_mux_dq_out_0 ( .A1(DQ_out_0[0]), .A2(DQ_out_1[0]), .S0(sdram_clk), 
        .Y(sd_DQ_out[0]) );
  MUX21X2 sd_mux_CK ( .A1(1'b0), .A2(1'b1), .S0(sdram_clk), .Y(sd_CK) );
  MUX21X2 sd_mux_CKn ( .A1(1'b0), .A2(1'b1), .S0(sdram_clk), .Y(sd_CKn) );
  GTECH_NOT I_0 ( .A(sdram_rst_n), .Z(N760) );
  ADD_TC_OP add_173 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 
        1'b0, 1'b0, 1'b1, 1'b0}), .Z({N262, N261, N260, N259, N258, N257, N256, 
        N255, N254, N253, N252, N251, N250, N249, N248, N247}) );
  ADD_TC_OP add_165 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 
        1'b1, 1'b1, 1'b0, 1'b1, 1'b1}), .Z({N198, N197, N196, N195, N194, N193, 
        N192, N191, N190, N189, N188, N187, N186, N185, N184, N183}) );
  ADD_TC_OP add_171 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 
        1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1}), .Z({N246, N245, N244, N243, N242, 
        N241, N240, N239, N238, N237, N236, N235, N234, N233, N232, N231}) );
  ADD_TC_OP add_163 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 
        1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .Z({N182, N181, N180, N179, N178, 
        N177, N176, N175, N174, N173, N172, N171, N170, N169, N168, N167}) );
  ADD_TC_OP add_161 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 
        1'b1}), .Z({N166, N165, N164, N163, N162, N161, N160, N159, N158, N157, 
        N156, N155, N154, N153, N152, N151}) );
  ADD_TC_OP add_167 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 
        1'b0, 1'b1, 1'b0, 1'b1}), .Z({N214, N213, N212, N211, N210, N209, N208, 
        N207, N206, N205, N204, N203, N202, N201, N200, N199}) );
  ADD_TC_OP add_169 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0}), .Z({N230, N229, N228, N227, N226, 
        N225, N224, N223, N222, N221, N220, N219, N218, N217, N216, N215}) );
  ADD_TC_OP add_175 ( .A({control_bus[12:0], sd_rfifo_full, sd_wfifo_empty, 
        1'b1}), .B({1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 
        1'b0, 1'b1, 1'b0}), .Z({N278, N277, N276, N275, N274, N273, N272, N271, 
        N270, N269, N268, N267, N266, N265, N264, N263}) );
  GTECH_NOT I_1 ( .A(c_out_control[0]), .Z(N7) );
  SELECT_OP C1016 ( .DATA1({N166, N165, N164, N163, N162, N161, N160, N159, 
        N158, N157, N156, N155, N154, N153, N152, N151}), .DATA2({N182, N181, 
        N180, N179, N178, N177, N176, N175, N174, N173, N172, N171, N170, N169, 
        N168, N167}), .DATA3({N198, N197, N196, N195, N194, N193, N192, N191, 
        N190, N189, N188, N187, N186, N185, N184, N183}), .DATA4({N214, N213, 
        N212, N211, N210, N209, N208, N207, N206, N205, N204, N203, N202, N201, 
        N200, N199}), .DATA5({N230, N229, N228, N227, N226, N225, N224, N223, 
        N222, N221, N220, N219, N218, N217, N216, N215}), .DATA6({N246, N245, 
        N244, N243, N242, N241, N240, N239, N238, N237, N236, N235, N234, N233, 
        N232, N231}), .DATA7({N262, N261, N260, N259, N258, N257, N256, N255, 
        N254, N253, N252, N251, N250, N249, N248, N247}), .DATA8({N278, N277, 
        N276, N275, N274, N273, N272, N271, N270, N269, N268, N267, N266, N265, 
        N264, N263}), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .CONTROL4(
        N3), .CONTROL5(N4), .CONTROL6(N5), .CONTROL7(N6), .CONTROL8(N150), .Z(
        c_out_control) );
  GTECH_BUF B_0 ( .A(N31), .Z(N0) );
  GTECH_BUF B_1 ( .A(N56), .Z(N1) );
  GTECH_BUF B_2 ( .A(N73), .Z(N2) );
  GTECH_BUF B_3 ( .A(N90), .Z(N3) );
  GTECH_BUF B_4 ( .A(N107), .Z(N4) );
  GTECH_BUF B_5 ( .A(N125), .Z(N5) );
  GTECH_BUF B_6 ( .A(N143), .Z(N6) );
  GTECH_NOT I_2 ( .A(control_bus[13]), .Z(N8) );
  GTECH_NOT I_3 ( .A(control_bus[11]), .Z(N9) );
  GTECH_NOT I_4 ( .A(control_bus[9]), .Z(N10) );
  GTECH_NOT I_5 ( .A(control_bus[7]), .Z(N11) );
  GTECH_NOT I_6 ( .A(control_bus[5]), .Z(N12) );
  GTECH_NOT I_7 ( .A(control_bus[3]), .Z(N13) );
  GTECH_NOT I_8 ( .A(control_bus[1]), .Z(N14) );
  GTECH_NOT I_9 ( .A(N30), .Z(N31) );
  GTECH_NOT I_10 ( .A(control_bus[14]), .Z(N32) );
  GTECH_NOT I_11 ( .A(control_bus[12]), .Z(N33) );
  GTECH_NOT I_12 ( .A(control_bus[10]), .Z(N34) );
  GTECH_NOT I_13 ( .A(control_bus[8]), .Z(N35) );
  GTECH_NOT I_14 ( .A(control_bus[6]), .Z(N36) );
  GTECH_NOT I_15 ( .A(control_bus[4]), .Z(N37) );
  GTECH_NOT I_16 ( .A(control_bus[2]), .Z(N38) );
  GTECH_NOT I_17 ( .A(control_bus[0]), .Z(N39) );
  GTECH_NOT I_18 ( .A(N55), .Z(N56) );
  GTECH_NOT I_19 ( .A(N72), .Z(N73) );
  GTECH_NOT I_20 ( .A(N89), .Z(N90) );
  GTECH_NOT I_21 ( .A(N106), .Z(N107) );
  GTECH_NOT I_22 ( .A(sd_wfifo_empty), .Z(N108) );
  GTECH_NOT I_23 ( .A(N124), .Z(N125) );
  GTECH_NOT I_24 ( .A(sd_rfifo_full), .Z(N126) );
  GTECH_NOT I_25 ( .A(N142), .Z(N143) );
  GTECH_OR2 C1091 ( .A(N56), .B(N31), .Z(N144) );
  GTECH_OR2 C1092 ( .A(N73), .B(N144), .Z(N145) );
  GTECH_OR2 C1093 ( .A(N90), .B(N145), .Z(N146) );
  GTECH_OR2 C1094 ( .A(N107), .B(N146), .Z(N147) );
  GTECH_OR2 C1095 ( .A(N125), .B(N147), .Z(N148) );
  GTECH_OR2 C1096 ( .A(N143), .B(N148), .Z(N149) );
  GTECH_NOT I_26 ( .A(N149), .Z(N150) );
  GTECH_BUF B_7 ( .A(N31) );
  GTECH_BUF B_8 ( .A(N56) );
  GTECH_BUF B_9 ( .A(N73) );
  GTECH_BUF B_10 ( .A(N90) );
  GTECH_BUF B_11 ( .A(N107) );
  GTECH_BUF B_12 ( .A(N125) );
  GTECH_BUF B_13 ( .A(N143) );
  GTECH_BUF B_14 ( .A(N150) );
  GTECH_NOT I_27 ( .A(sdram_clk), .Z(N279) );
  GTECH_XOR2 C1107 ( .A(mega_shift_0[1]), .B(mega_shift_0[0]), .Z(N280) );
  GTECH_XOR2 C1108 ( .A(mega_shift_0[2]), .B(N280), .Z(N281) );
  GTECH_XOR2 C1109 ( .A(mega_shift_0[3]), .B(N281), .Z(N282) );
  GTECH_XOR2 C1110 ( .A(mega_shift_0[4]), .B(N282), .Z(N283) );
  GTECH_XOR2 C1111 ( .A(mega_shift_0[5]), .B(N283), .Z(N284) );
  GTECH_XOR2 C1112 ( .A(mega_shift_0[6]), .B(N284), .Z(N285) );
  GTECH_XOR2 C1113 ( .A(mega_shift_0[7]), .B(N285), .Z(N286) );
  GTECH_XOR2 C1114 ( .A(mega_shift_0[8]), .B(N286), .Z(N287) );
  GTECH_XOR2 C1115 ( .A(mega_shift_0[9]), .B(N287), .Z(N288) );
  GTECH_XOR2 C1116 ( .A(mega_shift_0[10]), .B(N288), .Z(N289) );
  GTECH_XOR2 C1117 ( .A(mega_shift_0[11]), .B(N289), .Z(N290) );
  GTECH_XOR2 C1118 ( .A(mega_shift_0[12]), .B(N290), .Z(N291) );
  GTECH_XOR2 C1119 ( .A(mega_shift_0[13]), .B(N291), .Z(N292) );
  GTECH_XOR2 C1120 ( .A(mega_shift_0[14]), .B(N292), .Z(N293) );
  GTECH_XOR2 C1121 ( .A(mega_shift_0[15]), .B(N293), .Z(N294) );
  GTECH_XOR2 C1122 ( .A(mega_shift_0[0]), .B(mega_shift_0[15]), .Z(N295) );
  GTECH_XOR2 C1123 ( .A(mega_shift_0[1]), .B(N295), .Z(N296) );
  GTECH_XOR2 C1124 ( .A(mega_shift_0[2]), .B(N296), .Z(N297) );
  GTECH_XOR2 C1125 ( .A(mega_shift_0[3]), .B(N297), .Z(N298) );
  GTECH_XOR2 C1126 ( .A(mega_shift_0[4]), .B(N298), .Z(N299) );
  GTECH_XOR2 C1127 ( .A(mega_shift_0[5]), .B(N299), .Z(N300) );
  GTECH_XOR2 C1128 ( .A(mega_shift_0[6]), .B(N300), .Z(N301) );
  GTECH_XOR2 C1129 ( .A(mega_shift_0[7]), .B(N301), .Z(N302) );
  GTECH_XOR2 C1130 ( .A(mega_shift_0[8]), .B(N302), .Z(N303) );
  GTECH_XOR2 C1131 ( .A(mega_shift_0[9]), .B(N303), .Z(N304) );
  GTECH_XOR2 C1132 ( .A(mega_shift_0[10]), .B(N304), .Z(N305) );
  GTECH_XOR2 C1133 ( .A(mega_shift_0[11]), .B(N305), .Z(N306) );
  GTECH_XOR2 C1134 ( .A(mega_shift_0[12]), .B(N306), .Z(N307) );
  GTECH_XOR2 C1135 ( .A(mega_shift_0[13]), .B(N307), .Z(N308) );
  GTECH_XOR2 C1136 ( .A(mega_shift_0[14]), .B(N308), .Z(N309) );
  GTECH_XOR2 C1137 ( .A(mega_shift_0[15]), .B(mega_shift_0[14]), .Z(N310) );
  GTECH_XOR2 C1138 ( .A(mega_shift_0[0]), .B(N310), .Z(N311) );
  GTECH_XOR2 C1139 ( .A(mega_shift_0[1]), .B(N311), .Z(N312) );
  GTECH_XOR2 C1140 ( .A(mega_shift_0[2]), .B(N312), .Z(N313) );
  GTECH_XOR2 C1141 ( .A(mega_shift_0[3]), .B(N313), .Z(N314) );
  GTECH_XOR2 C1142 ( .A(mega_shift_0[4]), .B(N314), .Z(N315) );
  GTECH_XOR2 C1143 ( .A(mega_shift_0[5]), .B(N315), .Z(N316) );
  GTECH_XOR2 C1144 ( .A(mega_shift_0[6]), .B(N316), .Z(N317) );
  GTECH_XOR2 C1145 ( .A(mega_shift_0[7]), .B(N317), .Z(N318) );
  GTECH_XOR2 C1146 ( .A(mega_shift_0[8]), .B(N318), .Z(N319) );
  GTECH_XOR2 C1147 ( .A(mega_shift_0[9]), .B(N319), .Z(N320) );
  GTECH_XOR2 C1148 ( .A(mega_shift_0[10]), .B(N320), .Z(N321) );
  GTECH_XOR2 C1149 ( .A(mega_shift_0[11]), .B(N321), .Z(N322) );
  GTECH_XOR2 C1150 ( .A(mega_shift_0[12]), .B(N322), .Z(N323) );
  GTECH_XOR2 C1151 ( .A(mega_shift_0[13]), .B(N323), .Z(N324) );
  GTECH_XOR2 C1152 ( .A(mega_shift_0[14]), .B(mega_shift_0[13]), .Z(N325) );
  GTECH_XOR2 C1153 ( .A(mega_shift_0[15]), .B(N325), .Z(N326) );
  GTECH_XOR2 C1154 ( .A(mega_shift_0[0]), .B(N326), .Z(N327) );
  GTECH_XOR2 C1155 ( .A(mega_shift_0[1]), .B(N327), .Z(N328) );
  GTECH_XOR2 C1156 ( .A(mega_shift_0[2]), .B(N328), .Z(N329) );
  GTECH_XOR2 C1157 ( .A(mega_shift_0[3]), .B(N329), .Z(N330) );
  GTECH_XOR2 C1158 ( .A(mega_shift_0[4]), .B(N330), .Z(N331) );
  GTECH_XOR2 C1159 ( .A(mega_shift_0[5]), .B(N331), .Z(N332) );
  GTECH_XOR2 C1160 ( .A(mega_shift_0[6]), .B(N332), .Z(N333) );
  GTECH_XOR2 C1161 ( .A(mega_shift_0[7]), .B(N333), .Z(N334) );
  GTECH_XOR2 C1162 ( .A(mega_shift_0[8]), .B(N334), .Z(N335) );
  GTECH_XOR2 C1163 ( .A(mega_shift_0[9]), .B(N335), .Z(N336) );
  GTECH_XOR2 C1164 ( .A(mega_shift_0[10]), .B(N336), .Z(N337) );
  GTECH_XOR2 C1165 ( .A(mega_shift_0[11]), .B(N337), .Z(N338) );
  GTECH_XOR2 C1166 ( .A(mega_shift_0[12]), .B(N338), .Z(N339) );
  GTECH_XOR2 C1167 ( .A(mega_shift_0[13]), .B(mega_shift_0[12]), .Z(N340) );
  GTECH_XOR2 C1168 ( .A(mega_shift_0[14]), .B(N340), .Z(N341) );
  GTECH_XOR2 C1169 ( .A(mega_shift_0[15]), .B(N341), .Z(N342) );
  GTECH_XOR2 C1170 ( .A(mega_shift_0[0]), .B(N342), .Z(N343) );
  GTECH_XOR2 C1171 ( .A(mega_shift_0[1]), .B(N343), .Z(N344) );
  GTECH_XOR2 C1172 ( .A(mega_shift_0[2]), .B(N344), .Z(N345) );
  GTECH_XOR2 C1173 ( .A(mega_shift_0[3]), .B(N345), .Z(N346) );
  GTECH_XOR2 C1174 ( .A(mega_shift_0[4]), .B(N346), .Z(N347) );
  GTECH_XOR2 C1175 ( .A(mega_shift_0[5]), .B(N347), .Z(N348) );
  GTECH_XOR2 C1176 ( .A(mega_shift_0[6]), .B(N348), .Z(N349) );
  GTECH_XOR2 C1177 ( .A(mega_shift_0[7]), .B(N349), .Z(N350) );
  GTECH_XOR2 C1178 ( .A(mega_shift_0[8]), .B(N350), .Z(N351) );
  GTECH_XOR2 C1179 ( .A(mega_shift_0[9]), .B(N351), .Z(N352) );
  GTECH_XOR2 C1180 ( .A(mega_shift_0[10]), .B(N352), .Z(N353) );
  GTECH_XOR2 C1181 ( .A(mega_shift_0[11]), .B(N353), .Z(N354) );
  GTECH_XOR2 C1182 ( .A(mega_shift_0[12]), .B(mega_shift_0[11]), .Z(N355) );
  GTECH_XOR2 C1183 ( .A(mega_shift_0[13]), .B(N355), .Z(N356) );
  GTECH_XOR2 C1184 ( .A(mega_shift_0[14]), .B(N356), .Z(N357) );
  GTECH_XOR2 C1185 ( .A(mega_shift_0[15]), .B(N357), .Z(N358) );
  GTECH_XOR2 C1186 ( .A(mega_shift_0[0]), .B(N358), .Z(N359) );
  GTECH_XOR2 C1187 ( .A(mega_shift_0[1]), .B(N359), .Z(N360) );
  GTECH_XOR2 C1188 ( .A(mega_shift_0[2]), .B(N360), .Z(N361) );
  GTECH_XOR2 C1189 ( .A(mega_shift_0[3]), .B(N361), .Z(N362) );
  GTECH_XOR2 C1190 ( .A(mega_shift_0[4]), .B(N362), .Z(N363) );
  GTECH_XOR2 C1191 ( .A(mega_shift_0[5]), .B(N363), .Z(N364) );
  GTECH_XOR2 C1192 ( .A(mega_shift_0[6]), .B(N364), .Z(N365) );
  GTECH_XOR2 C1193 ( .A(mega_shift_0[7]), .B(N365), .Z(N366) );
  GTECH_XOR2 C1194 ( .A(mega_shift_0[8]), .B(N366), .Z(N367) );
  GTECH_XOR2 C1195 ( .A(mega_shift_0[9]), .B(N367), .Z(N368) );
  GTECH_XOR2 C1196 ( .A(mega_shift_0[10]), .B(N368), .Z(N369) );
  GTECH_XOR2 C1197 ( .A(mega_shift_0[11]), .B(mega_shift_0[10]), .Z(N370) );
  GTECH_XOR2 C1198 ( .A(mega_shift_0[12]), .B(N370), .Z(N371) );
  GTECH_XOR2 C1199 ( .A(mega_shift_0[13]), .B(N371), .Z(N372) );
  GTECH_XOR2 C1200 ( .A(mega_shift_0[14]), .B(N372), .Z(N373) );
  GTECH_XOR2 C1201 ( .A(mega_shift_0[15]), .B(N373), .Z(N374) );
  GTECH_XOR2 C1202 ( .A(mega_shift_0[0]), .B(N374), .Z(N375) );
  GTECH_XOR2 C1203 ( .A(mega_shift_0[1]), .B(N375), .Z(N376) );
  GTECH_XOR2 C1204 ( .A(mega_shift_0[2]), .B(N376), .Z(N377) );
  GTECH_XOR2 C1205 ( .A(mega_shift_0[3]), .B(N377), .Z(N378) );
  GTECH_XOR2 C1206 ( .A(mega_shift_0[4]), .B(N378), .Z(N379) );
  GTECH_XOR2 C1207 ( .A(mega_shift_0[5]), .B(N379), .Z(N380) );
  GTECH_XOR2 C1208 ( .A(mega_shift_0[6]), .B(N380), .Z(N381) );
  GTECH_XOR2 C1209 ( .A(mega_shift_0[7]), .B(N381), .Z(N382) );
  GTECH_XOR2 C1210 ( .A(mega_shift_0[8]), .B(N382), .Z(N383) );
  GTECH_XOR2 C1211 ( .A(mega_shift_0[9]), .B(N383), .Z(N384) );
  GTECH_XOR2 C1212 ( .A(mega_shift_0[10]), .B(mega_shift_0[9]), .Z(N385) );
  GTECH_XOR2 C1213 ( .A(mega_shift_0[11]), .B(N385), .Z(N386) );
  GTECH_XOR2 C1214 ( .A(mega_shift_0[12]), .B(N386), .Z(N387) );
  GTECH_XOR2 C1215 ( .A(mega_shift_0[13]), .B(N387), .Z(N388) );
  GTECH_XOR2 C1216 ( .A(mega_shift_0[14]), .B(N388), .Z(N389) );
  GTECH_XOR2 C1217 ( .A(mega_shift_0[15]), .B(N389), .Z(N390) );
  GTECH_XOR2 C1218 ( .A(mega_shift_0[0]), .B(N390), .Z(N391) );
  GTECH_XOR2 C1219 ( .A(mega_shift_0[1]), .B(N391), .Z(N392) );
  GTECH_XOR2 C1220 ( .A(mega_shift_0[2]), .B(N392), .Z(N393) );
  GTECH_XOR2 C1221 ( .A(mega_shift_0[3]), .B(N393), .Z(N394) );
  GTECH_XOR2 C1222 ( .A(mega_shift_0[4]), .B(N394), .Z(N395) );
  GTECH_XOR2 C1223 ( .A(mega_shift_0[5]), .B(N395), .Z(N396) );
  GTECH_XOR2 C1224 ( .A(mega_shift_0[6]), .B(N396), .Z(N397) );
  GTECH_XOR2 C1225 ( .A(mega_shift_0[7]), .B(N397), .Z(N398) );
  GTECH_XOR2 C1226 ( .A(mega_shift_0[8]), .B(N398), .Z(N399) );
  GTECH_XOR2 C1227 ( .A(mega_shift_0[9]), .B(mega_shift_0[8]), .Z(N400) );
  GTECH_XOR2 C1228 ( .A(mega_shift_0[10]), .B(N400), .Z(N401) );
  GTECH_XOR2 C1229 ( .A(mega_shift_0[11]), .B(N401), .Z(N402) );
  GTECH_XOR2 C1230 ( .A(mega_shift_0[12]), .B(N402), .Z(N403) );
  GTECH_XOR2 C1231 ( .A(mega_shift_0[13]), .B(N403), .Z(N404) );
  GTECH_XOR2 C1232 ( .A(mega_shift_0[14]), .B(N404), .Z(N405) );
  GTECH_XOR2 C1233 ( .A(mega_shift_0[15]), .B(N405), .Z(N406) );
  GTECH_XOR2 C1234 ( .A(mega_shift_0[0]), .B(N406), .Z(N407) );
  GTECH_XOR2 C1235 ( .A(mega_shift_0[1]), .B(N407), .Z(N408) );
  GTECH_XOR2 C1236 ( .A(mega_shift_0[2]), .B(N408), .Z(N409) );
  GTECH_XOR2 C1237 ( .A(mega_shift_0[3]), .B(N409), .Z(N410) );
  GTECH_XOR2 C1238 ( .A(mega_shift_0[4]), .B(N410), .Z(N411) );
  GTECH_XOR2 C1239 ( .A(mega_shift_0[5]), .B(N411), .Z(N412) );
  GTECH_XOR2 C1240 ( .A(mega_shift_0[6]), .B(N412), .Z(N413) );
  GTECH_XOR2 C1241 ( .A(mega_shift_0[7]), .B(N413), .Z(N414) );
  GTECH_XOR2 C1242 ( .A(mega_shift_0[8]), .B(mega_shift_0[7]), .Z(N415) );
  GTECH_XOR2 C1243 ( .A(mega_shift_0[9]), .B(N415), .Z(N416) );
  GTECH_XOR2 C1244 ( .A(mega_shift_0[10]), .B(N416), .Z(N417) );
  GTECH_XOR2 C1245 ( .A(mega_shift_0[11]), .B(N417), .Z(N418) );
  GTECH_XOR2 C1246 ( .A(mega_shift_0[12]), .B(N418), .Z(N419) );
  GTECH_XOR2 C1247 ( .A(mega_shift_0[13]), .B(N419), .Z(N420) );
  GTECH_XOR2 C1248 ( .A(mega_shift_0[14]), .B(N420), .Z(N421) );
  GTECH_XOR2 C1249 ( .A(mega_shift_0[15]), .B(N421), .Z(N422) );
  GTECH_XOR2 C1250 ( .A(mega_shift_0[0]), .B(N422), .Z(N423) );
  GTECH_XOR2 C1251 ( .A(mega_shift_0[1]), .B(N423), .Z(N424) );
  GTECH_XOR2 C1252 ( .A(mega_shift_0[2]), .B(N424), .Z(N425) );
  GTECH_XOR2 C1253 ( .A(mega_shift_0[3]), .B(N425), .Z(N426) );
  GTECH_XOR2 C1254 ( .A(mega_shift_0[4]), .B(N426), .Z(N427) );
  GTECH_XOR2 C1255 ( .A(mega_shift_0[5]), .B(N427), .Z(N428) );
  GTECH_XOR2 C1256 ( .A(mega_shift_0[6]), .B(N428), .Z(N429) );
  GTECH_XOR2 C1257 ( .A(mega_shift_0[7]), .B(mega_shift_0[6]), .Z(N430) );
  GTECH_XOR2 C1258 ( .A(mega_shift_0[8]), .B(N430), .Z(N431) );
  GTECH_XOR2 C1259 ( .A(mega_shift_0[9]), .B(N431), .Z(N432) );
  GTECH_XOR2 C1260 ( .A(mega_shift_0[10]), .B(N432), .Z(N433) );
  GTECH_XOR2 C1261 ( .A(mega_shift_0[11]), .B(N433), .Z(N434) );
  GTECH_XOR2 C1262 ( .A(mega_shift_0[12]), .B(N434), .Z(N435) );
  GTECH_XOR2 C1263 ( .A(mega_shift_0[13]), .B(N435), .Z(N436) );
  GTECH_XOR2 C1264 ( .A(mega_shift_0[14]), .B(N436), .Z(N437) );
  GTECH_XOR2 C1265 ( .A(mega_shift_0[15]), .B(N437), .Z(N438) );
  GTECH_XOR2 C1266 ( .A(mega_shift_0[0]), .B(N438), .Z(N439) );
  GTECH_XOR2 C1267 ( .A(mega_shift_0[1]), .B(N439), .Z(N440) );
  GTECH_XOR2 C1268 ( .A(mega_shift_0[2]), .B(N440), .Z(N441) );
  GTECH_XOR2 C1269 ( .A(mega_shift_0[3]), .B(N441), .Z(N442) );
  GTECH_XOR2 C1270 ( .A(mega_shift_0[4]), .B(N442), .Z(N443) );
  GTECH_XOR2 C1271 ( .A(mega_shift_0[5]), .B(N443), .Z(N444) );
  GTECH_XOR2 C1272 ( .A(mega_shift_0[6]), .B(mega_shift_0[5]), .Z(N445) );
  GTECH_XOR2 C1273 ( .A(mega_shift_0[7]), .B(N445), .Z(N446) );
  GTECH_XOR2 C1274 ( .A(mega_shift_0[8]), .B(N446), .Z(N447) );
  GTECH_XOR2 C1275 ( .A(mega_shift_0[9]), .B(N447), .Z(N448) );
  GTECH_XOR2 C1276 ( .A(mega_shift_0[10]), .B(N448), .Z(N449) );
  GTECH_XOR2 C1277 ( .A(mega_shift_0[11]), .B(N449), .Z(N450) );
  GTECH_XOR2 C1278 ( .A(mega_shift_0[12]), .B(N450), .Z(N451) );
  GTECH_XOR2 C1279 ( .A(mega_shift_0[13]), .B(N451), .Z(N452) );
  GTECH_XOR2 C1280 ( .A(mega_shift_0[14]), .B(N452), .Z(N453) );
  GTECH_XOR2 C1281 ( .A(mega_shift_0[15]), .B(N453), .Z(N454) );
  GTECH_XOR2 C1282 ( .A(mega_shift_0[0]), .B(N454), .Z(N455) );
  GTECH_XOR2 C1283 ( .A(mega_shift_0[1]), .B(N455), .Z(N456) );
  GTECH_XOR2 C1284 ( .A(mega_shift_0[2]), .B(N456), .Z(N457) );
  GTECH_XOR2 C1285 ( .A(mega_shift_0[3]), .B(N457), .Z(N458) );
  GTECH_XOR2 C1286 ( .A(mega_shift_0[4]), .B(N458), .Z(N459) );
  GTECH_XOR2 C1287 ( .A(mega_shift_0[5]), .B(mega_shift_0[4]), .Z(N460) );
  GTECH_XOR2 C1288 ( .A(mega_shift_0[6]), .B(N460), .Z(N461) );
  GTECH_XOR2 C1289 ( .A(mega_shift_0[7]), .B(N461), .Z(N462) );
  GTECH_XOR2 C1290 ( .A(mega_shift_0[8]), .B(N462), .Z(N463) );
  GTECH_XOR2 C1291 ( .A(mega_shift_0[9]), .B(N463), .Z(N464) );
  GTECH_XOR2 C1292 ( .A(mega_shift_0[10]), .B(N464), .Z(N465) );
  GTECH_XOR2 C1293 ( .A(mega_shift_0[11]), .B(N465), .Z(N466) );
  GTECH_XOR2 C1294 ( .A(mega_shift_0[12]), .B(N466), .Z(N467) );
  GTECH_XOR2 C1295 ( .A(mega_shift_0[13]), .B(N467), .Z(N468) );
  GTECH_XOR2 C1296 ( .A(mega_shift_0[14]), .B(N468), .Z(N469) );
  GTECH_XOR2 C1297 ( .A(mega_shift_0[15]), .B(N469), .Z(N470) );
  GTECH_XOR2 C1298 ( .A(mega_shift_0[0]), .B(N470), .Z(N471) );
  GTECH_XOR2 C1299 ( .A(mega_shift_0[1]), .B(N471), .Z(N472) );
  GTECH_XOR2 C1300 ( .A(mega_shift_0[2]), .B(N472), .Z(N473) );
  GTECH_XOR2 C1301 ( .A(mega_shift_0[3]), .B(N473), .Z(N474) );
  GTECH_XOR2 C1302 ( .A(mega_shift_0[4]), .B(mega_shift_0[3]), .Z(N475) );
  GTECH_XOR2 C1303 ( .A(mega_shift_0[5]), .B(N475), .Z(N476) );
  GTECH_XOR2 C1304 ( .A(mega_shift_0[6]), .B(N476), .Z(N477) );
  GTECH_XOR2 C1305 ( .A(mega_shift_0[7]), .B(N477), .Z(N478) );
  GTECH_XOR2 C1306 ( .A(mega_shift_0[8]), .B(N478), .Z(N479) );
  GTECH_XOR2 C1307 ( .A(mega_shift_0[9]), .B(N479), .Z(N480) );
  GTECH_XOR2 C1308 ( .A(mega_shift_0[10]), .B(N480), .Z(N481) );
  GTECH_XOR2 C1309 ( .A(mega_shift_0[11]), .B(N481), .Z(N482) );
  GTECH_XOR2 C1310 ( .A(mega_shift_0[12]), .B(N482), .Z(N483) );
  GTECH_XOR2 C1311 ( .A(mega_shift_0[13]), .B(N483), .Z(N484) );
  GTECH_XOR2 C1312 ( .A(mega_shift_0[14]), .B(N484), .Z(N485) );
  GTECH_XOR2 C1313 ( .A(mega_shift_0[15]), .B(N485), .Z(N486) );
  GTECH_XOR2 C1314 ( .A(mega_shift_0[0]), .B(N486), .Z(N487) );
  GTECH_XOR2 C1315 ( .A(mega_shift_0[1]), .B(N487), .Z(N488) );
  GTECH_XOR2 C1316 ( .A(mega_shift_0[2]), .B(N488), .Z(N489) );
  GTECH_XOR2 C1317 ( .A(mega_shift_0[3]), .B(mega_shift_0[2]), .Z(N490) );
  GTECH_XOR2 C1318 ( .A(mega_shift_0[4]), .B(N490), .Z(N491) );
  GTECH_XOR2 C1319 ( .A(mega_shift_0[5]), .B(N491), .Z(N492) );
  GTECH_XOR2 C1320 ( .A(mega_shift_0[6]), .B(N492), .Z(N493) );
  GTECH_XOR2 C1321 ( .A(mega_shift_0[7]), .B(N493), .Z(N494) );
  GTECH_XOR2 C1322 ( .A(mega_shift_0[8]), .B(N494), .Z(N495) );
  GTECH_XOR2 C1323 ( .A(mega_shift_0[9]), .B(N495), .Z(N496) );
  GTECH_XOR2 C1324 ( .A(mega_shift_0[10]), .B(N496), .Z(N497) );
  GTECH_XOR2 C1325 ( .A(mega_shift_0[11]), .B(N497), .Z(N498) );
  GTECH_XOR2 C1326 ( .A(mega_shift_0[12]), .B(N498), .Z(N499) );
  GTECH_XOR2 C1327 ( .A(mega_shift_0[13]), .B(N499), .Z(N500) );
  GTECH_XOR2 C1328 ( .A(mega_shift_0[14]), .B(N500), .Z(N501) );
  GTECH_XOR2 C1329 ( .A(mega_shift_0[15]), .B(N501), .Z(N502) );
  GTECH_XOR2 C1330 ( .A(mega_shift_0[0]), .B(N502), .Z(N503) );
  GTECH_XOR2 C1331 ( .A(mega_shift_0[1]), .B(N503), .Z(N504) );
  GTECH_XOR2 C1332 ( .A(mega_shift_0[2]), .B(mega_shift_0[1]), .Z(N505) );
  GTECH_XOR2 C1333 ( .A(mega_shift_0[3]), .B(N505), .Z(N506) );
  GTECH_XOR2 C1334 ( .A(mega_shift_0[4]), .B(N506), .Z(N507) );
  GTECH_XOR2 C1335 ( .A(mega_shift_0[5]), .B(N507), .Z(N508) );
  GTECH_XOR2 C1336 ( .A(mega_shift_0[6]), .B(N508), .Z(N509) );
  GTECH_XOR2 C1337 ( .A(mega_shift_0[7]), .B(N509), .Z(N510) );
  GTECH_XOR2 C1338 ( .A(mega_shift_0[8]), .B(N510), .Z(N511) );
  GTECH_XOR2 C1339 ( .A(mega_shift_0[9]), .B(N511), .Z(N512) );
  GTECH_XOR2 C1340 ( .A(mega_shift_0[10]), .B(N512), .Z(N513) );
  GTECH_XOR2 C1341 ( .A(mega_shift_0[11]), .B(N513), .Z(N514) );
  GTECH_XOR2 C1342 ( .A(mega_shift_0[12]), .B(N514), .Z(N515) );
  GTECH_XOR2 C1343 ( .A(mega_shift_0[13]), .B(N515), .Z(N516) );
  GTECH_XOR2 C1344 ( .A(mega_shift_0[14]), .B(N516), .Z(N517) );
  GTECH_XOR2 C1345 ( .A(mega_shift_0[15]), .B(N517), .Z(N518) );
  GTECH_XOR2 C1346 ( .A(mega_shift_0[0]), .B(N518), .Z(N519) );
  GTECH_XOR2 C1347 ( .A(mega_shift_1[1]), .B(mega_shift_1[0]), .Z(N520) );
  GTECH_XOR2 C1348 ( .A(mega_shift_1[2]), .B(N520), .Z(N521) );
  GTECH_XOR2 C1349 ( .A(mega_shift_1[3]), .B(N521), .Z(N522) );
  GTECH_XOR2 C1350 ( .A(mega_shift_1[4]), .B(N522), .Z(N523) );
  GTECH_XOR2 C1351 ( .A(mega_shift_1[5]), .B(N523), .Z(N524) );
  GTECH_XOR2 C1352 ( .A(mega_shift_1[6]), .B(N524), .Z(N525) );
  GTECH_XOR2 C1353 ( .A(mega_shift_1[7]), .B(N525), .Z(N526) );
  GTECH_XOR2 C1354 ( .A(mega_shift_1[8]), .B(N526), .Z(N527) );
  GTECH_XOR2 C1355 ( .A(mega_shift_1[9]), .B(N527), .Z(N528) );
  GTECH_XOR2 C1356 ( .A(mega_shift_1[10]), .B(N528), .Z(N529) );
  GTECH_XOR2 C1357 ( .A(mega_shift_1[11]), .B(N529), .Z(N530) );
  GTECH_XOR2 C1358 ( .A(mega_shift_1[12]), .B(N530), .Z(N531) );
  GTECH_XOR2 C1359 ( .A(mega_shift_1[13]), .B(N531), .Z(N532) );
  GTECH_XOR2 C1360 ( .A(mega_shift_1[14]), .B(N532), .Z(N533) );
  GTECH_XOR2 C1361 ( .A(mega_shift_1[15]), .B(N533), .Z(N534) );
  GTECH_XOR2 C1362 ( .A(mega_shift_1[0]), .B(mega_shift_1[15]), .Z(N535) );
  GTECH_XOR2 C1363 ( .A(mega_shift_1[1]), .B(N535), .Z(N536) );
  GTECH_XOR2 C1364 ( .A(mega_shift_1[2]), .B(N536), .Z(N537) );
  GTECH_XOR2 C1365 ( .A(mega_shift_1[3]), .B(N537), .Z(N538) );
  GTECH_XOR2 C1366 ( .A(mega_shift_1[4]), .B(N538), .Z(N539) );
  GTECH_XOR2 C1367 ( .A(mega_shift_1[5]), .B(N539), .Z(N540) );
  GTECH_XOR2 C1368 ( .A(mega_shift_1[6]), .B(N540), .Z(N541) );
  GTECH_XOR2 C1369 ( .A(mega_shift_1[7]), .B(N541), .Z(N542) );
  GTECH_XOR2 C1370 ( .A(mega_shift_1[8]), .B(N542), .Z(N543) );
  GTECH_XOR2 C1371 ( .A(mega_shift_1[9]), .B(N543), .Z(N544) );
  GTECH_XOR2 C1372 ( .A(mega_shift_1[10]), .B(N544), .Z(N545) );
  GTECH_XOR2 C1373 ( .A(mega_shift_1[11]), .B(N545), .Z(N546) );
  GTECH_XOR2 C1374 ( .A(mega_shift_1[12]), .B(N546), .Z(N547) );
  GTECH_XOR2 C1375 ( .A(mega_shift_1[13]), .B(N547), .Z(N548) );
  GTECH_XOR2 C1376 ( .A(mega_shift_1[14]), .B(N548), .Z(N549) );
  GTECH_XOR2 C1377 ( .A(mega_shift_1[15]), .B(mega_shift_1[14]), .Z(N550) );
  GTECH_XOR2 C1378 ( .A(mega_shift_1[0]), .B(N550), .Z(N551) );
  GTECH_XOR2 C1379 ( .A(mega_shift_1[1]), .B(N551), .Z(N552) );
  GTECH_XOR2 C1380 ( .A(mega_shift_1[2]), .B(N552), .Z(N553) );
  GTECH_XOR2 C1381 ( .A(mega_shift_1[3]), .B(N553), .Z(N554) );
  GTECH_XOR2 C1382 ( .A(mega_shift_1[4]), .B(N554), .Z(N555) );
  GTECH_XOR2 C1383 ( .A(mega_shift_1[5]), .B(N555), .Z(N556) );
  GTECH_XOR2 C1384 ( .A(mega_shift_1[6]), .B(N556), .Z(N557) );
  GTECH_XOR2 C1385 ( .A(mega_shift_1[7]), .B(N557), .Z(N558) );
  GTECH_XOR2 C1386 ( .A(mega_shift_1[8]), .B(N558), .Z(N559) );
  GTECH_XOR2 C1387 ( .A(mega_shift_1[9]), .B(N559), .Z(N560) );
  GTECH_XOR2 C1388 ( .A(mega_shift_1[10]), .B(N560), .Z(N561) );
  GTECH_XOR2 C1389 ( .A(mega_shift_1[11]), .B(N561), .Z(N562) );
  GTECH_XOR2 C1390 ( .A(mega_shift_1[12]), .B(N562), .Z(N563) );
  GTECH_XOR2 C1391 ( .A(mega_shift_1[13]), .B(N563), .Z(N564) );
  GTECH_XOR2 C1392 ( .A(mega_shift_1[14]), .B(mega_shift_1[13]), .Z(N565) );
  GTECH_XOR2 C1393 ( .A(mega_shift_1[15]), .B(N565), .Z(N566) );
  GTECH_XOR2 C1394 ( .A(mega_shift_1[0]), .B(N566), .Z(N567) );
  GTECH_XOR2 C1395 ( .A(mega_shift_1[1]), .B(N567), .Z(N568) );
  GTECH_XOR2 C1396 ( .A(mega_shift_1[2]), .B(N568), .Z(N569) );
  GTECH_XOR2 C1397 ( .A(mega_shift_1[3]), .B(N569), .Z(N570) );
  GTECH_XOR2 C1398 ( .A(mega_shift_1[4]), .B(N570), .Z(N571) );
  GTECH_XOR2 C1399 ( .A(mega_shift_1[5]), .B(N571), .Z(N572) );
  GTECH_XOR2 C1400 ( .A(mega_shift_1[6]), .B(N572), .Z(N573) );
  GTECH_XOR2 C1401 ( .A(mega_shift_1[7]), .B(N573), .Z(N574) );
  GTECH_XOR2 C1402 ( .A(mega_shift_1[8]), .B(N574), .Z(N575) );
  GTECH_XOR2 C1403 ( .A(mega_shift_1[9]), .B(N575), .Z(N576) );
  GTECH_XOR2 C1404 ( .A(mega_shift_1[10]), .B(N576), .Z(N577) );
  GTECH_XOR2 C1405 ( .A(mega_shift_1[11]), .B(N577), .Z(N578) );
  GTECH_XOR2 C1406 ( .A(mega_shift_1[12]), .B(N578), .Z(N579) );
  GTECH_XOR2 C1407 ( .A(mega_shift_1[13]), .B(mega_shift_1[12]), .Z(N580) );
  GTECH_XOR2 C1408 ( .A(mega_shift_1[14]), .B(N580), .Z(N581) );
  GTECH_XOR2 C1409 ( .A(mega_shift_1[15]), .B(N581), .Z(N582) );
  GTECH_XOR2 C1410 ( .A(mega_shift_1[0]), .B(N582), .Z(N583) );
  GTECH_XOR2 C1411 ( .A(mega_shift_1[1]), .B(N583), .Z(N584) );
  GTECH_XOR2 C1412 ( .A(mega_shift_1[2]), .B(N584), .Z(N585) );
  GTECH_XOR2 C1413 ( .A(mega_shift_1[3]), .B(N585), .Z(N586) );
  GTECH_XOR2 C1414 ( .A(mega_shift_1[4]), .B(N586), .Z(N587) );
  GTECH_XOR2 C1415 ( .A(mega_shift_1[5]), .B(N587), .Z(N588) );
  GTECH_XOR2 C1416 ( .A(mega_shift_1[6]), .B(N588), .Z(N589) );
  GTECH_XOR2 C1417 ( .A(mega_shift_1[7]), .B(N589), .Z(N590) );
  GTECH_XOR2 C1418 ( .A(mega_shift_1[8]), .B(N590), .Z(N591) );
  GTECH_XOR2 C1419 ( .A(mega_shift_1[9]), .B(N591), .Z(N592) );
  GTECH_XOR2 C1420 ( .A(mega_shift_1[10]), .B(N592), .Z(N593) );
  GTECH_XOR2 C1421 ( .A(mega_shift_1[11]), .B(N593), .Z(N594) );
  GTECH_XOR2 C1422 ( .A(mega_shift_1[12]), .B(mega_shift_1[11]), .Z(N595) );
  GTECH_XOR2 C1423 ( .A(mega_shift_1[13]), .B(N595), .Z(N596) );
  GTECH_XOR2 C1424 ( .A(mega_shift_1[14]), .B(N596), .Z(N597) );
  GTECH_XOR2 C1425 ( .A(mega_shift_1[15]), .B(N597), .Z(N598) );
  GTECH_XOR2 C1426 ( .A(mega_shift_1[0]), .B(N598), .Z(N599) );
  GTECH_XOR2 C1427 ( .A(mega_shift_1[1]), .B(N599), .Z(N600) );
  GTECH_XOR2 C1428 ( .A(mega_shift_1[2]), .B(N600), .Z(N601) );
  GTECH_XOR2 C1429 ( .A(mega_shift_1[3]), .B(N601), .Z(N602) );
  GTECH_XOR2 C1430 ( .A(mega_shift_1[4]), .B(N602), .Z(N603) );
  GTECH_XOR2 C1431 ( .A(mega_shift_1[5]), .B(N603), .Z(N604) );
  GTECH_XOR2 C1432 ( .A(mega_shift_1[6]), .B(N604), .Z(N605) );
  GTECH_XOR2 C1433 ( .A(mega_shift_1[7]), .B(N605), .Z(N606) );
  GTECH_XOR2 C1434 ( .A(mega_shift_1[8]), .B(N606), .Z(N607) );
  GTECH_XOR2 C1435 ( .A(mega_shift_1[9]), .B(N607), .Z(N608) );
  GTECH_XOR2 C1436 ( .A(mega_shift_1[10]), .B(N608), .Z(N609) );
  GTECH_XOR2 C1437 ( .A(mega_shift_1[11]), .B(mega_shift_1[10]), .Z(N610) );
  GTECH_XOR2 C1438 ( .A(mega_shift_1[12]), .B(N610), .Z(N611) );
  GTECH_XOR2 C1439 ( .A(mega_shift_1[13]), .B(N611), .Z(N612) );
  GTECH_XOR2 C1440 ( .A(mega_shift_1[14]), .B(N612), .Z(N613) );
  GTECH_XOR2 C1441 ( .A(mega_shift_1[15]), .B(N613), .Z(N614) );
  GTECH_XOR2 C1442 ( .A(mega_shift_1[0]), .B(N614), .Z(N615) );
  GTECH_XOR2 C1443 ( .A(mega_shift_1[1]), .B(N615), .Z(N616) );
  GTECH_XOR2 C1444 ( .A(mega_shift_1[2]), .B(N616), .Z(N617) );
  GTECH_XOR2 C1445 ( .A(mega_shift_1[3]), .B(N617), .Z(N618) );
  GTECH_XOR2 C1446 ( .A(mega_shift_1[4]), .B(N618), .Z(N619) );
  GTECH_XOR2 C1447 ( .A(mega_shift_1[5]), .B(N619), .Z(N620) );
  GTECH_XOR2 C1448 ( .A(mega_shift_1[6]), .B(N620), .Z(N621) );
  GTECH_XOR2 C1449 ( .A(mega_shift_1[7]), .B(N621), .Z(N622) );
  GTECH_XOR2 C1450 ( .A(mega_shift_1[8]), .B(N622), .Z(N623) );
  GTECH_XOR2 C1451 ( .A(mega_shift_1[9]), .B(N623), .Z(N624) );
  GTECH_XOR2 C1452 ( .A(mega_shift_1[10]), .B(mega_shift_1[9]), .Z(N625) );
  GTECH_XOR2 C1453 ( .A(mega_shift_1[11]), .B(N625), .Z(N626) );
  GTECH_XOR2 C1454 ( .A(mega_shift_1[12]), .B(N626), .Z(N627) );
  GTECH_XOR2 C1455 ( .A(mega_shift_1[13]), .B(N627), .Z(N628) );
  GTECH_XOR2 C1456 ( .A(mega_shift_1[14]), .B(N628), .Z(N629) );
  GTECH_XOR2 C1457 ( .A(mega_shift_1[15]), .B(N629), .Z(N630) );
  GTECH_XOR2 C1458 ( .A(mega_shift_1[0]), .B(N630), .Z(N631) );
  GTECH_XOR2 C1459 ( .A(mega_shift_1[1]), .B(N631), .Z(N632) );
  GTECH_XOR2 C1460 ( .A(mega_shift_1[2]), .B(N632), .Z(N633) );
  GTECH_XOR2 C1461 ( .A(mega_shift_1[3]), .B(N633), .Z(N634) );
  GTECH_XOR2 C1462 ( .A(mega_shift_1[4]), .B(N634), .Z(N635) );
  GTECH_XOR2 C1463 ( .A(mega_shift_1[5]), .B(N635), .Z(N636) );
  GTECH_XOR2 C1464 ( .A(mega_shift_1[6]), .B(N636), .Z(N637) );
  GTECH_XOR2 C1465 ( .A(mega_shift_1[7]), .B(N637), .Z(N638) );
  GTECH_XOR2 C1466 ( .A(mega_shift_1[8]), .B(N638), .Z(N639) );
  GTECH_XOR2 C1467 ( .A(mega_shift_1[9]), .B(mega_shift_1[8]), .Z(N640) );
  GTECH_XOR2 C1468 ( .A(mega_shift_1[10]), .B(N640), .Z(N641) );
  GTECH_XOR2 C1469 ( .A(mega_shift_1[11]), .B(N641), .Z(N642) );
  GTECH_XOR2 C1470 ( .A(mega_shift_1[12]), .B(N642), .Z(N643) );
  GTECH_XOR2 C1471 ( .A(mega_shift_1[13]), .B(N643), .Z(N644) );
  GTECH_XOR2 C1472 ( .A(mega_shift_1[14]), .B(N644), .Z(N645) );
  GTECH_XOR2 C1473 ( .A(mega_shift_1[15]), .B(N645), .Z(N646) );
  GTECH_XOR2 C1474 ( .A(mega_shift_1[0]), .B(N646), .Z(N647) );
  GTECH_XOR2 C1475 ( .A(mega_shift_1[1]), .B(N647), .Z(N648) );
  GTECH_XOR2 C1476 ( .A(mega_shift_1[2]), .B(N648), .Z(N649) );
  GTECH_XOR2 C1477 ( .A(mega_shift_1[3]), .B(N649), .Z(N650) );
  GTECH_XOR2 C1478 ( .A(mega_shift_1[4]), .B(N650), .Z(N651) );
  GTECH_XOR2 C1479 ( .A(mega_shift_1[5]), .B(N651), .Z(N652) );
  GTECH_XOR2 C1480 ( .A(mega_shift_1[6]), .B(N652), .Z(N653) );
  GTECH_XOR2 C1481 ( .A(mega_shift_1[7]), .B(N653), .Z(N654) );
  GTECH_XOR2 C1482 ( .A(mega_shift_1[8]), .B(mega_shift_1[7]), .Z(N655) );
  GTECH_XOR2 C1483 ( .A(mega_shift_1[9]), .B(N655), .Z(N656) );
  GTECH_XOR2 C1484 ( .A(mega_shift_1[10]), .B(N656), .Z(N657) );
  GTECH_XOR2 C1485 ( .A(mega_shift_1[11]), .B(N657), .Z(N658) );
  GTECH_XOR2 C1486 ( .A(mega_shift_1[12]), .B(N658), .Z(N659) );
  GTECH_XOR2 C1487 ( .A(mega_shift_1[13]), .B(N659), .Z(N660) );
  GTECH_XOR2 C1488 ( .A(mega_shift_1[14]), .B(N660), .Z(N661) );
  GTECH_XOR2 C1489 ( .A(mega_shift_1[15]), .B(N661), .Z(N662) );
  GTECH_XOR2 C1490 ( .A(mega_shift_1[0]), .B(N662), .Z(N663) );
  GTECH_XOR2 C1491 ( .A(mega_shift_1[1]), .B(N663), .Z(N664) );
  GTECH_XOR2 C1492 ( .A(mega_shift_1[2]), .B(N664), .Z(N665) );
  GTECH_XOR2 C1493 ( .A(mega_shift_1[3]), .B(N665), .Z(N666) );
  GTECH_XOR2 C1494 ( .A(mega_shift_1[4]), .B(N666), .Z(N667) );
  GTECH_XOR2 C1495 ( .A(mega_shift_1[5]), .B(N667), .Z(N668) );
  GTECH_XOR2 C1496 ( .A(mega_shift_1[6]), .B(N668), .Z(N669) );
  GTECH_XOR2 C1497 ( .A(mega_shift_1[7]), .B(mega_shift_1[6]), .Z(N670) );
  GTECH_XOR2 C1498 ( .A(mega_shift_1[8]), .B(N670), .Z(N671) );
  GTECH_XOR2 C1499 ( .A(mega_shift_1[9]), .B(N671), .Z(N672) );
  GTECH_XOR2 C1500 ( .A(mega_shift_1[10]), .B(N672), .Z(N673) );
  GTECH_XOR2 C1501 ( .A(mega_shift_1[11]), .B(N673), .Z(N674) );
  GTECH_XOR2 C1502 ( .A(mega_shift_1[12]), .B(N674), .Z(N675) );
  GTECH_XOR2 C1503 ( .A(mega_shift_1[13]), .B(N675), .Z(N676) );
  GTECH_XOR2 C1504 ( .A(mega_shift_1[14]), .B(N676), .Z(N677) );
  GTECH_XOR2 C1505 ( .A(mega_shift_1[15]), .B(N677), .Z(N678) );
  GTECH_XOR2 C1506 ( .A(mega_shift_1[0]), .B(N678), .Z(N679) );
  GTECH_XOR2 C1507 ( .A(mega_shift_1[1]), .B(N679), .Z(N680) );
  GTECH_XOR2 C1508 ( .A(mega_shift_1[2]), .B(N680), .Z(N681) );
  GTECH_XOR2 C1509 ( .A(mega_shift_1[3]), .B(N681), .Z(N682) );
  GTECH_XOR2 C1510 ( .A(mega_shift_1[4]), .B(N682), .Z(N683) );
  GTECH_XOR2 C1511 ( .A(mega_shift_1[5]), .B(N683), .Z(N684) );
  GTECH_XOR2 C1512 ( .A(mega_shift_1[6]), .B(mega_shift_1[5]), .Z(N685) );
  GTECH_XOR2 C1513 ( .A(mega_shift_1[7]), .B(N685), .Z(N686) );
  GTECH_XOR2 C1514 ( .A(mega_shift_1[8]), .B(N686), .Z(N687) );
  GTECH_XOR2 C1515 ( .A(mega_shift_1[9]), .B(N687), .Z(N688) );
  GTECH_XOR2 C1516 ( .A(mega_shift_1[10]), .B(N688), .Z(N689) );
  GTECH_XOR2 C1517 ( .A(mega_shift_1[11]), .B(N689), .Z(N690) );
  GTECH_XOR2 C1518 ( .A(mega_shift_1[12]), .B(N690), .Z(N691) );
  GTECH_XOR2 C1519 ( .A(mega_shift_1[13]), .B(N691), .Z(N692) );
  GTECH_XOR2 C1520 ( .A(mega_shift_1[14]), .B(N692), .Z(N693) );
  GTECH_XOR2 C1521 ( .A(mega_shift_1[15]), .B(N693), .Z(N694) );
  GTECH_XOR2 C1522 ( .A(mega_shift_1[0]), .B(N694), .Z(N695) );
  GTECH_XOR2 C1523 ( .A(mega_shift_1[1]), .B(N695), .Z(N696) );
  GTECH_XOR2 C1524 ( .A(mega_shift_1[2]), .B(N696), .Z(N697) );
  GTECH_XOR2 C1525 ( .A(mega_shift_1[3]), .B(N697), .Z(N698) );
  GTECH_XOR2 C1526 ( .A(mega_shift_1[4]), .B(N698), .Z(N699) );
  GTECH_XOR2 C1527 ( .A(mega_shift_1[5]), .B(mega_shift_1[4]), .Z(N700) );
  GTECH_XOR2 C1528 ( .A(mega_shift_1[6]), .B(N700), .Z(N701) );
  GTECH_XOR2 C1529 ( .A(mega_shift_1[7]), .B(N701), .Z(N702) );
  GTECH_XOR2 C1530 ( .A(mega_shift_1[8]), .B(N702), .Z(N703) );
  GTECH_XOR2 C1531 ( .A(mega_shift_1[9]), .B(N703), .Z(N704) );
  GTECH_XOR2 C1532 ( .A(mega_shift_1[10]), .B(N704), .Z(N705) );
  GTECH_XOR2 C1533 ( .A(mega_shift_1[11]), .B(N705), .Z(N706) );
  GTECH_XOR2 C1534 ( .A(mega_shift_1[12]), .B(N706), .Z(N707) );
  GTECH_XOR2 C1535 ( .A(mega_shift_1[13]), .B(N707), .Z(N708) );
  GTECH_XOR2 C1536 ( .A(mega_shift_1[14]), .B(N708), .Z(N709) );
  GTECH_XOR2 C1537 ( .A(mega_shift_1[15]), .B(N709), .Z(N710) );
  GTECH_XOR2 C1538 ( .A(mega_shift_1[0]), .B(N710), .Z(N711) );
  GTECH_XOR2 C1539 ( .A(mega_shift_1[1]), .B(N711), .Z(N712) );
  GTECH_XOR2 C1540 ( .A(mega_shift_1[2]), .B(N712), .Z(N713) );
  GTECH_XOR2 C1541 ( .A(mega_shift_1[3]), .B(N713), .Z(N714) );
  GTECH_XOR2 C1542 ( .A(mega_shift_1[4]), .B(mega_shift_1[3]), .Z(N715) );
  GTECH_XOR2 C1543 ( .A(mega_shift_1[5]), .B(N715), .Z(N716) );
  GTECH_XOR2 C1544 ( .A(mega_shift_1[6]), .B(N716), .Z(N717) );
  GTECH_XOR2 C1545 ( .A(mega_shift_1[7]), .B(N717), .Z(N718) );
  GTECH_XOR2 C1546 ( .A(mega_shift_1[8]), .B(N718), .Z(N719) );
  GTECH_XOR2 C1547 ( .A(mega_shift_1[9]), .B(N719), .Z(N720) );
  GTECH_XOR2 C1548 ( .A(mega_shift_1[10]), .B(N720), .Z(N721) );
  GTECH_XOR2 C1549 ( .A(mega_shift_1[11]), .B(N721), .Z(N722) );
  GTECH_XOR2 C1550 ( .A(mega_shift_1[12]), .B(N722), .Z(N723) );
  GTECH_XOR2 C1551 ( .A(mega_shift_1[13]), .B(N723), .Z(N724) );
  GTECH_XOR2 C1552 ( .A(mega_shift_1[14]), .B(N724), .Z(N725) );
  GTECH_XOR2 C1553 ( .A(mega_shift_1[15]), .B(N725), .Z(N726) );
  GTECH_XOR2 C1554 ( .A(mega_shift_1[0]), .B(N726), .Z(N727) );
  GTECH_XOR2 C1555 ( .A(mega_shift_1[1]), .B(N727), .Z(N728) );
  GTECH_XOR2 C1556 ( .A(mega_shift_1[2]), .B(N728), .Z(N729) );
  GTECH_XOR2 C1557 ( .A(mega_shift_1[3]), .B(mega_shift_1[2]), .Z(N730) );
  GTECH_XOR2 C1558 ( .A(mega_shift_1[4]), .B(N730), .Z(N731) );
  GTECH_XOR2 C1559 ( .A(mega_shift_1[5]), .B(N731), .Z(N732) );
  GTECH_XOR2 C1560 ( .A(mega_shift_1[6]), .B(N732), .Z(N733) );
  GTECH_XOR2 C1561 ( .A(mega_shift_1[7]), .B(N733), .Z(N734) );
  GTECH_XOR2 C1562 ( .A(mega_shift_1[8]), .B(N734), .Z(N735) );
  GTECH_XOR2 C1563 ( .A(mega_shift_1[9]), .B(N735), .Z(N736) );
  GTECH_XOR2 C1564 ( .A(mega_shift_1[10]), .B(N736), .Z(N737) );
  GTECH_XOR2 C1565 ( .A(mega_shift_1[11]), .B(N737), .Z(N738) );
  GTECH_XOR2 C1566 ( .A(mega_shift_1[12]), .B(N738), .Z(N739) );
  GTECH_XOR2 C1567 ( .A(mega_shift_1[13]), .B(N739), .Z(N740) );
  GTECH_XOR2 C1568 ( .A(mega_shift_1[14]), .B(N740), .Z(N741) );
  GTECH_XOR2 C1569 ( .A(mega_shift_1[15]), .B(N741), .Z(N742) );
  GTECH_XOR2 C1570 ( .A(mega_shift_1[0]), .B(N742), .Z(N743) );
  GTECH_XOR2 C1571 ( .A(mega_shift_1[1]), .B(N743), .Z(N744) );
  GTECH_XOR2 C1572 ( .A(mega_shift_1[2]), .B(mega_shift_1[1]), .Z(N745) );
  GTECH_XOR2 C1573 ( .A(mega_shift_1[3]), .B(N745), .Z(N746) );
  GTECH_XOR2 C1574 ( .A(mega_shift_1[4]), .B(N746), .Z(N747) );
  GTECH_XOR2 C1575 ( .A(mega_shift_1[5]), .B(N747), .Z(N748) );
  GTECH_XOR2 C1576 ( .A(mega_shift_1[6]), .B(N748), .Z(N749) );
  GTECH_XOR2 C1577 ( .A(mega_shift_1[7]), .B(N749), .Z(N750) );
  GTECH_XOR2 C1578 ( .A(mega_shift_1[8]), .B(N750), .Z(N751) );
  GTECH_XOR2 C1579 ( .A(mega_shift_1[9]), .B(N751), .Z(N752) );
  GTECH_XOR2 C1580 ( .A(mega_shift_1[10]), .B(N752), .Z(N753) );
  GTECH_XOR2 C1581 ( .A(mega_shift_1[11]), .B(N753), .Z(N754) );
  GTECH_XOR2 C1582 ( .A(mega_shift_1[12]), .B(N754), .Z(N755) );
  GTECH_XOR2 C1583 ( .A(mega_shift_1[13]), .B(N755), .Z(N756) );
  GTECH_XOR2 C1584 ( .A(mega_shift_1[14]), .B(N756), .Z(N757) );
  GTECH_XOR2 C1585 ( .A(mega_shift_1[15]), .B(N757), .Z(N758) );
  GTECH_XOR2 C1586 ( .A(mega_shift_1[0]), .B(N758), .Z(N759) );
endmodule


module SDRAM_FIFO ( fifo_clk_push, fifo_clk_pop, fifo_rst_n, test_mode, 
        fifo_push_req_n, fifo_pop_req_n, fifo_data_in, push_empty_fifo, 
        push_ae_fifo, push_hf_fifo, push_af_fifo, push_full_fifo, 
        push_error_fifo, pop_empty_fifo, pop_ae_fifo, pop_hf_fifo, pop_af_fifo, 
        pop_full_fifo, pop_error_fifo, data_out_fifo );
  input [31:0] fifo_data_in;
  output [31:0] data_out_fifo;
  input fifo_clk_push, fifo_clk_pop, fifo_rst_n, test_mode, fifo_push_req_n,
         fifo_pop_req_n;
  output push_empty_fifo, push_ae_fifo, push_hf_fifo, push_af_fifo,
         push_full_fifo, push_error_fifo, pop_empty_fifo, pop_ae_fifo,
         pop_hf_fifo, pop_af_fifo, pop_full_fifo, pop_error_fifo;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, we_n, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42,
         N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56,
         N57, N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70,
         N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84,
         N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98,
         N99, N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8;
  wire   [2:0] wr_addr;
  wire   [2:0] rd_addr;
  wire   [255:0] reg_array;
  wire   [31:0] data_out_sync;

  DW_fifoctl_s2_sf SD_FIFO_CTL ( .clk_push(fifo_clk_push), .clk_pop(
        fifo_clk_pop), .rst_n(fifo_rst_n), .push_req_n(fifo_push_req_n), 
        .pop_req_n(fifo_pop_req_n), .we_n(we_n), .push_empty(push_empty_fifo), 
        .push_ae(push_ae_fifo), .push_hf(push_hf_fifo), .push_af(push_af_fifo), 
        .push_full(push_full_fifo), .push_error(push_error_fifo), .pop_empty(
        pop_empty_fifo), .pop_ae(pop_ae_fifo), .pop_hf(pop_hf_fifo), .pop_af(
        pop_af_fifo), .pop_full(pop_full_fifo), .pop_error(pop_error_fifo), 
        .wr_addr(wr_addr), .rd_addr(rd_addr), .push_word_count({
        SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4}), .pop_word_count({SYNOPSYS_UNCONNECTED_5, 
        SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8}), .test(test_mode) );
  \**SEQGEN**  reg_array_reg_0__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[255]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[254]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[253]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[252]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[251]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[250]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[249]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[248]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[247]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[246]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[245]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[244]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[243]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[242]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[241]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[240]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[239]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[238]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[237]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[236]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[235]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[234]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[233]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[232]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[231]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[230]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[229]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[228]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[227]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[226]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[225]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_0__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[224]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N119) );
  \**SEQGEN**  reg_array_reg_1__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[223]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[222]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[221]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[220]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[219]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[218]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[217]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[216]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[215]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[214]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[213]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[212]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[211]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[210]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[209]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[208]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[207]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[206]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[205]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[204]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[203]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[202]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[201]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[200]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[199]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[198]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[197]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[196]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[195]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[194]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[193]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_1__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[192]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N118) );
  \**SEQGEN**  reg_array_reg_2__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[191]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[190]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[189]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[188]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[187]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[186]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[185]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[184]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[183]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[182]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[181]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[180]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[179]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[178]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[177]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[176]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[175]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[174]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[173]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[172]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[171]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[170]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[169]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[168]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[167]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[166]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[165]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[164]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[163]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[162]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[161]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_2__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[160]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N117) );
  \**SEQGEN**  reg_array_reg_3__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[159]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[158]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[157]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[156]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[155]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[154]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[153]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[152]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[151]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[150]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[149]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[148]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[147]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[146]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[145]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[144]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[143]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[142]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[141]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[140]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[139]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[138]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[137]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[136]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[135]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[134]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[133]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[132]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[131]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[130]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[129]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_3__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[128]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N116) );
  \**SEQGEN**  reg_array_reg_4__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[127]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[126]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[125]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[124]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[123]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[122]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[121]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[120]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[119]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[118]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[117]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[116]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[115]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[114]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[113]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[112]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[111]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[110]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[109]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[108]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[107]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[106]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[105]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[104]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[103]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[102]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[101]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[100]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[99]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[98]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[97]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_4__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[96]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N115) );
  \**SEQGEN**  reg_array_reg_5__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[95]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[94]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[93]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[92]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[91]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[90]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[89]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[88]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[87]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[86]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[85]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[84]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[83]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[82]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[81]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[80]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[79]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[78]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[77]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[76]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[75]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[74]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[73]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[72]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[71]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[70]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[69]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[68]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[67]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[66]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[65]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_5__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[64]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N114) );
  \**SEQGEN**  reg_array_reg_6__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[63]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[62]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[61]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[60]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[59]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[58]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[57]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[56]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[55]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[54]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[53]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[52]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[51]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_6__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N113) );
  \**SEQGEN**  reg_array_reg_7__31_ ( .clear(N152), .preset(1'b0), 
        .next_state(N112), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[31]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__30_ ( .clear(N152), .preset(1'b0), 
        .next_state(N111), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[30]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__29_ ( .clear(N152), .preset(1'b0), 
        .next_state(N110), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[29]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__28_ ( .clear(N152), .preset(1'b0), 
        .next_state(N109), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[28]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__27_ ( .clear(N152), .preset(1'b0), 
        .next_state(N108), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[27]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__26_ ( .clear(N152), .preset(1'b0), 
        .next_state(N107), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[26]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__25_ ( .clear(N152), .preset(1'b0), 
        .next_state(N106), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[25]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__24_ ( .clear(N152), .preset(1'b0), 
        .next_state(N105), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[24]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__23_ ( .clear(N152), .preset(1'b0), 
        .next_state(N104), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[23]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__22_ ( .clear(N152), .preset(1'b0), 
        .next_state(N103), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[22]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__21_ ( .clear(N152), .preset(1'b0), 
        .next_state(N102), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[21]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__20_ ( .clear(N152), .preset(1'b0), 
        .next_state(N101), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[20]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__19_ ( .clear(N152), .preset(1'b0), 
        .next_state(N100), .clocked_on(fifo_clk_push), .data_in(1'b0), 
        .enable(1'b0), .Q(reg_array[19]), .synch_clear(1'b0), .synch_preset(
        1'b0), .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__18_ ( .clear(N152), .preset(1'b0), 
        .next_state(N99), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__17_ ( .clear(N152), .preset(1'b0), 
        .next_state(N98), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__16_ ( .clear(N152), .preset(1'b0), 
        .next_state(N97), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__15_ ( .clear(N152), .preset(1'b0), 
        .next_state(N96), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__14_ ( .clear(N152), .preset(1'b0), 
        .next_state(N95), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__13_ ( .clear(N152), .preset(1'b0), 
        .next_state(N94), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__12_ ( .clear(N152), .preset(1'b0), 
        .next_state(N93), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__11_ ( .clear(N152), .preset(1'b0), 
        .next_state(N92), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__10_ ( .clear(N152), .preset(1'b0), 
        .next_state(N91), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(
        1'b0), .Q(reg_array[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__9_ ( .clear(N152), .preset(1'b0), .next_state(
        N90), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__8_ ( .clear(N152), .preset(1'b0), .next_state(
        N89), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__7_ ( .clear(N152), .preset(1'b0), .next_state(
        N88), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__6_ ( .clear(N152), .preset(1'b0), .next_state(
        N87), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__5_ ( .clear(N152), .preset(1'b0), .next_state(
        N86), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__4_ ( .clear(N152), .preset(1'b0), .next_state(
        N85), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__3_ ( .clear(N152), .preset(1'b0), .next_state(
        N84), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__2_ ( .clear(N152), .preset(1'b0), .next_state(
        N83), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__1_ ( .clear(N152), .preset(1'b0), .next_state(
        N82), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  reg_array_reg_7__0_ ( .clear(N152), .preset(1'b0), .next_state(
        N81), .clocked_on(fifo_clk_push), .data_in(1'b0), .enable(1'b0), .Q(
        reg_array[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N80) );
  \**SEQGEN**  data_out_sync_reg_31_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N120), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_30_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N121), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_29_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N122), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_28_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N123), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_27_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N124), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_26_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N125), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_25_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N126), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_24_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N127), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_23_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N128), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_22_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N129), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_21_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N130), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_20_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N131), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_19_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N132), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_18_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N133), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_17_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N134), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_16_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N135), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_15_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N136), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_14_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N137), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_13_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N138), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_12_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N139), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N140), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N141), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N142), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N143), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N144), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N145), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N146), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N147), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N148), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N149), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N150), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_sync_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N151), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_sync[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_31_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[31]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[31]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_30_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[30]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[30]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_29_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[29]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[29]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_28_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[28]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[28]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_27_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[27]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[27]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_26_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[26]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[26]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_25_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[25]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[25]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_24_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[24]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[24]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_23_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[23]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[23]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_22_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[22]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[22]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_21_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[21]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[21]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_20_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[20]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[20]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_19_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[19]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[19]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_18_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[18]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[18]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_17_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[17]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[17]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_16_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[16]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[16]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_15_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[15]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[15]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_14_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[14]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[14]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_13_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[13]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[13]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_12_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[12]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[12]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[11]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[11]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[10]), .clocked_on(fifo_clk_pop), .data_in(1'b0), 
        .enable(1'b0), .Q(data_out_fifo[10]), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[9]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[8]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[7]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[6]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[5]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[4]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[3]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[2]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[1]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  data_out_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        data_out_sync[0]), .clocked_on(fifo_clk_pop), .data_in(1'b0), .enable(
        1'b0), .Q(data_out_fifo[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(fifo_rst_n), .Z(N152) );
  GTECH_NOT I_1 ( .A(we_n), .Z(N153) );
  GTECH_AND2 C1069 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N154) );
  GTECH_AND2 C1070 ( .A(N154), .B(wr_addr[2]), .Z(N39) );
  GTECH_AND2 C1071 ( .A(N0), .B(wr_addr[1]), .Z(N155) );
  GTECH_NOT I_2 ( .A(wr_addr[0]), .Z(N0) );
  GTECH_AND2 C1072 ( .A(N155), .B(wr_addr[2]), .Z(N38) );
  GTECH_AND2 C1073 ( .A(wr_addr[0]), .B(N1), .Z(N156) );
  GTECH_NOT I_3 ( .A(wr_addr[1]), .Z(N1) );
  GTECH_AND2 C1074 ( .A(N156), .B(wr_addr[2]), .Z(N37) );
  GTECH_AND2 C1075 ( .A(N2), .B(N3), .Z(N157) );
  GTECH_NOT I_4 ( .A(wr_addr[0]), .Z(N2) );
  GTECH_NOT I_5 ( .A(wr_addr[1]), .Z(N3) );
  GTECH_AND2 C1076 ( .A(N157), .B(wr_addr[2]), .Z(N36) );
  GTECH_AND2 C1077 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N158) );
  GTECH_AND2 C1078 ( .A(N158), .B(N4), .Z(N35) );
  GTECH_NOT I_6 ( .A(wr_addr[2]), .Z(N4) );
  GTECH_AND2 C1079 ( .A(N5), .B(wr_addr[1]), .Z(N159) );
  GTECH_NOT I_7 ( .A(wr_addr[0]), .Z(N5) );
  GTECH_AND2 C1080 ( .A(N159), .B(N6), .Z(N34) );
  GTECH_NOT I_8 ( .A(wr_addr[2]), .Z(N6) );
  GTECH_AND2 C1081 ( .A(wr_addr[0]), .B(N7), .Z(N160) );
  GTECH_NOT I_9 ( .A(wr_addr[1]), .Z(N7) );
  GTECH_AND2 C1082 ( .A(N160), .B(N8), .Z(N33) );
  GTECH_NOT I_10 ( .A(wr_addr[2]), .Z(N8) );
  GTECH_AND2 C1083 ( .A(N9), .B(N10), .Z(N161) );
  GTECH_NOT I_11 ( .A(wr_addr[0]), .Z(N9) );
  GTECH_NOT I_12 ( .A(wr_addr[1]), .Z(N10) );
  GTECH_AND2 C1084 ( .A(N161), .B(N11), .Z(N32) );
  GTECH_NOT I_13 ( .A(wr_addr[2]), .Z(N11) );
  GTECH_AND2 C1085 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N162) );
  GTECH_AND2 C1086 ( .A(N162), .B(wr_addr[2]), .Z(N79) );
  GTECH_AND2 C1087 ( .A(N12), .B(wr_addr[1]), .Z(N163) );
  GTECH_NOT I_14 ( .A(wr_addr[0]), .Z(N12) );
  GTECH_AND2 C1088 ( .A(N163), .B(wr_addr[2]), .Z(N78) );
  GTECH_AND2 C1089 ( .A(wr_addr[0]), .B(N13), .Z(N164) );
  GTECH_NOT I_15 ( .A(wr_addr[1]), .Z(N13) );
  GTECH_AND2 C1090 ( .A(N164), .B(wr_addr[2]), .Z(N77) );
  GTECH_AND2 C1091 ( .A(N14), .B(N15), .Z(N165) );
  GTECH_NOT I_16 ( .A(wr_addr[0]), .Z(N14) );
  GTECH_NOT I_17 ( .A(wr_addr[1]), .Z(N15) );
  GTECH_AND2 C1092 ( .A(N165), .B(wr_addr[2]), .Z(N76) );
  GTECH_AND2 C1093 ( .A(wr_addr[0]), .B(wr_addr[1]), .Z(N166) );
  GTECH_AND2 C1094 ( .A(N166), .B(N16), .Z(N75) );
  GTECH_NOT I_18 ( .A(wr_addr[2]), .Z(N16) );
  GTECH_AND2 C1095 ( .A(N17), .B(wr_addr[1]), .Z(N167) );
  GTECH_NOT I_19 ( .A(wr_addr[0]), .Z(N17) );
  GTECH_AND2 C1096 ( .A(N167), .B(N18), .Z(N74) );
  GTECH_NOT I_20 ( .A(wr_addr[2]), .Z(N18) );
  GTECH_AND2 C1097 ( .A(wr_addr[0]), .B(N19), .Z(N168) );
  GTECH_NOT I_21 ( .A(wr_addr[1]), .Z(N19) );
  GTECH_AND2 C1098 ( .A(N168), .B(N20), .Z(N73) );
  GTECH_NOT I_22 ( .A(wr_addr[2]), .Z(N20) );
  GTECH_AND2 C1099 ( .A(N21), .B(N22), .Z(N169) );
  GTECH_NOT I_23 ( .A(wr_addr[0]), .Z(N21) );
  GTECH_NOT I_24 ( .A(wr_addr[1]), .Z(N22) );
  GTECH_AND2 C1100 ( .A(N169), .B(N23), .Z(N72) );
  GTECH_NOT I_25 ( .A(wr_addr[2]), .Z(N23) );
  SELECT_OP C1101 ( .DATA1({N32, N33, N34, N35, N36, N37, N38, N39}), .DATA2({
        N72, N73, N74, N75, N76, N77, N78, N79}), .CONTROL1(N24), .CONTROL2(
        N25), .Z({N119, N118, N117, N116, N115, N114, N113, N80}) );
  GTECH_BUF B_0 ( .A(N153), .Z(N24) );
  GTECH_BUF B_1 ( .A(we_n), .Z(N25) );
  SELECT_OP C1102 ( .DATA1(fifo_data_in), .DATA2({N40, N41, N42, N43, N44, N45, 
        N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, 
        N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71}), 
        .CONTROL1(N24), .CONTROL2(N25), .Z({N112, N111, N110, N109, N108, N107, 
        N106, N105, N104, N103, N102, N101, N100, N99, N98, N97, N96, N95, N94, 
        N93, N92, N91, N90, N89, N88, N87, N86, N85, N84, N83, N82, N81}) );
  MUX_OP C1103 ( .D0({reg_array[224], reg_array[225], reg_array[226], 
        reg_array[227], reg_array[228], reg_array[229], reg_array[230], 
        reg_array[231], reg_array[232], reg_array[233], reg_array[234], 
        reg_array[235], reg_array[236], reg_array[237], reg_array[238], 
        reg_array[239], reg_array[240], reg_array[241], reg_array[242], 
        reg_array[243], reg_array[244], reg_array[245], reg_array[246], 
        reg_array[247], reg_array[248], reg_array[249], reg_array[250], 
        reg_array[251], reg_array[252], reg_array[253], reg_array[254], 
        reg_array[255]}), .D1({reg_array[192], reg_array[193], reg_array[194], 
        reg_array[195], reg_array[196], reg_array[197], reg_array[198], 
        reg_array[199], reg_array[200], reg_array[201], reg_array[202], 
        reg_array[203], reg_array[204], reg_array[205], reg_array[206], 
        reg_array[207], reg_array[208], reg_array[209], reg_array[210], 
        reg_array[211], reg_array[212], reg_array[213], reg_array[214], 
        reg_array[215], reg_array[216], reg_array[217], reg_array[218], 
        reg_array[219], reg_array[220], reg_array[221], reg_array[222], 
        reg_array[223]}), .D2({reg_array[160], reg_array[161], reg_array[162], 
        reg_array[163], reg_array[164], reg_array[165], reg_array[166], 
        reg_array[167], reg_array[168], reg_array[169], reg_array[170], 
        reg_array[171], reg_array[172], reg_array[173], reg_array[174], 
        reg_array[175], reg_array[176], reg_array[177], reg_array[178], 
        reg_array[179], reg_array[180], reg_array[181], reg_array[182], 
        reg_array[183], reg_array[184], reg_array[185], reg_array[186], 
        reg_array[187], reg_array[188], reg_array[189], reg_array[190], 
        reg_array[191]}), .D3({reg_array[128], reg_array[129], reg_array[130], 
        reg_array[131], reg_array[132], reg_array[133], reg_array[134], 
        reg_array[135], reg_array[136], reg_array[137], reg_array[138], 
        reg_array[139], reg_array[140], reg_array[141], reg_array[142], 
        reg_array[143], reg_array[144], reg_array[145], reg_array[146], 
        reg_array[147], reg_array[148], reg_array[149], reg_array[150], 
        reg_array[151], reg_array[152], reg_array[153], reg_array[154], 
        reg_array[155], reg_array[156], reg_array[157], reg_array[158], 
        reg_array[159]}), .D4({reg_array[96], reg_array[97], reg_array[98], 
        reg_array[99], reg_array[100], reg_array[101], reg_array[102], 
        reg_array[103], reg_array[104], reg_array[105], reg_array[106], 
        reg_array[107], reg_array[108], reg_array[109], reg_array[110], 
        reg_array[111], reg_array[112], reg_array[113], reg_array[114], 
        reg_array[115], reg_array[116], reg_array[117], reg_array[118], 
        reg_array[119], reg_array[120], reg_array[121], reg_array[122], 
        reg_array[123], reg_array[124], reg_array[125], reg_array[126], 
        reg_array[127]}), .D5({reg_array[64], reg_array[65], reg_array[66], 
        reg_array[67], reg_array[68], reg_array[69], reg_array[70], 
        reg_array[71], reg_array[72], reg_array[73], reg_array[74], 
        reg_array[75], reg_array[76], reg_array[77], reg_array[78], 
        reg_array[79], reg_array[80], reg_array[81], reg_array[82], 
        reg_array[83], reg_array[84], reg_array[85], reg_array[86], 
        reg_array[87], reg_array[88], reg_array[89], reg_array[90], 
        reg_array[91], reg_array[92], reg_array[93], reg_array[94], 
        reg_array[95]}), .D6({reg_array[32], reg_array[33], reg_array[34], 
        reg_array[35], reg_array[36], reg_array[37], reg_array[38], 
        reg_array[39], reg_array[40], reg_array[41], reg_array[42], 
        reg_array[43], reg_array[44], reg_array[45], reg_array[46], 
        reg_array[47], reg_array[48], reg_array[49], reg_array[50], 
        reg_array[51], reg_array[52], reg_array[53], reg_array[54], 
        reg_array[55], reg_array[56], reg_array[57], reg_array[58], 
        reg_array[59], reg_array[60], reg_array[61], reg_array[62], 
        reg_array[63]}), .D7({reg_array[0], reg_array[1], reg_array[2], 
        reg_array[3], reg_array[4], reg_array[5], reg_array[6], reg_array[7], 
        reg_array[8], reg_array[9], reg_array[10], reg_array[11], 
        reg_array[12], reg_array[13], reg_array[14], reg_array[15], 
        reg_array[16], reg_array[17], reg_array[18], reg_array[19], 
        reg_array[20], reg_array[21], reg_array[22], reg_array[23], 
        reg_array[24], reg_array[25], reg_array[26], reg_array[27], 
        reg_array[28], reg_array[29], reg_array[30], reg_array[31]}), .S0(N26), 
        .S1(N27), .S2(N28), .Z({N71, N70, N69, N68, N67, N66, N65, N64, N63, 
        N62, N61, N60, N59, N58, N57, N56, N55, N54, N53, N52, N51, N50, N49, 
        N48, N47, N46, N45, N44, N43, N42, N41, N40}) );
  GTECH_BUF B_2 ( .A(wr_addr[0]), .Z(N26) );
  GTECH_BUF B_3 ( .A(wr_addr[1]), .Z(N27) );
  GTECH_BUF B_4 ( .A(wr_addr[2]), .Z(N28) );
  MUX_OP C1104 ( .D0({reg_array[224], reg_array[225], reg_array[226], 
        reg_array[227], reg_array[228], reg_array[229], reg_array[230], 
        reg_array[231], reg_array[232], reg_array[233], reg_array[234], 
        reg_array[235], reg_array[236], reg_array[237], reg_array[238], 
        reg_array[239], reg_array[240], reg_array[241], reg_array[242], 
        reg_array[243], reg_array[244], reg_array[245], reg_array[246], 
        reg_array[247], reg_array[248], reg_array[249], reg_array[250], 
        reg_array[251], reg_array[252], reg_array[253], reg_array[254], 
        reg_array[255]}), .D1({reg_array[192], reg_array[193], reg_array[194], 
        reg_array[195], reg_array[196], reg_array[197], reg_array[198], 
        reg_array[199], reg_array[200], reg_array[201], reg_array[202], 
        reg_array[203], reg_array[204], reg_array[205], reg_array[206], 
        reg_array[207], reg_array[208], reg_array[209], reg_array[210], 
        reg_array[211], reg_array[212], reg_array[213], reg_array[214], 
        reg_array[215], reg_array[216], reg_array[217], reg_array[218], 
        reg_array[219], reg_array[220], reg_array[221], reg_array[222], 
        reg_array[223]}), .D2({reg_array[160], reg_array[161], reg_array[162], 
        reg_array[163], reg_array[164], reg_array[165], reg_array[166], 
        reg_array[167], reg_array[168], reg_array[169], reg_array[170], 
        reg_array[171], reg_array[172], reg_array[173], reg_array[174], 
        reg_array[175], reg_array[176], reg_array[177], reg_array[178], 
        reg_array[179], reg_array[180], reg_array[181], reg_array[182], 
        reg_array[183], reg_array[184], reg_array[185], reg_array[186], 
        reg_array[187], reg_array[188], reg_array[189], reg_array[190], 
        reg_array[191]}), .D3({reg_array[128], reg_array[129], reg_array[130], 
        reg_array[131], reg_array[132], reg_array[133], reg_array[134], 
        reg_array[135], reg_array[136], reg_array[137], reg_array[138], 
        reg_array[139], reg_array[140], reg_array[141], reg_array[142], 
        reg_array[143], reg_array[144], reg_array[145], reg_array[146], 
        reg_array[147], reg_array[148], reg_array[149], reg_array[150], 
        reg_array[151], reg_array[152], reg_array[153], reg_array[154], 
        reg_array[155], reg_array[156], reg_array[157], reg_array[158], 
        reg_array[159]}), .D4({reg_array[96], reg_array[97], reg_array[98], 
        reg_array[99], reg_array[100], reg_array[101], reg_array[102], 
        reg_array[103], reg_array[104], reg_array[105], reg_array[106], 
        reg_array[107], reg_array[108], reg_array[109], reg_array[110], 
        reg_array[111], reg_array[112], reg_array[113], reg_array[114], 
        reg_array[115], reg_array[116], reg_array[117], reg_array[118], 
        reg_array[119], reg_array[120], reg_array[121], reg_array[122], 
        reg_array[123], reg_array[124], reg_array[125], reg_array[126], 
        reg_array[127]}), .D5({reg_array[64], reg_array[65], reg_array[66], 
        reg_array[67], reg_array[68], reg_array[69], reg_array[70], 
        reg_array[71], reg_array[72], reg_array[73], reg_array[74], 
        reg_array[75], reg_array[76], reg_array[77], reg_array[78], 
        reg_array[79], reg_array[80], reg_array[81], reg_array[82], 
        reg_array[83], reg_array[84], reg_array[85], reg_array[86], 
        reg_array[87], reg_array[88], reg_array[89], reg_array[90], 
        reg_array[91], reg_array[92], reg_array[93], reg_array[94], 
        reg_array[95]}), .D6({reg_array[32], reg_array[33], reg_array[34], 
        reg_array[35], reg_array[36], reg_array[37], reg_array[38], 
        reg_array[39], reg_array[40], reg_array[41], reg_array[42], 
        reg_array[43], reg_array[44], reg_array[45], reg_array[46], 
        reg_array[47], reg_array[48], reg_array[49], reg_array[50], 
        reg_array[51], reg_array[52], reg_array[53], reg_array[54], 
        reg_array[55], reg_array[56], reg_array[57], reg_array[58], 
        reg_array[59], reg_array[60], reg_array[61], reg_array[62], 
        reg_array[63]}), .D7({reg_array[0], reg_array[1], reg_array[2], 
        reg_array[3], reg_array[4], reg_array[5], reg_array[6], reg_array[7], 
        reg_array[8], reg_array[9], reg_array[10], reg_array[11], 
        reg_array[12], reg_array[13], reg_array[14], reg_array[15], 
        reg_array[16], reg_array[17], reg_array[18], reg_array[19], 
        reg_array[20], reg_array[21], reg_array[22], reg_array[23], 
        reg_array[24], reg_array[25], reg_array[26], reg_array[27], 
        reg_array[28], reg_array[29], reg_array[30], reg_array[31]}), .S0(N29), 
        .S1(N30), .S2(N31), .Z({N151, N150, N149, N148, N147, N146, N145, N144, 
        N143, N142, N141, N140, N139, N138, N137, N136, N135, N134, N133, N132, 
        N131, N130, N129, N128, N127, N126, N125, N124, N123, N122, N121, N120}) );
  GTECH_BUF B_5 ( .A(rd_addr[0]), .Z(N29) );
  GTECH_BUF B_6 ( .A(rd_addr[1]), .Z(N30) );
  GTECH_BUF B_7 ( .A(rd_addr[2]), .Z(N31) );
endmodule


module SDRAM_TOP ( sys_clk, sdram_clk, sys_rst_n, sdram_rst_n, test_mode, 
        risc_OUT_VALID, risc_STACK_FULL, risc_EndOfInstrn, risc_PSW, 
        risc_Rd_Instr, sd_A, sd_CK, sd_CKn, sd_LD, sd_RW, sd_BWS, sd_DQ_in, 
        sd_DQ_out, sd_DQ_en, sd_sys_data_out, sd_wfifo_data, 
        parser_sd_rfifo_pop, parser_sd_wfifo_push, sd_rfifo_parser_empty, 
        sd_wfifo_parser_full );
  input [10:0] risc_PSW;
  output [9:0] sd_A;
  output [1:0] sd_BWS;
  input [15:0] sd_DQ_in;
  output [15:0] sd_DQ_out;
  output [15:0] sd_DQ_en;
  output [31:0] sd_sys_data_out;
  input [31:0] sd_wfifo_data;
  input sys_clk, sdram_clk, sys_rst_n, sdram_rst_n, test_mode, risc_OUT_VALID,
         risc_STACK_FULL, risc_EndOfInstrn, risc_Rd_Instr, parser_sd_rfifo_pop,
         parser_sd_wfifo_push;
  output sd_CK, sd_CKn, sd_LD, sd_RW, sd_rfifo_parser_empty,
         sd_wfifo_parser_full;
  wire   net_sd_wfifo_pop, net_sd_wfifo_empty, net_sd_rfifo_push,
         net_sd_rfifo_full;
  wire   [31:0] net_sdram_if_rDQ;
  wire   [31:0] net_sdram_if_wDQ;

  SDRAM_IF I_SDRAM_IF ( .sdram_clk(sdram_clk), .sdram_rst_n(sdram_rst_n), 
        .risc_OUT_VALID(risc_OUT_VALID), .risc_STACK_FULL(risc_STACK_FULL), 
        .risc_EndOfInstrn(risc_EndOfInstrn), .risc_PSW(risc_PSW), 
        .risc_Rd_Instr(risc_Rd_Instr), .sd_A(sd_A), .sd_CK(sd_CK), .sd_CKn(
        sd_CKn), .sd_LD(sd_LD), .sd_RW(sd_RW), .sd_BWS(sd_BWS), .sd_DQ_in(
        sd_DQ_in), .sd_DQ_out(sd_DQ_out), .sd_DQ_en(sd_DQ_en), .sd_wfifo_pop(
        net_sd_wfifo_pop), .sd_wfifo_empty(net_sd_wfifo_empty), 
        .sd_rfifo_push(net_sd_rfifo_push), .sd_rfifo_full(net_sd_rfifo_full), 
        .sd_rfifo_DQ_out(net_sdram_if_rDQ), .sd_wfifo_DQ_in(net_sdram_if_wDQ)
         );
  SDRAM_FIFO I_SDRAM_READ_FIFO ( .fifo_clk_push(sdram_clk), .fifo_clk_pop(
        sys_clk), .fifo_rst_n(sdram_rst_n), .test_mode(test_mode), 
        .fifo_push_req_n(net_sd_rfifo_push), .fifo_pop_req_n(
        parser_sd_rfifo_pop), .fifo_data_in(net_sdram_if_rDQ), 
        .push_full_fifo(net_sd_rfifo_full), .pop_empty_fifo(
        sd_rfifo_parser_empty), .data_out_fifo(sd_sys_data_out) );
  SDRAM_FIFO I_SDRAM_WRITE_FIFO ( .fifo_clk_push(sys_clk), .fifo_clk_pop(
        sdram_clk), .fifo_rst_n(sys_rst_n), .test_mode(test_mode), 
        .fifo_push_req_n(parser_sd_wfifo_push), .fifo_pop_req_n(
        net_sd_wfifo_pop), .fifo_data_in(sd_wfifo_data), .push_full_fifo(
        sd_wfifo_parser_full), .pop_empty_fifo(net_sd_wfifo_empty), 
        .data_out_fifo(net_sdram_if_wDQ) );
endmodule


module PCI_W_MUX ( blender_data, sdram_read_data, risc_result_data, 
        pci_w_select, pci_wfifo_data );
  input [31:0] blender_data;
  input [31:0] sdram_read_data;
  input [31:0] risc_result_data;
  input [1:0] pci_w_select;
  output [31:0] pci_wfifo_data;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11;

  GTECH_OR2 C5 ( .A(pci_w_select[1]), .B(N3), .Z(N4) );
  GTECH_OR2 C8 ( .A(N6), .B(pci_w_select[0]), .Z(N7) );
  GTECH_AND2 C10 ( .A(pci_w_select[1]), .B(pci_w_select[0]), .Z(N9) );
  GTECH_AND2 C13 ( .A(N6), .B(N3), .Z(N10) );
  SELECT_OP C54 ( .DATA1(blender_data), .DATA2(sdram_read_data), .DATA3(
        risc_result_data), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .Z(
        pci_wfifo_data) );
  GTECH_BUF B_0 ( .A(N5), .Z(N0) );
  GTECH_BUF B_1 ( .A(N8), .Z(N1) );
  GTECH_BUF B_2 ( .A(N11), .Z(N2) );
  GTECH_NOT I_0 ( .A(pci_w_select[0]), .Z(N3) );
  GTECH_NOT I_1 ( .A(N4), .Z(N5) );
  GTECH_NOT I_2 ( .A(pci_w_select[1]), .Z(N6) );
  GTECH_NOT I_3 ( .A(N7), .Z(N8) );
  GTECH_OR2 C60 ( .A(N9), .B(N10), .Z(N11) );
endmodule


module SD_W_MUX ( blender_data, pci_read_data, risc_result_data, sd_w_select, 
        sd_wfifo_data );
  input [31:0] blender_data;
  input [31:0] pci_read_data;
  input [31:0] risc_result_data;
  input [1:0] sd_w_select;
  output [31:0] sd_wfifo_data;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11;

  GTECH_OR2 C5 ( .A(sd_w_select[1]), .B(N3), .Z(N4) );
  GTECH_OR2 C8 ( .A(N6), .B(sd_w_select[0]), .Z(N7) );
  GTECH_AND2 C10 ( .A(sd_w_select[1]), .B(sd_w_select[0]), .Z(N9) );
  GTECH_AND2 C13 ( .A(N6), .B(N3), .Z(N10) );
  SELECT_OP C54 ( .DATA1(blender_data), .DATA2(risc_result_data), .DATA3(
        pci_read_data), .CONTROL1(N0), .CONTROL2(N1), .CONTROL3(N2), .Z(
        sd_wfifo_data) );
  GTECH_BUF B_0 ( .A(N5), .Z(N0) );
  GTECH_BUF B_1 ( .A(N8), .Z(N1) );
  GTECH_BUF B_2 ( .A(N11), .Z(N2) );
  GTECH_NOT I_0 ( .A(sd_w_select[0]), .Z(N3) );
  GTECH_NOT I_1 ( .A(N4), .Z(N5) );
  GTECH_NOT I_2 ( .A(sd_w_select[1]), .Z(N6) );
  GTECH_NOT I_3 ( .A(N7), .Z(N8) );
  GTECH_OR2 C60 ( .A(N9), .B(N10), .Z(N11) );
endmodule


module ORCA_TOP ( sys_clk, sys_2x_clk, sdram_clk, scan_en, test_mode, 
        pci_rst_n, sdram_rst_n, sys_rst_n, sys_2x_rst_n, pclk, pidsel, pgnt_n, 
        pad_in, pad_out, pad_en, ppar_in, ppar_out, ppar_en, pc_be_in, 
        pc_be_out, pc_be_en, pframe_n_in, pframe_n_out, pframe_n_en, 
        ptrdy_n_in, ptrdy_n_out, ptrdy_n_en, pirdy_n_in, pirdy_n_out, 
        pirdy_n_en, pdevsel_n_in, pdevsel_n_out, pdevsel_n_en, pstop_n_in, 
        pstop_n_out, pstop_n_en, pperr_n_in, pperr_n_out, pperr_n_en, 
        pserr_n_in, pserr_n_out, pserr_n_en, preq_n, pm66en, sd_A, sd_CK, 
        sd_CKn, sd_LD, sd_RW, sd_BWS, sd_DQ_in, sd_DQ_out, sd_DQ_en );
  input [15:0] pad_in;
  output [15:0] pad_out;
  input [3:0] pc_be_in;
  output [3:0] pc_be_out;
  output [9:0] sd_A;
  output [1:0] sd_BWS;
  input [15:0] sd_DQ_in;
  output [15:0] sd_DQ_out;
  output [15:0] sd_DQ_en;
  input sys_clk, sys_2x_clk, sdram_clk, scan_en, test_mode, pci_rst_n,
         sdram_rst_n, sys_rst_n, sys_2x_rst_n, pclk, pidsel, pgnt_n, ppar_in,
         pframe_n_in, ptrdy_n_in, pirdy_n_in, pdevsel_n_in, pstop_n_in,
         pperr_n_in, pserr_n_in, pm66en;
  output pad_en, ppar_out, ppar_en, pc_be_en, pframe_n_out, pframe_n_en,
         ptrdy_n_out, ptrdy_n_en, pirdy_n_out, pirdy_n_en, pdevsel_n_out,
         pdevsel_n_en, pstop_n_out, pstop_n_en, pperr_n_out, pperr_n_en,
         pserr_n_out, pserr_n_en, preq_n, sd_CK, sd_CKn, sd_LD, sd_RW;
  wire   net_pci_parser_cmd_valid, net_parser_pci_cmd_valid,
         net_parser_fifo_read_pop, net_parser_fifo_read_empty,
         net_parser_fifo_write_push, net_parser_fifo_write_full,
         net_context_en, net_blender_clk_en, net_parser_sd_rfifo_pop,
         net_sd_rfifo_parser_empty, net_parser_sd_wfifo_push,
         net_sd_wfifo_parser_full, net_risc_sd_EndOfInstrn,
         net_risc_sd_Rd_Instr, net_risc_sd_OUT_VALID, net_risc_sd_STACK_FULL,
         net_blender_result_0__31_, net_blender_result_0__30_,
         net_blender_result_0__29_, net_blender_result_0__28_,
         net_blender_result_0__27_, net_blender_result_0__26_,
         net_blender_result_0__25_, net_blender_result_0__24_,
         net_blender_result_0__23_, net_blender_result_0__22_,
         net_blender_result_0__21_, net_blender_result_0__20_,
         net_blender_result_0__19_, net_blender_result_0__18_,
         net_blender_result_0__17_, net_blender_result_0__16_,
         net_blender_result_0__15_, net_blender_result_0__14_,
         net_blender_result_0__13_, net_blender_result_0__12_,
         net_blender_result_0__11_, net_blender_result_0__10_,
         net_blender_result_0__9_, net_blender_result_0__8_,
         net_blender_result_0__7_, net_blender_result_0__6_,
         net_blender_result_0__5_, net_blender_result_0__4_,
         net_blender_result_0__3_, net_blender_result_0__2_,
         net_blender_result_0__1_, net_blender_result_0__0_;
  wire   [3:0] net_pci_parser_cmd;
  wire   [3:0] net_parser_pci_cmd;
  wire   [31:0] net_pci_sys_read_data;
  wire   [31:0] net_pci_wfifo_data;
  wire   [7:0] net_context_cmd;
  wire   [3:0] net_blender_op;
  wire   [7:0] net_parser_risc_Instrn_lo;
  wire   [31:0] net_risc_Xecutng_Instrn;
  wire   [1:0] net_pci_w_mux_select;
  wire   [1:0] net_sd_w_mux_select;
  wire   [31:0] net_pci_context_data;
  wire   [10:0] net_risc_sd_PSW;
  wire   [15:0] net_risc_RESULT_DATA;
  wire   [31:0] net_sd_sys_read_data;
  wire   [31:0] net_sd_wfifo_data;

  PCI_TOP I_PCI_TOP ( .pclk(pclk), .pci_rst_n(pci_rst_n), .pidsel(pidsel), 
        .pgnt_n(pgnt_n), .pad_in(pad_in), .pad_out(pad_out), .pad_en(pad_en), 
        .ppar_in(ppar_in), .ppar_out(ppar_out), .ppar_en(ppar_en), .pc_be_in(
        pc_be_in), .pc_be_out(pc_be_out), .pc_be_en(pc_be_en), .pframe_n_in(
        pframe_n_in), .pframe_n_out(pframe_n_out), .pframe_n_en(pframe_n_en), 
        .ptrdy_n_in(ptrdy_n_in), .ptrdy_n_out(ptrdy_n_out), .ptrdy_n_en(
        ptrdy_n_en), .pirdy_n_in(pirdy_n_in), .pirdy_n_out(pirdy_n_out), 
        .pirdy_n_en(pirdy_n_en), .pdevsel_n_in(pdevsel_n_in), .pdevsel_n_out(
        pdevsel_n_out), .pdevsel_n_en(pdevsel_n_en), .pstop_n_in(pstop_n_in), 
        .pstop_n_out(pstop_n_out), .pstop_n_en(pstop_n_en), .pperr_n_in(
        pperr_n_in), .pperr_n_out(pperr_n_out), .pperr_n_en(pperr_n_en), 
        .pserr_n_in(pserr_n_in), .pserr_n_out(pserr_n_out), .pserr_n_en(
        pserr_n_en), .preq_n(preq_n), .pm66en(pm66en), .cmd_valid(
        net_pci_parser_cmd_valid), .cmd(net_pci_parser_cmd), .cmd_in_valid(
        net_parser_pci_cmd_valid), .cmd_in(net_parser_pci_cmd), .sys_clk(
        sys_clk), .sys_rst_n(sys_rst_n), .test_mode(test_mode), .rfifo_pop(
        net_parser_fifo_read_pop), .rfifo_empty(net_parser_fifo_read_empty), 
        .wfifo_push(net_parser_fifo_write_push), .wfifo_full(
        net_parser_fifo_write_full), .pci_read_data(net_pci_sys_read_data), 
        .pci_write_data(net_pci_wfifo_data) );
  PARSER I_PARSER ( .sys_clk(sys_clk), .pclk(pclk), .sys_rst_n(sys_rst_n), 
        .pcmd(net_pci_parser_cmd), .pcmd_valid(net_pci_parser_cmd_valid), 
        .pcmd_out(net_parser_pci_cmd), .pcmd_out_valid(
        net_parser_pci_cmd_valid), .blender_op(net_blender_op), 
        .blender_clk_en(net_blender_clk_en), .context_en(net_context_en), 
        .context_cmd(net_context_cmd), .fifo_read_pop(net_parser_fifo_read_pop), .fifo_read_empty(net_parser_fifo_read_empty), .fifo_write_push(
        net_parser_fifo_write_push), .fifo_write_full(
        net_parser_fifo_write_full), .risc_Instrn_lo(net_parser_risc_Instrn_lo), .risc_Xecutng_Instrn_lo(net_risc_Xecutng_Instrn[15:0]), .pci_w_mux_select(
        net_pci_w_mux_select), .sd_w_mux_select(net_sd_w_mux_select), 
        .parser_sd_rfifo_pop(net_parser_sd_rfifo_pop), .sd_rfifo_parser_empty(
        net_sd_rfifo_parser_empty), .parser_sd_wfifo_push(
        net_parser_sd_wfifo_push), .sd_wfifo_parser_full(
        net_sd_wfifo_parser_full) );
  CONTEXT_MEM I_CONTEXT_MEM ( .sys_clk(sys_clk), .sys_rst_n(sys_rst_n), 
        .context_en(net_context_en), .cmd(net_context_cmd), .pci_data_in(
        net_pci_sys_read_data), .pci_context_data(net_pci_context_data) );
  RISC_CORE I_RISC_CORE ( .clk(sys_2x_clk), .reset_n(sys_2x_rst_n), .Instrn({
        net_pci_context_data[31:8], net_parser_risc_Instrn_lo}), 
        .Xecutng_Instrn(net_risc_Xecutng_Instrn), .EndOfInstrn(
        net_risc_sd_EndOfInstrn), .PSW(net_risc_sd_PSW), .Rd_Instr(
        net_risc_sd_Rd_Instr), .RESULT_DATA(net_risc_RESULT_DATA), .OUT_VALID(
        net_risc_sd_OUT_VALID), .STACK_FULL(net_risc_sd_STACK_FULL) );
  BLENDER I_BLENDER_1 ( .clk(sys_clk), .reset_n(sys_rst_n), .clk_enable(
        net_blender_clk_en), .test_mode(test_mode), .operation(net_blender_op), 
        .op1(net_sd_sys_read_data), .op2(net_pci_context_data), .result({
        net_blender_result_0__31_, net_blender_result_0__30_, 
        net_blender_result_0__29_, net_blender_result_0__28_, 
        net_blender_result_0__27_, net_blender_result_0__26_, 
        net_blender_result_0__25_, net_blender_result_0__24_, 
        net_blender_result_0__23_, net_blender_result_0__22_, 
        net_blender_result_0__21_, net_blender_result_0__20_, 
        net_blender_result_0__19_, net_blender_result_0__18_, 
        net_blender_result_0__17_, net_blender_result_0__16_, 
        net_blender_result_0__15_, net_blender_result_0__14_, 
        net_blender_result_0__13_, net_blender_result_0__12_, 
        net_blender_result_0__11_, net_blender_result_0__10_, 
        net_blender_result_0__9_, net_blender_result_0__8_, 
        net_blender_result_0__7_, net_blender_result_0__6_, 
        net_blender_result_0__5_, net_blender_result_0__4_, 
        net_blender_result_0__3_, net_blender_result_0__2_, 
        net_blender_result_0__1_, net_blender_result_0__0_}) );
  SDRAM_TOP I_SDRAM_TOP ( .sys_clk(sys_clk), .sdram_clk(sdram_clk), 
        .sys_rst_n(sys_rst_n), .sdram_rst_n(sdram_rst_n), .test_mode(test_mode), .risc_OUT_VALID(net_risc_sd_OUT_VALID), .risc_STACK_FULL(
        net_risc_sd_STACK_FULL), .risc_EndOfInstrn(net_risc_sd_EndOfInstrn), 
        .risc_PSW(net_risc_sd_PSW), .risc_Rd_Instr(net_risc_sd_Rd_Instr), 
        .sd_A(sd_A), .sd_CK(sd_CK), .sd_CKn(sd_CKn), .sd_LD(sd_LD), .sd_RW(
        sd_RW), .sd_BWS(sd_BWS), .sd_DQ_in(sd_DQ_in), .sd_DQ_out(sd_DQ_out), 
        .sd_DQ_en(sd_DQ_en), .sd_sys_data_out(net_sd_sys_read_data), 
        .sd_wfifo_data(net_sd_wfifo_data), .parser_sd_rfifo_pop(
        net_parser_sd_rfifo_pop), .parser_sd_wfifo_push(
        net_parser_sd_wfifo_push), .sd_rfifo_parser_empty(
        net_sd_rfifo_parser_empty), .sd_wfifo_parser_full(
        net_sd_wfifo_parser_full) );
  PCI_W_MUX I_PCI_W_MUX ( .blender_data({net_blender_result_0__31_, 
        net_blender_result_0__30_, net_blender_result_0__29_, 
        net_blender_result_0__28_, net_blender_result_0__27_, 
        net_blender_result_0__26_, net_blender_result_0__25_, 
        net_blender_result_0__24_, net_blender_result_0__23_, 
        net_blender_result_0__22_, net_blender_result_0__21_, 
        net_blender_result_0__20_, net_blender_result_0__19_, 
        net_blender_result_0__18_, net_blender_result_0__17_, 
        net_blender_result_0__16_, net_blender_result_0__15_, 
        net_blender_result_0__14_, net_blender_result_0__13_, 
        net_blender_result_0__12_, net_blender_result_0__11_, 
        net_blender_result_0__10_, net_blender_result_0__9_, 
        net_blender_result_0__8_, net_blender_result_0__7_, 
        net_blender_result_0__6_, net_blender_result_0__5_, 
        net_blender_result_0__4_, net_blender_result_0__3_, 
        net_blender_result_0__2_, net_blender_result_0__1_, 
        net_blender_result_0__0_}), .sdram_read_data(net_sd_sys_read_data), 
        .risc_result_data({net_risc_RESULT_DATA, 
        net_risc_Xecutng_Instrn[31:16]}), .pci_w_select(net_pci_w_mux_select), 
        .pci_wfifo_data(net_pci_wfifo_data) );
  SD_W_MUX I_SD_W_MUX ( .blender_data({net_blender_result_0__31_, 
        net_blender_result_0__30_, net_blender_result_0__29_, 
        net_blender_result_0__28_, net_blender_result_0__27_, 
        net_blender_result_0__26_, net_blender_result_0__25_, 
        net_blender_result_0__24_, net_blender_result_0__23_, 
        net_blender_result_0__22_, net_blender_result_0__21_, 
        net_blender_result_0__20_, net_blender_result_0__19_, 
        net_blender_result_0__18_, net_blender_result_0__17_, 
        net_blender_result_0__16_, net_blender_result_0__15_, 
        net_blender_result_0__14_, net_blender_result_0__13_, 
        net_blender_result_0__12_, net_blender_result_0__11_, 
        net_blender_result_0__10_, net_blender_result_0__9_, 
        net_blender_result_0__8_, net_blender_result_0__7_, 
        net_blender_result_0__6_, net_blender_result_0__5_, 
        net_blender_result_0__4_, net_blender_result_0__3_, 
        net_blender_result_0__2_, net_blender_result_0__1_, 
        net_blender_result_0__0_}), .pci_read_data(net_pci_context_data), 
        .risc_result_data({net_risc_RESULT_DATA, 
        net_risc_Xecutng_Instrn[31:16]}), .sd_w_select(net_sd_w_mux_select), 
        .sd_wfifo_data(net_sd_wfifo_data) );
endmodule


module ORCA ( scan_en, test_mode, pll_bypass, power_save, sys_clk, pclk, 
        prst_n, pidsel, pgnt_n, pad, ppar, pc_be, pframe_n, ptrdy_n, pirdy_n, 
        pdevsel_n, pstop_n, pperr_n, pserr_n, preq_n, pm66en, sdr_clk, sd_CK, 
        sd_CKn, sd_DQ, sd_A, sd_BWS, sd_LD, sd_RW );
  inout [15:0] pad;
  inout [3:0] pc_be;
  inout [15:0] sd_DQ;
  output [9:0] sd_A;
  output [1:0] sd_BWS;
  input scan_en, test_mode, pll_bypass, power_save, sys_clk, pclk, prst_n,
         pidsel, pgnt_n, pm66en, sdr_clk;
  output preq_n, sd_CK, sd_CKn, sd_LD, sd_RW;
  inout ppar,  pframe_n,  ptrdy_n,  pirdy_n,  pdevsel_n,  pstop_n,  pperr_n, 
     pserr_n;
  wire   net_pclk, net_sys_clk, net_sdram_clk, s_test_mode, s_scan_en,
         s_pll_bypass, s_power_save, s_prst_n, net_pidsel, net_pgnt_n,
         net_pad_en, net_ppar_in, net_ppar_out, net_ppar_en, net_pc_be_en,
         net_pframe_n_in, net_pframe_n_out, net_pframe_n_en, net_ptrdy_n_in,
         net_ptrdy_n_out, net_ptrdy_n_en, net_pirdy_n_in, net_pirdy_n_out,
         net_pirdy_n_en, net_pdevsel_n_in, net_pdevsel_n_out, net_pdevsel_n_en,
         net_pstop_n_in, net_pstop_n_out, net_pstop_n_en, net_pperr_n_in,
         net_pperr_n_out, net_pperr_n_en, net_pserr_n_in, net_pserr_n_out,
         net_pserr_n_en, net_preq_n, net_pm66en, net_sdram_CK, net_sdram_CKn,
         net_sdram_LD, net_sdram_RW, buf_pclk, buf_sdram_clk, s_pclk,
         s_sdram_clk, s_sys_clk, s_sys_2x_clk, buf_sys_clk, buf_sys_2x_clk,
         s_pci_rst_n, s_sdram_rst_n, s_sys_rst_n, s_sys_2x_rst_n, net817;
  wire   [15:0] net_pad_out;
  wire   [15:0] net_pad_in;
  wire   [3:0] net_pc_be_out;
  wire   [3:0] net_pc_be_in;
  wire   [9:0] net_sdram_A;
  wire   [1:0] net_sdram_BWS;
  wire   [15:0] net_sdram_DQ_en;
  wire   [15:0] net_sdram_DQ_out;
  wire   [15:0] net_sdram_DQ_in;
  tri   [15:0] pad;
  tri   ppar;
  tri   [3:0] pc_be;
  tri   pframe_n;
  tri   ptrdy_n;
  tri   pirdy_n;
  tri   pdevsel_n;
  tri   pstop_n;
  tri   pperr_n;
  tri   pserr_n;
  tri   [15:0] sd_DQ;

  IBUFFX2 pclk_iopad ( .A(pclk), .Y(net_pclk) );
  IBUFFX2 sys_clk_iopad ( .A(sys_clk), .Y(net_sys_clk) );
  IBUFFX2 sdr_clk_iopad ( .A(sdr_clk), .Y(net_sdram_clk) );
  IBUFFX2 test_mode_iopad ( .A(test_mode), .Y(s_test_mode) );
  IBUFFX2 scan_en_iopad ( .A(scan_en), .Y(s_scan_en) );
  IBUFFX2 pll_bypass_iopad ( .A(pll_bypass), .Y(s_pll_bypass) );
  IBUFFX2 powersave_iopad ( .A(power_save), .Y(s_power_save) );
  IBUFFX2 prst_n_iopad ( .A(prst_n), .Y(s_prst_n) );
  IBUFFX2 pidsel_iopad ( .A(pidsel), .Y(net_pidsel) );
  IBUFFX2 pgnt_n_iopad ( .A(pgnt_n), .Y(net_pgnt_n) );
  B16I1025_EW pad_iopad_15 ( .PADIO(pad[15]), .DOUT(net_pad_in[15]), .DIN(
        net_pad_out[15]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_14 ( .PADIO(pad[14]), .DOUT(net_pad_in[14]), .DIN(
        net_pad_out[14]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_13 ( .PADIO(pad[13]), .DOUT(net_pad_in[13]), .DIN(
        net_pad_out[13]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_12 ( .PADIO(pad[12]), .DOUT(net_pad_in[12]), .DIN(
        net_pad_out[12]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_11 ( .PADIO(pad[11]), .DOUT(net_pad_in[11]), .DIN(
        net_pad_out[11]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_10 ( .PADIO(pad[10]), .DOUT(net_pad_in[10]), .DIN(
        net_pad_out[10]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_9 ( .PADIO(pad[9]), .DOUT(net_pad_in[9]), .DIN(
        net_pad_out[9]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_8 ( .PADIO(pad[8]), .DOUT(net_pad_in[8]), .DIN(
        net_pad_out[8]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_7 ( .PADIO(pad[7]), .DOUT(net_pad_in[7]), .DIN(
        net_pad_out[7]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_6 ( .PADIO(pad[6]), .DOUT(net_pad_in[6]), .DIN(
        net_pad_out[6]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_5 ( .PADIO(pad[5]), .DOUT(net_pad_in[5]), .DIN(
        net_pad_out[5]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_4 ( .PADIO(pad[4]), .DOUT(net_pad_in[4]), .DIN(
        net_pad_out[4]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_3 ( .PADIO(pad[3]), .DOUT(net_pad_in[3]), .DIN(
        net_pad_out[3]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_2 ( .PADIO(pad[2]), .DOUT(net_pad_in[2]), .DIN(
        net_pad_out[2]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_1 ( .PADIO(pad[1]), .DOUT(net_pad_in[1]), .DIN(
        net_pad_out[1]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pad_iopad_0 ( .PADIO(pad[0]), .DOUT(net_pad_in[0]), .DIN(
        net_pad_out[0]), .EN(net_pad_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW ppar_iopad ( .PADIO(ppar), .DOUT(net_ppar_in), .DIN(net_ppar_out), .EN(net_ppar_en), .R_EN(1'b1), .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW pc_be_iopad_3 ( .PADIO(pc_be[3]), .DOUT(net_pc_be_in[3]), .DIN(
        net_pc_be_out[3]), .EN(net_pc_be_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pc_be_iopad_2 ( .PADIO(pc_be[2]), .DOUT(net_pc_be_in[2]), .DIN(
        net_pc_be_out[2]), .EN(net_pc_be_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pc_be_iopad_1 ( .PADIO(pc_be[1]), .DOUT(net_pc_be_in[1]), .DIN(
        net_pc_be_out[1]), .EN(net_pc_be_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pc_be_iopad_0 ( .PADIO(pc_be[0]), .DOUT(net_pc_be_in[0]), .DIN(
        net_pc_be_out[0]), .EN(net_pc_be_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pframe_n_iopad ( .PADIO(pframe_n), .DOUT(net_pframe_n_in), .DIN(
        net_pframe_n_out), .EN(net_pframe_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW ptrdy_n_iopad ( .PADIO(ptrdy_n), .DOUT(net_ptrdy_n_in), .DIN(
        net_ptrdy_n_out), .EN(net_ptrdy_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pirdy_n_iopad ( .PADIO(pirdy_n), .DOUT(net_pirdy_n_in), .DIN(
        net_pirdy_n_out), .EN(net_pirdy_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pdevsel_n_iopad ( .PADIO(pdevsel_n), .DOUT(net_pdevsel_n_in), 
        .DIN(net_pdevsel_n_out), .EN(net_pdevsel_n_en), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW pstop_n_iopad ( .PADIO(pstop_n), .DOUT(net_pstop_n_in), .DIN(
        net_pstop_n_out), .EN(net_pstop_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pperr_n_iopad ( .PADIO(pperr_n), .DOUT(net_pperr_n_in), .DIN(
        net_pperr_n_out), .EN(net_pperr_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  B16I1025_EW pserr_n_iopad ( .PADIO(pserr_n), .DOUT(net_pserr_n_in), .DIN(
        net_pserr_n_out), .EN(net_pserr_n_en), .R_EN(1'b1), .PULL_UP(1'b0), 
        .PULL_DOWN(1'b0) );
  IBUFFX2 preq_n_iopad ( .A(net_preq_n), .Y(preq_n) );
  IBUFFX2 pm66en_iopad ( .A(pm66en), .Y(net_pm66en) );
  IBUFFX2 sdram_A_iopad_9 ( .A(net_sdram_A[9]), .Y(sd_A[9]) );
  IBUFFX2 sdram_A_iopad_8 ( .A(net_sdram_A[8]), .Y(sd_A[8]) );
  IBUFFX2 sdram_A_iopad_7 ( .A(net_sdram_A[7]), .Y(sd_A[7]) );
  IBUFFX2 sdram_A_iopad_6 ( .A(net_sdram_A[6]), .Y(sd_A[6]) );
  IBUFFX2 sdram_A_iopad_5 ( .A(net_sdram_A[5]), .Y(sd_A[5]) );
  IBUFFX2 sdram_A_iopad_4 ( .A(net_sdram_A[4]), .Y(sd_A[4]) );
  IBUFFX2 sdram_A_iopad_3 ( .A(net_sdram_A[3]), .Y(sd_A[3]) );
  IBUFFX2 sdram_A_iopad_2 ( .A(net_sdram_A[2]), .Y(sd_A[2]) );
  IBUFFX2 sdram_A_iopad_1 ( .A(net_sdram_A[1]), .Y(sd_A[1]) );
  IBUFFX2 sdram_A_iopad_0 ( .A(net_sdram_A[0]), .Y(sd_A[0]) );
  IBUFFX2 sdram_CK_iopad ( .A(net_sdram_CK), .Y(sd_CK) );
  IBUFFX2 sdram_CKn_iopad ( .A(net_sdram_CKn), .Y(sd_CKn) );
  IBUFFX2 sdram_LD_iopad ( .A(net_sdram_LD), .Y(sd_LD) );
  IBUFFX2 sdram_RW_iopad ( .A(net_sdram_RW), .Y(sd_RW) );
  IBUFFX2 sdram_BWS_iopad_1 ( .A(net_sdram_BWS[1]), .Y(sd_BWS[1]) );
  IBUFFX2 sdram_BWS_iopad_0 ( .A(net_sdram_BWS[0]), .Y(sd_BWS[0]) );
  B16I1025_EW sdram_DQ_iopad_15 ( .PADIO(sd_DQ[15]), .DOUT(net_sdram_DQ_in[15]), .DIN(net_sdram_DQ_out[15]), .EN(net_sdram_DQ_en[15]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_14 ( .PADIO(sd_DQ[14]), .DOUT(net_sdram_DQ_in[14]), .DIN(net_sdram_DQ_out[14]), .EN(net_sdram_DQ_en[14]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_13 ( .PADIO(sd_DQ[13]), .DOUT(net_sdram_DQ_in[13]), .DIN(net_sdram_DQ_out[13]), .EN(net_sdram_DQ_en[13]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_12 ( .PADIO(sd_DQ[12]), .DOUT(net_sdram_DQ_in[12]), .DIN(net_sdram_DQ_out[12]), .EN(net_sdram_DQ_en[12]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_11 ( .PADIO(sd_DQ[11]), .DOUT(net_sdram_DQ_in[11]), .DIN(net_sdram_DQ_out[11]), .EN(net_sdram_DQ_en[11]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_10 ( .PADIO(sd_DQ[10]), .DOUT(net_sdram_DQ_in[10]), .DIN(net_sdram_DQ_out[10]), .EN(net_sdram_DQ_en[10]), .R_EN(1'b1), .PULL_UP(
        1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_9 ( .PADIO(sd_DQ[9]), .DOUT(net_sdram_DQ_in[9]), 
        .DIN(net_sdram_DQ_out[9]), .EN(net_sdram_DQ_en[9]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_8 ( .PADIO(sd_DQ[8]), .DOUT(net_sdram_DQ_in[8]), 
        .DIN(net_sdram_DQ_out[8]), .EN(net_sdram_DQ_en[8]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_7 ( .PADIO(sd_DQ[7]), .DOUT(net_sdram_DQ_in[7]), 
        .DIN(net_sdram_DQ_out[7]), .EN(net_sdram_DQ_en[7]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_6 ( .PADIO(sd_DQ[6]), .DOUT(net_sdram_DQ_in[6]), 
        .DIN(net_sdram_DQ_out[6]), .EN(net_sdram_DQ_en[6]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_5 ( .PADIO(sd_DQ[5]), .DOUT(net_sdram_DQ_in[5]), 
        .DIN(net_sdram_DQ_out[5]), .EN(net_sdram_DQ_en[5]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_4 ( .PADIO(sd_DQ[4]), .DOUT(net_sdram_DQ_in[4]), 
        .DIN(net_sdram_DQ_out[4]), .EN(net_sdram_DQ_en[4]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_3 ( .PADIO(sd_DQ[3]), .DOUT(net_sdram_DQ_in[3]), 
        .DIN(net_sdram_DQ_out[3]), .EN(net_sdram_DQ_en[3]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_2 ( .PADIO(sd_DQ[2]), .DOUT(net_sdram_DQ_in[2]), 
        .DIN(net_sdram_DQ_out[2]), .EN(net_sdram_DQ_en[2]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_1 ( .PADIO(sd_DQ[1]), .DOUT(net_sdram_DQ_in[1]), 
        .DIN(net_sdram_DQ_out[1]), .EN(net_sdram_DQ_en[1]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  B16I1025_EW sdram_DQ_iopad_0 ( .PADIO(sd_DQ[0]), .DOUT(net_sdram_DQ_in[0]), 
        .DIN(net_sdram_DQ_out[0]), .EN(net_sdram_DQ_en[0]), .R_EN(1'b1), 
        .PULL_UP(1'b0), .PULL_DOWN(1'b0) );
  CLOCK_GEN I_CLOCK_GEN ( .pclk(net_pclk), .sdram_clk(net_sdram_clk), 
        .sys_clk(net_sys_clk), .sys_clk_fb(net817), .pclk_fb(buf_pclk), 
        .sdram_clk_fb(buf_sdram_clk), .test_mode(s_test_mode), .scan_enable(
        s_scan_en), .pll_bypass(s_pll_bypass), .powersave(s_power_save), 
        .o_pclk(s_pclk), .o_sdram_clk(s_sdram_clk), .o_sys_clk(s_sys_clk), 
        .o_sys_2x_clk(s_sys_2x_clk) );
  IBUFFX2 I_CLK_SOURCE_PCLK ( .A(s_pclk), .Y(buf_pclk) );
  IBUFFX2 I_CLK_SOURCE_SYS_CLK ( .A(s_sys_clk), .Y(buf_sys_clk) );
  IBUFFX2 I_CLK_SOURCE_SYS_2x_CLK ( .A(s_sys_2x_clk), .Y(buf_sys_2x_clk) );
  IBUFFX2 I_CLK_SOURCE_SDRAM_CLK ( .A(s_sdram_clk), .Y(buf_sdram_clk) );
  RESET_BLOCK I_RESET_BLOCK ( .pclk(buf_pclk), .sys_clk(buf_sys_clk), 
        .sys_2x_clk(buf_sys_2x_clk), .sdram_clk(buf_sdram_clk), .prst_n(
        s_prst_n), .test_mode(s_test_mode), .pci_rst_n(s_pci_rst_n), 
        .sdram_rst_n(s_sdram_rst_n), .sys_rst_n(s_sys_rst_n), .sys_2x_rst_n(
        s_sys_2x_rst_n) );
  ORCA_TOP I_ORCA_TOP ( .sys_clk(buf_sys_clk), .sys_2x_clk(buf_sys_2x_clk), 
        .sdram_clk(buf_sdram_clk), .scan_en(s_scan_en), .test_mode(s_test_mode), .pci_rst_n(s_pci_rst_n), .sdram_rst_n(s_sdram_rst_n), .sys_rst_n(s_sys_rst_n), .sys_2x_rst_n(s_sys_2x_rst_n), .pclk(buf_pclk), .pidsel(net_pidsel), 
        .pgnt_n(net_pgnt_n), .pad_in(net_pad_in), .pad_out(net_pad_out), 
        .pad_en(net_pad_en), .ppar_in(net_ppar_in), .ppar_out(net_ppar_out), 
        .ppar_en(net_ppar_en), .pc_be_in(net_pc_be_in), .pc_be_out(
        net_pc_be_out), .pc_be_en(net_pc_be_en), .pframe_n_in(net_pframe_n_in), 
        .pframe_n_out(net_pframe_n_out), .pframe_n_en(net_pframe_n_en), 
        .ptrdy_n_in(net_ptrdy_n_in), .ptrdy_n_out(net_ptrdy_n_out), 
        .ptrdy_n_en(net_ptrdy_n_en), .pirdy_n_in(net_pirdy_n_in), 
        .pirdy_n_out(net_pirdy_n_out), .pirdy_n_en(net_pirdy_n_en), 
        .pdevsel_n_in(net_pdevsel_n_in), .pdevsel_n_out(net_pdevsel_n_out), 
        .pdevsel_n_en(net_pdevsel_n_en), .pstop_n_in(net_pstop_n_in), 
        .pstop_n_out(net_pstop_n_out), .pstop_n_en(net_pstop_n_en), 
        .pperr_n_in(net_pperr_n_in), .pperr_n_out(net_pperr_n_out), 
        .pperr_n_en(net_pperr_n_en), .pserr_n_in(net_pserr_n_in), 
        .pserr_n_out(net_pserr_n_out), .pserr_n_en(net_pserr_n_en), .preq_n(
        net_preq_n), .pm66en(net_pm66en), .sd_A(net_sdram_A), .sd_CK(
        net_sdram_CK), .sd_CKn(net_sdram_CKn), .sd_LD(net_sdram_LD), .sd_RW(
        net_sdram_RW), .sd_BWS(net_sdram_BWS), .sd_DQ_in(net_sdram_DQ_in), 
        .sd_DQ_out(net_sdram_DQ_out), .sd_DQ_en(net_sdram_DQ_en) );
endmodule

