# config to select component, the format is CONFIG_USE_${component}
# Please refer to cmake files below to get available components:
#  ${ProjDirPath}/devices/MCXC242/all_lib_device.cmake

set(CONFIG_COMPILER gcc)
set(CONFIG_TOOLCHAIN armgcc)
set(CONFIG_USE_COMPONENT_CONFIGURATION false)
set(CONFIG_CORE cm0p)
set(CONFIG_DEVICE MCXC242)
set(CONFIG_BOARD frdmmcxc242)
set(CONFIG_KIT frdmmcxc242)
set(CONFIG_DEVICE_ID MCXC242)
set(CONFIG_FPU NO_FPU)
set(CONFIG_DSP '')
set(CONFIG_CORE_ID core0)
