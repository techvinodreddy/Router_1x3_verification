/* --------------------- virtual sequences ------------------------------------- */
class virtual_sequences extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(virtual_sequences);
    virtual_sequencer v_seqr;
    write_sequencer w_seqr[];
    read_sequencer r_seqr[];
    env_config cfg;

    extern function new(string name="virtual_sequences");
    extern task body;
endclass : virtual_sequences

/* --------------------- constructor ------------------------------------- */
function router_virtual_sequence::new(string name="virtual_sequences");
	super.new(name);
endfunction

/* --------------------- body ------------------------------------- */
task virtual_sequences::body;
	if(!uvm_config_db#(env_config) ::get(null,get_full_name(),"env_config",cfg))
		`uvm_fatal("virtual_sequences","cannot get cfg");

	$cast(v_seqr,m_sequencer);

	w_seqr=new[cfg.no_of_write_agent];
	r_seqr=new[cfg.no_of_read_agent];

	foreach(w_seqr[i]) w_seqr[i]=v_seqr.w_seqr[i];
	foreach(r_seqr[i]) r_seqr[i]=v_seqr.r_seqr[i];
endtask

/* ---------------------- small packet - extended class from base class ---------------------------- */
class virtual_small_packet extends write_sequences;
  `uvm_object_utils(virtual_small_packet);
  bit [1:0]addr;  // it is used inside task body
  
  write_sequence w_seq[];
  read_sequence r_seq[];

  extern function new(string name="virtual_small_packet");
  extern task body;
endclass

/* ---------------------- constructor new ---------------------------- */
function virtual_small_packet::new(string name ="virtual_small_packet");
	super.new(name);
endfunction

task router_virtual_sequence_c1::body;
	super.body;
	w_seq=small_packet::type_id::create("w_seq");
	r_seq=new[cfg.no_of_read_agent];
	foreach(r_seq[i]) r_seq[i] = read_sequences_1::type_id::create($sformatf("r_seq[%0d]",i));
	fork:a
		begin		// write thread 
		  foreach(w_seqr[i]) w_seq.start(w_seqr[i]);
		end

		begin		// read thread
		  fork:b
		  	r_seq[0].start(r_seqr[0]);
			r_seq[1].start(r_seqr[1]);
			r_seq[2].start(r_seqr[2]);
		  join_any
		  disable b;
		end
	join

