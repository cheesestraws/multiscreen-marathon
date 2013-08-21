package Bcast;
use strict;

use IO::Socket::INET;

my $sock = undef;

sub send {
	my ($message) = @_;
	$sock = IO::Socket::INET->new(
		Proto => "udp",
		Broadcast => 1,
		PeerPort => 5425,
		PeerAddr => "255.255.255.255"
	) unless $sock;

	$sock->send($message);

}

1;

