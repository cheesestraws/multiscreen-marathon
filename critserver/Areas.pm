package Areas;
use strict;

use Bcast;
use DBI;

# this is a hack
my %areas = (
	"5.922, 5.078, 1.5" => "This is a big pile of offal."
);

my $filename="db.sqlite";
my $dbh = DBI->connect("dbi:SQLite:dbname=$filename", "", "");
my $oldcontent = "";

sub findArea {
	my ($level, $x, $y, $z) = @_;
	my $content = "";
	my $hasContent = 0;
	$level = lc($level);
	
	%areas = ();
	my $sth = $dbh->prepare("SELECT * FROM point WHERE level=?");
	$sth->execute($level);
	my $row;
	while (defined($row = $sth->fetchrow_hashref())) {
		my $coords = $row->{'x'} . "," . $row->{'y'} . "," . $row->{'radius'};
		my $url = "/" . $level . "/" . $row->{'id'} . '/';
		$areas{$coords} = $url;
	}

	for my $k (keys %areas) {
		# get the centre point of the point
		my ($cx, $cy, $radius) = split /,/, $k;
	
		my $xdist = abs($x - $cx);
		my $ydist = abs($y - $cy);
		my $distance = sqrt($xdist*$xdist + $ydist*$ydist);

		if ($distance <= $radius) {
			$content .= $areas{$k};
			$hasContent = 1;
		}
	}

	if ($content eq $oldcontent) {
		print "stale";
	} else {
		$oldcontent = $content;
		print $content;
		print "\n\n\n";
		print "[[ " . ($oldcontent eq $content) . " ]] \n";
		Bcast::send($content) if $hasContent;
		print "sent...\n";
	}


}

sub fireContent {
	my ($point, $text) = @_;
	
	print $point . " => " . $text . "\n";
}

1;
