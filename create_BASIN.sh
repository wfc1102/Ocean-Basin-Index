#!/bin/bash
alias rm=/bin/rm
name1=${0##*/}
name2=${name1%%.*}

models=(ACCESS1-0 ACCESS1-3 bcc-csm1-1 bcc-csm1-1-m BNU-ESM CanESM2 CCSM4 CMCC-CESM CMCC-CM CMCC-CMS CNRM-CM5  CNRM-CM5-2 CSIRO-Mk3-6-0 FGOALS-g2 FGOALS-s2 GFDL-CM2p1 CanESM2 GFDL-ESM2G GFDL-ESM2M GISS-E2-H GISS-E2-H-CC GISS-E2-R GISS-E2-R-CC HadCM3 HadGEM2-AO HadGEM2-CC HadGEM2-ES  IPSL-CM5A-LR IPSL-CM5A-MR IPSL-CM5B-LR MIROC4h MIROC5 MIROC-ESM MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-MR MPI-ESM-P MRI-CGCM3 MRI-ESM1 NorESM1-ME)
models=(ACCESS1-0 ACCESS1-3 bcc-csm1-1 bcc-csm1-1-m BNU-ESM CanESM2 CCSM4 CMCC-CESM CMCC-CM CMCC-CMS)
models=(CNRM-CM5  CNRM-CM5-2 CSIRO-Mk3-6-0 FGOALS-g2 FGOALS-s2 GFDL-CM2p1 GFDL-CM3 GFDL-ESM2G GFDL-ESM2M)
models=(GISS-E2-H GISS-E2-H-CC GISS-E2-R GISS-E2-R-CC HadCM3 HadGEM2-AO HadGEM2-CC HadGEM2-ES  IPSL-CM5A-LR)
models=(IPSL-CM5A-MR IPSL-CM5B-LR MIROC4h MIROC5 MIROC-ESM MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-MR MPI-ESM-P MRI-CGCM3 MRI-ESM1 NorESM1-ME)

#models=(ACCESS1-0 ACCESS1-3 bcc-csm1-1 bcc-csm1-1-m BNU-ESM CanESM2 CCSM4 CMCC-CESM CMCC-CM CMCC-CMS CNRM-CM5  CNRM-CM5-2 CSIRO-Mk3-6-0 FGOALS-g2 FGOALS-s2 GFDL-CM2p1 CanESM2 GFDL-ESM2G GFDL-ESM2M GISS-E2-H GISS-E2-H-CC GISS-E2-R GISS-E2-R-CC HadCM3 HadGEM2-AO HadGEM2-CC HadGEM2-ES  IPSL-CM5A-LR IPSL-CM5A-MR IPSL-CM5B-LR MIROC5 MIROC-ESM MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-MR MPI-ESM-P MRI-CGCM3 MRI-ESM1 NorESM1-ME)

models=(ACCESS1-3 bcc-csm1-1-m CanESM2 CCSM4 CMCC-CESM CNRM-CM5-2 CSIRO-Mk3-6-0 EC-EARTH FGOALS-s2 FIO-ESM GFDL-CM2p1 GFDL-ESM2G GISS-E2-R HadGEM2-CC IPSL-CM5A-MR MIROC5 MIROC-ESM MPI-ESM-MR MRI-CGCM3 NorESM1-M)
models=(ACCESS1-0 bcc-csm1-1 BNU-ESM CESM1-BGC CESM1-CAM5 CESM1-CAM5-1-FV2 CESM1-FASTCHEM CESM1-WACCM CMCC-CM CMCC-CMS CNRM-CM5  FGOALS-g2 GFDL-CM3 GFDL-ESM2M GISS-E2-H GISS-E2-H-CC GISS-E2-R-CC HadCM3 HadGEM2-AO HadGEM2-ES inmcm4 IPSL-CM5A-LR IPSL-CM5B-LR MIROC4h MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-P MRI-ESM1 NorESM1-ME)
models=(ACCESS1-0 bcc-csm1-1 BNU-ESM CESM1-BGC CESM1-CAM5 CESM1-CAM5-1-FV2 CESM1-FASTCHEM)
models=(CESM1-WACCM CMCC-CM CMCC-CMS CNRM-CM5  FGOALS-g2 GFDL-CM3 GFDL-ESM2M)
models=(GISS-E2-H GISS-E2-H-CC GISS-E2-R-CC HadCM3 HadGEM2-AO HadGEM2-ES inmcm4)
models=(IPSL-CM5A-LR IPSL-CM5B-LR MIROC4h MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-P MRI-ESM1 NorESM1-ME)

for var   in vo so uo;do
for model in ${models[*]};do
    echo "=============================== ${model} ${var} ==============================="

script="create_BASIN_step1.ncl"
    ncl="${name2}_${model}_${var}.ncl"
    cp $script ${ncl}
    nc=`ls ${model}/run1/data/${var}_Omon_${model}_*.nc| head -n 1`
    nc=${nc##*_}
    year=${nc%%.nc}

    sed -i "s#CanESM2#${model}#g"      ${ncl}
    sed -i "s#vo#${var}#g"             ${ncl}
    sed -i "s#185001-186012#${year}#g" ${ncl}
    ncl ${ncl}
    wait
    wait
    wait
    rm -f ${ncl}

script="create_BASIN_step3.ncl"
    cp $script ${ncl}
    sed -i "s#CanESM2#${model}#g" ${ncl}
    sed -i "s#vo#${var}#g"        ${ncl}
    ncl ${ncl}
    wait
    wait
    wait

    num=`cat BASIN_${model}_${var}_step.txt`
    mv ${model}/BASIN_${model}_${var}_step${num}.nc ${model}/BASIN_${model}_${var}.nc
    mv ${model}/BASIN_${model}_${var}_step1.nc      ${model}/BASIN_${model}_${var}0.nc
    rm -f ${model}/BASIN_${model}_${var}_step*.nc

    rm -f ${ncl}
    rm -f BASIN_${model}_${var}_step.txt
done ### model loop
done ### var   loop

times