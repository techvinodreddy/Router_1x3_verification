/* ---------------------- base class for sequences ---------------------------- */
class write_sequences extends uvm_sequence #(write_transaction);
  `uvm_object_utils(write_sequences);
  extern function new(string name="write_sequences");
endclass

/* ---------------------- constructor new ---------------------------- */
function write_sequences::new(string name="write_sequences");
	super.new(name);
endfunction

/* ---------------------- small packet - extended class from base class ---------------------------- */
class small_packet extends write_sequences;
  `uvm_object_utils(small_packet);
  bit [1:0]addr;  // it is used inside task body
  extern function new(string name="small_packet");
  extern task body;
endclass

/* ---------------------- constructor new ---------------------------- */
function small_packet::new(string name ="small_packet");
	super.new(name);
endfunction


/* ---------------------- task body ---------------------------- */
task small_packet::body;
	req=write_transaction::type_id::create("req");
	start_item(req);
	assert( req.randomize with {header[7:2] inside { [1:15] && header[1:0] == addr; } } );
	finish_item(req);
endtask