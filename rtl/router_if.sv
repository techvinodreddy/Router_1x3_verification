interface router_if(input bit clock);

    logic [7:0] data_in;
    logic [7:0] data_out;
    logic rst;
    logic err;
    logic busy;
    logic read_enb;
    logic vld_out;
    logic pkt_valid;

    
    clocking write_driver_clocking @(posedge clock);    // write driver clocking block
        default input #1 output #1;
        output data_in;
        output pkt_valid;
        output rst;
        input err;
        input busy;
    endclocking : write_driver_clocking

    
    clocking read_driver_clocking @(posedge clock);     // read driver clocking block
        default input #1 output #1;
        output read_enb;
        input vld_out;
    endclocking : read_driver_clocking

    modport write_driver_modport(clocking write_driver_clocking);       // modport for write driver

    modport read_driver_modport(clocking read_driver_clocking);       // modport for read driver

    clocking write_monitor_clocking @(posedge clock);    // write monitor clocking block
        default input #1 output #1;
        input data_in;
        input pkt_valid;
        input rst;
        input err;
        input busy;
    endclocking : write_monitor_clocking

    clocking read_monitor_clocking @(posedge clock);    // read monitor clocking block
        default input #1 output #1;
        input data_out;
        input read_enb;
    endclocking : read_monitor_clocking

    modport write_monitor_modport(clocking write_monitor_clocking);       // modport for write monitor

    modport read_monitor_modport(clocking read_monitor_clocking);       // modport for read monitor

endinterface : router_if