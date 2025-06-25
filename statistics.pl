#!/usr/bin/perl -w

use Math::CDF;

$split_used = 0;

$alpha = 0.05;
$superalpha = 0.025;
$verbose = 1;

$errorcode = 0;

$theory_dist = <<'Theory';
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

$theory_split = <<'Theory';
0       0       0 10400600   1.00000000     1.00000000

1       1       0 5200300    0.50000000     1.00000000

2       2       0 2496144    0.24000000     0.48000000
2       1       1 5408312    0.52000000     0.52000000

3       3       0 1144066    0.11000000     0.22000000
3       2       1 4056234    0.39000000     0.78000000

4       4       0  497420    0.04782609     0.09565217
4       3       1 2586584    0.24869565     0.49739130
4       2       2 4232592    0.40695652     0.40695652

5       5       0  203490    0.01956522     0.03913043
5       4       1 1469650    0.14130435     0.28260870
5       3       2 3527160    0.33913043     0.67826087

6       6       0   77520    0.00745342     0.01490683
6       5       1  755820    0.07267081     0.14534161
6       4       2 2519400    0.24223602     0.48447205
6       3       3 3695120    0.35527950     0.35527950

7       7       0   27132    0.00260870     0.00521739
7       6       1  352716    0.03391304     0.06782609
7       5       2 1587222    0.15260870     0.30521739
7       4       3 3233230    0.31086957     0.62173913

8       8       0    8568    0.00082380     0.00164760
8       7       1  148512    0.01427918     0.02855835
8       6       2  891072    0.08567506     0.17135011
8       5       3 2450448    0.23560641     0.47121281
8       4       4 3403400    0.32723112     0.32723112

9       9       0    2380    0.00022883     0.00045767
9       8       1   55692    0.00535469     0.01070938
9       7       2  445536    0.04283753     0.08567506
9       6       3 1633632    0.15707094     0.31414188
9       5       4 3063060    0.29450801     0.58901602

10      10       0     560    0.00005384     0.00010769
10       9       1   18200    0.00174990     0.00349980
10       8       2  196560    0.01889891     0.03779782
10       7       3  960960    0.09239467     0.18478934
10       6       4 2402400    0.23098667     0.46197335
10       5       5 3243240    0.31183201     0.31183201

11      11       0     105    0.00001010     0.00002019
11      10       1    5005    0.00048122     0.00096244
11       9       2   75075    0.00721833     0.01443667
11       8       3  495495    0.04764100     0.09528200
11       7       4 1651650    0.15880334     0.31760668
11       6       5 2972970    0.28584601     0.57169202

12      12       0      14    0.00000135     0.00000269
12      11       1    1092    0.00010499     0.00020999
12      10       2   24024    0.00230987     0.00461973
12       9       3  220220    0.02117378     0.04234756
12       8       4  990990    0.09528200     0.19056401
12       7       5 2378376    0.22867681     0.45735361
12       6       6 3171168    0.30490241     0.30490241

13      13       0       1    0.00000010     0.00000019
13      12       1     169    0.00001625     0.00003250
13      11       2    6084    0.00058497     0.00116993
13      10       3   81796    0.00786455     0.01572909
13       9       4  511225    0.04915341     0.09830683
13       8       5 1656369    0.15925706     0.31851412
13       7       6 2944656    0.28312367     0.56624733
Theory

@names_compass = ("N", "E", "S", "W");
@names_suit = ("S", "H", "D", "C");
@names_card = ("2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A");

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

    # print "compass $compass, suitlen: @suitlen\n";
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

sub init_report {

    $full_report = "";
}

sub report {
    my ($manyfew, $distr, $thands, $phands, $perc) = @_;

    my $result = sprintf "$manyfew  $distr Theory %6.1f: Set %4d percentile %.6f%%\n", $thands, $phands, 100*$perc;
    $full_report .= $result;
}

sub print_report {

    print $full_report;
    init_report();
}

sub outlyer {
    my($binom, $alpha) = @_;

    $binom -= 0.5;	# Now between -0.5 and 0.5
    my $sign = $binom < 0 ? -1 : 1;
    $binom = abs($binom);
    $binom = 0.5 - $binom;
    return 2*$sign if ($binom < $alpha/10);
    return 1*$sign if ($binom < $alpha);
    return 0;
}

sub olstring {
    my($ol) = @_;

    return "        " unless($ol);
    my $s = $ol > 0 ? "too many" : "too few ";
    $s = uc $s if (abs($ol)>1);
    return $s;
}

for $t (split(/\n/, $theory_dist)) {
    my ($l1, $l2, $l3, $l4, $perc, $type) = split(/\s+/, $t);
    my $index = "$l1:$l2:$l3:$l4";
    $d_perc{$index} = $perc;
    $d_type{$index} = $type;
    $d_tperc{$type} += $perc;
    push(@distrs, $index);
}
# print "@distrs\n";
# die;

#
# This looks like it should calculate splits, like 5-crd suit split 0 5 or 1 4 or 2 3
# clearly not implemented further
#

