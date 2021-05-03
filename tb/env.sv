/* -------------------------- env class ----------------------------------------- */
class env extends uvm_env;
  `uvm_component_utils(env)

  env_config cfg;
  write_agent_top write_agt_top[];
  read_agent_top read_agt_top[];
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

    super.build_phase(phase);

    // ----------------------------- write agt top---------------------------------
    if(cfg.has_write_agent_top)
    begin
      write_agt_top = new[cfg.has_write_agent_top];

      // uvm config db set method hear and get method in lower level components
      uvm_config_db #(write_agent_config)::set(this,$sformatf("write_agt_top[%0d]*",i),  "write_agent_config", cfg.write_cfg[i]);

      uvm_config_db #(ram_wr_agent_config)::set(this,$sformatf("wagt_top[%0d]*",i),  "ram_wr_agent_config", m_cfg.m_wr_agent_cfg[i]);

      foreach(write_agt_top[i]) write_agt_top[i] = write_agent_top::type_id::create($sformatf("write_agt_top[%0d]",i),this);
    end
    
    // ----------------------------- read agt top---------------------------------
    if(cfg.has_read_agent_top)
    begin
      read_agt_top = new[cfg.has_read_agent_top];

      // uvm config db set method hear and get method in lower level components
      uvm_config_db #(read_agent_config)::set(this,$sformatf("read_agt_top[%0d]*",i),  "read_agent_config", cfg.read_cfg[i]);

      foreach(read_agt_top[i]) read_agt_top[i] = read_agent_top::type_id::create($sformatf("read_agt_top[%0d]",i),this);
    end
endfunction

/*-----------------------------------------connect phase-----------------------------------------*/
