/* [CS:GO] Zombie Reloaded Rank
 *
 *  Copyright (C) 2018 Hallucinogenic Troll
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>
#undef REQUIRE_PLUGIN
#include <zombiereloaded>
#define REQUIRE_PLUGIN
#include <colorvariables>
#include <emitsoundany>

#pragma semicolon 1
#pragma newdecls required

#include "zr_rank/variables.sp"
#include "zr_rank/commands.sp"
#include "zr_rank/database.sp"
#include "zr_rank/events.sp"
#include "zr_rank/natives.sp"
#include "zr_rank/top_defenders.sp"

public Plugin myinfo =
{
	name = "[ZR] Rank",
	author = "Hallucinogenic Troll, Anubis Edition",
	description = "Rank Specified for Zombie Reloaded or Zombie Plague Servers",
	version = "1.7-A, Anubis Edition",
	url = "http://HallucinogenicTrollConfigs.com/"
};

public void OnPluginStart()
{
	// Connection to the database;
	SQL_TConnect(OnSQLConnect, "zr_rank");
	
	// ConVars
	g_CVAR_ZR_Rank_StartPoints 	= CreateConVar("zr_rank_startpoints", "100", "How many points that a new player starts", _, true, 0.0, false);
	g_CVAR_ZR_Rank_InfectHuman = CreateConVar("zr_rank_infecthuman", "1", "How many points you get when you infect an human (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_KillZombie = CreateConVar("zr_rank_killzombie", "1", "How many points you get when you kill a zombie (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_KillZombie_Headshot = CreateConVar("zr_rank_killzombie_headshot", "2", "How many points you get when you kill a zombie with an headshot", _, true, 0.0, false);
	g_CVAR_ZR_Rank_StabZombie_Left = CreateConVar("zr_rank_stabzombie_left", "1", "How many points you get when you stab a zombie with left mouse button (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_StabZombie_Right = CreateConVar("zr_rank_stabzombie_right", "1", "How many points you get when you stab a zombie with right mouse button (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_KillZombie_Knife = CreateConVar("zr_rank_killzombie_knife", "5", "How many points you get when you kill a zombie with a knife (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_KillZombie_HE = CreateConVar("zr_rank_killzombie_he", "3", "How many points you get when you kill a zombie with a HE Grenade (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_KillZombie_SmokeFlashbang = CreateConVar("zr_rank_killzombie_smokeflashbang", "20", "How many points you get when you kill a zombie with a Smoke Grenade or a Flashbang (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_MaxPlayers_Top = CreateConVar("zr_rank_maxplayers_top", "50", "Max number of players that are shown in the top commands", _, true, 1.0, false);
	g_CVAR_ZR_Rank_MinPlayers = CreateConVar("zr_rank_minplayers", "4", "Minimum players for activating the rank system (0 will disable this function)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_Prefix = CreateConVar("zr_rank_prefix", "[{purple}ZR Rank{default}]", "Prefix to be used in every chat's plugin");
	g_CVAR_ZR_Rank_BeingInfected = CreateConVar("zr_rank_beinginfected", "1", "How many points you lost if you got infected by a zombie", _, true, 0.0, false);
	g_CVAR_ZR_Rank_BeingKilled = CreateConVar("zr_rank_beingkilled", "1", "How many points you lost if you get killed by an human", _, true, 0.0, false);
	g_CVAR_ZR_Rank_AllowWarmup = CreateConVar("zr_rank_allow_warmup", "0", "Allow players to get or lose points during Warmup", _, true, 0.0, true, 0.0);
	g_CVAR_ZR_Rank_Suicide = CreateConVar("zr_rank_suicide", "0", "How many points do you lose when you suicide (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_RoundWin_Zombie = CreateConVar("zr_rank_roundwin_zombie", "1", "How many points you get by winning a round as a zombie", _, true, 0.0, false);
	g_CVAR_ZR_Rank_RoundWin_Human = CreateConVar("zr_rank_roundwin_human", "1", "How many points you get by winning a round as an human", _, true, 0.0, false);
	g_CVAR_ZR_Rank_Inactive_Days = CreateConVar("zr_rank_inactive_days", "30", "How many days a player needs to be inactive and deleted from the database (0 will disable it)", _, true, 0.0, false);
	g_CVAR_ZR_Rank_Defenders_Enabled = CreateConVar("zr_rank_defenders_enabled", "1.0", "Plugin is enabled or disabled.", _, true, 0.0, true, 1.0);
	g_CVAR_ZR_Rank_Defenders_Top_List = CreateConVar("zr_rank_defenders_top_list", "5.0", "How many players will be listed on the top list. (1.0-20.0)", _, true, 1.0, true, 64.0);
	g_CVAR_ZR_Rank_Minium_Damage = CreateConVar("zr_rank_defenders_minium_damage", "500.0", "The total minimum damage for players to be listed. (1.0-5000.0)", _, true, 1.0, true, 5000.0);
	g_CVAR_ZR_Rank_Defenders_Save_Enable = CreateConVar("zr_rank_defenders_save_enabled", "1.0", "Save Top 1 from turning zombie.", _, true, 0.0, true, 1.0);
	g_CVAR_ZR_Rank_Defenders_Sound_Enable = CreateConVar("zr_rank_defenders_sound_enabled", "1.0", "Save sound enabled or disabled.", _, true, 0.0, true, 1.0);
	g_CVAR_ZR_Rank_HudSave_Position = CreateConVar("zr_rank_defenders_hudsave_position", "-1.0 0.150", "The X and Y position for the HudSave.");
	g_CVAR_ZR_Rank_HudTop_Position = CreateConVar("zr_rank_defenders_hudtop_position", "-1.0 0.775", "The X and Y position for the HudTop.");
	g_CVAR_ZR_Rank_MyHudTop_Position = CreateConVar("zr_rank_defenders_myhudtop_position", "-1.0 0.900", "The X and Y position for the MyHudTop.");
	g_CVAR_ZR_Rank_Hud_Colors = CreateConVar("zr_rank_defenders_hud_colors", "255 255 0", "RGB color value for the hud.");
	g_CVAR_ZR_Rank_Defenders_Sound  = CreateConVar("zr_rank_defenders_sound", "top/bells.mp3", "Saved from becoming a zombie,Sound.");
	
	// Events
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEvent("round_start",Event_RoundStart, EventHookMode_PostNoCopy);
	
	// Normal Commands
	RegConsoleCmd("sm_rank", Command_Rank, "Shows a player rank in the menu");
	RegConsoleCmd("sm_mystats", Command_MyStats, "Shows all the stats of a player");
	RegConsoleCmd("sm_top", Command_Top, "Shows the Top Players List, order by points");
	RegConsoleCmd("sm_topkills", Command_TopZombieKills, "Show the Top Players List, order by Zombie Kills");
	RegConsoleCmd("sm_topinfects", Command_TopInfectedHumans, "Show the Top Players List, order by Infected Humans");
	RegConsoleCmd("sm_humanwins", Command_TopWinRounds_Human, "Show the Top Players List, order by Round Wins as a Human");
	RegConsoleCmd("sm_zombiewins", Command_TopWinRounds_Zombie, "Show the Top Players List, order by Round Wins as a Zombie");
	RegConsoleCmd("sm_resetmyrank", Command_ResetMyRank, "It lets a player reset his rank all by himself");
	
	// Admin Commands
	RegAdminCmd("sm_resetrank_all", Command_ResetRank_All, ADMFLAG_ROOT, "Deletes all the players that are in the database");
	
	// Exec Config
	AutoExecConfig(true, "zr_rank", "zr_rank");
	
	// Translations
	LoadTranslations("zr_rank.phrases");
	
	
	// Let's iniciate to 0, just to be sure;
	g_ZR_Rank_NumPlayers = 0;
	
	hHudText1 = CreateHudSynchronizer();
	hHudText2 = CreateHudSynchronizer();
	hHudText3 = CreateHudSynchronizer();
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			OnClientPostAdminCheck(i);
		}
	}

}

public void OnAllPluginsLoaded()
{
	ZombieReloaded = LibraryExists("zombiereloaded");
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "zombiereloaded"))
	{
		ZombieReloaded = false;
	}
}
 
public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "zombiereloaded"))
	{
		ZombieReloaded = true;
	}
}

public void OnConfigsExecuted()
{
	char Zr_StringPosA[2][8];
	char Zr_StringPosB[2][8];
	char Zr_StringPosC[2][8];
	char Zr_PosValueA[16];
	char Zr_PosValueB[16];
	char Zr_PosValueC[16];
	char Zr_ColorValue[64];

	g_CVAR_ZR_Rank_Prefix.GetString(g_ZR_Rank_Prefix, sizeof(g_ZR_Rank_Prefix));
	g_ZR_Rank_InfectHuman = g_CVAR_ZR_Rank_InfectHuman.IntValue;
	g_ZR_Rank_KillZombie = g_CVAR_ZR_Rank_KillZombie.IntValue;
	g_ZR_Rank_KillZombie_Headshot = g_CVAR_ZR_Rank_KillZombie_Headshot.IntValue;
	g_ZR_Rank_StartPoints = g_CVAR_ZR_Rank_StartPoints.IntValue;
	g_ZR_Rank_StabZombie_Left = g_CVAR_ZR_Rank_StabZombie_Left.IntValue;
	g_ZR_Rank_StabZombie_Right = g_CVAR_ZR_Rank_StabZombie_Right.IntValue;
	g_ZR_Rank_KillZombie_Knife = g_CVAR_ZR_Rank_KillZombie_Knife.IntValue;
	g_ZR_Rank_KillZombie_HE = g_CVAR_ZR_Rank_KillZombie_HE.IntValue;
	g_ZR_Rank_KillZombie_SmokeFlashbang = g_CVAR_ZR_Rank_KillZombie_SmokeFlashbang.IntValue;
	g_ZR_Rank_MaxPlayers_Top = g_CVAR_ZR_Rank_MaxPlayers_Top.IntValue;
	g_ZR_Rank_AllowWarmup = g_CVAR_ZR_Rank_AllowWarmup.IntValue;
	g_ZR_Rank_MinPlayers = g_CVAR_ZR_Rank_MinPlayers.IntValue;
	g_ZR_Rank_BeingInfected = g_CVAR_ZR_Rank_BeingInfected.IntValue;
	g_ZR_Rank_BeingKilled = g_CVAR_ZR_Rank_BeingKilled.IntValue;
	g_ZR_Rank_Suicide = g_CVAR_ZR_Rank_Suicide.IntValue;
	g_ZR_Rank_RoundWin_Zombie = g_CVAR_ZR_Rank_RoundWin_Zombie.IntValue;
	g_ZR_Rank_RoundWin_Human = g_CVAR_ZR_Rank_RoundWin_Human.IntValue;
	g_ZR_Rank_Inactive_Days = g_CVAR_ZR_Rank_Inactive_Days.IntValue;
	g_ZR_Rank_Defenders_Enabled = g_CVAR_ZR_Rank_Defenders_Enabled.BoolValue;
	g_ZR_Rank_Defenders_Top_List = g_CVAR_ZR_Rank_Defenders_Top_List.IntValue;
	g_ZR_Rank_Minium_Damage = g_CVAR_ZR_Rank_Minium_Damage.IntValue;
	g_ZR_Rank_Defenders_Save_Enable = g_CVAR_ZR_Rank_Defenders_Save_Enable.BoolValue;
	g_ZR_Rank_Defenders_Sound_Enable = g_CVAR_ZR_Rank_Defenders_Sound_Enable.BoolValue;
	g_CVAR_ZR_Rank_HudSave_Position.GetString(Zr_PosValueA, sizeof(Zr_PosValueA));
	g_CVAR_ZR_Rank_HudTop_Position.GetString(Zr_PosValueB, sizeof(Zr_PosValueB));
	g_CVAR_ZR_Rank_MyHudTop_Position.GetString(Zr_PosValueC, sizeof(Zr_PosValueC));

	ExplodeString(Zr_PosValueA, " ", Zr_StringPosA, sizeof(Zr_StringPosA), sizeof(Zr_StringPosA[]));
	ExplodeString(Zr_PosValueB, " ", Zr_StringPosB, sizeof(Zr_StringPosB), sizeof(Zr_StringPosB[]));
	ExplodeString(Zr_PosValueC, " ", Zr_StringPosC, sizeof(Zr_StringPosC), sizeof(Zr_StringPosC[]));

	HudSavePos[0] = StringToFloat(Zr_StringPosA[0]);
	HudSavePos[1] = StringToFloat(Zr_StringPosA[1]);
	HudTopPos[0] = StringToFloat(Zr_StringPosB[0]);
	HudTopPos[1] = StringToFloat(Zr_StringPosB[1]);
	MyHudTopPos[0] = StringToFloat(Zr_StringPosC[0]);
	MyHudTopPos[1] = StringToFloat(Zr_StringPosC[1]);

	g_CVAR_ZR_Rank_Hud_Colors.GetString(Zr_ColorValue, sizeof(Zr_ColorValue));

	ColorStringToArray(Zr_ColorValue, ZrankHudColor);

	if(g_ZR_Rank_Defenders_Sound_Enable)
	{
		GetConVarString(g_CVAR_ZR_Rank_Defenders_Sound, g_ZR_Rank_Save_Sound, MAX_FILE_LEN);
		char buffer[MAX_FILE_LEN];
		PrecacheSoundAny(g_ZR_Rank_Save_Sound, true);
		Format(buffer, sizeof(buffer), "sound/%s", g_ZR_Rank_Save_Sound);
		AddFileToDownloadsTable(buffer);
	}
}

public void ColorStringToArray(const char[] zrsColorString, int zraColor[3])
{
	char zrasColors[4][4];
	ExplodeString(zrsColorString, " ", zrasColors, sizeof(zrasColors), sizeof(zrasColors[]));

	zraColor[0] = StringToInt(zrasColors[0]);
	zraColor[1] = StringToInt(zrasColors[1]);
	zraColor[2] = StringToInt(zrasColors[2]);
}

public void OnClientPostAdminCheck(int client)
{
	g_ZR_Rank_Points[client] = g_ZR_Rank_StartPoints;
	g_ZR_Rank_ZombieKills[client] = 0;
	g_ZR_Rank_HumanInfects[client] = 0;
	g_ZR_Rank_RoundWins_Zombie[client] = 0;
	g_ZR_Rank_RoundWins_Human[client] = 0;
	Top_Defenders_OnClientConnect_Post(client);
	LoadPlayerInfo(client);
}

public void OnClientConnected(int client)
{
	g_ZR_Rank_NumPlayers++;

	if(g_ZR_Rank_NumPlayers == g_ZR_Rank_MinPlayers)
	{
		CPrintToChatAll("%s %t", g_ZR_Rank_Prefix, "Currently Min Players", g_ZR_Rank_MinPlayers);
	}
	CPrintToChatAll("Clientes %s players de %s min players", g_ZR_Rank_NumPlayers, g_ZR_Rank_MinPlayers);
}
public void OnClientDisconnect(int client)
{
	Top_Defenders_OnClientDisconnect_Post(client);
	
	if(!IsValidClient(client, false, true))
	{
		return;
	}
	
	g_ZR_Rank_NumPlayers--;
	
	if(g_ZR_Rank_NumPlayers < g_ZR_Rank_MinPlayers)
	{
		CPrintToChatAll("%s %t", g_ZR_Rank_Prefix, "Currently Not Min Players", g_ZR_Rank_MinPlayers);
	}
	
	char update[512];
	char playername[64];
	GetClientName(client, playername, sizeof(playername));
	GetClientAuthId(client, AuthId_Steam3, g_ZR_Rank_SteamID[client], sizeof(g_ZR_Rank_SteamID[]));
	SQL_EscapeString(db, playername, playername, sizeof(playername));
	FormatEx(update, sizeof(update), "UPDATE  zrank SET playername = '%s', points =  %i , human_infects = %i, zombie_kills = %i, roundwins_zombie = %i, roundwins_human = %i, time = %d WHERE  SteamID = '%s';", playername, g_ZR_Rank_Points[client], g_ZR_Rank_ZombieKills[client], g_ZR_Rank_HumanInfects[client], g_ZR_Rank_RoundWins_Zombie[client], g_ZR_Rank_RoundWins_Human[client], GetTime(), g_ZR_Rank_SteamID[client]);
	
	SQL_TQuery(db, SQL_NothingCallback, update);
}

public void DeletePlayerData()
{
	char buffer[1024];
	int now = GetTime();
	FormatEx(buffer, sizeof(buffer), "DELETE FROM zrank WHERE time < (%d - (%d * 86400));", now, g_ZR_Rank_Inactive_Days);
	SQL_TQuery(db, SQL_NothingCallback, buffer);
}

public void LoadPlayerInfo(int client)
{
	char buffer[2048];

	GetClientAuthId(client, AuthId_Steam3, g_ZR_Rank_SteamID[client], sizeof(g_ZR_Rank_SteamID[]));
	if(db != INVALID_HANDLE)
	{
		FormatEx(buffer, sizeof(buffer), "SELECT * FROM zrank WHERE SteamID = '%s';", g_ZR_Rank_SteamID[client]);
		SQL_TQuery(db, SQL_LoadPlayerCallback, buffer, client);
	}
}

stock void GetRank(int client)
{
	char query[255];
	Format(query, sizeof(query), "SELECT * FROM zrank ORDER BY points DESC;");
	
	SQL_TQuery(db, SQL_GetRank, query, GetClientUserId(client));
}

stock void ResetRank(int client)
{
	char query[255];
	Format(query, sizeof(query), "DELETE FROM zrank WHERE SteamID = '%s';", g_ZR_Rank_SteamID[client]);

	SQL_TQuery(db, SQL_NothingCallback, query);
	
	OnClientPostAdminCheck(client);
}

stock bool IsValidClient(int client, bool bzrAllowBots = false, bool bzrAllowDead = true)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bzrAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bzrAllowDead && !IsPlayerAlive(client)))
		return false;
	return true;
}