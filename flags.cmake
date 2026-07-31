IF(NOT DEFINED FPU)  
    SET(FPU "-mfloat-abi=soft")  
ENDIF()  

IF(NOT DEFINED SPECS)  
    SET(SPECS "--specs=nosys.specs")  
ENDIF()  

IF(NOT DEFINED DEBUG_CONSOLE_CONFIG)  
    SET(DEBUG_CONSOLE_CONFIG "-DSDK_DEBUGCONSOLE=1")  
ENDIF()  

SET(CMAKE_ASM_FLAGS_DEBUG " \
    ${CMAKE_ASM_FLAGS_DEBUG} \
    -DCPU_MCXC242VLH \
    -DMCXC242_SERIES \
    -D__STARTUP_CLEAR_BSS \
    -DMCUXPRESSO_SDK \
    -include \
    \"${ProjDirPath}/mcux_config.h\" \
    -include \
    \"${ProjDirPath}/mcuxsdk_version.h\" \
    -mthumb \
    -mcpu=cortex-m0plus \
    -g \
    -fmacro-prefix-map=\"${ProjDirPath}/\"=./ \
    ${FPU} \
")
SET(CMAKE_C_FLAGS_DEBUG " \
    ${CMAKE_C_FLAGS_DEBUG} \
    -DCPU_MCXC242VLH \
    -DMCXC242_SERIES \
    -D__STARTUP_CLEAR_BSS \
    -DDEBUG \
    -DMCUX_META_BUILD \
    -DMCUXPRESSO_SDK \
    -DPRINTF_ADVANCED_ENABLE=1 \
    -DFRDM_MCXC242 \
    -DFREEDOM \
    -include \
    \"${ProjDirPath}/mcux_config.h\" \
    -include \
    \"${ProjDirPath}/mcuxsdk_version.h\" \
    --specs=nano.specs \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -std=gnu99 \
    -Werror \
    -fstack-usage \
    -mcpu=cortex-m0plus \
    -g \
    -O0 \
    -fmacro-prefix-map=\"${ProjDirPath}/\"=./ \
    ${FPU} \
    ${DEBUG_CONSOLE_CONFIG} \
")
SET(CMAKE_EXE_LINKER_FLAGS_DEBUG " \
    ${CMAKE_EXE_LINKER_FLAGS_DEBUG} \
    -Wall \
    -fno-common \
    -ffunction-sections \
    -fdata-sections \
    -fno-builtin \
    -mthumb \
    -mapcs \
    -Wl,--gc-sections \
    -Wl,-static \
    -Wl,--print-memory-usage \
    -Xlinker \
    -Map=output.map \
    -mcpu=cortex-m0plus \
    -g \
    -Wl,--no-warn-rwx-segments \
    ${FPU} \
    ${SPECS} \
    -T\"${ProjDirPath}/devices/MCX/MCXC/MCXC242/gcc/MCXC242_flash.ld\" -static \
")
