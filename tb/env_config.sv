class env_config extends uvm_object;

`uvm_object_utils(env_config)

bit has_write_agent_top = 1;
bit has_read_agent_top = 1;
int no_of_write_agent = 1;
int no_of_read_agent = 3;
bit has_virtual_sequencer = 1;
bit has_scoreboard = 1;

write_agent_config write_cfg[];
read_agent_config read_cfg[];

extern function new(string name="env_config");

endclass

function router_env_config::new(string name="env_config");
	super.new(name);
endfunction
