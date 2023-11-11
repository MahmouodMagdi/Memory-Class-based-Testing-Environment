//////////////////////////////////////////////////////////////
////////////////       Scoreboard Class        ///////////////
//////////////////////////////////////////////////////////////
class Scoreboard;

/*
	
	Scoreboard receives the sampled packet from monitor,

		- if the transaction type is “read”, compares the read data with the local memory data
		- if the transaction type is “write”, local memory will be written with the wdata

*/


	// Mailbox handle
	mailbox mon_to_scb;
	
	
	// An integer to count the number of transactions
	int trans_count;
	

	// Creating an array that will be used as a local memory
	bit [31:0]loc_mem[31:0];
	
	
	function new(mailbox mon_to_scb);
	
		// Getting the mailbox handles from environment class
		this.mon_to_scb = mon_to_scb;
		
	endfunction
	
	
	
	// Storing wdata and compare rdata with stored data
	task scb_task;
	
	
		// Creating an instance of the Transaction Class
		Transaction #(32,5)trans;	
				
		forever
		begin
		
			#50;
			
			mon_to_scb.get(trans);
	
			if(trans.Wr_En)
			begin
			
				loc_mem[trans.Address] = trans.Data_in;
			
			end
			else if(trans.Rd_En)
			begin
				
				if(loc_mem[trans.Address] != trans.Data_out)
				$error("T = %0t, Sucsriber Failed: \nAddr = %d \nData :: Expected = %h \t Actual = %h", $time, trans.Address, loc_mem[trans.Address], trans.Data_out);
				else
				$display("Sucsriber Successeded !\n Addr = %0d Data :: Expected = %0h \t Actual = %0h", trans.Address, loc_mem[trans.Address], trans.Data_out);
			
			end


			trans_count++;
		
		end
	
	endtask
	
endclass  // Scoreboard
