#!/bin/bash

data=$(curl -s http://wttr.in/Guadalajara+Jalisco?format=j1)
temp=$(echo "$data" | jq -r 'data.current_condition[0].temp_C')
desc=$(echo "$data" | jq -r 'data.current_condition[0].weatherDesc[0].value')

echo "{\"text\": \"$temp°C $desc\"}"
