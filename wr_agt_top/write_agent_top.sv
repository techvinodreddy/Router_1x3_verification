/* ------------------------ write agent top ------------------------------------------- */
class write_agent_top extends uvm_env;
    `uvm_component_utils(write_agent_top);

    env_config cfg;
    write_agent write_agt[];

    extern function new(string name="write_agent_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

/* -------------------------- constructor ----------------------------------------- */
function write_agent_top::new(string name="write_agent_top",uvm_component parent);
	  super.new(name,parent);
endfunction 

/* ------------------------------- build phase ------------------------------------------------ */
function void write_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("write_agent_top","cannot get config data");

	write_agt=new[cfg.no_of_write_agent];

	foreach(write_agt[i]) write_agt[i]=write_agent::type_id::create($sformatf("write_agt[%0d]",i),this);
  
endfunction

/*-------------------------- run phase ----------------------------------------------*/
task write_agent_top::run_phase(uvm_phase phase);
    uvm_top.print_topology;
endtask
