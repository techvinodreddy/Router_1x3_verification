/*-------------------------- write agent ----------------------------------------------*/
class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent);
  write_agent_config write_cfg;

  write_driver wr_drv;
  write_monitor wr_mon;
  write_sequencer wr_seqr;

  extern function new(string name="write_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

/*-------------------------- constructor ----------------------------------------------*/
function write_agent::new(string name="write_agent",uvm_component parent);
    super.new(name,parent);
endfunction : new

/*-------------------------- build phase ----------------------------------------------*/
function void write_agent::build_phase(uvm_phase phase);
    if(!uvm_config_db #(write_agent_config)::get(this,"","write_config",write_cfg))
		`uvm_fatal("write_agent","cannot get config data");
    super.build_phase(phase);
    wr_mon = write_monitor::type_id::create("wr_mon",this);

    if(write_cfg.is_active == UVM_ACTIVE)
          begin
                  wr_drv = write_driver::type_id::create("wr_drv",this);
                  wr_seqr == write_sequencer::type_id::create("wr_seqr",this);
          end
endfunction : build_phase

/*-------------------------- connect phase ----------------------------------------------*/
function void write_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
endfunction

