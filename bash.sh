#!/bin/bash

#Scrip que adivina numeros del 1 al 10 

cierto=1
numero=$(shuf -i 1-10 -n 1)
res=$numero

while [  $cierto == 1 ]; do
    echo "¿El numero es el $numero? ¿Mayor, menor o correcto?"
    read answer
    if [ $answer == 'correcto' ]; then
        echo "soy la verga"
        exit 1;
    fi
    if [ $answer == 'menor' ]; then
        #res=$((res - 1))
        numero=$(shuf -i 1-$res -n 1)
        res=$numero
    fi
    if [ $answer == 'mayor' ]; then
        #res=$((res + 1))
        numero=$(shuf -i $res-10 -n 1)
        res=$numero=
    fi

done





