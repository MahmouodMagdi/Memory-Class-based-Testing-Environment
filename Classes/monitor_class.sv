`define MONT_IF mem_vif.MONITOR.Monitor_cb                                // `MONT_IF will point to mem_vif.MONITOR.Monitor_cb which is in the virtual interface

//////////////////////////////////////////////////////////////
////////////////         Monitor Class         ///////////////
//////////////////////////////////////////////////////////////
class Monitor;

/*

	** Samples the interface signals and converts the signal level activity to the transaction level
	** Send the sampled transaction to Scoreboard via Mailbox

*/


	// Virtual Memory Interface handle
	virtual memory_if mem_vif;
	
	
	
	// Mailbox from monitor into the subscriber
	mailbox mon_to_scb;
	
	
	
	// Constructor
	function new(virtual memory_if mem_vif, mailbox mon_to_scb);
	
		// Getting the Memory Interface
		this.mem_vif = mem_vif;
		
		// Getting the mailbox handles from the Environment Class
		this.mon_to_scb = mon_to_scb;
		
	endfunction
	
	
	
	
	// Sampling logic and sending the sampled transaction to the scoreboard
	task mont_task;
	
		forever
		begin
		
			Transaction #(32,5)trans;
			trans = new();
			
			
			@(posedge mem_vif.MONITOR.CLK)
			wait(`MONT_IF.Rd_En || `MONT_IF.Wr_En);
				
				trans.Wr_En   <= `MONT_IF.Wr_En;
				trans.Data_in <= `MONT_IF.Data_in;
				trans.Address <= `MONT_IF.Address;
				
				if(`MONT_IF.Rd_En)
				begin
				
					trans.Rd_En <= `MONT_IF.Rd_En;
					@(posedge mem_vif.MONITOR.CLK);
					@(posedge mem_vif.MONITOR.CLK);
					trans.Data_out  <= `MONT_IF.Data_out;
					trans.Valid_out <= `MONT_IF.Valid_out;
				
				end
		
			mon_to_scb.put(trans);
		end
	
	endtask

endclass  // Monitor 
