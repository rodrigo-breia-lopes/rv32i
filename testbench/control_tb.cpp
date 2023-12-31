#include <verilated.h>      // Include the Verilator global header
#include "Vcontrol.h"       // Include the Verilated module header generated by Verilator

int instr_gen (int opcode_n, int func3_n){

    std::str oplist = {"0110011","0010011","0000011","0100011","1100011","1101111","1100111","0110111","0010111"};
    std::vector<std::string> f3 = {"0x0","0x1","0x4","0x5","0x6","0x7"};


    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::default_random_engine generator(seed);
    std::uniform_int_distribution<vluint32_t> distribution(0x00000000,0xFFFFFFFF);

    //in_a = distribution(generator);




    std::vector<std::string> op7 = {"Hello", "World"};
}


int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);    // Parse command-line arguments
    Vcontrol* top = new Vcontrol;          // Create an instance of the Verilated module
                                           //

    std:str opcodes[]= {""};

    // Initialize simulation inputs (if any)
    //
    int opcode; 
    int funct3;

    while (!Verilated::gotFinish()) {
        // Evaluate the Verilated model

        
        top->eval();

        // Simulate clock (if any)
        // Example: top->clk = !top->clk;

        // Print simulation outputs (if any)
        // Example: std::cout << "Output value: " << top->output << std::endl;
    }

    // Clean up
    top->final();
    delete top;
    return 0;
}
