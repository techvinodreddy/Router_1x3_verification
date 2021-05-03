/* ---------------------------------- scoreboard -------------------------------------------------- */
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard);

    uvm_tlm_analysis_fifo#(write_transaction) tlm_write;
    uvm_tlm_analysis_fifo#(read_transaction) tlm_read[];

    env_config cfg;
    write_transaction w_xtn;
    read_transaction r_xtn1, r_xtn2, r_xtn3;

    write_transaction write_cov_data;
    read_transaction read_cov_data;

    covergroup router_fcov1;
        option.per_instance=1;
        //Address
        CHANNEL : coverpoint write_cov_data.header [1:0] { bins low = {2'b00};
                                                           bins mid1 = {2'b01};
                                                           bins mid2 = {2'b10};  }

        //payload size
        PAYLOAD_SIZE : coverpoint write_cov_data.header [7:0] {
                                                              bins small_packet = {[1:15]};
                                                              bins medium_packet = {[16:30]};
                                                              bins large_packet = {[31:63]};

        CHANNEL_X_PAYLAOD_SIZE : cross CHANNEL,PAYLOAD_SIZE;
    endgroup

    covergroup router_fcov2;
      option.per_instance = 1;

      //Address
      CHANNEL : coverpoint read_cov_data.header[1:0] {        bins low = {2'b00};
                                                              bins mid1 ={2'b01};
                                                              bins mid2 ={2'b10};     }

      //payload size
      PAYLOAD_SIZE : coverpoint read_cov_data.header[7:0] {   bins small_packet = {[1:15]};
                                                              bins medium_pakcet = {[16:30]};
                                                              bins large_packet ={[31:63]};   }

      CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL,PAYLOAD_SIZE;

    endgroup

    extern function new(string name="scoreboard",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase);
    extern task check_(read_transaction rd);
endclass

/* ---------------------------------- constructor -------------------------------------------------- */
function scoreboard::new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
endfunction

/* ---------------------------------- build phase -------------------------------------------------- */
function void scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("scoreboard","cannot get config data");

	tlm_write=new[cfg.no_of_write_agent];
  tlm_read=new[cfg.no_of_read_agent];
  foreach(tlm_write[i]) tlm_write[i] = new($sformatf("tlm_write[%0d]",i),this);
	foreach(tlm_read[i]) tlm_read[i] = new($sformatf("tlm_read[%0d]",i),this);
	super.build_phase(phase);
endfunction

/* ---------------------------------- run phase -------------------------------------------------- */
task scoreboard::run_phase(uvm_phase);
	fork
    begin
      forever tlm_write.get(w_xtn);  
    end

		forever 
      begin
        fork:A
          begin 
            tlm_read[0].get(r_xtn1);
            check_(r_xtn1);
          end
          begin 
            tlm_read[1].get(r_xtn2);
            check_(r_xtn2);
          end
          begin 
            tlm_read[2].get(r_xtn3);
            check_(r_xtn3);
          end
        join_any
			  disable A;
			end
	join
endtask

/* ---------------------------------- check -------------------------------------------------- */
task scoreboard::check_(read_transaction rd);
	if(rd.header==w_xtn.header)
	begin
	foreach(rd.payload_data[i])
		if(rd.payload_data[i]!=w_xtn.payload_data[i])
		begin 
		$display("----------------------------------WRONG DATA-------------------------------");
		return;
		end
	end
	else
	begin  $display("---------------------------HEADER MISMATCH------------------------------------");
	return;
	end
	if(rd.parity==w_xtn.parity)
	$display("----------------------------------GOOD PACKET-------------------------------------------");
	else
	$display("------------------------------------BAD PACKET------------------------------------------");
endtask