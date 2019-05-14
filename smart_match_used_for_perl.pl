#!/usr/bin/perl -w
use strict;
no if $] >= 5.018, warnings => "experimental::smartmatch"; #delete Smartmatch is experimental at test1.pl line 9
print "version: ",$],"\n";

my @temp=qw(a b c d e f);
my $match='c';

if($match ~~ @temp){
        print "Having characters:\n";
}else{
        print "NO\n";
