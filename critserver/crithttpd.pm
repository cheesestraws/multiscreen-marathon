#!/usr/bin/perl
package crithttpd;
use strict;
use Net::Server;
use DBI;
use Data::Dumper;
use base qw(Net::Server::HTTP);

my $dbh; 

sub start {
	my $filename="db.sqlite";
	$dbh = DBI->connect("dbi:SQLite:dbname=$filename", "", "");
	__PACKAGE__->run(port => 5426);
}

sub process_http_request {
	my ($self) = @_;
	
	my $url = $ENV{'REQUEST_URI'};
	my ($dummy, $level, $id, $name) = split /\//, $url;

	my $sth = $dbh->prepare("SELECT * FROM asset WHERE level=? AND id=? AND name=?");
	$sth->execute($level, $id, $name);
	my $row = $sth->fetchrow_hashref();
	
	if (defined $row) {
		print "Status: 200 OK\n";
		print "Content-type: " . $row->{'mimetype'} . "\n\n";
		print $row->{'data'};
	} else {
		print "Status: 404 Not Found\nContent-type: text/plain\n\nNo such asset";
	}
}

1;	
