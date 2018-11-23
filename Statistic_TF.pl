#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
open(IN,"$ARGV[0]");
my $basename=basename($ARGV[0]);
open(OUT,">$basename\_result.list");
open(OUT1,">test.list");
my %hash=();
while(<IN>){
	chomp;
	my $tf=(split /\s+/,$_)[0];
	$hash{$tf} +=1;
}
close IN;
my $i=0;
my $Other=0;
for my $key(sort{$hash{$b}<=>$hash{$a}} keys %hash){
	print OUT1 $key,"\t";
	print OUT1 $hash{$key},"\n";
	$i++;
	if($i<10){
		print OUT $key,"\t";
        	print OUT $hash{$key},"\n";
		next;
	}
	$Other +=$hash{$key};
}
print OUT "Other\t",$Other;
close OUT;
