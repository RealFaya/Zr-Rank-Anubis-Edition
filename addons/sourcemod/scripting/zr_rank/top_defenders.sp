void Top_Defenders_Event_RoundStart()
{
	Top_Rank_Reset();
}

void Top_Defenders_OnClientDisconnect_Post(int client)
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

void Top_Defenders_OnClientConnect_Post(int client)
{
	if(!g_ZR_Rank_Defenders_Enabled) return;
	Top_Rank_Dmg[client] = 0;
	ClientImune[client] = false;
	ClientImuneTemp[client] = false;
}

void Top_Rank_Reset()
{
	for (int i = 1; i <= MaxClients; i++)
	{	
		Top_Rank_Dmg[i] = 0;
	}
}

void Top_Defenders_Event_RoundEnd()
{
	if(!g_ZR_Rank_Defenders_Enabled || g_ZR_Rank_NumPlayers < g_ZR_Rank_MinPlayers)
	{
		return;
	}

	int iTop[5];

	static char TopHudMessage[512];

	if(g_ZR_Rank_Defenders_Save_Enable)
	{
		ResetImune();
	}

	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[iTop[0]] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 1)
		{
			iTop[0] = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i != iTop[0] && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[iTop[1]] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 2)
		{		   
			iTop[1] = i;
		}
	}	  
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i != iTop[0] && i != iTop[1] && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[iTop[2]] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 3)
		{
			iTop[2] = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i != iTop[0] && i != iTop[1] && i != iTop[2] && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[iTop[3]] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 4)
		{
			iTop[3] = i;
		}
	}
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i != iTop[0] && i != iTop[1] && i != iTop[2] && i != iTop[3] && IsClientInGame(i) && Top_Rank_Dmg[i] >= Top_Rank_Dmg[iTop[4]] && Top_Rank_Dmg[i] >= g_ZR_Rank_Minium_Damage && g_ZR_Rank_Defenders_Top_List  >= 5)
		{
			iTop[4] = i;
		}
	}

	static char szTop[512];

	if(Top_Rank_Dmg[iTop[4]] >= 5)
	{
		FormatEx(szTop, sizeof szTop, "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.\n4. %N - %i Dmg.\n5. %N - %i Dmg.", iTop[0], Top_Rank_Dmg[iTop[0]], iTop[1], Top_Rank_Dmg[iTop[1]], iTop[2], Top_Rank_Dmg[iTop[2]], iTop[3], Top_Rank_Dmg[iTop[3]], iTop[4], Top_Rank_Dmg[iTop[4]]);

		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);

				if (Top_Rank_Dmg[client] >= 1)
				{
					FormatEx(TopHudMessage, sizeof(TopHudMessage), "%s\n\n%t", szTop, "You Points", client, Top_Rank_Dmg[client]);
				}
				else
				{
					FormatEx(TopHudMessage, sizeof(TopHudMessage), "%s\n\n%t", szTop, "You haven t done any damage");
				}

				SendHudTopRankMsg(client, TopHudMessage);
			}
		}

		if(g_ZR_Rank_Defenders_Save_Enable)
		{
			ClientImune[iTop[0]] = true;
		}

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, iTop[0], Top_Rank_Dmg[iTop[0]]);
		CPrintToChatAll("%t", "top_nonwinner", 2, iTop[1], Top_Rank_Dmg[iTop[1]]);
		CPrintToChatAll("%t", "top_nonwinner", 3, iTop[2], Top_Rank_Dmg[iTop[2]]);
		CPrintToChatAll("%t", "top_nonwinner", 4, iTop[3], Top_Rank_Dmg[iTop[3]]);
		CPrintToChatAll("%t", "top_nonwinner", 5, iTop[4], Top_Rank_Dmg[iTop[4]]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[iTop[0]] += g_ZR_Rank_Top1_Point;
			CPrintToChat(iTop[0], "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[iTop[3]]>=5)
	{
		FormatEx(szTop, sizeof szTop, "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.\n4. %N - %i Dmg.", iTop[0], Top_Rank_Dmg[iTop[0]], iTop[1], Top_Rank_Dmg[iTop[1]], iTop[2], Top_Rank_Dmg[iTop[2]], iTop[3], Top_Rank_Dmg[iTop[3]]);

		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);

				if (Top_Rank_Dmg[client] >= 1)
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You Points", client, Top_Rank_Dmg[client]);
				}
				else
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You haven t done any damage");
				}

				SendHudTopRankMsg(client, TopHudMessage);
			}
		}

		if(g_ZR_Rank_Defenders_Save_Enable)
		{
			ClientImune[iTop[0]] = true;
		}

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, iTop[0], Top_Rank_Dmg[iTop[0]]);
		CPrintToChatAll("%t", "top_nonwinner", 2, iTop[1], Top_Rank_Dmg[iTop[1]]);
		CPrintToChatAll("%t", "top_nonwinner", 3, iTop[2], Top_Rank_Dmg[iTop[2]]);
		CPrintToChatAll("%t", "top_nonwinner", 4, iTop[3], Top_Rank_Dmg[iTop[3]]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[iTop[0]] += g_ZR_Rank_Top1_Point;
			CPrintToChat(iTop[0], "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[iTop[2]]>=5)
	{
		FormatEx(szTop, sizeof szTop, "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.\n3. %N - %i Dmg.", iTop[0], Top_Rank_Dmg[iTop[0]], iTop[1], Top_Rank_Dmg[iTop[1]], iTop[2], Top_Rank_Dmg[iTop[2]]);

		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);

				if (Top_Rank_Dmg[client] >= 1)
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You Points", client, Top_Rank_Dmg[client]);
				}
				else
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You haven t done any damage");
				}

				SendHudTopRankMsg(client, TopHudMessage);
			}
		}

		if(g_ZR_Rank_Defenders_Save_Enable)
		{
			ClientImune[iTop[0]] = true;
		}

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, iTop[0], Top_Rank_Dmg[iTop[0]]);
		CPrintToChatAll("%t", "top_nonwinner", 2, iTop[1], Top_Rank_Dmg[iTop[1]]);
		CPrintToChatAll("%t", "top_nonwinner", 3, iTop[2], Top_Rank_Dmg[iTop[2]]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[iTop[0]] += g_ZR_Rank_Top1_Point;
			CPrintToChat(iTop[0], "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[iTop[1]]>=5)
	{
		FormatEx(szTop, sizeof szTop, "- Rank Top Defenders -\n1. %N - %i Dmg.\n2. %N - %i Dmg.", iTop[0], Top_Rank_Dmg[iTop[0]], iTop[1], Top_Rank_Dmg[iTop[1]]);

		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);

				if (Top_Rank_Dmg[client] >= 1)
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You Points", client, Top_Rank_Dmg[client]);
				}
				else
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You haven t done any damage");
				}

				SendHudTopRankMsg(client, TopHudMessage);
			}
		}

		if(g_ZR_Rank_Defenders_Save_Enable)
		{
			ClientImune[iTop[0]] = true;
		}

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, iTop[0], Top_Rank_Dmg[iTop[0]]);
		CPrintToChatAll("%t", "top_nonwinner", 2, iTop[1], Top_Rank_Dmg[iTop[1]]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[iTop[0]] += g_ZR_Rank_Top1_Point;
			CPrintToChat(iTop[0], "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	} 
	else if(Top_Rank_Dmg[iTop[0]]>=5)
	{
		FormatEx(szTop ,sizeof szTop, "- Rank Top Defenders -\n1. %N - %i Dmg.", iTop[0], Top_Rank_Dmg[iTop[0]]);

		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client) && g_ZR_Rank_Defenders_Hud_Enabled)
			{
				SetGlobalTransTarget(client);

				if (Top_Rank_Dmg[client] >= 1)
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You Points", client, Top_Rank_Dmg[client]);
				}
				else
				{
					FormatEx(TopHudMessage,sizeof(TopHudMessage), "%s\n\n%t", szTop, "You haven t done any damage");
				}

				SendHudTopRankMsg(client, TopHudMessage);
			}
		}

		if(g_ZR_Rank_Defenders_Save_Enable)
		{
			ClientImune[iTop[0]] = true;
		}

		CPrintToChatAll("%t", "top_header");
		CPrintToChatAll("%t", "top_winner", 1, iTop[0], Top_Rank_Dmg[iTop[0]]);
		CPrintToChatAll("%t", "top_footer");

		if(g_ZR_Rank_Top1_Point > 0)
		{
			g_ZR_Rank_Points[iTop[0]] += g_ZR_Rank_Top1_Point;
			CPrintToChat(iTop[0], "%s %t", g_ZR_Rank_Prefix, "Top One Point", g_ZR_Rank_Top1_Point);
		}
	}

	Top_Rank_Reset();
}

