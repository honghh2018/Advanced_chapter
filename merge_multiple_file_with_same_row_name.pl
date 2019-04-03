#!/usr/bin/perl
use strict;
use warnings;

my %integrate;
my $header = "#ID";
$\="\n";
$,="\t";
for my $i (0..scalar@ARGV-1){
  $header.="\t$ARGV[$i]";
  open IN,"$ARGV[$i]";
  while(<IN>){
    next if($.==1);
    chomp $_;
    my @arr=split;
    $integrate{$arr[0]}[$i]=$arr[1];
  }
  close IN;
}
open O,">merge.list";
print O $header;
foreach my $gene_id(sort{$a cmp $b}keys %integrate){
  foreach my $i(0..scalar @ARGV-1){
    if(!$integrate{$gene_id}[$i]){
      $integrate{$gene_id}[$i]=0;
    }
  }
  print O $key,join("\t",@{$total{$key}});
close O;
undef $\;
undef $,;
##merge file like :a1.txt
gene_1  1780
gene_2  6920
gene_3  4860
gene_4  6660
gene_5  3950
gene_6  480
gene_7  9260
gene_8  7330
gene_9  6600
gene_10 5780
a2.txt
gene_1  178
gene_2  692
gene_3  486
gene_4  666
gene_5  395
gene_6  48
gene_7  926
gene_8  733
gene_9  660
gene_10 578
USAGE:perl $0 a1.txt a2.txt
