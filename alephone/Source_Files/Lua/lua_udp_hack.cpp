/*
 *  lua_udp_hack.c
 *  AlephOne
 *
 *  Created by Rob Mitchelmore on 10/08/2013.
 *  Copyright 2013 Rob Mitchelmore & Rob Jones. All rights reserved.
 *
 */

#include "lua_udp_hack.h"

#ifdef HAVE_LUA
extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}
#endif

extern "C" {
#include "SDL_net.h"	
}

static int lua_udp_blat(lua_State* L) {
	const char* address = "127.0.0.1";
	
	// get our parameters
	size_t message_len;
	int port = lua_tonumber(L, 1);
	const char* message = lua_tolstring(L, 2, &message_len);
	
	UDPsocket sock;
	IPaddress addr;
	UDPpacket* pack;
	
	if (!(sock = SDLNet_UDP_Open(0))) {
		lua_pushstring(L, "udp_hack: Cannot open socket");
		lua_error(L);
	}
	
	if (!SDLNet_ResolveHost(&addr, address, port)) {
		lua_pushstring(L, "udp_hack: cannot resolve host");
		lua_error(L);
	}
	
	if (!(pack = SDLNet_AllocPacket(message_len))) {
		lua_pushstring(L, "udp_hack: cannot allocate packet");
		lua_error(L);
	}
	
	memcpy(pack->data, message, message_len);
	pack->address.host = addr.host;
	pack->address.port = addr.port;
	pack->len = message_len;
	SDLNet_UDP_Send(sock, -1, pack);
	
	SDLNet_FreePacket(pack);
	
	return 0;
}

void lua_udp_register(lua_State* L) {
	lua_register(L, "udp_blat", &lua_udp_blat);
}

