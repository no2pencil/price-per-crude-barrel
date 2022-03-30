#!/bin/bash

url="https://markets.businessinsider.com/commodities/oil-price?op=1"
sleep_value=10
previous_value=0
current_value=0

while [ 1 -ne 2 ] 
do 
  previous_value=$(echo ${current_value})
  current_value=$(curl --silent ${url} | grep "price-section__current-value" | cut -d'>' -f2 | cut -d'<' -f1)
  if [ "${current_value}" != "${previous_value}" ]; then
    time=$(date +%H:%M)
    output=$(echo ${current_value})
    if [ "${current_value}" > "${previous_value}" ]; then
      # Check for, and correct trailing zero
      retval=$(echo ${current_value}|cut -d'.' -f2|wc|awk '{print$3}')
      if [ ${retval} -eq 2 ]; then
        output=$(echo ${output}0)
      fi
      output=$(echo "${output} [  UP  ] [ ${time} ]")
    else
      output=$(echo "${output} [ DOWN ] [ ${time} ]")
    fi
    echo ${output}
  fi
  sleep ${sleep_value}
done
