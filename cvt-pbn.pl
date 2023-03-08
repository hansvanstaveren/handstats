#!/usr/bin/perl -w

while(<>) {
    chomp;

    next unless( /^\[Deal "[NESW]:(.*)"\]/ );
    $_ = $1;
    print "$_\n";
    next;
    @fields = split(/[ \.]/, $_, 16);
    #print $#fields, "\n";
    for $i (0..15) {
	$_ = $fields[$i];
	print $_;
	print $i==15 ? "\n" : $i%4!=3 ? "." : " ";
    }
}
