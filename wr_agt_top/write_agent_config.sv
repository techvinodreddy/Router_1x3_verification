class write_agent_config extends uvm_object;

    `uvm_object_utils(write_agent_config) // factory registration

    virtual router_if vif;  // router interface as virtual vif

    static int driver_data_sent_count = 0; // keep track of how many data's driven by driven
    static int monitor_data_rcvd_count = 0; // keep track of how many data's monitor driven

    // setting wether agent has passive or active,
                                            // in active -- driver, monitor and sequencer is present
                                            // in passive -- only monitor is present

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    extern function new(string name = "write_agent_config");    

endclass : write_agent_config

function new(string name = "write_agent_config");
    super.new(name);
endfunction : new