/* --------------------- write monitor ----------------------------------------- */
class write_monitor extends uvm_monitor;
  `uvm_component_utils(write_monitor);

  virtual router_if.write_monitor_modport vif;

  write_agent_config write_cfg;

  uvm_analysis_port #(write_transaction) write_analysis_port;

  write_transaction write_xtn;

  extern function new(string name="write_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  
endclass

/* ----------------------------- constructor new ------------------------------ */
function write_monitor::new(string name="write_monitor",uvm_component parent);
    super.new(name,parent);
    write_analysis_port = new("write_analysis_port",this);
endfunction : new

/* ----------------------------- build_phase ------------------------------ */
function void write_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db #(write_agent_config)::get(this,"","write_config",write_cfg))
		`uvm_fatal("write_monitor","cannot get config data");
  super.build_phase(phase);
endfunction : build_phase

function void write_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=write_cfg.vif;
endfunction