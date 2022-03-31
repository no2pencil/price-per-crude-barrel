#!/bin/bash

url="https://markets.businessinsider.com/commodities/oil-price?op=1"
sleep_value=10
previous_value=0
current_value=0

# Text Colors
#red='\033[0;31m'
#green='\033[0;32m'
red='\033[0;41m'
green='\033[0;42m'
clear='\033[0m'

while [ 1 -ne 2 ] 
do 
  previous_value=$(echo ${current_value})
  current_value=$(curl --silent ${url} | grep "price-section__current-value" | cut -d'>' -f2 | cut -d'<' -f1)
  if [ "${current_value}" != "${previous_value}" ]; then
    time=$(date +%H:%M)
    output=$(echo ${current_value})
    # Check for, and correct trailing zero
    retval=$(echo ${current_value}|cut -d'.' -f2|wc|awk '{print$3}')
    if [ ${retval} -eq 2 ]; then
      output=$(echo ${output}0)
    fi
    #if [ ${current_value} -gt ${previous_value} ]; then
    if [ $(bc <<< "${current_value}>${previous_value}") -eq 1 ]; then
      output=$(echo "${output} [${green}  UP  ${clear}] [ ${time} ]")
    else
      output=$(echo "${output} [${red}DOWN${clear}] [ ${time} ]")
    fi
    echo -e ${output}
  fi
  sleep ${sleep_value}
done
