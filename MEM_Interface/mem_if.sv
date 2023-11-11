interface memory_if #(

	parameter 	Data_Width = 32,
				Addr_Width = 5

)( input logic CLK, Rst_n);


	logic						 Wr_En	  ;
	logic						 Rd_En	  ;
	logic 	[Data_Width - 1 : 0] Data_in  ;
	logic 	[Addr_Width - 1 : 0] Address  ;
	logic 	[Data_Width - 1 : 0] Data_out ;
	logic  					  	 Valid_out;


	// Driver Clocking Block 
	clocking Driver_cb @(posedge CLK);
	
		default input #1 output #1;
		output Address	;
		output Wr_En	;
		output Rd_En	;
		output Data_in	;
		input  Data_out	;
		input  Valid_out;
		
	endclocking
	
	// Monitor Clocking Block
	clocking Monitor_cb @(posedge CLK);
	
		default input #1 output #1;
		input  Address	;
		input  Wr_En	;
		input  Rd_En	;
		input  Data_in	;
		input  Data_out	;
		input  Valid_out;
		
	endclocking
	
	
	// Driver Modport
	modport DRIVER (
	
		clocking Driver_cb	, 
		input    CLK		, 
		input    Rst_n
	
	);
	
	
	// Monitor Modport
	modport MONITOR (
	
		clocking Monitor_cb	, 
		input    CLK		, 
		input    Rst_n
		
	);
	
endinterface
