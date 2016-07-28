#!/usr/bin/perl
#use strict;
use SnortUnified(qw(:ALL));
use Funciones;
use Cwd;
use Data::Dumper;

#Variables locales
my $origen = $ARGV[0];  #Directorio actual por default
my $destino = $ARGV[1]; #Directorio actual por default
#obtener_archivos($origen);
obtener_archivos($origen,$destino);


#my $directory = getcwd();
#my $log_dir = getcwd();
#my $file= "snort.u2.1462992767"; 
#procesa_archivo($file,$log_dir,$directory,$file);
