#!/usr/bin/perl -w
#use strict; strict declaration should be inhibited within symbolic reference 
no strict 'refs'; ##no strict syntax claim symbolic reference worked,so strict synatx had symoblic reference syntax invalid.

$name="some";
$$name="helloworld"; ##symbolic reference
print $some."\n";

##dynamic build variables through symbolic reference, which its example show below
for (1..5){
   $name="$_";
   ${"var".$name}="Hello,this is VAR $_!";
 }
print $var3;  #Hello,this is VAR 3

#hard reference was built with symbol '\' like below
my $a="helloworld";
my $b=\$a;

note:
use strict 'refs';  it was informed that perl interpretation no allowing to use symbolic reference 

