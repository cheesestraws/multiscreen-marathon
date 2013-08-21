UDPListener = {};

UDPListener.start = function(success) {
	cordova.exec(success, function() { alert("Ugh, UDP failed"); },
					"UDPListener", "start", []);
}