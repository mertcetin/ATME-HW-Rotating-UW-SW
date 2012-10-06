onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/updatevec[2:0]} update_x
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/updatevec[5:3]} update_y
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV1[6:0]} MV1_x
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV1[13:7]} MV1_y
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV2[6:0]} MV2_x
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV2[13:7]} MV2_y
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV3[6:0]} MV3_x
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/MV3[13:7]} MV3_y
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/curpos[6:0]} curpos_x
quietly virtual signal -install /test3DRS/DUT { /test3DRS/DUT/curpos[13:7]} curpos_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/updatein[2:0]} updatein_x
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/updatein[5:3]} updatein_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/outMV[13:7]} outMV_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/outMV[6:0]} outMV_x
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/UWpos[6:0]} UWposx
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/UWpos[13:7]} UWposy
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/medianMV[13:7]} medianMV_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/medianMV[6:0]} medianMV_x
quietly virtual signal -install /test3DRS/DUT/mvselect { /test3DRS/DUT/mvselect/MVin[6:0]} MVin_x
quietly virtual signal -install /test3DRS/DUT/mvselect { /test3DRS/DUT/mvselect/MVin[13:7]} MVin_y
quietly virtual function -install /test3DRS/DUT/mvselect -env /test3DRS { &{/test3DRS/DUT/mvselect/MVSelected[6], /test3DRS/DUT/mvselect/MVSelected[5], /test3DRS/DUT/mvselect/MVSelected[4], /test3DRS/DUT/mvselect/MVSelected[3], /test3DRS/DUT/mvselect/MVSelected[2], /test3DRS/DUT/mvselect/MVSelected[1], /test3DRS/DUT/mvselect/MVSelected[0] }} MVselected_x
quietly virtual function -install /test3DRS/DUT/mvselect -env /test3DRS { &{/test3DRS/DUT/mvselect/MVSelected[13], /test3DRS/DUT/mvselect/MVSelected[12], /test3DRS/DUT/mvselect/MVSelected[11], /test3DRS/DUT/mvselect/MVSelected[10], /test3DRS/DUT/mvselect/MVSelected[9], /test3DRS/DUT/mvselect/MVSelected[8], /test3DRS/DUT/mvselect/MVSelected[7] }} MVselected_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vecin[13:7]} vecin_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vecin[6:0]} vecin_x
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors0[13:7]} vectors0_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors0[6:0]} vectors0_x
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors1[13:7]} vectors1_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors1[6:0]} vectors1_x
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors2[13:7]} vectors2_y
quietly virtual signal -install /test3DRS/DUT/swaddrgen { /test3DRS/DUT/swaddrgen/vectors2[6:0]} vectors2_x
add wave -noupdate -format Logic /test3DRS/outready
add wave -noupdate -format Literal /test3DRS/outSAD
add wave -noupdate -format Logic /test3DRS/clk
add wave -noupdate -format Logic /test3DRS/reset
add wave -noupdate -format Logic /test3DRS/start
add wave -noupdate -format Logic /test3DRS/firstframe
add wave -noupdate -format Logic /test3DRS/refwrite
add wave -noupdate -format Logic /test3DRS/searchwrite
add wave -noupdate -format Literal -radix unsigned /test3DRS/refaddress
add wave -noupdate -format Literal -radix unsigned /test3DRS/searchaddress
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/refdata
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/searchdata
add wave -noupdate -format Logic /test3DRS/curfilled
add wave -noupdate -format Logic /test3DRS/srcfilled
add wave -noupdate -format Literal /test3DRS/rowblock
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/update_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/update_y
add wave -noupdate -format Literal /test3DRS/DUT/updatevec
add wave -noupdate -format Logic /test3DRS/DUT/update_enable
add wave -noupdate -format Logic /test3DRS/DUT/SW_AddrGen_enable
add wave -noupdate -format Logic /test3DRS/DUT/UWFilled
add wave -noupdate -format Logic /test3DRS/DUT/UW_WE
add wave -noupdate -format Logic /test3DRS/DUT/MV_Process_Done
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV1_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV1_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV2_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV2_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV3_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/MV3_y
add wave -noupdate -format Literal /test3DRS/DUT/MV1
add wave -noupdate -format Literal /test3DRS/DUT/MV2
add wave -noupdate -format Literal /test3DRS/DUT/MV3
add wave -noupdate -format Literal /test3DRS/DUT/curMV
add wave -noupdate -format Literal /test3DRS/DUT/selectedMV
add wave -noupdate -format Literal /test3DRS/DUT/SearchWin
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/CurBlock
add wave -noupdate -format Literal /test3DRS/DUT/curSAD
add wave -noupdate -format Logic /test3DRS/DUT/cur_WE
add wave -noupdate -format Logic /test3DRS/DUT/search_WE
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/cur_data_in
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/search_data_in
add wave -noupdate -format Literal /test3DRS/DUT/search_addr_in
add wave -noupdate -format Logic /test3DRS/DUT/mvselect_WE
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/curpos_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/curpos_y
add wave -noupdate -format Literal /test3DRS/DUT/curpos
add wave -noupdate -format Literal /test3DRS/DUT/UW_Data_IN
add wave -noupdate -format Literal /test3DRS/DUT/UW_address
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/updatein_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/updatein_y
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/updatein
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/MV_ready
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/outMV_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/outMV_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/outMV
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/UWDATA_Out
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/UW_WE
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/InputDATA
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/InputADDR
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/done
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/UWaddress_out
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/order
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/inside
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/UWposx
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/UWposy
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/UWpos
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/median
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/underTh
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SubState
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SubState_d
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/medianMV_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/medianMV_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/medianMV
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_mod_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_mod_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/preSWcoord_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/preSWcoord_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/premodSWcoord_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWshift
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/valid
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S01
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S02
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S03
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S04
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S05
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S06
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S07
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S08
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S09
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S10
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S11
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S12
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S13
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S14
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S15
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S16
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S17
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S18
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S19
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S20
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S21
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/RADDR_S22
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr2
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr4
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr5
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr6
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr7
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr8
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr9
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr10
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr11
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr12
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr13
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr14
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr15
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr16
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr17
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr18
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr19
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr20
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr21
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/raddr22
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/readaddr
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S01
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S02
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S03
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S04
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S05
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S06
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S07
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S08
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S09
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S10
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S11
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S12
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S13
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S14
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S15
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S16
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S17
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S18
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S19
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S20
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S21
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/swaddrgen/RDATA_S22
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/WADDR_S
add wave -noupdate -format Logic /test3DRS/DUT/controller/UPen
add wave -noupdate -format Logic /test3DRS/DUT/controller/MVArray_WE
add wave -noupdate -format Literal /test3DRS/DUT/controller/curpos
add wave -noupdate -format Logic /test3DRS/DUT/controller/SWaddren
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/controller/count_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/controller/count_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/controller/State
add wave -noupdate -format Logic /test3DRS/DUT/controller/frameend
add wave -noupdate -format Logic /test3DRS/DUT/controller/countenable
add wave -noupdate -format Logic /test3DRS/DUT/updatewin/WE
add wave -noupdate -format Logic /test3DRS/DUT/updatewin/W_SELECT_ROW_OR_COL
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/updatewin/input_data
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/R_ROW
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/R_COL
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/row
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/col
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/updatewin/SearchOut
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/write_count
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/UW_row
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/UW_col
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/row
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updatewin/col
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/pe_array/search
add wave -noupdate -format Literal -radix hexadecimal /test3DRS/DUT/pe_array/current
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/pe_array/SADOUT
add wave -noupdate -format Logic /test3DRS/DUT/mvselect/WE
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADin
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/mvselect/MVin_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/mvselect/MVin_y
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MVin
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADSelected
add wave -noupdate -format Logic /test3DRS/DUT/mv_array_WE
add wave -noupdate -format Literal /test3DRS/DUT/MVarray_in
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/MVwait
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/mvselect/MVselected_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/mvselect/MVselected_y
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MVSelected
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADs2
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADs1
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADs0
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/SADmin
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MVmin
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvselect/count
add wave -noupdate -format Logic /test3DRS/DUT/mvselect/WE_delay1
add wave -noupdate -format Logic /test3DRS/DUT/mvselect/WE_delay2
add wave -noupdate -format Logic /test3DRS/DUT/mvselect/WE_delay3
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MV_delay1
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MV_delay2
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/MV_delay3
add wave -noupdate -format Logic /test3DRS/DUT/mvselect/done
add wave -noupdate -format Literal /test3DRS/DUT/mvselect/i
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/updater/lfsr1/out
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/vec1x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/bposy
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/bposx
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/vec2y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/vec3x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/vec3y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/whichRAM
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/prewhichRAM
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/whichRAM_d
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/inside
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/UW_count_d
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/UWcount
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/howmany_col
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/howmany_row
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/howmany_row_signed
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/howmany_col_signed
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/new_UWpos_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/new_UWpos_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/whichblock_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_mod_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_mod_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/SWcoord_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/premodSWcoord_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/preSWcoord_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/preSWcoord_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol3
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol4
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol5
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol6
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol7
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol8
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol9
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol10
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol11
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol12
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol14
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol15
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol16
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol17
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol18
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol19
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol20
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol21
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/addrcol22
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/reference_block_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/reference_block_y
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/new_ref_x
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/new_ref_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/ref_check_x
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/ref_check_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/preUWaddr_out
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/modSWcoord_x
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/\\State\[0\]\\
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/\\State\[2\]\\
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/\\State\[3\]\\
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/\\State\[4\]\\
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/\\State\[5\]\\
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/swaddrgen/feedcount
add wave -noupdate -format Logic /test3DRS/DUT/swaddrgen/feed
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vecin_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vecin_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/vecin
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors0_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors0_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/vectors0
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors1_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors1_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/vectors1
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors2_y
add wave -noupdate -format Literal -radix decimal /test3DRS/DUT/swaddrgen/vectors2_x
add wave -noupdate -format Literal /test3DRS/DUT/swaddrgen/vectors2
add wave -noupdate -format Logic /test3DRS/DUT/mvarray/feed
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/MVector
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/curpos
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/AddrOut
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vecout
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/topMVout
add wave -noupdate -format Literal -radix unsigned /test3DRS/DUT/mvarray/count
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/Addr
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vecout1addr
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vecout2addr
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vecout3addr
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/bposx
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/bposy
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vec1x
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vec2y
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vec3y
add wave -noupdate -format Literal /test3DRS/DUT/mvarray/vec3x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {183709039 ps} 0}
configure wave -namecolwidth 237
configure wave -valuecolwidth 103
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {183477683 ps} {184795535 ps}
