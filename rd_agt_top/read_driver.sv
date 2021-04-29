/* ----------------------------- read_driver ------------------------------ */
class read_driver extends uvm_driver #(read_transaction);
  `uvm_component_utils(read_driver);

  virtual router_if.read_driver_modport vif;
  read_agent_config read_cfg;

  extern function new(string name="read_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

/* ----------------------------- constructor new ------------------------------ */
function read_driver::new(string name="read_driver",uvm_component parent);
    super.new(name,parent);
endfunction : new

/* ----------------------------- build_phase ------------------------------ */
function void read_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(read_agent_config)::get(this,"","read_config",read_cfg))
		`uvm_fatal("read_driver","cannot get config data");
  super.build_phase(phase);
endfunction : build_phase

function void read_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=read_cfg.vif;
endfunction