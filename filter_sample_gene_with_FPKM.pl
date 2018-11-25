#!/usr/bin/perl -w
use strict;
use warnings;

open(IN,"$ARGV[0]") or die $!;
open(OUT,">T1.list");
open(OUT1,">T2.list");
open(OUT2,">T3.list");
open(OUT3,">T4.list");
my $head=();  #storage the matrix title
my %file=();
while(<IN>){
        chomp;
        if(/\#/){
                $head=$_;
                next;
        }
        my @array=split /\s+/,$_;
        my $head1=shift@array;
        $file{$head1}=\@array;
}
close IN;


foreach my $key(sort{$a cmp $b}keys %file){
        if($file{$key}->[0] >= 0.1){
                print OUT $key,"\n";
        }
        if($file{$key}->[1]>=0.1){
                print OUT1 $key,"\n";
        }
        if($file{$key}->[2] >=0.1){
                print OUT2 $key,"\n";
        }
        if($file{$key}->[3] >=0.1){
                print OUT3 $key,"\n";
        }

}

close OUT;
close OUT1;
close OUT2;
close OUT3;