stock void SendHudTopRankMsg(int client, const char[] topMessage, any...)
{
	if(IsValidClient(client, true, false))
	{
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
	}
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
}

stock void ResetImune()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		ClientImune[client] = false;
	}
}

stock void ResetImuneTemp()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		ClientImuneTemp[client] = false;
	}
}

public Action ZR_OnClientInfect(int &client, int &attacker, bool &motherInfect, bool &respawnOverride, bool &respawn)
{
	if(g_ZR_Rank_Defenders_Save_Enable)
	{
		if(ClientImune[client])
		{
			CPrintToChatAll("%s %t", g_ZR_Rank_Prefix, "Chat were saved", client);
			CreateTimer(0.1, InfectSubstitute, client);

			return Plugin_Handled;
		}

		if(motherInfect)
		{
			ClientImuneTemp[client] = true;
		}

		ResetImune();
	}

	return Plugin_Continue;
}

Action InfectSubstitute(Handle timer, any value)
{	
	if(g_ZR_Rank_NumPlayers < g_ZR_Rank_MinPlayers)
	{
		return;
	}

	HudSave(value);
	ZR_InfectClient(GetRandomPlayer(), _,true ,true);
	ResetImune();
	ResetImuneTemp();
}

stock int GetRandomPlayer()
{
	int clients[MAXPLAYERS + 1];
	int clientCount, i;

	for(i = 1; i <= MaxClients; ++i)
	{
		if(IsClientInGame(i) && ZR_IsClientHuman(i) && !ClientImune[i])
		{
			clients[clientCount++] = i;
		}
	}

	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];
}