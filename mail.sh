#!/bin/bash
#Samuel Abraham Morales Pablo
#Script que hace envio de correo spam a todos los usuarios en una maquina

dominio="@smartstationary.com"
cat /etc/passwd | cut -d ":" -f1 >file.txt
 
while IFS='' read -r line || [[ -n "$line" ]]; do
      cat face.html|mail -s “Facebook” $line$dominio
done < file.txt

