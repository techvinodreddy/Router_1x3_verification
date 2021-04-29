/* ---------------------- write transaction class ---------------------------- */
class write_transaction extends uvm_sequence_item;
    
  `uvm_object_utils(write_transaction);

   rand bit[7:0]header;
   rand bit[7:0]payload_data[];
   bit [7:0] parity;
  
   constraint O{payload_data.size ==header[7:2];}
   constraint Y{header[1:0]!=3;}
  
   extern function new(string name = "write_transaction");
   extern function void do_copy(uvm_object rhs);
   extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
   extern function void do_print(uvm_printer printer);
   extern function void post_randomize();

endclass : write_transaction
  
/* ---------------------- constructor new ---------------------------- */
function write_transaction::new(string name = "write_transaction");
    super.new(name);
endfunction : new

/* ---------------------- do copy() method ---------------------------- */
function void write_transaction::do_copy (uvm_object rhs);
    super.do_copy(rhs);

    write_transaction rhs_;
    
    if(!$cast(rhs_,rhs)) `uvm_fatal("do_copy","cast of the rhs object failed")
        
    header= rhs_.header;
    foreach(payload_data[i]) payload_data[i]= rhs_.payload_data[i];
    parity= rhs_.parity;
endfunction : do_copy

/* ---------------------- do compare() method ---------------------------- */
function bit  write_transaction::do_compare (uvm_object rhs,uvm_comparer comparer);  
    write_transaction rhs_;
    
    if(!$cast(rhs_,rhs)) 
    begin
        `uvm_fatal("do_compare","cast of the rhs object failed")
        return 0;
    end
    
    return super.do_compare(rhs,comparer) &&
    header== rhs_.header &&
    parity== rhs_.parity;
endfunction : do_compare 

/* ---------------------- do print() method ---------------------------- */
function void  write_transaction::do_print (uvm_printer printer);
    `uvm_info("write transaction","printing the packet info",UVM_LOW)
    printer.print_field( "header", 		this.header, 	    8,		 UVM_BIN		);
      
    foreach(payload_data[i]) printer.print_field( $sformatf("payload_data[%0d]",i), this.payload_data[i], 	    8,		 UVM_DEC		);
        
    printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
endfunction : do_print

/* ---------------------- post reanomize() method ---------------------------- */    
function void write_transaction::post_randomize();
    `uvm_info("write transaction post_randomize()","calculating the parity [error checking]",UVM_LOW)
    parity=header;
    foreach(payload_data[i]) parity=payload_data[i]^parity;
endfunction : post_randomize
  
  