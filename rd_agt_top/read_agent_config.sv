class read_agent_config extends uvm_object;

  `uvm_object_utils(read_agent_config)

  uvm_active_passive_enum is_active=UVM_ACTIVE;

  static int write_driver_packet_send_count = 0;
  static int write_monitor_packet_received_count = 0;


  virtual router_if vif;

  extern function new(string name="read_agent_config");

endclass

function read_agent_config::new(string name="read_agent_config");
	super.new(name);
endfunction
