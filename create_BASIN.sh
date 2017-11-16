#!/bin/bash
alias rm=/bin/rm
name1=${0##*/}
name2=${name1%%.*}

models=(CCSM4 GFDL-CM2p1)

for var   in vo;do
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
