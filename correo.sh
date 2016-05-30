#!/bin/bash
#
#  Samuel Abraham Morales Pablo
#  Respuesta a incidentes

echo "		Samuel Abraham Morales Pablo"
echo "		 Identificacion de cabeceras"
echo ""
echo ""

################  Validacion de entradas ################
if [[ -z "$@" ]]; then
    echo >&2 "Falta argumento"
    echo "Ejemplo de ejecucion:  ./correo.sh file"
    echo ""
    exit 1
fi

FILE=$1

##### Validacion del documento (existe o no existe) #####
if [ ! -f $FILE ]; then
    echo "    El archivo no existe"
    echo ""
    exit 1
fi

####### Archivos temporales para manejo de lineas ######
TMP=tmp.txt
TMP2=tmp2.txt
TMP3=tmp3.txt

###### Se limpia el archivo orginal y se obtienen #####
######    las ips  y dominios del mismo          #####

cat $FILE | grep 'from\|by' | tail -2 > $TMP
grep -oE '[[:alnum:]]+[.][[:alnum:]_.-]+' $TMP > $TMP2
rm $TMP
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $TMP2 > $TMP


########### Separamos ip's de dominios ###############

while read -r line
do
    texto+="$line\\|"    
done < "$TMP"

texto+="a"
cat $TMP2 | grep -v $texto > $TMP3 
rm $TMP2

############ Eliminar ip's privadas #######################

cat $TMP | grep -v -E '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.)' > $TMP2
rm $TMP

############# Se toma la ip responsable y se hace whois ############
##########          se obtienen cadenas importates         ########

RES=responsable.txt
ip=$(cat $TMP2)
whois $ip > $RES
echo "IP Responsable: $ip"
owner=$(cat $RES| grep -E "owner")
mail=$(cat $RES | grep -E "e-mail")
organis=$(cat $RES | grep -E "organisation")
orgname=$(cat $RES | grep -E "OrgName")
abuse=$(cat $RES| grep -E "OrgAbuseEmail")

[  -z "$organis" ] && echo -n "" || echo "$organis"
[  -z "$owner" ] && echo -n "" || echo "$owner"
[  -z "$mail" ] && echo -n "" || echo "$mail"
[  -z "$orgname" ] && echo -n "" || echo "$orgname"
[  -z "$abuse" ] && echo -n "" || echo "$abuse"

echo ""

###### Se lee dominio de correo y se obtiene su ip ########
rm $TMP2
echo "Servidor de correo: `cat $TMP3`"
serv=$(cat $TMP3)
echo "IP Servidor: `dig +short $serv`"
echo ""
rm $TMP3 
rm $RES

