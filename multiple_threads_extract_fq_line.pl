#!/usr/bin/perl -w
use strict;
use threads;
use autodie;
use File::Basename;
use Thread::Semaphore;


my $j=0;
my $thread=0;
my $max_thread=@ARGV;
my $semaphore=new Thread::Semaphore($max_thread);

for(my $i=0;$i<@ARGV;$i++){
	my $thr=threads->create(\&readfq,$ARGV[$i]);
        $semaphore->down();
       	$thr->detach();
}

&waitquit();

sub readfq{
	my $file=shift;
	my $count=0;
	my $basename=basename($file);
	open(IN,$file);
        open(OUT,">$basename");
        while(<IN>){
                chomp;
                my $seq=<IN>;chomp $seq;
                my $mark=<IN>;chomp$mark;
                my $quality=<IN>;chomp $quality;
                $count++;
                if($count<=22881472){ #get 22881472 fq line
                        print OUT $_."\n".$seq."\n".$mark."\n".$quality."\n";
                }else{
                        last;
                }
        }
	close IN;
	close OUT;
	$semaphore->up();
}



sub waitquit{
    print "Waiting to quit...\n";
    my $num=0;
    while($num<$max_thread){
        $semaphore->down();
        $num++;
        print "$num thread quit...\n";
    }
    print "All $max_thread thread quit\n";
}

=cut
perl $0 a.fq1 a.fq2 b.fq1 b.fq2 c.fq1 c.fq2 d.fq1 d.fq2
