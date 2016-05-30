#!/bin/bash

# Script que toma como argumento una archivo PE
# y obtiene tres campos
#  1.Tipo de maquina 
#  2.Fecha y hora
#  3.Numero magico
#  Samuel Abraham Morales Pablo

#-------- Validar parametro

#parametro=$1 
if [ $1 ]; then
  echo El archivo es: $1 
else
echo "Te falta especificar el parámetro."
echo "El modo de ejecucion es el siguiente: ./tarea.sh archivo"
exit 
fi

#---------- Existe archivo

if [ -f $1 ];
then
echo ""
else
echo "El archivo no existe."
exit
fi

#---------- TIPO DE ARCHIVO ------------# 

type=`hexdump -C $1 | head -n 1 | cut -d " " -f 3,4 | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }' | sed 's/ //g'`
echo ""
echo -n "Tipo de archivo: "
########## comparacion hexa para determinar tipo de archivo ############
case "$type" in
'5a4d')
echo "DLL/DOS MZ executable"
;;
'd8ff')
echo "JPG"
;;
'5089')
echo "PNG"
;;
'5a42')
echo "Bzip"
;;
'8b1f')
echo "Gzip"
;;
'4b50')
echo "zip"
;;
'5025')
echo "pdf"
;;
'6923')
echo "file C"
;;
'6152')
echo "rar"
;;
esac
echo ""

#---------------- OBTENER HEXADECIMAL A PARTIR DEL DESPLAZAMIENTO, SE GUARDA EN ARCHIVO Y SE LIMPIA ---------------#

FILE=file.txt;
echo "-------------"
salto=`hexdump -C -s 0x3c $1 | head -n 1 | cut -d " " -f 3,4,5,6 | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }' | sed 's/ //g'`
echo "Desplazamiento hacia la direccion: $salto"
echo "-------------"
echo ""
salto="0x$salto"
hexdump -C -s $salto -n 256 $1 > $FILE

TMP=tmp.txt
for linea in $(cat $FILE);do
  echo $linea >> $TMP
done
sed '/|/d' $TMP > otro.txt
cat otro.txt > $TMP
rm $FILE

############ Se obtiene tipo de maquina ##############
machine=$(cat $TMP | sed -n 6p)
machine1=$(cat $TMP | sed -n 7p)
tipo=$machine1$machine
echo "Tipo de maquina: $tipo"
echo -n "Arquitectura: "
#----------- comparacion tipo de maquina a partir del hexadecimal ----------#
case "$tipo" in
'0')
echo "Cualquier tipo de máquina"
;;
'01d3')
echo "Matsushita AM33"
;;
'8664')
echo "x64"
;;
'01c0')
echo "ARM little endian"
;;
'01c4')
echo "ARMv7 (or higher) Thumb mode only"
;;
'aa64')
echo "ARMv8 in 64-bit mode"
;;
'0ebc')
echo "EFI byte code"
;;
'014c')
echo "Intel 386 or later and compatible processors"
;;
'0200')
echo "Intel Itanium processor family"
;;
'9041')
echo "Mitsubishi M32R little endian"
;;
'0266')
echo "MIPS16"
;;
'0366')
echo "MIPS with FPU"
;;
'0466')
echo "MIPS16 with FPU"
;;
'01f0')
echo "Power PC little endian"
;;
'01f1')
echo "Power PC with floating point support"
;;
'0166')
echo "MIPS little endian"
;;
'01a2')
echo "Hitachi SH3"
;;
'01a3')
echo "Hitachi SH3 DSP"
;;
'01a6')
echo "Hitachi SH4"
;;
'01a8')
echo "Hitachi SH5"
;;
'01c2')
echo "ARM or Thumb ('interworking')"
;;
'0169')
echo "MIPS little-endian WCE v2"
;;

esac

echo ""

###### SE OBTIENE HORA Y FECHA #############

hora=$(cat $TMP | sed -n 10p)
hora1=$(cat $TMP | sed -n 11p)
hora2=$(cat $TMP | sed -n 12p)
hora3=$(cat $TMP | sed -n 13p)
fecha=$hora3$hora2$hora1$hora
fecha="0x$fecha"
fecha=`echo $(($fecha))`
echo "Fecha y hora: `date -d @$fecha`"
echo ""

####### SE OBTIENE NUMERO MAGICO ############

magic=$(cat $TMP | sed -n 27p)
magic1=$(cat $TMP | sed -n 28p)
numero=$magic1$magic
numero="0x$numero"
echo "Numero magico: $numero"
echo -n "Arquitectura compatible: "

#------- Comparacion para saber  compatibilidad a partir del hexadecimal ---------#
case "$numero" in
'0x010b')
echo "32 bits"
;;
'0x020b')
echo "64 bits"
;;
'0x0107')
echo "Imagen ROM"
;;
esac
#---------------


echo ""
rm $TMP
rm otro.txt