if ($split_used) {
    for $t (split(/\n+/, $theory_split)) {
	print "$t\n";
	my ($ncards, $high, $low, $n, $p, $frac) = split(/\s+/, $t);
	my $index = "$high:$low";
	$s_perc{$index} = $frac;
    }
    print %s_perc{"1:1"} if(0);	# prevent warning for this unused code
}

$complete_hands = 0;
while(<>) {
    chomp;
    s/[ \r]*$//;
    s/^ *//;

    #
    # Sometimes we only have the suitlengths
    #
    if ($_ =~ /^[0-9 ]*$/) {
	@nums = split;
	# Then it should be 16
	die "wrong number of numbers" unless($#nums == 15);
	countfreq("N", @nums[0..3]);		# North
	countfreq("E", @nums[4..7]);		# East
	countfreq("S", @nums[8..11]);		# South
	countfreq("W", @nums[12..15]);		# West
	next;
    }

    # We have complete hands

    my (@countar);

    # Complete hands
    my @hands = split / /;
    die unless $#hands==3;
    # print "Hands: @hands\n";
    $complete_hands++;
    for my $compass (@names_compass) {
	my (@suitlen);
	$chand = shift(@hands);
	my @suits = split (/\./, $chand, 4);
	die unless $#suits==3;
	# print "Suit $compass: @suits\n";
	for my $suit (@names_suit) {
	    my $csuit = shift(@suits);
	    my @cards = split("", $csuit);
	    my $slen = 0;
	    for my $cc (@cards) {
		$slen++;
		$hascard{"$compass:$suit:$cc"}++;
		# print "$compass:$suit:cc $hascard{\"$compass:$suit:$cc\"}\n";
	    }
	    push(@suitlen, $slen);
	}
	countfreq($compass, @suitlen);
    }
    # end loop on input
}

print "read $complete_hands\n";
if ($complete_hands >= 20) {
    $tests = 0;
    $failed = 0;
    init_report();
    for my $c (reverse @names_card) {
	for my $s (@names_suit) {
	    for my $h (@names_compass) {
		my $hc = $hascard{"$h:$s:$c"};
		$hc = 0 unless defined($hc);
		$tests++;
		#
		# Checking for frequency of specific card in player
		#
		my $binom = Math::CDF::pbinom($hc, $nhands/4, 1/4);
		$ol = outlyer($binom, $alpha/2);
		$failed++ if ($ol);
		if ($ol || $verbose>1) {
		    report(olstring($ol), "$h has $s$c", $nhands/16, $hc, $binom);
		}
	    }
	}
    }
    $binom = Math::CDF::pbinom($failed, $tests, $alpha);
    $ol = outlyer($binom, $superalpha/2);

    print_report() if ($verbose);
    if ($ol) {
	print_report();
	my $percentile = 100*$binom;
	print "Final verdict ($failed/$tests): percentile=$percentile%\n";
	print "Distribution not compatible with normal percentages\n";
	$errorcode = 1;
    }
}

#print "Nhands $nhands\n";
$failed=0;
init_report();
for my $d (@distrs) {
    my ($l1, $l2, $l3, $l4) = split /:/, $d;
    my $perc = $d_perc{$d};
    $l = $dcount{$d};
    $l = 0 unless(defined($l));
    $short_perc[$l4] += $perc;
    $short_hands[$l4] += $l;
    $thands = $perc*$nhands;
    # Ignore too seldom cases
    next if ($thands < 5 && $verbose < 2);
    $distr_counted++;
    $binom = Math::CDF::pbinom($l, $nhands, $perc);
    $ol = outlyer($binom, $alpha/2);
    $failed++ if ($ol);
    if ($ol || $verbose>1) {
	report(olstring($ol), "$l1$l2$l3$l4", $thands, $l, $binom);
    }
#    $pperc = $l/$nhands;
#    $diff = abs($pperc-$perc);
#    if ($diff/$perc > 0.01) {
#	print "Theory $l1 $l2 $l3 $l4 $perc%\n";
#	print "Practice: ", $pperc , "\n";
#    }
}
$binom = Math::CDF::pbinom($failed, $distr_counted, $alpha);
$ol = outlyer($binom, $superalpha/2);

print_report() if ($verbose);
if ($ol) {
    print_report();
    my $percentile = 100*$binom;
    print "Final verdict ($failed/$distr_counted): percentile=$percentile%\n";
    print "Distribution not compatible with normal percentages\n";
    $errorcode = 1;
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
if ($chisq > 4.5) {
    print "Normalized chi-square shortest suit: $chisq\n";
    print "Distribution not compatible with normal percentages\n";
    $errorcode = 1;
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
    for my $compass (@names_compass) {
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
	    $errorcode = 1;
	}
	# print "$compass $k $nplus $nmin $mean $variance -- $origval $val $zscore\n";
    }
}
$chisq /= $nchi;
if ($chisq > 4.5) {
    print "Normalized chi-square hand types $chisq\n";
    print "Distribution not compatible with normal percentages\n";
    $errorcode = 1;
}

exit($errorcode);
