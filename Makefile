VASM        = ./vasmm68k_mot
VLINK       = ./vlink
BIN         = test
SRC         = test.s
OBJ         = test.o
VASM_FLAGS  = -m68000 -Fhunk -Felf
VLINK_FLAGS =

.PHONY: all all-before all-after clean clean-custom run run-custom

all: all-before $(BIN) all-after

clean: clean-custom
	rm -rf $(OBJ) $(BIN) s

$(BIN): $(OBJ)
	$(VLINK) $(OBJ) -o $(BIN)

$(OBJ): $(SRC)
	$(VASM) $(SRC) $(VASM_FLAGS) -o $(OBJ)

run: run-custom
	rm -rf s
	mkdir -p s
	echo $(BIN) > s/Startup-Sequence
	fs-uae --chip_memory=1024 --hard_drive_0=`pwd` --joystick_port_1=none --amiga_model=A1200 --slow_memory=1792 --remote_debugger=200 --use_remote_debugger=true --automatic_input_grab=0

