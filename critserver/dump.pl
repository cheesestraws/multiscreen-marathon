#!/usr/bin/perl
use strict;
use IO::Socket::INET;

# autoflush
$|++;

my $socket = IO::Socket::INET->new(
	LocalPort => '5424',
	Proto => 'udp'
) or die 'Could not create listening socket';

my $data;
while(1) {
	$socket->recv($data, 1024);
	`clear`;
	my @line = split /|/, $data;
	my ($game, $msgtype) = shift @line;
	print "Game: $game \n";
	print "Msgtype: $msgtype \n";
	print $data . "\n";
}
