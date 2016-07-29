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
	
	##### validacion de los archivos ingresados ###
	if ( -e $origen && -e $destino ){		

	print "Directorio origen: $origen\n";
	print "Directorio destino: $destino\n";

	obtener_archivos($origen,$destino);

	}
	elsif( $origen  =! (-e $origen)){
	print "No se encontró el directorio origen\n";
	}
	elsif( $destino =! (-e $destino)){
        print "No se encontró el directorio destino\n";
	}



