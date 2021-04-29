/* ----------------------------- write_driver ------------------------------ */
class write_driver extends uvm_driver #(write_transaction);
  `uvm_component_utils(write_driver);

  virtual router_if.write_driver_modport vif;
  write_agent_config write_cfg;

  extern function new(string name="write_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

/* ----------------------------- constructor new ------------------------------ */
function write_driver::new(string name="write_driver",uvm_component parent);
    super.new(name,parent);
endfunction : new

/* ----------------------------- build_phase ------------------------------ */
function void write_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(write_agent_config)::get(this,"","write_config",write_cfg))
		`uvm_fatal("write_driver","cannot get config data");
  super.build_phase(phase);
endfunction : build_phase

function void write_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=write_cfg.vif;
endfunction