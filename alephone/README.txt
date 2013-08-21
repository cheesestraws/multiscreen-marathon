This is a patch against Aleph One 20120514.

It provides a "udp_blat" function that sends a UDP packet to the specified port on the local machine.

Syntax:
	udp_blat(port, "message")
	
To use it:
----------

Copy the contents of the Source_Files directory over their corresponding files in the standard Aleph One source tree.  Add the lua_udp_hack.* files to the project of your choice (we were using the Xcode project), build and hope.

Once it's built it's a good idea to test it using wireshark and the Marathon console.

Note: this /is/ a fairly awful hack.  Caveat ludor.
	
License:
--------

This is under the GPLv3.  A copy of this license is provided in the COPYING file in the root directory of the distribution.  If it breaks, you get to keep both pieces.

