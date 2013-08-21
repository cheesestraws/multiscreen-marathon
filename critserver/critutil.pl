#!/usr/bin/perl
use strict;
use DBI;
use Data::Dumper;

my $filename = "db.sqlite";
my $dbh = DBI->connect("dbi:SQLite:dbname=$filename", "", "");

my $verb = shift @ARGV;

if ($verb eq 'create') {
	$dbh->do("DROP TABLE IF EXISTS point");
	$dbh->do("DROP TABLE IF EXISTS asset");
	$dbh->do(q{
		CREATE TABLE point (
			level VARCHAR(128),
			x INT,
			y INT,
			radius INT,
			id VARCHAR(128)
		)
	});

	$dbh->do(q{
		CREATE TABLE asset (
			level VARCHAR(128),
			id VARCHAR(128),
			name VARCHAR(128),
			mimetype VARCHAR(64),
			data BLOB
		);
	});
} elsif ($verb eq 'edithtml') {
	my $level = lc(shift @ARGV);
	my $id = lc(shift @ARGV);
	# Create a temp file
	use File::Temp;
	my $f = File::Temp->new();
	my $fn = $f->filename;
	my $ofn = select($f); $|++; select($ofn);
	
	# Is there already html under this id?
	my $hashtml = 0;
	my $sth = $dbh->prepare("SELECT * FROM asset WHERE level=? AND id=? AND name=''");
	$sth->execute($level, $id);
	my $row = $sth->fetchrow_hashref();
	if (defined $row) {
		$hashtml=1;
		print $f $row->{'data'};
		print "hashtml";
	}
	$sth->finish;

	# Edit temp file
	system("vi $fn");

	# Read temp file back in
	my $content = "";
	open my $newf, '<', $fn;
	while (<$newf>) {
		$content .= $_;
	}
	close $newf;
	
	# Save into DB
	my $qry;
	if ($hashtml) {
		$qry = "UPDATE asset SET data=? WHERE level=? AND id=? AND name=''";
	} else {
		$qry = "INSERT INTO asset (data, level, id, name, mimetype) VALUES (?, ?, ?, '', 'text/html')";
	}
	$sth = $dbh->prepare($qry);
	$sth->execute($content, $level, $id);

	$sth->finish;
} elsif ($verb eq 'hotspot') {
	my $level = shift @ARGV;
	my $x = shift @ARGV;
	my $y = shift @ARGV;
	my $radius = shift @ARGV;
	my $id = shift @ARGV;

	my $sth = $dbh->prepare("INSERT INTO point (level, x, y, radius, id) VALUES (?,?,?,?,?)");
	$sth->execute($level, $x, $y, $radius, $id);
} elsif ($verb eq 'mkimage') {
	my $level = lc(shift @ARGV);
	my $id = lc(shift @ARGV);
	my $name = shift @ARGV;
	my $filename = shift @ARGV;
	my $mimetype;

	if ($filename =~ /\.gif$/) {
		$mimetype = "image/gif";
	} elsif ($filename =~ /\.png$/) {
		$mimetype = "image/png";
	} elsif ($filename =~ /\.jpg$/ || $filename =~ /\.jpeg$/) {
		$mimetype = "image/jpeg";
	} else {
		$mimetype = "application/octet-stream";
	}

	my $content = "";
	open my $fh, '<', $filename;
	my $line;
	while(defined($line = <$fh>)) {
		$content .= $line;
	}	
	close($fh);

	my $qry = "INSERT INTO asset (data, level, id, name, mimetype) VALUES (?, ?, ?, ?, ?)";
	my $sth = $dbh->prepare($qry);
	$sth->execute($content, $level, $id, $name, $mimetype);
}
