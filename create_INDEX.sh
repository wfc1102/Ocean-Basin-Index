#!/bin/bash
alias rm=/bin/rm
name1=${0##*/}
name2=${name1%%.*}

models=(CCSM4 GFDL-CM2p1)
for var   in vo;do
for model in ${models[*]};do
    echo "=============================== ${model} ${var} ==============================="

    script="create_INDEX.ncl"

    nc=`ls ${model}/run1/data/${var}_Omon_${model}_*.nc| head -n 1`
    nc=${nc##*_}
    year=${nc%%.nc}

    ncl=${name2}_${model}_${var}.ncl
    cp $script ${ncl}
    sed -i "s#CanESM2#${model}#g"      ${ncl}
    sed -i "s#vo#${var}#g"             ${ncl}
    sed -i "s#185001-186012#${year}#g" ${ncl}
    ncl ${ncl}
    wait
    wait
    wait
    rm -f ${ncl}
done
done
times
