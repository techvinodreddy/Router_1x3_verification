***
# Router 1x3 Verification using UVM along with RTL 
## Interface 
    An interface is a bundle of signals or nets through which a testbench communicates with a design.
SystemVerilog adds the interface construct which encapsulates the communication between blocks.
A virtual interface is a variable that represents an interface instance, this section describes the interface, interface over traditional method and virtual interface.

It is written in RTL Folder

In interface we want to write clocking block and modport for ti give direction and synchronization.

Basic Syntax
  ```verilog
  interface if_name;
      ---------
      ---------
      //necessary signals are present

      clocking // defines the sync
      modport  // defines the direction

      // generally in clocking block itself the direction  of signals is declared and it is used al modport
      ---------
      ---------
  endinterface : if_name 
  ```
  **Before building uvm_component class we required the uvm_sequence class**

  ---

## Transaction 

    For transferring data packets to driver from sequence we need one datatype (class) in that all members which are required to generate a packet are there.

For write 1 transaction is used 1 for read one transaction is used.

The process required for writing transaction are:

- extend class with uvm_sequence_item
- factory registration with uvm_ogject_utils
- declare class property or members 
- constructor new ( pass sumer.new() )
- Two ways, any one is use ( mostly second method is used )

  1. factory registration of class members with ***uvm field macros*** user_defined function are not necessary.
  2. define user_define functions like ***do_copy, do_compare, do_print*** and many more [ all methods are not necessary ].

If we required two transaction like write and read then repeat this process two times.


After creating write and read transaction class we need to pass it **uvm_sequence in here the transaction is generated and randomized and by using uvm_sequencer this generated packet(transaction) send to driver using seq_item_port.**

---
## Sequences [ Transaction's ] 

