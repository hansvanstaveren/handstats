#!/usr/bin/perl -w

while(<>) {
    chomp;

    s/ *$//;
    @fields = split(/[ \.]/, $_, 16);
    #print $#fields, "\n";
    for $i (0..15) {
	$len = length($fields[$i]);
	print "$len";
	print $i==15 ? "\n" : " ";
    }
}
