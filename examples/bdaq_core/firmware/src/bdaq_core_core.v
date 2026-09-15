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

        output wire [7:0]   GPIO1,        
        input wire [7:0]   GPIO2
    );


    /* -------  MODULE ADREESSES  ------- */
    localparam GPIO1_BASEADDR = 32'h1000;
    localparam GPIO1_HIGHADDR = 32'h101f;


    /* -------  USER MODULES  ------- */
    gpio #(
        .BASEADDR(GPIO1_BASEADDR),
        .HIGHADDR(GPIO1_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(8),
        .IO_DIRECTION(8'hff)
    ) i_gpio1_rx (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(GPIO1)
    );

    /* -------  MODULE ADREESSES  ------- */
    localparam GPIO2_BASEADDR = 32'h1020;
    localparam GPIO2_HIGHADDR = 32'h103f;


    /* -------  USER MODULES  ------- */
    gpio #(
        .BASEADDR(GPIO2_BASEADDR),
        .HIGHADDR(GPIO2_HIGHADDR),
        .ABUSWIDTH(32),
        .IO_WIDTH(8),
        .IO_DIRECTION(8'h00)
    ) i_gpio_rx (
        .BUS_CLK(BUS_CLK),
        .BUS_RST(BUS_RST),
        .BUS_ADD(BUS_ADD),
        .BUS_DATA(BUS_DATA[7:0]),
        .BUS_RD(BUS_RD),
        .BUS_WR(BUS_WR),
        .IO(GPIO2)
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
