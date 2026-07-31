# CROSS COMPILER SETTING
set(CMAKE_SYSTEM_NAME Generic)
cmake_minimum_required(VERSION 3.10.0)

if (NOT DEFINED SdkRootDirPath)
    SET(SdkRootDirPath ${CMAKE_CURRENT_LIST_DIR})
endif()

include(${CMAKE_CURRENT_LIST_DIR}/config.cmake)
include(${SdkRootDirPath}/cmake/toolchain/toolchain.cmake)

# THE VERSION NUMBER
SET (MCUXPRESSO_CMAKE_FORMAT_MAJOR_VERSION 2)
SET (MCUXPRESSO_CMAKE_FORMAT_MINOR_VERSION 0)

include(ide_overrides.cmake OPTIONAL)

if(CMAKE_SCRIPT_MODE_FILE)
  message("${MCUXPRESSO_CMAKE_FORMAT_MAJOR_VERSION}")
  return()
endif()


set(CMAKE_EXECUTABLE_LIBRARY_PREFIX)
set(CMAKE_EXECUTABLE_LIBRARY_SUFFIX)

# CURRENT DIRECTORY
set(ProjDirPath ${CMAKE_CURRENT_SOURCE_DIR})

set(EXECUTABLE_OUTPUT_PATH ${ProjDirPath}/${CMAKE_BUILD_TYPE})
set(LIBRARY_OUTPUT_PATH ${ProjDirPath}/${CMAKE_BUILD_TYPE})


project(dm-mcxc242-pn7160)

enable_language(ASM)

set(MCUX_BUILD_TYPES debug)

set(EXECUTABLE_OUTPUT_PATH ${ProjDirPath})
set(LIBRARY_OUTPUT_PATH ${ProjDirPath})
set(MCUX_SDK_PROJECT_NAME ${PROJECT_NAME}.elf)

include(${ProjDirPath}/flags.cmake)

add_executable(${MCUX_SDK_PROJECT_NAME} 
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/system_MCXC242.c"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/gcc/startup_MCXC242.S"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/drivers/fsl_clock.c"
"${ProjDirPath}/board/board.c"
"${ProjDirPath}/board/clock_config.c"
"${ProjDirPath}/board/pin_mux.c"
"${ProjDirPath}/board/hardware_init.c"
"${ProjDirPath}/drivers/common/fsl_common.c"
"${ProjDirPath}/drivers/common/fsl_common_arm.c"
"${ProjDirPath}/drivers/gpio/fsl_gpio.c"
"${ProjDirPath}/drivers/i2c/fsl_i2c.c"
"${ProjDirPath}/drivers/lpuart/fsl_lpuart.c"
"${ProjDirPath}/drivers/smc/fsl_smc.c"
"${ProjDirPath}/components/assert/fsl_assert.c"
"${ProjDirPath}/components/debug_console_lite/fsl_debug_console.c"
"${ProjDirPath}/components/misc_utilities/fsl_syscall_stub.c"
"${ProjDirPath}/components/misc_utilities/fsl_sbrk.c"
"${ProjDirPath}/components/str/fsl_str.c"
"${ProjDirPath}/components/uart/fsl_adapter_lpuart.c"
"${ProjDirPath}/applications/main.c"
"${ProjDirPath}/applications/nfc_example_RWandCE.c"
"${ProjDirPath}/applications/nfc_example_RW.c"
"${ProjDirPath}/applications/nfc_example_P2P.c"
"${ProjDirPath}/applications/ndef_helper.c"
"${ProjDirPath}/applications/TML/tml.c"
"${ProjDirPath}/applications/tool/tool.c"
"${ProjDirPath}/NfcLibrary/NxpNci20/src/NxpNci20.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/P2P_NDEF.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_MIFARE.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_T1T.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_T2T.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_T3T.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_T4T.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/RW_NDEF_T5T.c"
"${ProjDirPath}/NfcLibrary/NdefLibrary/src/T4T_NDEF_emu.c"
"${ProjDirPath}/mcux_config.h"
"${ProjDirPath}/mcuxsdk_version.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/fsl_device_registers.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/MCXC242.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/MCXC242_features.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/MCXC242_COMMON.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_ADC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_CMP.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_CRC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_DMA.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_DMAMUX.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_FGPIO.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_FLEXIO.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_FTFA.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_GPIO.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_I2C.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_LLWU.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_LPTMR.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_LPUART.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_MCG.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_MCM.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_MTB.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_MTBDWT.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_NV.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_OSC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_PIT.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_PMC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_PORT.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_RCM.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_RFSYS.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_ROM.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_RTC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_SIM.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_SMC.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_SPI.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_TPM.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_UART.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_USB.h"
"${ProjDirPath}/devices/MCX/MCXC/periph1/PERI_VREF.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/system_MCXC242.h"
"${ProjDirPath}/devices/MCX/MCXC/MCXC242/drivers/fsl_clock.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/cmsis_compiler.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/cmsis_version.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/cmsis_gcc.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/m-profile/cmsis_gcc_m.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/core_cm0plus.h"
"${ProjDirPath}/arch/arm/CMSIS/Core/Include/m-profile/armv7m_mpu.h"
"${ProjDirPath}/board/board.h"
"${ProjDirPath}/board/clock_config.h"
"${ProjDirPath}/board/pin_mux.h"
"${ProjDirPath}/applications/app.h"
"${ProjDirPath}/drivers/common/fsl_common.h"
"${ProjDirPath}/drivers/common/fsl_common_arm.h"
"${ProjDirPath}/drivers/gpio/fsl_gpio.h"
"${ProjDirPath}/drivers/i2c/fsl_i2c.h"
"${ProjDirPath}/drivers/lpuart/fsl_lpuart.h"
"${ProjDirPath}/drivers/port/fsl_port.h"
"${ProjDirPath}/drivers/smc/fsl_smc.h"
"${ProjDirPath}/components/assert/fsl_assert.h"
"${ProjDirPath}/components/debug_console_lite/fsl_debug_console.h"
"${ProjDirPath}/components/str/fsl_str.h"
"${ProjDirPath}/components/uart/fsl_adapter_uart.h"
)

