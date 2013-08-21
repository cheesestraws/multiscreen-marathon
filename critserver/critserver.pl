#!/usr/bin/perl
use strict;
use IO::Socket::INET;
use Data::Dumper;
use threads;
use crithttpd;

use Areas;

my $httpthread = threads->create(\&crithttpd::start);
$httpthread->detach();

# autoflush
$|++;

my $socket = IO::Socket::INET->new(
	LocalPort => '5424',
	Proto => 'udp'
) or die 'Could not create listening socket';

my $data;
while(1) {
	$socket->recv($data, 1024);
	# parse out packet
	my @parts = split /\|/, $data;
	print Data::Dumper->Dump([@parts]);
	print $data . "\n";
	my $game = shift @parts;
	my $msg = shift @parts;
	print "game $game message $msg\n";
	
	# is it a position message
	if ($msg eq 'position') {
		my ($level, $x, $y, $z, $heading) = @parts;

		Areas::findArea($level, $x, $y, $z);	
	}
}
