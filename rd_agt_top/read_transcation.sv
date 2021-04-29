/* ---------------------- read transaction class ---------------------------- */
class read_transaction extends uvm_sequence_item;
  `uvm_object_utils(read_transaction);

  bit [7:0]header;
  bit [7:0]payload_data[];
  bit [7:0]parity;
  rand bit [5:0]no_of_cycles;
    
  constraint RD{no_of_cycles inside {[1:25]};}

  extern function new(string name="read_transaction");
  extern function void  do_print (uvm_printer printer);
  
endclass

/* ---------------------- constructor new ---------------------------- */
function read_transaction::new(string name="read_transaction");
    super.new(name);
endfunction : new

/* ---------------------- do print() method ---------------------------- */
function void  read_transaction::do_print (uvm_printer printer);
  `uvm_info("read transaction","printing the packet info",UVM_LOW)
  super.do_print(printer); 
  printer.print_field( "header", 		this.header, 	    8,		 UVM_DEC		);
  foreach(payload_data[i])
    printer.print_field( $sformatf("payload_data[%0d]",i), this.payload_data[i], 	    8,		 UVM_DEC		);
    
    printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
endfunction:do_print