target_include_directories(${MCUX_SDK_PROJECT_NAME} PRIVATE
    "${ProjDirPath}/devices/MCX/MCXC/MCXC242"
    "${ProjDirPath}/devices/MCX/MCXC/periph1"
    "${ProjDirPath}/devices/MCX/MCXC/MCXC242/drivers"
    "${ProjDirPath}/arch/arm/CMSIS/Core/Include"
    "${ProjDirPath}/arch/arm/CMSIS/Core/Include/m-profile"
    "${ProjDirPath}/board"
    "${ProjDirPath}/applications"
    "${ProjDirPath}/applications/TML"
    "${ProjDirPath}/applications/tool"
    "${ProjDirPath}/NfcLibrary/inc"
    "${ProjDirPath}/NfcLibrary/NxpNci20/inc"
    "${ProjDirPath}/NfcLibrary/NdefLibrary/inc"
    "${ProjDirPath}/drivers/common"
    "${ProjDirPath}/drivers/gpio"
    "${ProjDirPath}/drivers/i2c"
    "${ProjDirPath}/drivers/lpuart"
    "${ProjDirPath}/drivers/port"
    "${ProjDirPath}/drivers/smc"
    "${ProjDirPath}/components/assert"
    "${ProjDirPath}/components/debug_console_lite"
    "${ProjDirPath}/components/str"
    "${ProjDirPath}/components/uart"
)


IF(NOT DEFINED TARGET_LINK_SYSTEM_LIBRARIES)  
    SET(TARGET_LINK_SYSTEM_LIBRARIES "-lm -lc -lgcc -lnosys")  
ENDIF()  

TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE -Wl,--start-group)

target_link_libraries(${MCUX_SDK_PROJECT_NAME} PRIVATE ${TARGET_LINK_SYSTEM_LIBRARIES})

TARGET_LINK_LIBRARIES(${MCUX_SDK_PROJECT_NAME} PRIVATE -Wl,--end-group)

ADD_CUSTOM_COMMAND(TARGET ${MCUX_SDK_PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_OBJCOPY}
-Obinary ${EXECUTABLE_OUTPUT_PATH}/${MCUX_SDK_PROJECT_NAME} ${EXECUTABLE_OUTPUT_PATH}/${PROJECT_NAME}.bin)

set_target_properties(${MCUX_SDK_PROJECT_NAME} PROPERTIES ADDITIONAL_CLEAN_FILES "output.map;${EXECUTABLE_OUTPUT_PATH}/${PROJECT_NAME}.bin")

