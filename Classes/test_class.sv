//////////////////////////////////////////////////////////////
////////////////         Test Program          ///////////////
//////////////////////////////////////////////////////////////

// 1. Random Test 

program test(memory_if intf);

	class my_trans extends Transaction;
    
		bit [1:0] count;
		
		function void pre_randomize();
		  Wr_En.rand_mode(0);
		  Rd_En.rand_mode(0);
		  Address.rand_mode(0);
				
		  if(cnt %2 == 0) begin
			Wr_En = 1;
			Rd_En = 0;
			Address  = count;      
		  end 
		  else begin
			Wr_En = 0;
			Rd_En = 1;
			Address  = count;
			count++;
		  end
		  cnt++;
		endfunction
    
    endclass
	
	// Environment Class instance 
	environment env;
	my_trans    tr;
	
	initial
	begin
	
		// Environment Class handle Creation
		env = new(intf);
	
		tr = new();
		
		// Setting number of needed packets
		env.Seq.repeat_count = 50;				// Generate 15 packets
	
		// Calling the run test task from the Environment Class
		env.run();
		
	end
	
	
	
endprogram


/*
// 2. Write Read Test

	// postrandomize function, displaying randomized values of items 
	function void post_randomize();
		$display("--------- [Trans] post_randomize ------");
		if(Wr_En) $display("\t Address  = %0d\t wr_en = %d\t Data_in = %d",Address,Wr_En,Data_in);
		if(Rd_En) $display("\t Address  = %0h\t Rd_En = %d",Address,Rd_En);
		$display("-----------------------------------------");
	endfunction 
	
program test(mem_intf intf);
  
  class my_trans extends Transaction;
    
    bit [1:0] count;
    
    function void pre_randomize();
      Wr_En.rand_mode(0);
      Rd_En.rand_mode(0);
      Address.rand_mode(0);
            
      if(cnt %2 == 0) begin
        Wr_En = 1;
        Rd_En = 0;
        Address  = count;      
      end 
      else begin
        Wr_En = 0;
        Rd_En = 1;
        Address  = count;
        count++;
      end
      cnt++;
    endfunction
    
  endclass
    
  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(intf);
    
    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.drv.repeat_count = 10;
    
    env.drv.trans = my_tr;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram
*/
