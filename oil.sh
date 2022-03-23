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
    echo ${current_value}
  fi
  sleep ${sleep_value}
done