![uvm_sequencer process](https://drive.google.com/file/d/1Z7VOoN63wjKyN6GnIq1DrZCr3dcYuP8B/view "uvm_sequencer process")




    A sequence generates a series of sequence_item’s and sends it to the driver via sequencer, Sequence is written by extending the uvm_sequence.

- A uvm_sequence is derived from an uvm_sequence_item.

- A sequence is parameterized with the type of sequence_item, this defines the type of the item sequence that will send/receive to/from the driver.

- **req/request** A transaction that provides information to initiate the processing of a particular operation.

- **rsp/response** A transaction that provides information about the completion or status of a particular operation.

- **Sequence Execution**
    Most important properties of a sequence are,

     - body method
     - m_sequencer handle

## body method
    body method defines, what the sequence does.

## m_sequencer handle
    The m_sequencer handle contains the reference to the sequencer on which the sequence is running.

  ```verilog
  sequence_name.start(sequencer_name);
  ```
  The sequence will get executed upon calling the start of the sequence from the test.

  ### sequencer_name specifies on which sequencer sequence has to run.

  - There are Methods, macros and pre-defined callbacks associated with uvm_sequence.

  - Users can define the methods(task or function) to pre-defined callbacks, these methods will get executed automatically upon calling the start of the sequence.

  - These methods should not be called directly by the user.

  Below block diagram shows the order in which the methods will get called on calling the start of a sequence.

  ![uvm_sequence_calbacks](file:///home/vinodreddy/Desktop/Router%201x3%20project/router%201x3%20verification/codev3/readme/assets/uvm_sequence_callback.png "uvm_sequence_calbacks")



    mid_do and post_do are functions, All other are tasks.
---
## Starting The Sequence
    Logic to generate and send the sequence_item will be written inside the body() method of the sequence.

The handshake between the sequence, sequencer and driver to send the sequence_item is given below.

![uvm_sequence_driver_handshake](file:///home/vinodreddy/Desktop/Router%201x3%20project/router%201x3%20verification/codev3/readme/assets/uvm_sequence_driver_handshake.png "uvm_sequence_driver_handshake")

### Communication between the Sequence and driver involves below steps,

    1.create_item() / create req.
    2.wait_for_grant().
    3.randomize the req.
    4.send the req.
    5.wait for item done.
    6.get response.

 **Step 5 and 6 are optional.**
 
 seq driver communication without response stage
 ![uvm_sequence_driver_handshake](file:///home/vinodreddy/Desktop/Router%201x3%20project/router%201x3%20verification/codev3/readme/assets/uvm_sequence_driver_handshake_item_done.png "uvm_sequence_driver_handshake optional")

 Method call
 1. ***create_item()***
    ```verilog
    req = **_seq_item::type_id::create(“req”);
    ```
    Create and initialize* a sequence_item or sequence.

    Initialize – initialized to communicate with the specified sequencer.

2. ***wait_for_grant()***

    This method call is blocking, Execution will be blocked until the method returns.

      - This method issues a request to the current sequencer.
      - The sequencer grants on getting get_next_item() request
        from driver.

3. ***req.randomize()***	

    This method is to randomize the sequence_item 
    
    ```verilog 
    send_request(req,re-randomize) re-randomize = 0 or re-randomize = 1;
    ```

    Send the request item to the sequencer, which will forward it to the driver.

    If the re-randomize the bit is set, the item will be randomized before being sent to the driver.
4. ***wait_for_item_done()***	

    This call is optional.

    This task will block until the driver calls item_done or put, get_current_item()	Returns the request item currently being executed by the sequencer.

    If the sequencer is not currently executing an item, this method will return null, get_response(rsp)	receives the response from driver.

5. ***get_current_item()***	

    Returns the request item currently being executed by the sequencer.

    If the sequencer is not currently executing an item, this method will return null.
    get_response(rsp) receives the response from driver.

6. ***get_response(rsp)***	

    Receives the response from driver.

---
## virtual sequence

 [ToDo]

---
## Sequencer

    uvm_sequencer is responsible for the coordination between sequence and driver.

- Sequencer sends the transaction to driver and gets the response from the driver. 

- The response transaction from the driver is optional. 

- When multiple sequences are running in parallel, then sequencer is responsible for arbitrating between the parallel sequences. 

There are two types of sequencers : uvm_sequencer and uvm_push_sequencer

    In sequencer class just extends from uvm_sequencer which is parm class #(pass_ transaction_class)

---

## Difference between m_sequencer and p_sequencer

***m_sequencer***

    The m_sequencer handle contains the reference to the sequencer(default sequencer) on which the sequence is running.

This is determined by,

- The sequencer handle provided in the start method.
- The sequencer used by the parent sequence.
- The sequencer that was set using the set_sequencer method.

***p_sequencer***

    The p_sequencer is a variable, used as a handle to access the sequencer properties.
p_sequencer is defined using the macro 

```verilog
`uvm_declare_p_sequencer(SEQUENCER_NAME)
```

![uvm_sequence_driver_handshake](file:///home/vinodreddy/Desktop/Router%201x3%20project/router%201x3%20verification/codev3/readme/assets/uvm_sequencer_agt.png "uvm_sequencer connection")

---

## Driver

A driver is written by extending the uvm_driver.

- uvm_driver is inherited from uvm_component, Methods and TLM port (seq_item_port and seq_item_export) are defined for communication between sequencer and driver.

- The uvm_driver is a parameterized class and it is parameterized with the type of the request sequence_item and the type of the response sequence_item.

There are different driver methods to keep communication cool, they are

**get_next_item**

    This method blocks until a REQ sequence_item is available in the sequencer.

**try_next_item**

    This is a non-blocking variant of the get_next_item() method. It will return a null pointer if there is no REQ sequence_item available in the sequencer.

**item_done**

    The non-blocking item_done() method completes the driver-sequencer handshake and it should be called after a get_next_item() or a successful try_next_item() call.

**put**

    The put() method is non-blocking and is used to place an RSP sequence_item in the sequencer.

---

## Monitor

    A UVM monitor is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components. 
    
**monitor is derived from uvm_monitor class, and it has following features**
- Collect bus or signal information through a virtual interface.
- Collected data can be used for protocol checking and coverage.
- Collected data is exported via an analysis port.

---

## Agent

- A user-defined agent is extended from uvm_agent, uvm_agent is inherited by uvm_component.

- An agent typically contains a driver, a sequencer, and a monitor.

- Agents can be configured either active or passive.

**Active Agent**  

Active agents generate stimulus and drive to DUT,
An active agent shall consists of all the three components driver, sequencer, and monitor.

**Passive Agent**

Passive agents sample DUT signals but do not drive them.
A passive agent consists of only the monitor.

An agent can be configured as ACTIVE/PASSIVE by using a set config method, the default agent will be ACTIVE. the set config can be done in the env or test.

```verilog
set_config_int("path_to_agent", "is_active", UVM_ACTIVE);
set_config_int("path_to_agent", "is_active", UVM_PASSIVE);
```

**get_is_active()** returns UVM_ACTIVE if the agent is acting as an active agent and UVM_PASSIVE if the agent acting as a passive agent.

## Writing UVM Agent

**An agent is written by extending UVM_agent**

```verilog
class mem_agent extends uvm_agent;
 
  // UVM automation macros for general components
  `uvm_component_utils(mem_agent)
 
  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
endclass : mem_agent
```

**Declare driver, sequencer and monitor instance**
```verilog
//declaring agent components
mem_driver    driver;
mem_sequencer sequencer;
mem_monitor   monitor;
```
**Depending on Agent type, create agent components in the build phase,driver and sequencer will be created only for the active agent***
```verilog
// build_phase
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 
  if(get_is_active() == UVM_ACTIVE) begin
    driver = mem_driver::type_id::create("driver", this);
    sequencer = mem_sequencer::type_id::create("sequencer", this);
  end

 
  monitor = mem_monitor::type_id::create("monitor", this);
endfunction : build_phase
```

**Connect the driver seq_item_port to sequencer seq_item_export for communication between driver and sequencer in the connect phase**
```verilog
// connect_phase
function void connect_phase(uvm_phase phase);
  if(get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase
```

---

## Agent Top

**It is container of agent's** for example there are three agent's  in order to controll them eeasily we want to put it in some container and this is termed as **Agent Top.**

    It is extended from uvm_top

---




           



