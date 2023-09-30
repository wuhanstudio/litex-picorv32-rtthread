BUILD_DIR?=../build/muselab_icesugar/

include $(BUILD_DIR)/software/include/generated/variables.mak
include $(SOC_DIRECTORY)/software/common.mak

# COMMONFLAGS = $(DEPFLAGS) -Os $(CPUFLAGS) -g3 -no-pie -fomit-frame-pointer -Wall -fno-builtin -fno-stack-protector $(INCLUDES)
# COMMONFLAGS += -fexceptions
# CFLAGS  = $(COMMONFLAGS)

CFLAGS += 	-I ../build/muselab_icesugar/software/include/\
          	-I ./rt-thread/libcpu/risc-v/picorv32\
        	-I ./rt-thread/include/\
        	-I ./rt-thread/include/libc/\
            -I ./rt-thread/components/finsh/\
			-I ./libraries/picorv32/\
			-I ./\
			-Wno-missing-prototypes\

LDFLAGS =  -ffunction-sections -nostartfiles\
		   -nostdlib -Wl,--build-id=none $(CFLAGS)\
		   -L ../build/muselab_icesugar/software/include -L$(BUILDINC_DIRECTORY)

OBJECTS   = drivers/board.o\
			applications/main.o\
			libraries/start.o\
			./rt-thread/libcpu/risc-v/picorv32/interrupt_gcc.o\
			./rt-thread/libcpu/risc-v/picorv32/interrupt.o\
			./rt-thread/libcpu/risc-v/picorv32/context_gcc.o\
			./rt-thread/libcpu/risc-v/picorv32/cpuport.o\
			./rt-thread/components/finsh/cmd.o\
			./rt-thread/components/finsh/msh.o\
			./rt-thread/components/finsh/shell.o\
			./rt-thread/src/clock.o\
			./rt-thread/src/components.o\
			./rt-thread/src/cpu.o\
			./rt-thread/src/idle.o\
			./rt-thread/src/ipc.o\
			./rt-thread/src/irq.o\
			./rt-thread/src/kservice.o\
			./rt-thread/src/mem.o\
			./rt-thread/src/memheap.o\
			./rt-thread/src/mempool.o\
			./rt-thread/src/object.o\
			./rt-thread/src/scheduler.o\
			./rt-thread/src/slab.o\
			./rt-thread/src/thread.o\
			./rt-thread/src/timer.o\

all: rt-thread.bin

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
ifneq ($(OS),Windows_NT)
	chmod -x $@
endif

vpath %.a $(PACKAGES:%=../%)

rt-thread.elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -T ./drivers/linker_scripts/link.lds -N -o $@ \
		$(OBJECTS) \
		$(PACKAGES:%=-L$(BUILD_DIR)/software/%) \
		-Wl,--whole-archive \
		-Wl,--gc-sections \
		-Wl,-Map,$@.map \
		$(LIBS:lib%=-l%)

ifneq ($(OS),Windows_NT)
	chmod -x $@
endif

# pull in dependency info for *existing* .o files
-include $(OBJECTS:.o=.d)

VPATH = $(BIOS_DIRECTORY):$(BIOS_DIRECTORY)/cmds:$(CPU_DIRECTORY)

%.o: %.cpp
	$(compilexx)

%.o: %.c
	$(compile)

%.o: %.S
	$(assemble)

clean:
	$(RM) $(OBJECTS) rt-thread.elf rt-thread.bin .*~ *~

.PHONY: all clean
