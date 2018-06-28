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


cd ${WORK_DIR}/WRF
cat > namelist.input << EOF
 &time_control
 run_days                            = 0,
 run_hours                           = 6,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = 2014, 2014, 2014,
 start_month                         = 05,   05,   05,
 start_day                           = 22,   22,   22,
 start_hour                          = 06,   06,   06,
 start_minute                        = 00,   00,   00,
 start_second                        = 00,   00,   00,
 end_year                            = 2014, 2014, 2014,
 end_month                           = 05,   05,   05,
 end_day                             = 22,   22,   22,
 end_hour                            = 18,   18,   18,
 end_minute                          = 00,   00,   00,
 end_second                          = 00,   00,   00,
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 360,  360,  360,
 frames_per_outfile                  = 1, 1, 1,
 restart                             = .false.,
 restart_interval                    = 5000,
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 io_form_auxinput2                   = 2
 /

 &domains
 time_step                           = ${timestep[0]},
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = 3,
 e_we                                = ${nx[0]}, ${nx[1]}, ${nx[2]}
 e_sn                                = ${ny[0]}, ${ny[1]}, ${ny[2]}
 e_vert                              = 31,     31,    31, 
 p_top_requested                     = 5000,
 num_metgrid_levels                  = 27,
 num_metgrid_soil_levels             = 4,
 dx                                  = ${dx_m[0]}, ${dx_m[1]}, ${dx_m[2]}
 dy                                  = ${dx_m[0]}, ${dx_m[1]}, ${dx_m[2]}
 grid_id                             = 1,     2,     3,
 parent_id                           = 1,     1,     2,
 i_parent_start                      = 1,     35,    109,
 j_parent_start                      = 1,     34,    61,
 parent_grid_ratio                   = 1,     3,     3,
 parent_time_step_ratio              = 1,     3,     5,
 feedback                            = 0,
 smooth_option                       = 0
 /

 &physics
 mp_physics                          = 2,     2,     2,
 ra_lw_physics                       = 1,     1,     1,
 ra_sw_physics                       = 1,     1,     1,
 radt                                = 27,    9,     3,
 sf_sfclay_physics                   = 1,     1,     1,
 sf_surface_physics                  = 2,     2,     2,
 bl_pbl_physics                      = 1,     1,     1,
 bldt                                = 0,     0,     0,
 cu_physics                          = 1,     1,     0,
 cudt                                = 5,     5,     0,
 isfflx                              = 1,
 ifsnow                              = 1,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,
 sf_urban_physics                    = 0,     0,     0,
 num_land_cat                        = 20,
 /

 &fdda
 /

 &dynamics
 w_damping                           = 0,
 diff_opt                            = 1,      1,      1,
 km_opt                              = 4,      4,      4,
 diff_6th_opt                        = 0,      0,      0,
 diff_6th_factor                     = 0.12,   0.12,   0.12,
 base_temp                           = 290.
 damp_opt                            = 0,
 zdamp                               = 5000.,  5000.,  5000.,
 dampcoef                            = 0.2,    0.2,    0.2
 khdif                               = 0,      0,      0,
 kvdif                               = 0,      0,      0,
 non_hydrostatic                     = .true., .true., .true.,
 moist_adv_opt                       = 1,      1,      1,
 scalar_adv_opt                      = 1,      1,      1,
 /

 &bdy_control
 spec_bdy_width                      = 10,
 spec_zone                           = 1,
 relax_zone                          = 9,
 specified                           = .true., .false.,.false.,
 nested                              = .false., .true., .true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /
EOF

ln -sf ${VAR_OUT}/met_em* .
mpirun -np 30 ./real.exe
rm -rf met_em*

sed -i "15s/^.*.$/ end_hour                            = 12,   12,   12,/" ./namelist.input
cp ./wrfinput_d02 ./wrfndi_d02
ln -sf ${VAR_OUT}/wrfout_d01_2014-05-22_06:00:00 .
ln -sf ${VAR_OUT}/wrfout_d01_2014-05-22_12:00:00 .
mpirun -np 30 ./ndown.exe
rm -rf wrfout*

mv wrfbdy_d01 wrfbdy_d01_06
mv wrfbdy_d01_06 ${VAR_OUT}
cp ${VAR_OUT}/wrfbdy_d01_06 ${VAR_OUT}/wrfbdy_d01_06.bak

mv wrfinput_d01 wrfinput_d01_06
mv wrfinput_d01_06 ${VAR_OUT}
cp ${VAR_OUT}/wrfinput_d01_06 ${VAR_OUT}/wrfinput_d01_06.bak

mv wrfbdy_d02 wrfbdy_d02_06
mv wrfbdy_d02_06 ${VAR_OUT}
cp ${VAR_OUT}/wrfbdy_d02_06 ${VAR_OUT}/wrfbdy_d02_06.bak

mv wrfinput_d02 wrfinput_d02_06
mv wrfinput_d02_06 ${VAR_OUT}
cp ${VAR_OUT}/wrfinput_d02_06 ${VAR_OUT}/wrfinput_d02_06.bak

mv wrfinput_d03 wrfinput_d03_06
mv wrfinput_d03_06 ${VAR_OUT}
cp ${VAR_OUT}/wrfinput_d03_06 ${VAR_OUT}/wrfinput_d03_06.bak

rm -rf rsl.* met_em* wrfout* wrfbdy* wrfinput* wrfndi*