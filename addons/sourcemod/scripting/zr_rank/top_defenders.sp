public void Top_Defenders_Event_RoundStart()
{
	Top_Rank_Reset();
}

public void Top_Defenders_OnClientDisconnect_Post(int client)
{
	if(!g_ZR_Rank_Defenders_Enabled) return;
	Top_Rank_Dmg[client] = 0;
	if (ClientImune[client])
	{
		ClientImune[client] = false;
	}
	if (ClientImuneTemp[client])
	{
		ClientImuneTemp[client] = false;
	}
}

public void Top_Defenders_OnClientConnect_Post(int client)
{
	if(!g_ZR_Rank_Defenders_Enabled) return;
	Top_Rank_Dmg[client] = 0;
	ClientImune[client] = false;
	ClientImuneTemp[client] = false;
}

public void Top_Rank_Reset()
{
	for (int i = 1; i <= MaxClients; i++)
	{	
		Top_Rank_Dmg[i] = 0;
	}
}

public void Top_Defenders_Event_RoundEnd()
{
	if(!g_ZR_Rank_Defenders_Enabled || g_ZR_Rank_NumPlayers < g_ZR_Rank_MinPlayers) return;

	if (g_ZR_Rank_Defenders_Save_Enable) ResetImune();
	int TopOne, TopTwo, TopThree, TopFour, TopFive;
	char TopHudMessage[512];

	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[TopOne] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 1)
		{
			TopOne = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i != TopOne && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[TopTwo] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 2)
		{		   
			TopTwo = i;
		}
	}	  
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i != TopOne && i != TopTwo && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[TopThree] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 3)
		{
			TopThree = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i != TopOne && i != TopTwo && i != TopThree && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[TopFour] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 4)
		{
			TopFour = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i != TopOne && i != TopTwo && i != TopThree && i != TopFour && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[TopFive] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 5)
		{
			TopFive = i;
		}
	}
	
	char top1[512];
	Format(top1,sizeof(top1), "- Rank Top Defenders -\n1. %N - %i Dmg.", TopOne, Top_Rank_Dmg[TopOne]);
	
	char top2[512];
	Format(top2,sizeof(top2), "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.", TopOne, Top_Rank_Dmg[TopOne], TopTwo, Top_Rank_Dmg[TopTwo]);
	
	char top3[512];
	Format(top3,sizeof(top3), "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.", TopOne, Top_Rank_Dmg[TopOne], TopTwo, Top_Rank_Dmg[TopTwo], TopThree, Top_Rank_Dmg[TopThree]);
	
	char top4[512];
	Format(top4,sizeof(top4), "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.\n4. %N - %i Dmg.", TopOne, Top_Rank_Dmg[TopOne], TopTwo, Top_Rank_Dmg[TopTwo], TopThree, Top_Rank_Dmg[TopThree], TopFour, Top_Rank_Dmg[TopFour]);
	
	char top5[512];
	Format(top5,sizeof(top5), "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.\n4. %N - %i Dmg.\n5. %N - %i Dmg.", TopOne, Top_Rank_Dmg[TopOne], TopTwo, Top_Rank_Dmg[TopTwo], TopThree, Top_Rank_Dmg[TopThree], TopFour, Top_Rank_Dmg[TopFour], TopFive, Top_Rank_Dmg[TopFive]);
	
	if(Top_Rank_Dmg[TopFive]>=5)
	{ 
		for (int client = 1; client <= MaxClients; client++)
		{
			if (client == 0)
				return;

			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);
				if (Top_Rank_Dmg[client] >= 1)
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top5, "You Points", client, Top_Rank_Dmg[client]);
					SendHudTopRankMsg(client, TopHudMessage);
				}
				else
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top5, "You haven t done any damage");
					SendHudTopRankMsg(client, TopHudMessage);
				}
			}
		}
		if (g_ZR_Rank_Defenders_Save_Enable) ClientImune[TopOne] = true;

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, TopOne, Top_Rank_Dmg[TopOne]);
		CPrintToChatAll("%t", "top_nonwinner", 2, TopTwo, Top_Rank_Dmg[TopTwo]);
		CPrintToChatAll("%t", "top_nonwinner", 3, TopThree, Top_Rank_Dmg[TopThree]);
		CPrintToChatAll("%t", "top_nonwinner", 4, TopFour, Top_Rank_Dmg[TopFour]);
		CPrintToChatAll("%t", "top_nonwinner", 5, TopFive, Top_Rank_Dmg[TopFive]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[TopOne] += g_ZR_Rank_Top1_Point;
			CPrintToChat(TopOne, "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[TopFour]>=5)
	{ 
		for (int client = 1; client <= MaxClients; client++)
		{
			if (client == 0)
				return;

			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);
				if (Top_Rank_Dmg[client] >= 1)
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top4, "You Points", client, Top_Rank_Dmg[client]);
					SendHudTopRankMsg(client, TopHudMessage);
				}
				else
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top4, "You haven t done any damage");
					SendHudTopRankMsg(client, TopHudMessage);
				}
			}
		}
		if (g_ZR_Rank_Defenders_Save_Enable) ClientImune[TopOne] = true;

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, TopOne, Top_Rank_Dmg[TopOne]);
		CPrintToChatAll("%t", "top_nonwinner", 2, TopTwo, Top_Rank_Dmg[TopTwo]);
		CPrintToChatAll("%t", "top_nonwinner", 3, TopThree, Top_Rank_Dmg[TopThree]);
		CPrintToChatAll("%t", "top_nonwinner", 4, TopFour, Top_Rank_Dmg[TopFour]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[TopOne] += g_ZR_Rank_Top1_Point;
			CPrintToChat(TopOne, "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[TopThree]>=5)
	{ 
		for (int client = 1; client <= MaxClients; client++)
		{
			if (client == 0)
				return;

			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);
				if (Top_Rank_Dmg[client] >= 1)
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top3, "You Points", client, Top_Rank_Dmg[client]);
					SendHudTopRankMsg(client, TopHudMessage);
				}
				else
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top3, "You haven t done any damage");
					SendHudTopRankMsg(client, TopHudMessage);
				}
			}
		}
		if (g_ZR_Rank_Defenders_Save_Enable) ClientImune[TopOne] = true;

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, TopOne, Top_Rank_Dmg[TopOne]);
		CPrintToChatAll("%t", "top_nonwinner", 2, TopTwo, Top_Rank_Dmg[TopTwo]);
		CPrintToChatAll("%t", "top_nonwinner", 3, TopThree, Top_Rank_Dmg[TopThree]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[TopOne] += g_ZR_Rank_Top1_Point;
			CPrintToChat(TopOne, "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[TopTwo]>=5)
	{ 
		for (int client = 1; client <= MaxClients; client++)
		{
			if (client == 0)
				return;

			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);
				if (Top_Rank_Dmg[client] >= 1)
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top2, "You Points", client, Top_Rank_Dmg[client]);
					SendHudTopRankMsg(client, TopHudMessage);
				}
				else
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top2, "You haven t done any damage");
					SendHudTopRankMsg(client, TopHudMessage);
				}
			}
		}
		if (g_ZR_Rank_Defenders_Save_Enable) ClientImune[TopOne] = true;

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, TopOne, Top_Rank_Dmg[TopOne]);
		CPrintToChatAll("%t", "top_nonwinner", 2, TopTwo, Top_Rank_Dmg[TopTwo]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[TopOne] += g_ZR_Rank_Top1_Point;
			CPrintToChat(TopOne, "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[TopOne]>=5)
	{
		for (int client = 1; client <= MaxClients; client++)
		{
			if (client == 0)
				return;

			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);
				if (Top_Rank_Dmg[client] >= 1)
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top1, "You Points", client, Top_Rank_Dmg[client]);
					SendHudTopRankMsg(client, TopHudMessage);
				}
				else
				{
					Format(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", top1, "You haven t done any damage");
					SendHudTopRankMsg(client, TopHudMessage);
				}
			}
		}
		if (g_ZR_Rank_Defenders_Save_Enable) ClientImune[TopOne] = true;

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, TopOne, Top_Rank_Dmg[TopOne]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[TopOne] += g_ZR_Rank_Top1_Point;
			CPrintToChat(TopOne, "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	}
	Top_Rank_Reset();
}

