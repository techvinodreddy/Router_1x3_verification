/* ---------------------- read sequencer class ---------------------------- */
class read_sequencer extends uvm_sequencer #(read_transaction);
  `uvm_component_utils(read_sequencer);
  extern function new(string name="read_sequencer",uvm_component parent);
endclass

/* ---------------------- constructor new ---------------------------- */
function read_sequencer::new(string name="read_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
