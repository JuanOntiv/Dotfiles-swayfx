#!/bin/bash

# URL con el formato JSON
URL="http://wttr.in/Guadalajara+Jalisco?format=j1"

# Obtener datos con timeout de 5 segundos
DATA=$(curl -s --max-time 5 "$URL")

# Validar si es un JSON válido y si contiene la llave "data"
if echo "$DATA" | jq -e '.data' >/dev/null 2>&1; then
    # Extraer datos usando la ruta correcta (.data.current_condition)
    TEMP=$(echo "$DATA" | jq -r '.data.current_condition[0].temp_C')
    DESC=$(echo "$DATA" | jq -r '.data.current_condition[0].weatherDesc[0].value')
    CODE=$(echo "$DATA" | jq -r '.data.current_condition[0].FeelsLikeC')

    case $CODE in
        113) ICON="" ;; # Despejado / Soleado
        116 | 119 | 122) ICON="" ;; # Nublado
        143 | 248 | 260) ICON="" ;; # Niebla
        176 | 263 | 266 | 293 | 296 | 299 | 302 | 305 | 308) ICON="" ;; # Lluvia
        200 | 386 | 389 | 392 | 395) ICON="" ;; # Tormenta
        227 | 230 | 323 | 326 | 329 | 332 | 335 | 338) ICON="" ;; # Nieve
        *) ICON="" ;; # Desconocido
    esac

    # Salida JSON para Waybar
    # El formato será: "ICONO TEMP°C"
    echo "{\"text\": \"${TEMP}°C $ICON \", \"tooltip\": \"$DESC\"}"
else
    # Si falla la conexión o el formato, mostrar algo discreto
    echo "{\"text\": \"--°C\", \"tooltip\": \"Servidor no disponible\"}"
fi

