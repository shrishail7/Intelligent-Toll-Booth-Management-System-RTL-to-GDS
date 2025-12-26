//================================================================
// MODULE: tb_toll_gate
// DESCRIPTION: Testbench for the toll_gate FSM module.
//              It simulates vehicle arrivals and tests different
//              transaction scenarios.
//================================================================
module tb_toll_gate;

    // Testbench signals
    // Inputs to the DUT are declared as 'reg'
    reg clk;
    reg reset;
    reg sensor_vehicle_enter;
    reg sensor_vehicle_exit;
    reg [7:0] vehicle_id_in;

    // Outputs from the DUT are declared as 'wire'
    wire barrier_open_cmd;
    wire barrier_close_cmd;
    wire [1:0] led_status;
    wire [7:0] display_out;

    // Instantiate the Device Under Test (DUT)
    // Connects the testbench signals to the toll_gate module's ports.
    toll_gate uut (
        .clk(clk),
        .reset(reset),
        .sensor_vehicle_enter(sensor_vehicle_enter),
        .sensor_vehicle_exit(sensor_vehicle_exit),
        .vehicle_id_in(vehicle_id_in),
        .barrier_open_cmd(barrier_open_cmd),
        .barrier_close_cmd(barrier_close_cmd),
        .led_status(led_status),
        .display_out(display_out)
    );

    // Clock Generation Block
    // Generates a clock with a 10ns period (100 MHz frequency).
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main Test Sequence Block
    initial begin
        // 1. Initialize all input signals to a known state
        reset = 1;
        sensor_vehicle_enter = 0;
        sensor_vehicle_exit = 0;
        vehicle_id_in = 8'h00;

        // 2. Apply and release reset
        // The reset is held high for 20ns to ensure all sequential
        // elements in the DUT are properly initialized.
        #20;
        reset = 0;
        #10;

        // 3. Setup signal monitoring
        // $monitor will print the signal values whenever any of them change.
        // This provides a clear log of the DUT's behavior.
        $monitor("Time=%0t | State=%s | Enter=%b, Exit=%b, ID_in=%h | OpenCmd=%b, CloseCmd=%b, LED=%b, Display=%s",
                 $time, uut.state, sensor_vehicle_enter, sensor_vehicle_exit, vehicle_id_in,
                 barrier_open_cmd, barrier_close_cmd, led_status, display_out);

        // --- SCENARIO 1: Successful Transaction (Vehicle ID: 01) ---
        $display("\n--- [START] SCENARIO 1: Vehicle with sufficient funds (ID: 01) ---");
        // A vehicle arrives at the entry sensor
        sensor_vehicle_enter = 1;
        vehicle_id_in = 8'h01; // This ID has a balance of 100
        #20; // Wait for FSM to read ID and check balance
        sensor_vehicle_enter = 0; // Vehicle has cleared the sensor
        #60; // Wait for the charge to complete and the gate to start opening

        // The barrier takes time to open. We wait for it to fully open.
        // The counter in barrier_ctrl needs 8 clock cycles (80ns) to reach the 'open' state.
        #100;
       
        // Vehicle passes through and triggers the exit sensor
        sensor_vehicle_exit = 1;
        #20;
        sensor_vehicle_exit = 0;

        // Wait for the barrier to fully close (another 80ns)
        #100;
        $display("--- [END] SCENARIO 1 ---");
        #40; // Idle time between vehicles

        // --- SCENARIO 2: Failed Transaction (Vehicle ID: 02) ---
        $display("\n--- [START] SCENARIO 2: Vehicle with insufficient funds (ID: 02) ---");
        // A new vehicle arrives
        sensor_vehicle_enter = 1;
        vehicle_id_in = 8'h02; // This ID has a balance of 5 (toll is 10)
        #20;
        sensor_vehicle_enter = 0;

        // Wait for the FSM to reject the transaction and return to IDLE.
        // The gate should NOT open.
        #40;
        $display("--- [END] SCENARIO 2 ---");
        #40; // Idle time

        // --- SCENARIO 3: Another Successful Transaction (Vehicle ID: 03) ---
        $display("\n--- [START] SCENARIO 3: Another vehicle with sufficient funds (ID: 03) ---");
        sensor_vehicle_enter = 1;
        vehicle_id_in = 8'h03; // This ID has a balance of 20
        #20;
        sensor_vehicle_enter = 0;
        #160; // Wait for charge and gate to open
       
        sensor_vehicle_exit = 1;
        #20;
        sensor_vehicle_exit = 0;

        #100; // Wait for gate to close
        $display("--- [END] SCENARIO 3 ---");

        // End the simulation
        #100;
        $display("\n--- Testbench Finished ---");
        $finish;
    end

endmodule
	

