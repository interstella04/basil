open_hw_manager
connect_hw_server
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE {/users/shoffmann/work/basil/examples/bdaq_core/firmware/vivado/output/BDAQ-CORE.bit} [current_hw_device]
program_hw_devices [current_hw_device]