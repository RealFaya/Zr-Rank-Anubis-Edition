public void Top_Defenders_Event_RoundStart()
{
	if(!g_ZR_Rank_Defenders_Enabled) return;

	resetDamangesArrays();
	resethud();
}

public void Top_Defenders_OnClientDisconnect_Post(int client)
{
	if(!g_ZR_Rank_Defenders_Enabled) return;
	
	damangeArray[client].playerid = client;
	damangeArray[client].damange = 0;
	ClientImune[client]=false;
	ClientImuneTemp[client]=false;
}

public void Top_Defenders_OnClientConnect_Post(int client)
{
	if(!g_ZR_Rank_Defenders_Enabled) return;
	
	damangeArray[client].playerid = client;
	damangeArray[client].damange = 0;
	ClientImune[client]=false;
	ClientImuneTemp[client]=false;
}

public void Top_Defenders_Event_RoundEnd()
{
	if(!g_ZR_Rank_Defenders_Enabled) return;

	ResetImune();
	bool loop = true;
	int myindex = 0;
	char texthud[256];
	char text_bufer[256];
	char text_bufer1[256];
	int counthud = 0;
	char top_text[128];
	char tophud_text[128];

	do {
		loop=false;
		myindex++;
		/* SORTING LOOP */
		for(int client = 1; client < MaxClients - myindex; client++) {
			if(damangeArray[client].damange < damangeArray[client + 1].damange) {
				tempArray[1]=damangeArray[client];
				damangeArray[client]=damangeArray[client + 1];
				damangeArray[client + 1] = tempArray[1];
				loop = true;
				}
			}
	} while (loop);

	for(int index = 1; index <= g_ZR_Rank_Defenders_Top_List; index++)
	{
		if(damangeArray[index].damange>=g_ZR_Rank_Minium_Damage || index==g_ZR_Rank_Defenders_Top_List)
		{
			if(index==1)
			{
				CPrintToChatAll("%t", "top_header");
				FPrintToConsoleAll("%t", "top_header");
			}
			if(damangeArray[index].damange>=g_ZR_Rank_Minium_Damage)
			{
				if(index<=1.0){ /* top 1 */
					Format(top_text, sizeof(top_text), "%t", "top_winner", toString(index), damangeArray[index].playerid, toString(damangeArray[index].damange), true);
					Format(tophud_text, sizeof(tophud_text), "%t", "tophud_winner", toString(index), damangeArray[index].playerid, toString(damangeArray[index].damange), true);
					CPrintToChatAll(top_text);
					FPrintToConsoleAll(top_text);					
					ClientImune[damangeArray[index].playerid]=true;
					
				} else { /* top 2-5 */
					Format(top_text, sizeof(top_text), "%t", "top_nonwinner", toString(index), damangeArray[index].playerid, toString(damangeArray[index].damange), true);
					Format(tophud_text, sizeof(tophud_text), "%t", "tophud_nonwinner", toString(index), damangeArray[index].playerid, toString(damangeArray[index].damange), true);
					CPrintToChatAll(top_text);
					FPrintToConsoleAll(top_text);
				}

				if(counthud == 0) {
					Format(text_bufer, sizeof(text_bufer), "%t\n%s", "tophud_header", tophud_text);
					Format(texthud, sizeof(texthud), "%s", text_bufer);
				} if(counthud == 1) {
					Format(text_bufer1, sizeof(text_bufer1), "%s\n%s", text_bufer, tophud_text);
					Format(texthud, sizeof(texthud), "%s", text_bufer1);
				} if(counthud == 2) {
					Format(text_bufer, sizeof(text_bufer), "%s\n%s", text_bufer1, tophud_text);
					Format(texthud, sizeof(texthud), "%s", text_bufer);
				} if(counthud <= 3) {
					PrintToHudAll(texthud);
					counthud++;
				}
			}
			if(index==g_ZR_Rank_Defenders_Top_List)
			{
				Format(top_text, sizeof(top_text), "%t", "top_footer", true);
				CPrintToChatAll(top_text);
				FPrintToConsoleAll(top_text);
			}
		}
		else if (index==1) break;
	}

	for(int clientzry = 0; clientzry <= MaxClients; clientzry++)
	{
		if(IsValidClient(clientzry, true, false))
		{
			int zr_damage = damangeArray[clientzry].damange;
			int zr_index = damangeArray[clientzry].playerid;
			SetGlobalTransTarget(zr_index);
			if(zr_damage>=1)
			{
				char mytplayer_text[128];
				Format(mytplayer_text, sizeof(mytplayer_text), "%t", "tophud_mypoints", toString(zr_damage), true);
				HudTopMyPoints(zr_index, mytplayer_text);
			}
			if(zr_damage<=0)
			{
				char mytplayer_nopont[128];
				Format(mytplayer_nopont, sizeof(mytplayer_nopont), "%t", "You haven t done any damage", true);
				HudTopMyPoints(zr_index, mytplayer_nopont);
			}
		}
	}

	resetDamangesArrays(); 
}

