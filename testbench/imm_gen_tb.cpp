// help: https://chat.openai.com/share/29cbdc74-11c0-4139-bf02-358d45b51632
#include "Vimm_gen.h"
#include "verilated.h"
#include <vector>
#include <fstream>
#include <sstream>

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);

    // Create an instance of our module under test
    Vimm_gen* imm_gen = new Vimm_gen;

    // <class c++>  <nome da instância>(<argumento>)
    std::ifstream infile("test.mc");
    
    // se var `infile` devolve 0 (vazio)
    if(!infile){
	VL_PRINTF("Error: couldn't open the file\n");
	return 1;
    }    
    
    std::vector <uint32_t> instructions; // vetor de instruções (programa) lidas do ficheiro (tipo instr. memory)
    std::string line;			 // instrução atual

    // leitura do ficheiro
    while (std::getline(infile, line)) {
	std::stringstream ss;	
	ss << std::hex << line;	// string interpretada como hex, guardada como sendo inteiro
	uint32_t instr;		
	ss >> instr;		// hex -> int
	instructions.push_back(instr);
    }

    // Open the second file
    //std::ifstream infile2("instructions_test.asm");
    //if(!infile2) {
    //    VL_PRINTF("Error: couldn't open the second file\n");
    //    return 1;
    //}
    
    int i = 0;
    for (uint32_t instr : instructions){

	imm_gen->instr = instr;
	imm_gen->eval(); 

	//std::string input_line;
        //if (std::getline(infile2, input_line)) {
        //    VL_PRINTF("|%08x|%s\n",i,input_line.c_str());
        //} else {
        //    VL_PRINTF("End of input file reached\n");
        //}

	VL_PRINTF("[%08x]\t| imm = 0x%08x\t(%02dd)\n",instr,imm_gen->imm,imm_gen->imm);
	i = i + 4;
    }
    imm_gen->final();
    delete imm_gen;
    return 0;
}
