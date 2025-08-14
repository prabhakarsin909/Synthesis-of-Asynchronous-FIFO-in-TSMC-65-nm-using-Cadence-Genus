#-------------------setting library paths------------------------------------------
set_attribute lib_search_path {../../../../../../../vlsi/pdk/tsmc_gp_65_stdio/tcbn65gplus_200a/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn65gplus_200a/ }

set_attribute library [list tcbn65gpluswc_ccs.lib tcbn65gplusbc_ccs.lib tcbn65gplustc_ccs.lib]

#------------------------Setup and File configuration -------------
set_attribute information_level 6
set_attribute hdl_search_path {../code/}
set myFiles [list fifo_1.v]  ;# All your HDL files
set basename fifo1           ;# name of top level module
set runname synthesis_report           ;# Name appended to output files

#------------clock definitions---------------------
set myClkA wclk                       ;# First clock name
set myClkB rclk       		      ;# second clock 
set myPeriodA_ps 20000                 ;# Clock A period in ps 80MHz
set myPeriodB_ps 100000               ;# Clock A period in ps 390.625

#-----------input output delays---------------------
set myInDelay_ps 2000                  ;# Delay from clock to inputs valid
set myOutDelay_ps 400                 ;# Delay from clock to output valid


# Analyze and Elaborate the HDL files
read_hdl ${myFiles}
elaborate ${basename}

#------------------- Define Clocks-----------
define_clock -period ${myPeriodA_ps} -name ${myClkA} [get_ports ${myClkA}]
define_clock -period ${myPeriodB_ps} -name ${myClkB} [get_ports ${myClkB}]


#-----------clock uncertainty---------------------
set_clock_uncertainty 0.25 [get_clocks ${myClkA}]
set_clock_uncertainty 0.1 [get_clocks ${myClkB}]

#---------Set clock transition --------------------
dc::set_clock_transition .1 $myClkA
dc::set_clock_transition .05 $myClkB

#-------------External delays for inputs and outputs---------------
external_delay -input $myInDelay_ps -clock ${myClkA} [find / -port ports_in/*]
external_delay -output $myOutDelay_ps -clock ${myClkB} [find / -port ports_out/*]
set_clock_gating_check -setup 0.1

# -----------define false paths for timing analysis(CDC path)---------------
set_false_path -from [get_clocks $myClkA] -to [get_clocks $myClkB]


#------------Check design integrity-------------------------------------
check_design -unresolved
report_timing -lint

#-----------Synthesize the design to the target library-----------------
#synthesize -to_mapped
#synth_map -to_mapped
#synthesize -to_generic
#synthesize -to_mapped
# Step 1: Generic synthesis
syn_gen

# Step 2: Map to technology
syn_map

# Step 3: Optimize mapped netlist
syn_opt
#-----------Write out reports--------------------------------------
report_timing > ${basename}_${runname}_timing.rep
report_gates  > ${basename}_${runname}_cell.rep
report_power  > ${basename}_${runname}_power.rep

#-----------Write out the structural Verilog and SDC files--------------
write_hdl -mapped > ${basename}_${runname}.v
write_sdc > ${basename}_${runname}.sdc

gui_show


