#!/usr/bin/perl -w

sub readfile {
    my ($filename) = @_;

    $/ = undef;
    open FILE, $filename || die "Cannot open $filename";
    $contents = <FILE>;
    #print "File $filename, length ", length $contents, "\n";
    close FILE;
    return $contents;
}

sub splitdup {
    my ($records) = @_;

    for(;;) {
	$_ = substr $records, 0, 156, "";
	last if (length $_ != 156);
	s/^[^\006]*(\006.*)/$1/;
	$_ = substr $_, 0, 68;
	s/\006/ /g;
	s/[\003-\005]/./g;
	s/^ //;
	print "$_\n";
    }
}

for $f (@ARGV) {
    $c = readfile($f);
    splitdup($c);
}
