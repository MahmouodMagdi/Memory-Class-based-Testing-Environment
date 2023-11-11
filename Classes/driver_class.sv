`define DRIV_IF mem_vif.DRIVER.Driver_cb					// `DRIV_IF will point to mem_vif.DRIVER.Driver_cb which is in the virtual interface

//////////////////////////////////////////////////////////////
////////////////         Driver Class          ///////////////
//////////////////////////////////////////////////////////////
class driver;

//    Resposible for driving transactions to the DUT through the virtual interface

	// Events that stops the write and read operations 
	event write_ended;
	event read_ended;
	
	
	// Creating virtual interface handle 
	virtual memory_if mem_vif;
	
	
	// Creating Mailbox handle
	mailbox mbox;

	// Transcations Counter 
	int trans_count;
	
	// Constructor 
	function new(virtual memory_if mem_vif, mailbox mbox);

		// Geting the interface 
		this.mem_vif = mem_vif;
		
		// Getting the mailbox handle from  environment 
		this.mbox = mbox;

	endfunction //new()

	// Adding a reset task, which initializes the Interface signals to default values
	task reset();
	
		wait(!mem_vif.Rst_n);
		
		$display("Time = %0t --------- Drivier Reset Task Started --------- \n", $time);
		
		`DRIV_IF.Wr_En   <= 'b0;
		`DRIV_IF.Rd_En   <= 'b0;
		`DRIV_IF.Data_in <= 'b0;
		`DRIV_IF.Address <= 'b0;
		
		wait(mem_vif.Rst_n);
		$display("Time = %0t --------- Drivier Reset Task Ended   --------- \n", $time);
			
	endtask


	// Driving the transaction items to the memory interface 
	task drive();
		
		$display("T = %0t [Driver] Starting .... \n", $time);
		forever
		begin

			Transaction #(32,5)trans;
			
			`DRIV_IF.Wr_En <= 'b0;
			`DRIV_IF.Rd_En <= 'b0;
			
			mbox.get(trans);
			
			$display("\n --- [Driver-Transfer: %0d] --- ", trans_count);
		
			@(posedge mem_vif.DRIVER.CLK);
				`DRIV_IF.Address <= trans.Address;

			// Write Operation 
			if(trans.Wr_En)
			begin
			
				`DRIV_IF.Wr_En 	 <= trans.Wr_En;
				`DRIV_IF.Data_in <= trans.Data_in;
				
				$display("Time = %0t --------------- Write Operation --------------- ",$time);
				$display("Wr_En = %0d \t Address = %0d \t Data_in = %0h",trans.Wr_En, trans.Address, trans.Data_in);
				
				@(posedge mem_vif.DRIVER.CLK);
			end
		

			// Read Operation 
			if(trans.Rd_En)
			begin

				`DRIV_IF.Rd_En <= trans.Rd_En;
				
				@(posedge mem_vif.DRIVER.CLK);
				`DRIV_IF.Rd_En <= 'b0;
				
				@(posedge mem_vif.DRIVER.CLK);
				trans.Data_out  <= `DRIV_IF.Data_out;
				trans.Valid_out <= `DRIV_IF.Valid_out;
				
				$display("Time = %0t --------------- Read Operation --------------- ",$time);
				$display("Rd_En = %0d \t Address = %0d \t Data_out = %0h \t Valid_out = %d",trans.Rd_En, `DRIV_IF.Address, `DRIV_IF.Data_out, `DRIV_IF.Valid_out);

			end
			trans_count++;
		end


	endtask 

endclass //driver
