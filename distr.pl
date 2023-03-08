#!/usr/bin/perl -w

use Math::CDF;

$alpha = 0.05;

$theory = <<'Theory';
4 3 3 3 0.1053613032 balanced
4 4 3 2 0.2155117565 balanced
4 4 4 1 0.0299321884 threesuiter
5 3 3 2 0.1551684646 balanced
5 4 3 1 0.1293070539 twosuiter
5 4 2 2 0.1057966804 twosuiter
5 5 2 1 0.0317390041 twosuiter
5 4 4 0 0.0124333706 threesuiter
5 5 3 0 0.0089520268 twosuiter
6 3 2 2 0.0564248962 singlesuiter
6 4 2 1 0.0470207469 singlesuiter
6 3 3 1 0.0344818810 singlesuiter
6 4 3 0 0.0132622619 singlesuiter
6 5 1 1 0.0070531120 twosuiter
6 5 2 0 0.0065105650 twosuiter
6 6 1 0 0.0007233961 twosuiter
7 3 2 1 0.0188082987 singlesuiter
7 2 2 2 0.0051295360 singlesuiter
7 4 1 1 0.0039183956 singlesuiter
7 4 2 0 0.0036169805 singlesuiter
7 3 3 0 0.0026524524 singlesuiter
7 5 1 0 0.0010850942 singlesuiter
7 6 0 0 0.0000556459 twosuiter
8 2 2 1 0.0019235760 singlesuiter
8 3 1 1 0.0011755187 singlesuiter
8 3 2 0 0.0010850942 singlesuiter
8 4 1 0 0.0004521226 singlesuiter
8 5 0 0 0.0000313008 twosuiter
9 2 1 1 0.0001781089 singlesuiter
9 2 2 0 0.0000822041 singlesuiter
9 3 1 0 0.0001004717 singlesuiter
9 4 0 0 0.0000096607 twosuiter
10 1 1 1 0.0000039580 singlesuiter
10 2 1 0 0.0000109605 singlesuiter
10 3 0 0 0.0000015457 singlesuiter
11 2 0 0 0.0000001150 singlesuiter
11 1 1 0 0.0000002491 singlesuiter
12 1 0 0 0.0000000032 singlesuiter
13 0 0 0 0.0000000000 singlesuiter
Theory

$last_type{"N"} = "";
$last_type{"E"} = "";
$last_type{"S"} = "";
$last_type{"W"} = "";

sub countfreq {
    my ($compass, @suitlen) = @_;

    @suitlen = sort { $b <=> $a} @suitlen;
    $nhands++;
    my $index = join(':', @suitlen);
    $dcount{$index}++;

    # print "compass $compass, suiteln: @suitlen\n";
    my $type = $d_type{$index};
    die "$index has no type" unless(defined($type));
    if ($last_type{$compass} ne $type) {
	# print "$compass changes type from $last_type{$compass} to $type\n";
	# Count one positive run
	$nruns{"$compass:$type"}++;
	# Count negative run for previous
	$nruns{"$compass:$last_type{$compass}"}++ if($last_type{$compass} ne "");
	# Change current 
	$last_type{$compass} = $type;
    }
    $ntype{"$compass:$type"}++;
}

sub counthand {
    # @_ containing 16 suitlengths

    countfreq("N", @_[0..3]);		# North
    countfreq("E", @_[4..7]);		# East
    countfreq("S", @_[8..11]);		# South
    countfreq("W", @_[12..15]);		# West
}

sub report {
    my ($manyfew, $distr, $thands, $phands, $perc) = @_;

    printf "$manyfew  $distr Theory %4d: Set %4d percentile %.6f%%\n", $thands, $phands, 100*$perc;
}

for $t (split(/\n/, $theory)) {
    my ($l1, $l2, $l3, $l4, $perc, $type) = split(/\s+/, $t);
    my $index = "$l1:$l2:$l3:$l4";
    $d_perc{$index} = $perc;
    $d_type{$index} = $type;
    $d_tperc{$type} += $perc;
    push(@distrs, $index);
}
# print "@distrs\n";
# die;

