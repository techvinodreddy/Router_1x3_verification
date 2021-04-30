/*-------------------------- read agent ----------------------------------------------*/
class read_agent extends uvm_agent;
  `uvm_component_utils(read_agent);
  read_agent_config read_cfg;

  read_driver rd_drv;
  read_monitor rd_mon;
  read_sequencer rd_seqr;

  extern function new(string name="read_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

/*-------------------------- constructor ----------------------------------------------*/
function read_agent::new(string name="read_agent",uvm_component parent);
    super.new(name,parent);
endfunction : new

/*-------------------------- build phase ----------------------------------------------*/
function void read_agent::build_phase(uvm_phase phase);
    if(!uvm_config_db #(read_agent_config)::get(this,"","read_config",read_cfg))
		`uvm_fatal("read_agent","cannot get config data");
    super.build_phase(phase);
    rd_mon = read_monitor::type_id::create("rd_mon",this);

    if(read_cfg.is_active == UVM_ACTIVE)
          begin
                  rd_drv = read_driver::type_id::create("rd_drv",this);
                  rd_seqr == read_sequencer::type_id::create("rd_seqr",this);
          end
endfunction : build_phase

/*-------------------------- connect phase ----------------------------------------------*/
function void read_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
endfunction
