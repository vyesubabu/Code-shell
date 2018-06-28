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


cd ${WORK_DIR}/WPS
cat > namelist.wps <<EOF
&share
 wrf_core = 'ARW',
 max_dom = ${ndomian},
 start_date = '2014-05-21_00:00:00','2014-05-21_00:00:00','2014-05-21_00:00:00'
 end_date   = '2014-05-23_00:00:00','2014-05-23_00:00:00','2014-05-23_00:00:00'
 interval_seconds = 21600
 io_form_geogrid = 2,
/

&geogrid
 parent_id         =   1,  1,  2
 parent_grid_ratio =   1,  3,  3 
 i_parent_start    =   1, 35,  109 
 j_parent_start    =   1, 34,  61
 e_we              =  ${nx[0]}, ${nx[1]}, ${nx[2]}
 e_sn              =  ${ny[0]}, ${ny[1]}, ${ny[2]}
 geog_data_res     =  ${geog_data_res[0]}, ${geog_data_res[1]}, ${geog_data_res[2]}
 dx = ${dx_m[0]},
 dy = ${dx_m[0]},
 map_proj = 'lambert',
 ref_lat   =  22.0,
 ref_lon   = 112.0,
 truelat1  =  6.0,
 truelat2  =  38.0,
 stand_lon = 112.0,
 geog_data_path = '/home2_hn/qf/wrfda/geog'
/

&ungrib
 out_format = 'WPS',
 prefix = 'FILE',
/

&metgrid
 fg_name = 'FILE'
 io_form_metgrid = 2,
/
EOF
./geogrid.exe
./link_grib.csh ${FNL_DATA}/fnl_2014052[1-3]*.grib2
./ungrib.exe
./metgrid.exe
mv geo_em.d* met_em.d* ${VAR_OUT}/
rm -rf FILE:* GRIB*