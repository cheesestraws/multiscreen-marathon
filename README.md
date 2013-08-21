multiscreen-marathon
====================
This is the initial Multiscreen Marathon distribution from Rob Mitchelmore & Rob Jones.

To use it you need to do the following things:

1. Build Aleph One with the included patch.
	* See the alephone directory in this tarball
2. Tell Aleph One to use the provided Export.lua script as the "Solo script".
	* Look in Preferences -> Environment.  The script is in the "Lua" folder.
3. Run critserver.pl.  This is in the critserver/ directory.
	* You will need to have DBD::SQLite and Net::HTTP::Server installed.
	* CPAN is probably your friend here.
	* sudo cpan DBD::SQLite && sudo cpan Net::HTTP::Server
4. Install the Multiscreen Marathon app on your phone.
	* There's a debug APK inside the tree provided.
	* You can build your own if you have the Android SDK.
5. Load the Multiscreen Marathon app on your phone
	* Make sure that the phone is on the same network segment as the 
	  computer running the game!  The same wireless network should be
	  fine here.
6. Try playing the first level of Marathon 1.


All of this cruft is under the GPLv3.  There is a COPYING file that contains this license.


SO YOU WANT TO MAKE YOUR OWN NOTES
==================================

This requires a bit of a run-up.  Go and get yourself a stiff drink.  We'll wait.

The notes themselves are in the db.sqlite file in the critserver directory.  This is an SQLite3 database.  You can open it with something like the SQLiteBrowser and have a look around.

A note belongs to a level and has an id.  A note consists of a number of assets.  Each asset has a name.  The basic note has an asset name of '', and should consist of either HTML or plain text.

If it consists of HTML, then it can refer to other assets by their name.  For example:
	<img src="assetname">
	
Level names are all in lowercase.

Assets are in the 'asset' table.

Then, hotspots are added to the level.  Hotspots in this version of MM are all circular, because we're lazy like that.

These are in the hotspots table.


WHAT, YOU WANT A USER INTERFACE?
================================

At the moment, the best you're getting is critutil.pl.

READ THE CODE BEFORE YOU USE THIS.  It is rudimentary /in the extreme/.

./critutil.pl create
	if you delete or completely hose db.sqlite
./critutil.pl edithtml <level> <noteid>
	edits '' for the level/noteid pair.  May contain vi.
./critutil.pl mkimage <level> <noteid> <assetname> <path>
	inserts an image into the database.
./critutil.pl hotspot <level> <x> <y> <radius> <noteid>
	associates a noteid with a position