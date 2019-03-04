VASM        = ./vasmm68k_mot
VLINK       = ./vlink
BIN         = test
SRC         = test.s
OBJ         = test.o
VASM_FLAGS  = -m68000 -Fhunk -Felf
#VASM_FLAGS  = -m68000 -Fhunk -devpac -Felf
VLINK_FLAGS =

.PHONY: all all-before all-after clean clean-custom run-a500 run-a500-custom run-a1200 run-a1200-custom

all: all-before $(BIN) all-after

clean: clean-custom
	rm -rf $(OBJ) $(BIN) s

$(BIN): $(OBJ)
	$(VLINK) $(OBJ) -o $(BIN)

$(OBJ): $(SRC)
	$(VASM) $(SRC) $(VASM_FLAGS) -o $(OBJ)

run-a500: run-a500-custom
	rm -rf s
	mkdir -p s
	echo $(BIN) > s/Startup-Sequence
	fs-uae ./a500.fs-uae
	#fs-uae --chip_memory=1024 --hard_drive_0=`pwd` --joystick_port_1=none --amiga_model=A1200 --slow_memory=1792 --remote_debugger=200 --use_remote_debugger=true --automatic_input_grab=0

run-a1200: run-a1200-custom
	rm -rf s
	mkdir -p s
	echo $(BIN) > s/Startup-Sequence
	fs-uae ./a1200.fs-uae
