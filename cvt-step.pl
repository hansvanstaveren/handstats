#!/usr/bin/perl -w

@symbol = ("A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2");

while(<>) {
    my (@hands);
    chomp;
    s/.*\t//;
    @cards = split("", $_);
    # print "@cards\n";
    for $beg (0,13,26,39) {
	my (@suit);
	$suit[0] = "";
	$suit[1] = "";
	$suit[2] = "";
	$suit[3] = "";
	for $ind (0..12) {
	    $crd = $cards[$beg+$ind];
	    $ord = ord($crd)-66;
	    $suit[int ($ord/13)] .= $symbol[$ord%13];
	    # print "beg $beg ind $ind crd $crd ord $ord\n";
	}
	# print "@suit\n";
	push(@hands, join(".", @suit));
    }
    print join(" ", @hands), "\n";
}
