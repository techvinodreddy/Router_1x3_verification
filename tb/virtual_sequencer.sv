class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(virtual_sequencer);
    write_sequencer w_seqr[];
    env_config cfg;
    read_sequencer r_seqr[];
extern function new(string name="virtual_sequencer",uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass

function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("VIRTUAL_SEQUENCER","cannot get config data");
    super.build_phase(phase);
	w_seqr=new[cfg.no_of_sources];
	r_seqr=new[cfg.no_of_clients];
endfunction



