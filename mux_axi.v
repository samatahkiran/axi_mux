`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2024 16:47:50
// Design Name: 
// Module Name: mux_axi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module mux_axi(
     
     input wire clk,
    input wire reset_n,
    
    input wire [7:0] s_axis_data_1,
    input wire s_axis_valid_1,
    output wire s_axis_ready_1,
    input wire s_axis_last_1,
    
    input wire [7:0] s_axis_data_2,
    input wire s_axis_valid_2,
    output wire s_axis_ready_2,
    input wire s_axis_last_2,
    
    output wire [7:0] m_axis_data,
    output wire m_axis_valid,
    input wire m_axis_ready,
    output wire m_axis_last,
    
    input wire sel
);

  //reg data_last;
  
  reg [7:0] m_axis_data_w = 8'b0; ;
  reg s_axis_ready_reg1;
  reg s_axis_ready_reg2;
  reg m_axis_valid_reg;
  reg tlast_reg;
   

always @(posedge clk) begin
    if (reset_n) begin
        m_axis_data_w <= 8'b0;
        //s_axis_ready_reg1 <= 1'b0;
        //s_axis_ready_reg2 <= 1'b0;
        tlast_reg <= 1'b0;
        m_axis_valid_reg <= 1'b0;
       // data_last <= 1'b0;
    end else begin
        if (sel) begin
            if (s_axis_valid_2 && s_axis_ready_2) begin
                m_axis_data_w <= s_axis_data_2;
                m_axis_valid_reg <= s_axis_valid_2;
                //s_axis_ready_reg2 <= m_axis_ready;
                tlast_reg <= s_axis_last_2;  // Select input_b
               
            
        end else begin
                m_axis_data_w <= 0;
                m_axis_valid_reg <= 0;
              end
           end else begin
                if (s_axis_valid_1 && s_axis_ready_1) begin    
                m_axis_data_w <= s_axis_data_1;
                m_axis_valid_reg <= s_axis_valid_1;
               // s_axis_ready_reg1 <= m_axis_ready;
                tlast_reg <= s_axis_last_1;  // Select input_a
             
            end
            else
            begin
              m_axis_data_w <= 0;
              m_axis_valid_reg <= 0;
           end
         end
          end
     end


       always @(posedge clk) begin
         if(reset_n)
          begin
            s_axis_ready_reg1 <= 8'b0;
            s_axis_ready_reg2 <= 8'b0;
            
           end
           else
           begin
           if(!sel)begin
           s_axis_ready_reg1 <= m_axis_ready;
           end
           else begin
           s_axis_ready_reg2 <= m_axis_ready;
           end
           end
       end
           
           

         assign m_axis_data =  (s_axis_ready_reg1 || s_axis_ready_reg2)? m_axis_data_w:0;
         assign s_axis_ready_1 = s_axis_ready_reg1;
         assign s_axis_ready_2 = s_axis_ready_reg2;
         assign m_axis_valid = m_axis_valid_reg;
         assign m_axis_last = tlast_reg;

endmodule