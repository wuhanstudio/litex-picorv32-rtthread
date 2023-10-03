cmake_minimum_required (VERSION 3.1)

ENABLE_LANGUAGE(ASM)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)
SET(CMAKE_CROSSCOMPILING 1)

set(tools /opt/riscv32im)
set(LINKR_FILE ../drivers/linker_scripts/link.lds)
set(CMAKE_ASM_COMPILER ${tools}/bin/riscv32-unknown-elf-gcc)
set(CMAKE_C_COMPILER ${tools}/bin/riscv32-unknown-elf-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/riscv32-unknown-elf-g++)
set(CMAKE_OBJCOPY ${tools}/bin/riscv32-unknown-elf-objcopy)
set(CMAKE_OBJDUMP ${tools}/bin/riscv32-unknown-elf-objdump)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS "-MD -Os -Wall" )

set(CMAKE_ASM_FLAGS "-nostdlib" )
set(LD_FLAGS "-L../../build/muselab_icesugar/software/include -ffunction-sections -nostartfiles -Wl,--gc-sections")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(ENABLE_EXPORTS  True)

set(PROJECT_NAME rt-thread)

set(BIN_TARGET ${PROJECT_NAME}.bin)
set(HEX_TARGET ${PROJECT_NAME}.hex)
set(MAP_TARGET ${PROJECT_NAME}.map)
set(LSS_TARGET ${PROJECT_NAME}.asm)
set(TMP_TARGET ${PROJECT_NAME}.tmp)

set(RISCV_SRC 
   applications/main.c
   drivers/board.c
   libraries/start.S
   ./rt-thread/libcpu/risc-v/picorv32/interrupt_gcc.S
   ./rt-thread/libcpu/risc-v/picorv32/interrupt.c
   ./rt-thread/libcpu/risc-v/picorv32/context_gcc.S
   ./rt-thread/libcpu/risc-v/picorv32/cpuport.c
   ./rt-thread/components/finsh/cmd.c
   ./rt-thread/components/finsh/msh.c
   ./rt-thread/components/finsh/shell.c
   ./rt-thread/src/clock.c
   ./rt-thread/src/components.c
   ./rt-thread/src/cpu.c
   ./rt-thread/src/idle.c
   ./rt-thread/src/ipc.c
   ./rt-thread/src/irq.c
   ./rt-thread/src/kservice.c
   ./rt-thread/src/mem.c
   ./rt-thread/src/memheap.c
   ./rt-thread/src/mempool.c
   ./rt-thread/src/object.c
   ./rt-thread/src/scheduler.c
   ./rt-thread/src/slab.c
   ./rt-thread/src/thread.c
   ./rt-thread/src/timer.c
   )

# create binary & hex files and show size of resulting firmware image

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

project (${PROJECT_NAME})

include_directories(../build/muselab_icesugar/software/include/
                    ./rt-thread/libcpu/risc-v/picorv32
                    ./rt-thread/include/
                    ./rt-thread/components/finsh/
                    ./rt-thread/include/libc/
                    ./libraries/picorv32/
                    ./)

add_executable(${PROJECT_NAME}.elf ${RISCV_SRC})

target_link_libraries(${PROJECT_NAME}.elf PRIVATE  -T${LINKR_FILE} ${LD_FLAGS},-Map=${MAP_TARGET})

# Remove option -rdynamic which is a bug
add_custom_command(TARGET ${PROJECT_NAME}.elf PRE_BUILD
        COMMAND sed -i 's/-rdynamic//g' CMakeFiles/${PROJECT_NAME}.elf.dir/link.txt
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Obinary ${PROJECT_NAME}.elf ${BIN_TARGET}
        COMMAND ${CMAKE_OBJCOPY} -O verilog ${PROJECT_NAME}.elf ${TMP_TARGET}
        COMMAND ${CMAKE_OBJDUMP} -S ${PROJECT_NAME}.elf > ${LSS_TARGET}
        COMMENT "Generating ${HEX_TARGET}, ${BIN_TARGET}"
)