stock void SendHudTopRankMsg(int client, const char[] topMessage, any...)
{
	if (!IsValidClient(client, true, false))
	return;

	int entranktop = CreateEntityByName("game_text");
	DispatchKeyValue(entranktop, "channel", "3");
	DispatchKeyValue(entranktop, "color", Zr_ColorValue);
	DispatchKeyValue(entranktop, "color2", "0 0 0");
	DispatchKeyValue(entranktop, "effect", "0");
	DispatchKeyValue(entranktop, "fadein", "1.5");
	DispatchKeyValue(entranktop, "fadeout", "0.5");
	DispatchKeyValue(entranktop, "fxtime", "0.25"); 		
	DispatchKeyValue(entranktop, "holdtime", "10.0");
	DispatchKeyValue(entranktop, "message", topMessage);
	DispatchKeyValue(entranktop, "spawnflags", "0"); 	
	DispatchKeyValue(entranktop, "x", HudTopPosX);
	DispatchKeyValue(entranktop, "y", HudTopPosY); 		
	DispatchSpawn(entranktop);
	SetVariantString("!activator");
	AcceptEntityInput(entranktop,"display",client);
	return;
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
		int entsavetop = CreateEntityByName("game_text");
		DispatchKeyValue(entsavetop, "channel", "3");
		DispatchKeyValue(entsavetop, "color", Zr_ColorValue);
		DispatchKeyValue(entsavetop, "color2", "0 0 0");
		DispatchKeyValue(entsavetop, "effect", "0");
		DispatchKeyValue(entsavetop, "fadein", "1.5");
		DispatchKeyValue(entsavetop, "fadeout", "0.5");
		DispatchKeyValue(entsavetop, "fxtime", "0.25"); 		
		DispatchKeyValue(entsavetop, "holdtime", "10.0");
		DispatchKeyValue(entsavetop, "message", text);
		DispatchKeyValue(entsavetop, "spawnflags", "0"); 	
		DispatchKeyValue(entsavetop, "x", HudSavePosX);
		DispatchKeyValue(entsavetop, "y", HudSavePosY);		
		DispatchSpawn(entsavetop);
		SetVariantString("!activator");
		AcceptEntityInput(entsavetop,"display",client);
	}
	return;
}

stock void ResetImune()
{
	for(int client = 1; client <= MaxClients; client++)
			ClientImune[client] = false;
}

stock void ResetImuneTemp()
{
	for(int client = 1; client <= MaxClients; client++)
			ClientImuneTemp[client] = false;
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
		ClientImuneTemp[client] = true;
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

stock int GetRandomPlayer()
{
	int clients[MAXPLAYERS + 1];
	int clientCount, i;
	for (i = 1; i <= MaxClients; ++i)
		if (IsClientInGame(i) && ZR_IsClientHuman(i) && !ClientImune[i])
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];
}