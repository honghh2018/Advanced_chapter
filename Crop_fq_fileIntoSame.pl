#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my ($fq1,$fq2);
GetOptions(
	"fq1:s" => \$fq1,
	"fq2:s" => \$fq2,
);

&USAGE unless(defined $fq1 or defined $fq2);


open(IN1,"$fq1") or die $!;
open(IN2,"$fq2") or die $!;

my %fq1=();
my %fq2=();
my @array1=();
my @array2=();
my $count=0;
my $count1=0;
while(<IN1>){
	chomp;
	push @array1,$_;
	if(scalar @array1==4){
		$count++;
		$fq1{$count}=[$array1[0],$array1[1],$array1[2],$array1[3],$count];
		@array1=();
	}
}

close IN1;
while(<IN2>){
	chomp;
	push @array2,$_;
	if(scalar @array2==4){
		$count1++;
		$fq2{$count1}=[$array2[0],$array2[1],$array2[2],$array2[3],$count1];
		@array2=();
	} 
	
}
close IN2;
my $o1=basename($fq1);
my $o2=basename($fq2);
open(OUT,">$o1\.new");
open(OUT1,">$o2\.new");		

foreach my $key(sort{${$fq1{$a}}[4] <=> ${$fq1{$b}}[4]} keys %fq1){
	if(exists $fq2{$key}){
		my $fq1_0=length(${$fq1{$key}}[0]);
		my $fq1_1=length(${$fq1{$key}}[1]);
		my $fq1_2=length(${$fq1{$key}}[2]);
		my $fq1_3=length(${$fq1{$key}}[3]);
		my $fq2_0=length(${$fq2{$key}}[0]);
		my $fq2_1=length(${$fq2{$key}}[1]);
		my $fq2_2=length(${$fq2{$key}}[2]);
		my $fq2_3=length(${$fq2{$key}}[3]);
		if($fq1_0 == $fq2_0 && $fq1_1==$fq2_1 && $fq1_2 == $fq2_2 && $fq1_3==$fq2_3){
			print OUT ${$fq1{$key}}[0],"\n";
			print OUT ${$fq1{$key}}[1],"\n";
			print OUT ${$fq1{$key}}[2],"\n";
			print OUT ${$fq1{$key}}[3],"\n";
			print OUT1 ${$fq2{$key}}[0],"\n";
			print OUT1 ${$fq2{$key}}[1],"\n";
			print OUT1 ${$fq2{$key}}[2],"\n";
			print OUT1 ${$fq2{$key}}[3],"\n";
		}
		
	}
}

close OUT;
close OUT1;

sub USAGE{
	my $usage=<<"USAGE";
	usage:
	perl $0 -fq1 <fq1> -fq2 <fq2>
	Need few mem to calculate;
USAGE
	print $usage;
	exit;
}
