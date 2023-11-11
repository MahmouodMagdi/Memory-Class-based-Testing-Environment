//////////////////////////////////////////////////////////////
////////////////       Environment Class       ///////////////
//////////////////////////////////////////////////////////////
class environment;

/*
	It is a container class, contains Mailbox, Sequencer, and Driver calsses

*/


	// Sequencer, Driver, Monitor and Subscriber Instances 
	Sequencer  Seq ;
	driver 	   drv ;
	Monitor    mont;
	Scoreboard scb ;
	

	
	// Virtual interface 
	virtual memory_if mem_vif;
	
	// Mailbox handle
	mailbox mbox;
	mailbox mon_to_scb;
	
	
	// Synchronize between the Drvier and the Sequencer through an Event
	event sync;
	
	
	function new(virtual memory_if mem_vif );
	
		// Get the interface from the test
		this.mem_vif = mem_vif;
		
		// Creating a mailbox handle, it will be shared across the Sequencer and Driver
		mbox = new();
		mon_to_scb = new();
		
		
		// Creating the Sequencer, Driver, Monitor, and Scoreboard
		Seq  = new(mbox, sync);
		drv  = new(mem_vif, mbox);
		mont = new(mem_vif, mon_to_scb);
		scb  = new(mon_to_scb);
		
	endfunction

	/*
	
		For better accessibility: I will divide the test operation on 3 tasks
		
		1. pre-test  task --> Method to call the initialization reset task
		2. test      task --> Method to generate the stimulus and drive it to the memory interface 
		3. post-test task --> Method to wait for the compeletion of the Sequencer and Driver operations 
	
	*/
	
	task pre_test();
	
		drv.reset();
	
	endtask
		
	
	task test;
	
		fork
		
			Seq.stimulus();
			drv.drive();
			mont.mont_task();
			scb.scb_task();
		
		join_any
		
	endtask
	
	
	task post_test;
	
		wait(sync.triggered);
		wait(Seq.repeat_count == drv.trans_count);
		wait(Seq.repeat_count == scb.trans_count);
		
	endtask


	// Test Run Task 
	task run();
	
		pre_test();
		test();
		post_test();
		
		$finish;
	
	endtask
	
endclass	// environment
