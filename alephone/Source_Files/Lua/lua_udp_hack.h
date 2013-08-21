/*
 *  lua_udp_hack.h
 *  AlephOne
 *
 *  Created by Rob Mitchelmore on 10/08/2013.
 *  Copyright 2013 Rob Mitchelmore & Rob Jones. All rights reserved.
 *
 */

#ifdef HAVE_LUA
extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}
#endif

void lua_udp_register(lua_State* L);