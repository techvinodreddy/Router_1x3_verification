/* ------------------------ read agent top ------------------------------------------- */
class read_agent_top extends uvm_env;
    `uvm_component_utils(read_agent_top);

    env_config cfg;
    read_agent read_agt[];

    extern function new(string name="read_agent_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

/* -------------------------- constructor ----------------------------------------- */
function read_agent_top::new(string name="read_agent_top",uvm_component parent);
	  super.new(name,parent);
endfunction 

/* ------------------------------- build phase ------------------------------------------------ */
function void read_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("read_agent_top","cannot get config data");

	read_agt=new[cfg.no_of_read_agent];

	foreach(read_agt[i]) read_agt[i]=read_agent::type_id::create($sformatf("read_agt[%0d]",i),this);
  
endfunction

