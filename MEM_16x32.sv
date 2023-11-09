module Memory_16x32 #(

	parameter Data_Width 	= 32,
			  Address_Width = 5,
			  Locations_Num = 32

)(

	// Input Ports
	input 	wire logic 					     	CLK,
	input 	wire logic 					     	Rst_n,
	input 	wire logic							Wr_En,
	input 	wire logic							Rd_En,
	input 	wire logic 	[Data_Width    - 1 : 0] Data_in,
	input 	wire logic 	[Address_Width - 1 : 0] Address,
	
	// Output Ports
	output  logic 	 	[Data_Width    - 1 : 0] Data_out,
	output  logic  						  		Valid_out
);


logic [Data_Width - 1 : 0] MEM [Locations_Num - 1 : 0];

always @(posedge CLK or negedge Rst_n)
begin

	if (!Rst_n)
	begin
	
		Data_out  <= 32'b0;
		Valid_out <= 1'b0;
		for(int i = 0; i<Locations_Num; i++)
		begin
		
			MEM[i] <= 'b0;
		
		end
		
	end
	
	else if (Wr_En)
	begin
	
		MEM[Address] <= Data_in;
		Valid_out <= 1'b0;
	
	end
	else if (Rd_En)
	begin
		Data_out <= MEM[Address];
		Valid_out <= 1'b1;
	end
	else
	begin
		Data_out  <= 32'b0;
		Valid_out <= 1'b0;
	end

end

endmodule