-- This is a test script for the footnote-o-matic.

Triggers = {}
numtix = 0
tick_count = 15

function make_position_packet()
	local payload = "marathon|position|"
	payload = payload .. Level.name .. "|"
	payload = payload .. Players[0].x .. "|"
	payload = payload .. Players[0].y .. "|"
	payload = payload .. Players[0].z .. "|"
	payload = payload .. Players[0].direction
	return payload
end

function Triggers.idle()
	numtix = numtix + 1
	if numtix == tick_count then
		udp_blat(5424, make_position_packet());
		numtix = 0
	end
end
