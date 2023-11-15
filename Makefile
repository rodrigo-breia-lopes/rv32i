# Directories
SRC_DIR := src
TB_DIR := testbench
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj_dir

# Simulator settings
SIMULATOR := verilator
SIM_FLAGS := --trace -Wall --Wno-BLKSEQ --Wno-UNUSEDSIGNAL

# Default target. Does nothing but provides a helpful message.
all:
	@echo "Please specify a module to simulate. Example: make sim MODULE=imm_gen"

# Rule to run Verilator and build the simulation executable
sim:
	@echo "Simulating $(MODULE)"
	mkdir -p $(OBJ_DIR)/$(MODULE)
	# Copy the testbench file to the object directory
	cp $(TB_DIR)/$(MODULE)_tb.cpp $(OBJ_DIR)/$(MODULE)/
	# Run Verilator with the testbench file in the current directory
	$(SIMULATOR) $(SIM_FLAGS) -cc $(SRC_DIR)/$(MODULE).sv --exe $(MODULE)_tb.cpp -Mdir $(OBJ_DIR)/$(MODULE)
	# Run the generated Makefile
	$(MAKE) -C $(OBJ_DIR)/$(MODULE) -f V$(MODULE).mk
	# Move the executable to the build directory
	mv $(OBJ_DIR)/$(MODULE)/V$(MODULE) $(BUILD_DIR)/V$(MODULE)
	# Clean up: Remove the copied testbench file
	rm $(OBJ_DIR)/$(MODULE)/$(MODULE)_tb.cpp

# Run the simulation
run: sim
	./$(BUILD_DIR)/V$(MODULE)

# Clean the build and object directories
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all sim run clean
