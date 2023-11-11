//////////////////////////////////////////////////////////////
////////////////        Sequencer Class        ///////////////
//////////////////////////////////////////////////////////////
class Sequencer;

	rand Transaction #(32,5)trn;
	
	
	// Creating a Mailbox is used to send the randomized transaction to Driver
	mailbox mbox;
    
	// Adding a variable to control the number of random packets to be created
	int repeat_count;
	
	
	//  Adding an event to indicate the completion of the generation process, 
	//  the event will be triggered on the completion of the Generation process.
	event completed;
	
	
	// Constructor
	function new(mailbox mbox, event completed);			
        
		// getting the mailbox handle from env
		this.mbox   = mbox;
		this.completed = completed;
		
    endfunction //new()

	

	// Main task that creates and randomize the stimulus and puts into the mailbox
    task stimulus ();
	
		repeat(repeat_count)
		begin
		
			trn = new();
			// trn.randomize();
			if (!trn.randomize ()) $fatal("Gen::trans randomization field");
			trn.print("Stimulus");
			mbox.put(trn);
			#5;
		end
		-> completed;
    endtask 

endclass //Sequencer
