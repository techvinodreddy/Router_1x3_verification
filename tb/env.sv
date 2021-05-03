/* -------------------------- env class ----------------------------------------- */
class env extends uvm_env;
  `uvm_component_utils(env)

  env_config cfg;
  write_agent_top write_agt_top;
  read_agent_top read_agt_top;
  // virtual sequencer
  //scoreboard

  extern function new(string name="env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : env

/* -------------------------- constructor ----------------------------------------- */
function write_agent_top::new(string name="write_agent_top",uvm_component parent);
	  super.new(name,parent);
endfunction

/* ------------------------------- build phase ------------------------------------------------ */
function void write_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("write_agent_top","cannot get config data");

  if(cfg.has_write_agent_top) write_agt_top = write_agent_top::type_id::create("write_agt_top",this);
  if(cfg.has_read_agent_top) read_agt_top = read_agent_top::type_id::create("read_agt_top",this);
  /*-----------------------------------virtual sequencer and scoreboard------------------------------------*/
  //if(cfg.has_read_agent_top) read_agt_top = read_agent_top::type_id::create("read_agt_top",this);
  //if(cfg.has_read_agent_top) read_agt_top = read_agent_top::type_id::create("read_agt_top",this);
  
endfunction