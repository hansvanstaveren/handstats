#!/usr/bin/perl -w

$mm = 1.0;
for $loop (1..50) {
    $m = 1.0;
    for $i (1..50) {
	$r = rand();
	$r = abs($r-0.5);
	print "m=$m, r=$r\n";
	$m *= $r;
    }
    $mm *= $m**0.02;
}
print $m**0.02, "\n";
