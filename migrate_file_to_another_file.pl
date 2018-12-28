#!/usr/bin/perl -w
use strict;
use warnings;
use File::Basename;
use Cwd qw(abs_path);

open(IN,"$ARGV[0]") or die $!;
my @file=glob("/share/nas1/honghh/personality/BMK170618-F762/topGo/Anno_enrichment/pathway/kegg_map/*png");
my $basename=basename($ARGV[0]);
mkdir $basename unless (-d $basename);
my $abs_path=abs_path($basename);
while(<IN>){
        chomp;
        next if(/\#/);
        my $ko_id=(split /\t+/,$_)[1];
        foreach my $file(@file){
                my $basename1=basename($file);
                if($basename1 =~m/$ko_id/i){
                        `cp $file $abs_path`;
                }
        }

}
close IN;
