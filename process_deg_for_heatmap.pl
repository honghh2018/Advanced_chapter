#!/usr/bin/perl -w
use strict;
use File::Basename;


my@file=glob("../BMK_6_DEG_Analysis/*_vs_*/Statistics_Visualization/*_vs_*.DEG.xls");

while(my$file=<@file>){
        chomp$file;
        my $basename=basename($file);
        $basename=fileparse($basename,".DEG.xls");
        mkdir $basename unless(-d "./$basename");
        open(IN,$file);
        open(OUT,">$basename/$basename\.DEG.xls");
        my@index=();
        while(<IN>){
                chomp;
                my@temp=split /\t/,$_;
                if($.==1){
                        push @index,0;
                        for(my$i=0;$i<=$#temp;$i++){
                                if($temp[$i]=~/_FPKM/){
                                        push @index,$i;
                                }
                        }
                        my$string=join("\t",@temp[(@index)]);
                        $string=~s/_FPKM//g;
                        print OUT $string,"\n";
                        next;
                }
                my $newstring=join("\t",@temp[(@index)]);
                print OUT $newstring,"\n";
        }
        close IN;
        close OUT;
}
