#!/bin/sh

export WORK_DIR=/home2_hn/qf/wrfda/WORK
mkdir -p ${WORK_DIR}/4dvarout
export VAR_OUT=${WORK_DIR}/4dvarout
export FNL_DATA=/home2_hn/QQF/MCS/2014DA/dafnl
export ndomian=3
export dn=('d01' 'd02' 'd03')
export nx=(189 361 436)
export ny=(146 238 355)
export dx_km=(27 9 3)
export dx_m=(27000 9000 3000)
export geog_data_res=('modis_30s+10m' 'modis_30s+2m' 'modis_30s+30s')
export timestep=(120 40 10)
export cu_physics=(1 1 0)
export cu_dt=(5 5 0)


cd ${WORK_DIR}/OBS
cat > namelist.obsproc << EOF
&record1
 obs_gts_filename = '/home2_hn/qf/wrfda/WORK/DATA/data/OBS:2014052200',
 obs_err_filename = 'obserr.txt',
/

&record2
 time_window_min  = '2014-05-22_00:00:00',
 time_analysis    = '2014-05-22_03:00:00',
 time_window_max  = '2014-05-22_06:00:00',
/

&record3
 max_number_of_obs        = 400000,
 fatal_if_exceed_max_obs  = .TRUE.,
/

&record4
 qc_test_vert_consistency = .TRUE.,
 qc_test_convective_adj   = .TRUE.,
 qc_test_above_lid        = .TRUE.,
 remove_above_lid         = .TRUE.,
 domain_check_h           = .true.,
 Thining_SATOB            = false,
 Thining_SSMI             = false,
 Thining_QSCAT            = false,
/

&record5
 print_gts_read           = .TRUE.,
 print_gpspw_read         = .TRUE.,
 print_recoverp           = .TRUE.,
 print_duplicate_loc      = .TRUE.,
 print_duplicate_time     = .TRUE.,
 print_recoverh           = .TRUE.,
 print_qc_vert            = .TRUE.,
 print_qc_conv            = .TRUE.,
 print_qc_lid             = .TRUE.,
 print_uncomplete         = .TRUE.,
/

&record6
 ptop =  1000.0,
 base_pres       = 100000.0,
 base_temp       = 290.0,
 base_lapse      = 50.0,
 base_strat_temp = 215.0,
 base_tropo_pres = 20000.0
/

&record7
 IPROJ = 1,
 PHIC  = 22.00,
 XLONC = 112.0,
 TRUELAT1= 6.0,
 TRUELAT2= 38.0,
 MOAD_CEN_LAT = 22.00,
 STANDARD_LON = 112.00,
/

&record8
 IDD    =   1,
 MAXNES =   3,
 NESTIX =  189,  361,  436,
 NESTJX =  146,  238,  355,
 DIS    =  27,     9,    3,
 NUMC   =    1,    1,   2,
 NESTI  =    1,   35,  109,
 NESTJ  =    1,   34,  61,
 /

&record9
 PREPBUFR_OUTPUT_FILENAME = 'prepbufr_output_filename',
 PREPBUFR_TABLE_FILENAME = 'prepbufr_table_filename',
 OUTPUT_OB_FORMAT = 2
 use_for          = '4DVAR',
 num_slots_past   = 3,
 num_slots_ahead  = 3,
 write_synop = .true.,
 write_ship  = .true.,
 write_metar = .true.,
 write_buoy  = .true.,
 write_pilot = .true.,
 write_sound = .true.,
 write_amdar = .true.,
 write_satem = .true.,
 write_satob = .true.,
 write_airep = .true.,
 write_gpspw = .true.,
 write_gpsztd= .true.,
 write_gpsref= .true.,
 write_gpseph= .true.,
 write_ssmt1 = .true.,
 write_ssmt2 = .true.,
 write_ssmi  = .true.,
 write_tovs  = .true.,
 write_qscat = .true.,
 write_profl = .true.,
 write_bogus = .true.,
 write_airs  = .true.,
 /
EOF
./obsproc.exe
mv obs_gts_*.4DVAR ${VAR_OUT}/

sed -i "2s/^.*.$/ obs_gts_filename = '\/home2_hn\/qf\/wrfda\/WORK\/DATA\/data\/OBS:2014052206',/" ${WORK_DIR}/OBS/namelist.obsproc
sed -i "7s/^.*.$/ time_window_min  = '2014-05-22_06:00:00',/" ${WORK_DIR}/OBS/namelist.obsproc
sed -i "8s/^.*.$/ time_analysis    = '2014-05-22_09:00:00',/" ${WORK_DIR}/OBS/namelist.obsproc
sed -i "9s/^.*.$/ time_window_max  = '2014-05-22_12:00:00',/" ${WORK_DIR}/OBS/namelist.obsproc
./obsproc.exe
mv obs_gts_*.4DVAR ${VAR_OUT}/

rm -rf DIR.txt HEIGHT.txt *.diag PRES.txt RH.txt SPD.txt TEMP.txt UV.txt obs_duplicate_time*