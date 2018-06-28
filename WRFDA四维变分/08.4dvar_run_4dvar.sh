#!/bin/sh
##PBS -l nodes=n14:ppn=16+n15:ppn=16+n16:ppn=16+n06:ppn=16+n13:ppn=16
#PBS -l nodes=7:ppn=16
#PBS -p 1023
echo "This jobs is "$PBS_JOBID@$PBS_QUEUE
NSLOTS=`cat ${PBS_NODEFILE} | wc -l`
cd $PBS_O_WORKDIR


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
export grid_id=(1 2 3)
export parent_id=(1 1 2)
export i_parent_start=(1 35 109)
export j_parent_start=(1 34 61)


cd ${WORK_DIR}/DA
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.airsev.t06z.20140522.bufr ./airs.bufr
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.1bamua.t06z.20140522.bufr ./amsua.bufr
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.1bamub.t06z.20140522.bufr ./amsub.bufr
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.1bhrs3.t06z.20140522.bufr ./hirs3.bufr
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.1bhrs4.t06z.20140522.bufr ./hirs4.bufr
ln -sf /home2_hn/qf/wrfda/WORK/DATA/data/gdas.1bmhs.t06z.20140522.bufr ./mhs.bufr
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_06:00:00.4DVAR ./ob01.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_07:00:00.4DVAR ./ob02.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_08:00:00.4DVAR ./ob03.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_09:00:00.4DVAR ./ob04.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_10:00:00.4DVAR ./ob05.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_11:00:00.4DVAR ./ob06.ascii
ln -sf ${VAR_OUT}/obs_gts_2014-05-22_12:00:00.4DVAR ./ob07.ascii
#ln -sf ${VAR_OUT}/wrfbdy_d01_06 ./wrfbdy_d01
#ln -sf ${VAR_OUT}/wrfinput_d01_06 ./wrfinput_d01
#ln -sf ${VAR_OUT}/wrfvar_input_d01_2014-05-22_06:00:00 ./fg
#
#cat > parame.in << EOF
#&control_param
#da_file='./fg'
#wrf_input='./wrfinput_d01'
#update_lateral_bdy= .false.
#update_low_bdy= .true.
#iswater= 17
#/
#EOF
#./da_update_bc.exe
#
#
cat > namelist.input << EOF
&wrfvar1
var4d=true,
var4d_lbc=false,
var4d_bin=3600,
var4d_bin_rain=21600,
print_detail_outerloop=false,
print_detail_grad=false,
/
&wrfvar2
/
&wrfvar3
ob_format=2,
/
&wrfvar4
use_synopobs=true,
use_shipsobs=true,
use_metarobs=true,
use_soundobs=true,
use_pilotobs=true,
use_airepobs=true,
use_geoamvobs=true,
use_polaramvobs=true,
use_bogusobs=true,
use_buoyobs=true,
use_profilerobs=true,
use_satemobs=true,
use_gpspwobs=true,
use_gpsrefobs=true,
use_qscatobs=true,
use_rainobs=false,
!!!!!!!!!!!!!!!!!!!!!!!
!use_airsobs=true,
!use_amsuaobs=true,
!use_amsubobs=true,
!use_hirs3obs=true,
!use_hirs4obs=true,
!use_mhsobs=true,
/
&wrfvar5
check_max_iv=true,
max_error_t    = 2.0,
max_error_uv   = 2.0,
max_error_pw   = 2.0,
max_error_ref  = 2.0,
max_error_q    = 2.0,
max_error_p    = 2.0,
max_error_rf   = 2.0,
max_error_rain = 2.0,
/
&wrfvar6
max_ext_its=1,
ntmax=50,
orthonorm_gradient=true,
/
&wrfvar7
cv_options=3,
as1=0.25
as2=0.25
as3=0.25
as4=0.25
as5=0.25
/
&wrfvar8
/
&wrfvar9
/
&wrfvar10
test_transforms=false,
test_gradient=false,
/
&wrfvar11
cv_options_hum=1,
check_rh=1,
sfc_assi_options=2,
calculate_cg_cost_fn=false,
/
&wrfvar12
/
&wrfvar13
/
&wrfvar14
!rtminit_nsensor = 17
!rtminit_platform = 9, 9, 10,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, 10,  1,  1,
!rtminit_satid =    2, 2,  2, 15, 16, 18, 19, 15, 16, 17, 15, 16, 17, 18,  2, 18, 19,
!rtminit_sensor =  11, 3,  3,  3,  3,  3,  3,  4,  4,  4,  0,  0,  0,  0, 15, 15, 15,
!rtm_option = 2,
!crtm_irland_coef='IGBP.IRland.EmisCoeff.bin'
/
&wrfvar15
/
&wrfvar16
/
&wrfvar17
/
&wrfvar18
analysis_date="2014-05-22_06:00:00.0000",
/
&wrfvar19
/
&wrfvar20
/
&wrfvar21
time_window_min="2014-05-22_06:00:00.0000",
/
&wrfvar22
time_window_max="2014-05-22_12:00:00.0000",
/
&wrfvar23
/
&time_control
run_hours=6,
start_year=2014,
start_month=05,
start_day=22,
start_hour=06,
end_year=2014,
end_month=05,
end_day=22,
end_hour=12,
interval_seconds=21600,
debug_level=0,
/
&domains
time_step                           = ${timestep[0]},
e_we                                = ${nx[0]}
e_sn                                = ${ny[0]}
e_vert                              = 31,
p_top_requested                     = 5000,
num_metgrid_levels                  = 27,
num_metgrid_soil_levels             = 4,
dx                                  = ${dx_m[0]},
dy                                  = ${dx_m[0]},
grid_id                             = ${grid_id[0]},    
parent_id                           = ${parent_id[0]},    
i_parent_start                      = ${i_parent_start[0]},    
j_parent_start                      = ${j_parent_start[0]},    
smooth_option                       = 0
/
&fdda
/
&dfi_control
/
&tc
/
&physics
mp_physics                          = 2,   
ra_lw_physics                       = 1,   
ra_sw_physics                       = 1,   
radt                                = ${dx_km[0]},  
sf_sfclay_physics                   = 1,   
sf_surface_physics                  = 2,   
bl_pbl_physics                      = 1,   
bldt                                = 0,   
cu_physics                          = ${cu_physics[0]},   
cudt                                = ${cu_dt[0]},   
isfflx                              = 1,
ifsnow                              = 1,
icloud                              = 1,
surface_input_source                = 1,
num_soil_layers                     = 4,
sf_urban_physics                    = 0,   
num_land_cat                        = 20,
/
&scm
/
&dynamics
w_damping                           = 0,
diff_opt                            = 1,    
km_opt                              = 4,    
diff_6th_opt                        = 0,    
diff_6th_factor                     = 0.12, 
base_temp                           = 290.
damp_opt                            = 0,
time_step_sound                     = 4,
zdamp                               = 5000.,
dampcoef                            = 0.2,  
khdif                               = 0,    
kvdif                               = 0,    
non_hydrostatic                     = .true.
moist_adv_opt                       = 1,     
scalar_adv_opt                      = 1,
use_baseparam_fr_nml                = true,     
/
&bdy_control
specified=true,
real_data_init_type=3,
/
&grib2
/
&namelist_quilt
/
&perturbation
trajectory_io=true,
enable_identity=false,
jcdfi_use=false,
jcdfi_diag=1,
jcdfi_penalty=1000.0,
/
EOF
/share/apps/intel/impi/4.1.1.036/intel64/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS ./da_wrfvar.exe

