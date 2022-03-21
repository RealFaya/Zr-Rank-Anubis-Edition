public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_hOnLoaded = CreateGlobalForward("Zr_Rank_OnLoaded", ET_Ignore);
	g_hOnClientLoaded = CreateGlobalForward("Zr_Rank_OnClientLoaded", ET_Ignore, Param_Cell, Param_Cell);
	g_hOnClientPointChange = CreateGlobalForward("Zr_Rank_OnClientPointChange", ET_Ignore, Param_Cell, Param_Cell);

	CreateNative("ZR_Rank_IsCoreLoaded", Native_ZR_Rank_IsCoreLoaded);
	CreateNative("ZR_Rank_GetPoints", Native_ZR_Rank_GetPoints);
	CreateNative("ZR_Rank_SetPoints", Native_ZR_Rank_SetPoints);
	CreateNative("ZR_Rank_GetZombieKills", Native_ZR_Rank_GetZombieKills);
	CreateNative("ZR_Rank_GetHumanInfects", Native_ZR_Rank_GetHumanInfects);
	CreateNative("ZR_Rank_GetRoundWins_Zombie", Native_ZR_Rank_GetRoundWins_Zombie);
	CreateNative("ZR_Rank_GetRoundWins_Human", Native_ZR_Rank_GetRoundWins_Human);
	CreateNative("ZR_Rank_ResetPlayer", Native_ZR_Rank_ResetPlayer);

	MarkNativeAsOptional("ZR_IsClientHuman");
	MarkNativeAsOptional("ZR_IsClientZombie");

	RegPluginLibrary("zr_rank");

	return APLRes_Success;
}

public int Native_ZR_Rank_IsCoreLoaded(Handle plugin, int numParams)
{
	return view_as<int>(g_bLoaded);
}

public int Native_ZR_Rank_GetRoundWins_Human(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_ZR_Rank_RoundWins_Human[client];
}

public int Native_ZR_Rank_GetRoundWins_Zombie(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_ZR_Rank_RoundWins_Zombie[client];
}

public int Native_ZR_Rank_GetPoints(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_ZR_Rank_Points[client];
}

public int Native_ZR_Rank_GetZombieKills(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_ZR_Rank_ZombieKills[client];
}

public int Native_ZR_Rank_GetHumanInfects(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	return g_ZR_Rank_HumanInfects[client];
}

public int Native_ZR_Rank_SetPoints(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int points = GetNativeCell(2);

	g_ZR_Rank_Points[client] = points;

	return view_as<int>(points);
}

public int Native_ZR_Rank_ResetPlayer(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	ResetRank(client);
}

void Call_PointChange(int iClient)
{
	Call_StartForward(g_hOnClientPointChange);
	Call_PushCell(iClient);
	Call_PushCell(g_ZR_Rank_Points[iClient]);
	Call_Finish();
}