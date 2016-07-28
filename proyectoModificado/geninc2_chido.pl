#!/usr/bin/perl
#use strict;
use SnortUnified(qw(:ALL));
use Funciones;
use Cwd;
use Data::Dumper;

my $origen = $ARGV[0];  #Directorio actual por default
my $destino = $ARGV[1]; #Directorio actual por default

if ($origen =~ /\/$/){

}
else{
    $origen = $origen."/";
}

obtener_archivos($origen,$destino);


