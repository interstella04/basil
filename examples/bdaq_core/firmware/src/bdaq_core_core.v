/**
 * ------------------------------------------------------------
 * Copyright (c) All rights reserved
 * SiLab, Physics Institute, University of Bonn
 * ------------------------------------------------------------
 */
`timescale 1ns / 1ps

module bdaq_core_core(
        input wire RESET_N,

        // clocks from PLL clock buffers
        input wire BUS_CLK,
        input wire PLL_LOCKED,

        input wire          BUS_RST,
        input wire  [31:0]  BUS_ADD,
        inout wire  [7:0]   BUS_DATA,
        input wire          BUS_RD,
        input wire          BUS_WR,

        input wire          FIFO_READY,
        output reg          FIFO_VALID,
        output reg [31:0]   FIFO_DATA,

        output wire [7:0] OUT0,
        input wire [7:0] IN0,

        output wire [31:0] OUT1,
        input wire [31:0] IN1,

    );

    /* -------  MODULE ADREESSES  ------- */
    localparam OUT0_BASEADDR = 32'h1040;
    localparam OUT0_HIGHADDR = 32'h105f;


    /* -------  USER MODULES  ------- */
    gpio #(
        .BASEADDR(OUT0_BASEADDR),
        .HIGHADDR(OUT0_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(8),
        .IO_DIRECTION(8'hff) // all 8 bits are considered as outputs
    ) i_gpio_out0 (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(OUT0)
    );

    
    /* -------  MODULE ADREESSES  ------- */
    localparam IN0_BASEADDR = 32'h1060;
    localparam IN0_HIGHADDR = 32'h107f;


    /* -------  USER MODULES  ------- */
    gpio #(
        .BASEADDR(IN0_BASEADDR),
        .HIGHADDR(IN0_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(8),
        .IO_DIRECTION(8'h00) // all 8 bits are considered as input
    ) i_gpio_in0 (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(IN0)
    );


    localparam OUT1_BASEADDR = 32'h1080;
    localparam OUT1_HIGHADDR = 32'h109f;

    gpio #(
        .BASEADDR(OUT1_BASEADDR),
        .HIGHADDR(OUT1_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(32),
        .IO_DIRECTION(32'hffffffff) // all 32 bits outputs
    ) i_gpio_out1 (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(OUT1)
    );

    localparam IN1_BASEADDR = 32'h10a0;
    localparam IN1_HIGHADDR = 32'h10cf;

    gpio #(
        .BASEADDR(OUT1_BASEADDR),
        .HIGHADDR(OUT1_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(32),
        .IO_DIRECTION(32'hffffffff) // all 32 bits outputs
    ) i_gpio_in1 (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(IN1)
    );

    
   
    wire EN;
    assign EN = GPIO1[0];

    reg [31:0] FIFO_DATA_REG = 0;

    always @(posedge BUS_CLK)
        if(EN) begin
            if(FIFO_READY) begin
                FIFO_DATA <= FIFO_DATA_REG;
                FIFO_DATA_REG <= FIFO_DATA_REG + 1;
                FIFO_VALID <= 1;
            end
        end
        else begin
            FIFO_DATA_REG <= 0;
            FIFO_VALID <= 0;
        end
    

endmodule
