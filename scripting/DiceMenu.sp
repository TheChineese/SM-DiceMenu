#include <sourcemod>
#include <morecolors>
#undef REQUIRE_PLUGIN
#include <updater>

#define UPDATE_URL    "http://bitbucket.toastdev.de/sourcemod-plugins/raw/a18e60cec31c4d60960f3426d6b3af3481d0169d/DiceMenu.txt"

public Plugin:myinfo = 
{
	name = "DiceMenu",
	author = "Toast",
	description = "Provides a menu for the dice Plugin by Popoklopsi",
	version = "1.0.1",
	url = "sourcemod.net"
}
new Handle:c_DiceText;
new Handle:c_DiceTeam;
new DiceTeam;
new NoDice[MAXPLAYERS + 1];
new Dice[MAXPLAYERS + 1];
new String:DiceText[64];
public displaymenu(client)
{
	new String:string[64];
	new Handle:menu = CreateMenu(DiceMenuHandler);
	Format(string,sizeof(string),"%t", "menutitle", LANG_SERVER);
	SetMenuTitle(menu, string);
	Format(string,sizeof(string),"%t", "menu1", LANG_SERVER);
	AddMenuItem(menu, "dice", string);
	Format(string,sizeof(string),"%t", "menu2", LANG_SERVER);
	AddMenuItem(menu, "dicea", string);
	Format(string,sizeof(string),"%t", "menu3", LANG_SERVER);
	AddMenuItem(menu, "ndice", string);
	Format(string,sizeof(string),"%t", "menu4", LANG_SERVER);
	AddMenuItem(menu, "ndicea", string);
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 0);
}
public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);
	HookEvent("player_disconnect", PlayerDissconnect);
	HookEvent("player_activate", PlayerJoin);
	HookEvent("server_cvar", CvarChange);
	
	c_DiceText = FindConVar("dice_text");
	c_DiceTeam = FindConVar("dice_team");
	if(c_DiceText != INVALID_HANDLE){
		GetConVarString(c_DiceText, DiceText, sizeof(DiceText));
	}
	if(c_DiceTeam != INVALID_HANDLE){
		DiceTeam = GetConVarInt(c_DiceTeam);
	}
	CreateConVar("dicemenu_version", "1.0", "The current version of the plugin");
	
	RegConsoleCmd("sm_dreset", dreset);
	RegConsoleCmd("sm_dmenu", dmenu2);
	
	LoadTranslations("dicemenu.phrases");
	
	if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
	
	
}
public OnLibraryAdded(const String:name[])
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL)
    }
}

public Action:dmenu2(client, args)
{
	new Team;
	Team = GetClientTeam(client);
	if(Team == 1 || Team == 0)
	{
	}
	else if(Team == 2 || Team == 3)
	{
		if(DiceTeam == 0)
		{
			if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
			{
				displaymenu(client)
			}
		}
		else if(DiceTeam == 2 && Team == 2)
		{
			if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
			{
				displaymenu(client)
			}
		}
		else if(DiceTeam == 3 && Team == 3)
		{
			if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
			{
				displaymenu(client)
			}
		}
	}
	
}
public CvarChange(Handle:event, const String:name[], bool:dontBroadcast)
{
	c_DiceText = FindConVar("dice_text");
	c_DiceTeam = FindConVar("dice_team");
	if(c_DiceText != INVALID_HANDLE){
		GetConVarString(c_DiceText, DiceText, sizeof(DiceText));
	}
	if(c_DiceTeam != INVALID_HANDLE){
		DiceTeam = GetConVarInt(c_DiceTeam);
	}
}
public PlayerDissconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid;
	userid = GetEventInt(event, "userid");
	Dice[userid] = 0;
	NoDice[userid] = 0;
	
}
public PlayerJoin(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid;
	userid = GetEventInt(event, "userid");
	Dice[userid] = 0;
	NoDice[userid] = 0;
}
public PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new Team;
	new userid;
	new client;
	userid = GetEventInt(event, "userid");
	client = GetClientOfUserId(userid);
	Team = GetClientTeam(client);
	if(Team == 1 || Team == 0)
	{
	}
	else if(Team == 2 || Team == 3)
	{
		if(DiceTeam == 0)
		{
			if(Dice[userid] == 0 && NoDice[userid] == 0)
			{
				if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
				{
					displaymenu(client)
				}
			}
			else if(Dice[userid] == 1)
			{
				CreateTimer(2.0, PerformDice, client);
			}
		}
		else if(DiceTeam == 2 && Team == 2)
		{
			if(Dice[userid] == 0 && NoDice[userid] == 0)
			{
				if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
				{
					displaymenu(client)
				}
			}
			else if(Dice[userid] == 1)
			{
				CreateTimer(2.0, PerformDice, client);
			}
		}
		else if(DiceTeam == 3 && Team == 3)
		{
			if(Dice[userid] == 0 && NoDice[userid] == 0)
			{
				if(GetClientTeam(client) != 0 || GetClientTeam(client) != 1)
				{
					displaymenu(client)
				}
			}
			else if(Dice[userid] == 1)
			{
				CreateTimer(2.0, PerformDice, client);
			}
		}
	}
	
}
public DiceMenuHandler(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		new String:info[64];
		GetMenuItem(menu, param2, info, sizeof(info));
		if(strcmp(info, "dice") == 0)
		{
			Dice[GetClientUserId(client)] = 0;
			NoDice[GetClientUserId(client)] = 0;
			FakeClientCommand(client, "sm_%s", DiceText);
			
		}
		else if(strcmp(info, "dicea") == 0)
		{
			Dice[GetClientUserId(client)] = 1;
			NoDice[GetClientUserId(client)] = 0;
			FakeClientCommand(client, "sm_%s", DiceText);
			CPrintToChat(client,"%t %t", "prefix", "save");
			CPrintToChat(client,"%t %t", "prefix", "alert");
		}
		else if(strcmp(info, "ndice") == 0)
		{
			Dice[GetClientUserId(client)] = 0;
			NoDice[GetClientUserId(client)] = 0;
		}
		else if(strcmp(info, "ndicea") == 0)
		{
			Dice[GetClientUserId(client)] = 0;
			NoDice[GetClientUserId(client)] = 1;
			CPrintToChat(client,"%t %t", "prefix", "save");
			CPrintToChat(client,"%t %t", "prefix", "alert");
		}
	}
}
public Action:dreset(client, args)
{
	Dice[GetClientUserId(client)] = 0;
	NoDice[GetClientUserId(client)] = 0;
	CPrintToChat(client,"%t %t", "prefix", "reset");
}
public Action:PerformDice(Handle:timer, any:client)
{
	FakeClientCommand(client, "sm_%s", DiceText);
}