#!/usr/bin/perl -w 
use strict;
use warnings;
use File::Basename;
my @file=glob("/share/nas1/honghh/personality/xiangmu/Result/*.result");
my %fa=();
open(IN1,"$ARGV[0]") or die $!;
my $count1=0;
$/=">";
while(<IN1>){
	chomp;
	next if(/^$/);
	my ($gene_id,$seq)=split /\n/,$_;
	my $real_id=(split /\|/,$gene_id)[1];
	my $real_id1=(split /\s+/,$real_id)[0];
	$fa{$real_id1}=$seq;
	$count1++;
}
print $count1,"\n";
$/="\n";
close IN1;

while(my $file=<@file>){
	my %hash=();
	my $count=0;
	open(IN,"$file") or die $!;
	my $basename=basename($file);
	open(OUT,">$basename\_seq.list");
	while(<IN>){
		chomp;
		if(/^Up|^\#|^Down/){
			next;
		}
		my $gene_id=(split /\|/,(split /\t/,$_)[1])[1];
               	$count++;
                $hash{$gene_id} =[$count,$_];
		
	}
	for my $key(sort{$hash{$a}[0]<=>$hash{$b}[0]} keys %hash){
		if(exists $fa{$key}){
			print OUT $hash{$key}[1],"\t",$fa{$key},"\n";
		}
	}

	close IN;
	close OUT;
}
