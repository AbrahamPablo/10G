#!/usr/bin/perl
use strict;
use Proc::Daemon;
use Data::Dumper;
use warnings;


############################### OBTIENE INCIDENTES #########################################################
sub obtiene_incidentes
{
        my @argumentos = @_;
        my %incidentes = %{$argumentos[0]};
        my $file = $argumentos[1];
        my $id=$argumentos[2];
        my $contador;
        my $UF_Data = openSnortUnified($file) or die "ERROR al abrir archivo";
        while ( my $record = readSnortUnified2Record() )
                {

                        if($record->{TYPE} == 7 || $record->{TYPE} == 72)
                        {
                                my $paquete;
                                if(exists($incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}))
                                {
                                        if(exists($incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'eventos'}{$record->{'event_id'}})){next};
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'n_eventos'}++;
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'ultimo'} = $record;
                                        $paquete = readSnortUnified2Record();
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'ultimo_paquete'} = $paquete;
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'eventos'}{$record->{'event_id'}}=1;
                                }
                                else
                                {
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}={'id_incidente' => ++$id,'n_eventos' => 1,'primero' => $record, 'ultimo' => $record};
                                        $paquete = readSnortUnified2Record();
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'primero_paquete'} = $paquete;
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'ultimo_paquete'} = $paquete;
                                        $incidentes{$record->{'sig_id'},$record->{'sip'},$record->{'protocol'}}{'eventos'}{$record->{'event_id'}}=1;
                                }
                                        $contador++;
                        }

                }
                closeSnortUnified();
        return (\%incidentes,$id);


}


############################### PROCESA ARCHIVO #########################################################

sub procesa_archivo{
	my @argumentos = @_;
	my $file = $argumentos[0];
	my $directory_log = $argumentos[1];
	my $directory = $argumentos[2];
	my $name_output_file = $argumentos[3];
	my %incidentes;
        my $id=0;
        my @resultado=obtiene_incidentes(\%incidentes,$file,$id);
        
        $id=$resultado[1];
        %incidentes=%{$resultado[0]};
                        
        imprime_incidentes(\%incidentes,$directory_log,$directory,$name_output_file);

	
}

############################### IMPRIME INCIDENTES #########################################################

sub imprime_incidentes
{
        my @argumentos = @_;
        my %incidentes = %{$argumentos[0]};
        my $directory_log = $argumentos[1];
        my $directory = $argumentos[2];
        my $name_output_file = $argumentos[3];
        
        open(my $salida, '+>:unix',$directory.'/'.$name_output_file.'_unified2')or die "no se pudo abrir $!";
        open(my $salida_plano, '+>',$directory.'/'.$name_output_file.'_plano')or die "no se pudo abrir $!";

        print $salida_plano "ID_incidente\t| total_de_eventos | \tEventos\n";

        foreach my $key (keys %incidentes)
        {
                        print $salida  pack('NN',$incidentes{$key}{primero}{TYPE},$incidentes{$key}{primero}{SIZE}).$incidentes{$key}{primero}{raw_record};
                        print $salida  pack('NN',$incidentes{$key}{primero_paquete}{TYPE},$incidentes{$key}{primero_paquete}{SIZE}).$incidentes{$key}{primero_paquete}{raw_record};
                        print $salida  pack('NN',$incidentes{$key}{ultimo}{TYPE},$incidentes{$key}{ultimo}{SIZE}).$incidentes{$key}{ultimo}{raw_record};
                        print $salida  pack('NN',$incidentes{$key}{ultimo_paquete}{TYPE},$incidentes{$key}{ultimo_paquete}{SIZE}).$incidentes{$key}{ultimo_paquete}{raw_record};

                        print $salida_plano "\t $incidentes{$key}{id_incidente}\t|\t$incidentes{$key}{n_eventos}\t   | " ;
			
			my $variable = Dumper ($incidentes{$key}{'eventos'});
                        $variable =~ s/(VAR1 = {)//g;
                        $variable =~ s/(' => 1)//g;
                        $variable =~ s/[\$',;}]//g;
                        $variable =~ s/\r|\n//g;
                        $variable =~ s/          /,/g;
			$variable =~ s/^,//g;
			$variable =~ s/ //g;
			my @var = split(",",$variable);
			my @sorted_numbers = sort { $a <=> $b } @var;
			print $salida_plano join(",", @sorted_numbers),"\n";

        }
        close($salida);
        close($salida_plano);
}

############################### OBTIENE ARCHIVOS #########################################################

sub obtener_archivos{

     my @argumentos = @_;
     my $dir = $argumentos[0];
     #my $directory = $argumentos[1];
     my $directory = $argumentos[1];
     my $log_dir = getcwd();
################################################################
     #my $directory = getcwd(); 
     #my $log_dir = getcwd();
     #my $file= "snort.u2.1462992767";
     #procesa_archivo($file,$log_dir,$directory,$file);

################################################################     
     #$dir= '/root/unified/dcruz-jrevilla/origen'
     opendir(DIR, $dir) or die $!;

     while (my $file = readdir(DIR)) {

       if ($file eq "." || $file eq "..")
       { }
       else{
          procesa_archivo($file,$log_dir,$directory,$file);
          print $file;
          print "\n";
       }
    }

    closedir(DIR);
}


1;


