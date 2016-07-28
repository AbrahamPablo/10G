#!/usr/bin/perl
#use strict;
use SnortUnified(qw(:ALL));
use Funciones;
use Cwd;
use Data::Dumper;

#Variables locales
my $directory = getcwd();  #Directorio actual por default
my $log_dir = getcwd(); #Directorio actual por default
my $file=  ; #Solo para un archivo
#my $origin= ""; #directorio especificado

	foreach( @ARGV) {
        
	print "\n\nLlamar al modo normal";
        #procesa_archivo($file,$log_directory,$directory,$file); # se envian 4 argumentos a la subrutina procesa_archivo
        procesa_archivo($file,$log_dir,$directory,$file); # se envian 4 argumentos a la subrutina procesa_archivo
	print "\n";

	}
