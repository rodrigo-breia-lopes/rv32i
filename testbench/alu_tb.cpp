#include "Valu.h"
#include "verilated.h"
#include <cassert>
#include <iostream>
#include <string>
#include <random>
#include <chrono>

void tick(Valu* alu, vluint8_t& clk){
    for (int cycle=0; cycle<2; cycle++) {
        clk = !clk; // Toggle clock
        alu->clk = clk;
        alu->eval();
    }
}

int main(int argc, char **argv){

    Verilated::commandArgs(argc,argv);
    Valu* alu = new Valu;
    
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::default_random_engine generator(seed);
    std::uniform_int_distribution<vluint32_t> distribution(0x00000000,0xFFFFFFFF);

    //in_a = distribution(generator);

    vluint8_t clk  = 0;
    vluint32_t in_a = 0;
    vluint32_t in_b = 0;

    alu->rst = 0;
    tick(alu,clk);

    alu->rst = 1;
    tick(alu,clk);   

    alu->rst = 0;
    tick(alu,clk);    

    std::cout << "----------- SIM START -----------" << std::endl;

    alu->op = 0x08; 

    alu->final();
    delete alu;
    return 0;

}

// while (true){
//     std::string op_str, in_a_str, in_b_str;
// 
//     std::cout << "OP: ";
//     std::cin >> op_str;
//     alu->op = std::stoul(op_str, nullptr, 16); // Convert hexadecimal string to unsigned long
// 
//     std::cout << "in_a: ";
//     std::cin >> in_a_str;
//     alu->in_a = std::stoul(in_a_str, nullptr, 10); // Convert hexadecimal string to unsigned long
// 
//     std::cout << "in_b: ";
//     std::cin >> in_b_str;
//     alu->in_b = std::stoul(in_b_str, nullptr, 10); // Convert hexadecimal string to unsigned long
// 
//     tick(alu,clk);
// }
//
/// VL_PRINTF("[%02x]\t| %d\t| %d\t| %08x\t| %04b\n",alu->op,alu->in_a,alu->in_b,alu->out,alu->o_flag);

//int getOverflow(vluint32_t x,vluint32_t y){
//    //std::cout << "x: " << std::hex << x << "\ty: " << y << std::endl;
//
//    int ny = 1 + ~y; // -y
//    //std::cout << "ny:\t" << std::hex << ny << std::endl;
//
//    int dif = x + ny; // dif is x - y
//    //std::cout << "dif:\t" << std::hex << dif << std::endl;
//
//    int sX = x >> 31; // get the sign of x
//    //std::cout << "sX:\t"<< std::hex << sX << std::endl;
//
//    int sY = y >> 31; // get the sign of -y
//    //std::cout << "sY:\t" << std::hex << sY << std::endl;
//
//    int sDif = (dif >> 31) && !0; // get the sign of the difference
//    //std::cout << "sDif:\t" << std::hex << sDif << std::endl;
//
//    //std::cout << "Ov:\t" << std::hex << ((sX ^ sY) && !(sY^sDif)) << std::endl;
//
//
//    return ((sX ^ sY) && !(sY^sDif));
//}