stock void resetDamangesArrays(){
	for(int client = 1; client <= MaxClients; client++) {
		damangeArray[client].playerid = client;
		damangeArray[client].damange = 0;
	}
}

stock void resethud()
{
	for (int i = 1; i <= MAXPLAYERS + 1; i++)
	{
		if(IsValidClient(i, true, true))
		{
			ClearSyncHud(i, hHudText1);
			ClearSyncHud(i, hHudText2);
			ClearSyncHud(i, hHudText3);
		}
	}
}

stock void ResetImune()
{
	for(int client = 1; client <= MaxClients; client++)
			ClientImune[client]=false;
}

stock void ResetImuneTemp()
{
	for(int client = 1; client <= MaxClients; client++)
			ClientImuneTemp[client]=false;
}

stock void FPrintToConsoleAll(const char[] format, any...) 
{
	char text[192];
	VFormat(text, sizeof(text), format, 2);
	/* Removes color variables */
	char removecolor[][] = {"{default}", "{darkred}", "{green}", "{lightgreen}", "{red}", "{blue}", "{olive}", "{lime}", "{lightred}", "{purple}", "{grey}", "{orange}", "{bluegrey}", "{lightblue}", "{darkblue}", "{grey2}", "{orchid}", "{lightred2}"};
	for(int color = 0; color < sizeof(removecolor); color++ ) {
		ReplaceString(text, sizeof(text), removecolor[color], "", false);
	}
	for(int client = 1; client <= MaxClients; client++)
		if(IsValidClient(client, true, true)) {
			PrintToConsole(client, text);
		}
}

stock void PrintToHudAll(const char[] szMessage, any...) 
{
	for(int client = 1; client <= MaxClients; client++)
		if(IsValidClient(client, true, true))
		{
			ClearSyncHud(client, hHudText1);
			SetHudTextParams(HudTopPos[0], HudTopPos[1], 5.0, ZrankHudColor[0], ZrankHudColor[1], ZrankHudColor[2], 255, 0, 0.1, 0.1, 0.1);
			ShowSyncHudText(client, hHudText1, szMessage);
		}
}

stock void HudTopMyPoints(int client, const char[] szMessage, any...)
{
	if(IsValidClient(client, true, true))
	{
		ClearSyncHud(client, hHudText2);
		SetHudTextParams(MyHudTopPos[0], MyHudTopPos[1], 5.0, ZrankHudColor[0], ZrankHudColor[1], ZrankHudColor[2], 255, 0, 0.1, 0.1, 0.1);
		ShowSyncHudText(client, hHudText2, szMessage);
	}
	return;
}

public Action ZR_OnClientInfect(int &client, int &attacker, bool &motherInfect, bool &respawnOverride, bool &respawn)
{
	if (ClientImune[client] && g_ZR_Rank_Defenders_Save_Enable)
	{
		CPrintToChatAll("%s %t", g_ZR_Rank_Prefix, "Chat were saved", client);
		CreateTimer(0.1, InfectSubstitute, client);
		return Plugin_Handled;
	}
	if(motherInfect && g_ZR_Rank_Defenders_Save_Enable)
	{
		ClientImuneTemp[client]=true;
	}
	if (g_ZR_Rank_Defenders_Save_Enable) ResetImune();
	return Plugin_Continue;
}

public Action InfectSubstitute(Handle timer, any value)
{	
	if(g_ZR_Rank_NumPlayers < g_ZR_Rank_MinPlayers) return;
	int client = value;
	HudSave(client);
	int counter = GetRandomPlayer();
	ZR_InfectClient(counter, _,true ,true);
	ResetImune();
	ResetImuneTemp();
}

stock void HudSave(int client)
{
	char text[192];
	SetGlobalTransTarget(client);
	Format(text, sizeof(text), "%t", "You were saved", true);
	if(IsValidClient(client, true, true))
	{
		if(g_ZR_Rank_Defenders_Sound_Enable)
		{
			EmitSoundToClientAny(client, g_ZR_Rank_Save_Sound, SOUND_FROM_PLAYER, SNDCHAN_AUTO);
		}
		ClearSyncHud(client, hHudText3);
		SetHudTextParams(HudSavePos[0], HudSavePos[1], 10.0, ZrankHudColor[0], ZrankHudColor[1], ZrankHudColor[2], 255, 2, 0.1, 0.02, 0.1);
		ShowSyncHudText(client, hHudText3, text);
	}
	return;
}

stock int GetRandomPlayer()
{
	int clients[MAXPLAYERS + 1];
	int clientCount, i;
	for (i = 1; i <= MaxClients; ++i)
		if (IsClientInGame(i) && ZR_IsClientHuman(i) && !ClientImune[i])
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];
}

stock char toString(int digi)
{ 
	char text[50];
	IntToString(digi, text, sizeof(text));
	/* 
	Format(text, sizeof(text), "%d", digi); 
	*/
	return text; 
}