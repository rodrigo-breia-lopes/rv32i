#include "Vprogram_counter.h"
#include "verilated.h"
#include <cassert>
#include <iostream>

int sim_time = 0;

void tick(Vprogram_counter* pc, vluint8_t& clk){
    for (int cycle=0; cycle<2; cycle++) {
        clk = !clk; // Toggle clock
        pc->clk = clk;
        pc->eval();
    }
    VL_PRINTF("");
    sim_time ++;
}



int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate our design
    Vprogram_counter* pc = new Vprogram_counter;
    
    vluint8_t clk = 0;

    VL_PRINTF("-------- SIM START --------");
    VL_PRINTF("[%04d tick]\t");

    pc->rst=0;
    tick(pc,clk);

    pc->rst=1;
    tick(pc,clk);

    pc->rst=0;
    tick(pc,clk);
    

    //std::string branch_typestr[] = {"BEQ","BNE","BLT","BGE","BLTU","BGEU"};
    //std::string flagsrt[]={"Z","N","F","C"};

    delete pc;
    return 0;
}
