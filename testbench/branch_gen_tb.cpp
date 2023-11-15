#include "Vbranch_gen.h"
#include "verilated.h"
#include <cassert>
#include <iostream>

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate our design
    Vbranch_gen* top = new Vbranch_gen;

    std::string branch_typestr[] = {"BEQ","BNE","BLT","BGE","BLTU","BGEU"};
    std::string flagsrt[]={"Z","N","F","C"};

    for(int i = 0; i < 16; i++) {   // For all 4-bit flag values
        for(int j = 1; j <= 32; j <<= 1) { // For all 6-bit branch_type values
            top->flag = i;
            top->branch_type = j;
            top->eval();

            bool zf = (i & 1) ? true : false;
            bool nf = (i & 2) ? true : false;
            bool vf = (i & 4) ? true : false;
            bool cf = (i & 8) ? true : false;

            bool expected = 0;

            switch(j) {
                case 1: expected = zf; break;
                case 2: expected = !zf; break;
                case 4: expected = nf ^ vf; break;
                case 8: expected = !(nf ^ vf); break;
                case 16: expected = cf; break;
                case 32: expected = !cf; break;
            }

            if(expected != top->pc_src) {
                std::cout << "Mismatch at flag=" << i << " branch_type=" << j << std::endl;
                std::cout << "Expected=" << expected << " Got=" << top->pc_src << std::endl;
            }

            assert(expected == top->pc_src);
        }
    }

    std::cout << "All tests passed!" << std::endl;

    delete top;
    return 0;
}

