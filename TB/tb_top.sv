`include"mem_if.sv"
`include"Classes.sv"
`include"MEM_16x32.sv"

module tb_top;


	// Test-Bench Parameters
		parameter CLK_PER 		= 10,
			      Data_Width 	= 32,
			      Address_Width = 5 ,
			      Locations_Num = 32;
	
	
	// Test-Bench Signals 
		bit tb_CLK;
		bit tb_RST_n;

	
	
	// Clock Generation 
		always #(CLK_PER/2) tb_CLK = ~tb_CLK;

		
	
	// Reset Generation 
		initial
		begin
		
			// Reset Assertion
			tb_RST_n = 1'b0;
			
			// Reset De-Assertion
			#(CLK_PER/2) tb_RST_n = 1'b1;
			
			#1500 $finish;
		
		end
	
	

	// Memory Interface instance
		memory_if m_if (tb_CLK, tb_RST_n);



	// Creating Test calss instance 
		test t1(m_if);


		
	// DUT Instantiation, connect the DUT with the interface 
		Memory_16x32 #(

					.Data_Width    (Data_Width 	 ),
					.Address_Width (Address_Width),
					.Locations_Num (Locations_Num)

				) DUT (

					.CLK		(m_if.CLK	   ),
					.Rst_n		(m_if.Rst_n	   ),
					.Wr_En		(m_if.Wr_En	   ),
					.Rd_En		(m_if.Rd_En	   ),
					.Data_in	(m_if.Data_in  ),
					.Address	(m_if.Address  ),	

					.Data_out	(m_if.Data_out ),
					.Valid_out	(m_if.Valid_out)
					
				);

		
		
		
	// Dump Generation
		initial
		begin
		
			$dumpfile("mem_dump.vcd");
			$dumpvars;
			
		end
endmodule 
