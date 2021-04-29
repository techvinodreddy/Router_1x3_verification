/* --------------------- read monitor ----------------------------------------- */
class read_monitor extends uvm_monitor;
  `uvm_component_utils(read_monitor);

  virtual router_if.read_monitor_modport vif;

  read_agent_config read_cfg;

  uvm_analysis_port #(read_transaction) read_analysis_port;

  read_transaction read_xtn;

  extern function new(string name="read_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  
endclass

/* ----------------------------- constructor new ------------------------------ */
function read_monitor::new(string name="read_monitor",uvm_component parent);
    super.new(name,parent);
    read_analysis_port = new("read_analysis_port",this);
endfunction : new

/* ----------------------------- build_phase ------------------------------ */
function void read_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db #(read_agent_config)::get(this,"","read_config",read_cfg))
		`uvm_fatal("read_monitor","cannot get config data");
  super.build_phase(phase);
endfunction : build_phase

function void read_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=read_cfg.vif;
endfunction