#cat > parame.in << EOF
#da_file = './wrfvar_output' 
#wrf_bdy_file = './wrfbdy_d01' 
#update_lateral_bdy = .true. 
#update_low_bdy = .false.
#EOF 
#./da_update_bc.exe
mv wrfvar_output wrfvar_output_d01_00
rm -rf wrfbdy_d01 wrfinput_d01 fg

ln -sf ${VAR_OUT}/wrfbdy_d02_06 ./wrfbdy_d01
ln -sf ${VAR_OUT}/wrfinput_d02_06 ./wrfinput_d01
ln -sf ${VAR_OUT}/wrfvar_input_d02_2014-05-22_06:00:00 ./fg
sed -i "124s/^.*.$/time_step                           = ${timestep[1]}/" ./namelist.input
sed -i "125s/^.*.$/e_we                                = ${nx[1]}/" ./namelist.input
sed -i "126s/^.*.$/e_sn                                = ${ny[1]}/" ./namelist.input
sed -i "131s/^.*.$/dx                                  = ${dx_m[1]},/" ./namelist.input
sed -i "132s/^.*.$/dy                                  = ${dx_m[1]},/" ./namelist.input
sed -i "133s/^.*.$/grid_id                             = ${grid_id[1]},  /" ./namelist.input
sed -i "134s/^.*.$/parent_id                           = ${parent_id[1]},/" ./namelist.input
sed -i "135s/^.*.$/i_parent_start                      = ${i_parent_start[1]},/" ./namelist.input
sed -i "136s/^.*.$/j_parent_start                      = ${j_parent_start[1]},/" ./namelist.input
#
#cat > parame.in << EOF
#&control_param
#da_file='./fg'
#wrf_input='./wrfinput_d01'
#update_lateral_bdy= .false.
#update_low_bdy= .true.
#iswater= 17
#domain_id=2
#/
#EOF
#./da_update_bc.exe

/share/apps/intel/impi/4.1.1.036/intel64/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS ./da_wrfvar.exe
mv wrfvar_output wrfvar_output_d02_06

mv wrfvar_output_d* ${VAR_OUT}/

#rm -rf *.bufr ob*.ascii rej_obs* unpert_obs* 01_qcstat_* gts_omb_oma_* fg wrfbdy* wrfinput*