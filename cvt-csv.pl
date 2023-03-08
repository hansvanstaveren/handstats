#!/usr/bin/perl -w

while(<>) {
    chomp;

    @fields = split /,/;
    #print $#fields, "\n";
    for $i (0..15) {
	$_ = $fields[$i];
	s/"//g;
	print $_;
	print $i==15 ? "\n" : $i%4!=3 ? "." : " ";
    }
}
