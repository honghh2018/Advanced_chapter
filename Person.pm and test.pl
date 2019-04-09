hui@hui-desktop:~/perl_test/test_new_syntax$ cat Person.pm
#!/usr/bin/perl -w
use strict;
package Person;

=pod #help archives description 
sub new 
{ 
    my $class = shift; 
　　my $self = {                          #hash reference shift from default array @_
　　}; 
　　# Print all the values just for clarification. 
　　bless $self, $class; 
　　return $self; 
} 
=cut

sub new {
	my $class = shift;
	print("CLASS = $class\n");
	my $self = {
		_time=>shift,
		_food=>shift
	}; 
	bless($self,$class);
	return $self;  ##return hash
}


sub sleep{
	my ($selfish,$time)=@_;  #$selfish same as C++ this pointer
	#debug information followed below
	if(my $type=ref $selfish){
		print "time reference type: "."$type"."\n"; #objective of Person
		#print "transmit data: ".$time."\n";
		print "hash self: ".$selfish->{_time}."\n";
		#$self->{_time}[1]=$time if defined ($time)
		#return [$self->{_time}]; #return anonymous array reference
		return $selfish->{_time};
	}
}

sub eat{
	my $food=shift;
	print "menu: ".$food."\n";
}
return 1; #string return 1 must be given

###another file for module test
#!/usr/bin/perl -w
use strict;
use lib '/home/hui/perl_test/test_new_syntax';
use Person;

my $obj=Person->new("Tom","male","hello");
#my $obj=Person::new("Tom","male","hello");
#my $sleep_person=$obj->sleep("10");
my $sleep_person=$obj->sleep();
$obj->eat("meat");
#print "Person: ".$sleep_person->[0]."Sleep time: ".$sleep_person->[1]."\n";
print "person name return: ".$sleep_person."\n";
#Sleep Time: Person=HASH(0x2473cb8)
#menu: Person=HASH(0x2473cb8)
#
##print data:
CLASS = Person
time reference type: Person
Use of uninitialized value $time in concatenation (.) or string at perl_test/test_new_syntax/Person.pm line 34.
transmit data: 
hash self: Tom
menu: Person=HASH(0xa20cb8)
Can't use string ("Tom") as an ARRAY ref while "strict refs" in use at test.pl line 11.



