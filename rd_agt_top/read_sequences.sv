/* ---------------------- base class for sequences ---------------------------- */
class read_sequences  extends uvm_sequence #(read_xtn);
  `uvm_object_utils(read_sequences);
  extern function new(string name="read_sequences");
endclass

/* ---------------------- constructor new ---------------------------- */
function read_sequences::new(string name="read_sequences");
	super.new(name);
endfunction

/* ---------------------- extended class from base class ---------------------------- */
class read_sequences_1  extends uvm_sequence #(read_xtn);
  `uvm_object_utils(read_sequences_1);
  extern function new(string name="read_sequences_1");
  extern task body;
endclass

/* ---------------------- constructor new ---------------------------- */
function read_sequences_1::new(string name="read_sequences_1");
	super.new(name);
endfunction

/* ---------------------- task body ---------------------------- */
task read_sequences_1::body;
	req=read_xtn::type_id::create("read_sequences_1");
	start_item(req);
	assert(req.randomize);
	finish_item(req);
endtask
