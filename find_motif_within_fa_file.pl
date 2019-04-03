#!/usr/bin/perl -w
use strict;
use File::Basename;

open(IN,"../1553664216547.outOEKOjuchayi.fa_result");
open(OUT,">result.txt");
$/=">";
my $count_gene=0;
my $motif=0;
print $ARGV[0],"\n";
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_;
        $count_gene++;
        my $sum=0;
        if($seq =~/$ARGV[0]/i){
                #print OUT ">".$gene_id."\n".$seq."\n";
                while($seq =~/$ARGV[0]/ig){
                        $sum++;
                }
                $motif +=$sum;
        }
}

my $frequency=($motif/$count_gene)*100;
$frequency=sprintf("%.2f",$frequency); #print format with two decimal assigment to variable $frequency
$frequency =$frequency."%";

close IN;
open(IN,"../1553664216547.outOEKOjuchayi.fa");
while(<IN>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split /\n/,$_;
        my $sum=0;
        if($seq =~/$ARGV[0]/i){
                while($seq =~/$ARGV[0]/ig){
                        $sum++;
                }
                print OUT '>'.$gene_id."\t"."Sequence_frequency: ".$sum."\t"."Total_frequency_ratio: ".$frequency."\n".$seq."\n";
        }

}

##USAGE：
perl $0 motif<ATCGT> 





close IN;