while(<>) {
    chomp;
    @nums = split;
    die "wrong number of numbers" unless($#nums == 15);
    counthand(@nums);
}

#print "Nhands $nhands\n";
$failed=0;
# for $t (split(/\n/, $theory)) {
for my $d (@distrs) {
    my ($l1, $l2, $l3, $l4) = split /:/, $d;
    my $perc = $d_perc{$d};
    $l = $dcount{$d};
    $l = 0 unless(defined($l));
    $short_perc[$l4] += $perc;
    $short_hands[$l4] += $l;
    $thands = int($perc*$nhands+0.5);
    next if ($thands < 5);
    $distr_counted++;
    $binom = Math::CDF::pbinom($l, $nhands, $perc);
    if ($binom < $alpha/2) {
	report("too few ", "$l1$l2$l3$l4", $thands, $l, $binom);
	$failed++;
    } elsif ($binom > 1-$alpha/2) {
	report("too many", "$l1$l2$l3$l4", $thands, $l, $binom);
	$failed++;
    } else {
	report($binom > 0.25 && $binom < 0.75 ? "all fine" : "just ok ",
	    "$l1$l2$l3$l4", $thands, $l, $binom) if(0);
    }
#    $pperc = $l/$nhands;
#    $diff = abs($pperc-$perc);
#    if ($diff/$perc > 0.01) {
#	print "Theory $l1 $l2 $l3 $l4 $perc%\n";
#	print "Practice: ", $pperc , "\n";
#    }
}
$binom = Math::CDF::pbinom($failed, $distr_counted, $alpha);

if ($binom > .99) {
    my $percentile = 100*$binom;
    print "Final verdict ($failed/$distr_counted): percentile=$percentile%\n";
    print "Distribution not compatible with normal percentages\n";
}

#print "@short_perc @short_hands\n";
$chisq = 0;
$nchi = 0;
for $shortlen (0..3) {
    my $expect = $short_perc[$shortlen]*$nhands;
    #print "nhands $nhands expected $shortlen $expect\n";
    $chisq += ($short_hands[$shortlen]-$expect)**2/$expect;
    $nchi++;
}
$chisq /= $nchi;
print "Normalized chi-square shortest suit: $chisq\n";
if ($chisq > 4.5) {
    print "Distribution not compatible with normal percentages\n";
}

for my $k (keys(%nruns)) {
    my $nr = $nruns{$k};
    my $nt = $ntype{$k};
    my ($compass, $type) = split /:/, $k;
    $tntype{$type} += $nt;
    # print "$k ntype $nt nruns $nr tntype $tntype{$type}\n";
}

$chisq = 0;
$nchi=0;
for my $k (sort { $tntype{$b} <=> $tntype{$a} } keys(%tntype)) {
    my $expect = $d_tperc{$k} * $nhands;
    $chisq += ($tntype{$k}-$expect)**2/$expect;
    $nchi++;
    for my $compass ("N", "E", "S", "W") {
	my $nplus = $ntype{"$compass:$k"};
	$nplus = 0 unless(defined($nplus));
	last if ($nplus < 5);
	my $nmin = $nhands/4 - $nplus;
	my $mean = 2*$nplus*$nmin/($nhands/4)+1;
	my $variance = ($mean-1)*($mean-2)/($nhands/4-1);
	my $origval = $val = $nruns{"$compass:$k"};
	$val -= $mean;
	$val /= sqrt($variance);
	my $zscore = Math::CDF::pnorm($val);
	if ($zscore < $alpha/2 || $zscore > 1-$alpha/2) {
	    print "$compass($k) fails runs test with zscore $zscore\n";
	}
	# print "$compass $k $nplus $nmin $mean $variance -- $origval $val $zscore\n";
    }
}
$chisq /= $nchi;
print "Normalized chi-square hand types $chisq\n";
if ($chisq > 4.5) {
    print "Distribution not compatible with normal percentages\n";
}
