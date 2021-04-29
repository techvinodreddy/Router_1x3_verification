/*-------------------------- write agent ----------------------------------------------*/
class write_agent extends uvm_agent;
  `uvm_component_utils(write_agent);
  uvm_sequencer#(write_transaction) w_seqr;
  router_wr_dr w_dr;
  router_wr_mon w_mon;
  write_agent_config w_cfg;i
  extern function new(string name="write_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass