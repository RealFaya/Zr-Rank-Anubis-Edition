// Chat's main prefix;

// ConVars
ConVar g_CVAR_ZR_Rank_InfectHuman;
ConVar g_CVAR_ZR_Rank_KillZombie;
ConVar g_CVAR_ZR_Rank_KillZombie_Headshot;
ConVar g_CVAR_ZR_Rank_StartPoints;
ConVar g_CVAR_ZR_Rank_StabZombie_Left;
ConVar g_CVAR_ZR_Rank_StabZombie_Right;
ConVar g_CVAR_ZR_Rank_KillZombie_Knife;
ConVar g_CVAR_ZR_Rank_KillZombie_HE;
ConVar g_CVAR_ZR_Rank_KillZombie_SmokeFlashbang;
ConVar g_CVAR_ZR_Rank_MaxPlayers_Top;
ConVar g_CVAR_ZR_Rank_Prefix;
ConVar g_CVAR_ZR_Rank_MinPlayers;
ConVar g_CVAR_ZR_Rank_BeingInfected;
ConVar g_CVAR_ZR_Rank_BeingKilled;
ConVar g_CVAR_ZR_Rank_AllowWarmup;
ConVar g_CVAR_ZR_Rank_Suicide;
ConVar g_CVAR_ZR_Rank_RoundWin_Zombie;
ConVar g_CVAR_ZR_Rank_RoundWin_Human;
ConVar g_CVAR_ZR_Rank_Inactive_Days;
ConVar g_CVAR_ZR_Rank_Defenders_Enabled;
ConVar g_CVAR_ZR_Rank_Defenders_Top_List;
ConVar g_CVAR_ZR_Rank_Minium_Damage;
ConVar g_CVAR_ZR_Rank_Defenders_Save_Enable;
ConVar g_CVAR_ZR_Rank_Defenders_Sound_Enable;
ConVar g_CVAR_ZR_Rank_Defenders_Hud_Enabled;
ConVar g_CVAR_ZR_Rank_HudSave_Position;
ConVar g_CVAR_ZR_Rank_HudTop_Position;
ConVar g_CVAR_ZR_Rank_Hud_Colors;
ConVar g_CVAR_ZR_Rank_Defenders_Sound;
ConVar g_CVAR_ZR_Rank_Top1_Point;


// Booleans for Optional Libraries
bool ZombieReloaded;

// Variables to Store ConVar Values;

char g_ZR_Rank_Prefix[32];
int g_ZR_Rank_InfectHuman;
int g_ZR_Rank_KillZombie;
int g_ZR_Rank_KillZombie_Headshot;
int g_ZR_Rank_StartPoints;
int g_ZR_Rank_StabZombie_Left;
int g_ZR_Rank_StabZombie_Right;
int g_ZR_Rank_KillZombie_Knife;
int g_ZR_Rank_KillZombie_HE;
int g_ZR_Rank_KillZombie_SmokeFlashbang;
int g_ZR_Rank_MaxPlayers_Top;
int g_ZR_Rank_AllowWarmup;
int g_ZR_Rank_MinPlayers;
int g_ZR_Rank_BeingInfected;
int g_ZR_Rank_BeingKilled;
int g_ZR_Rank_Suicide;
int g_ZR_Rank_RoundWin_Zombie;
int g_ZR_Rank_RoundWin_Human;
int g_ZR_Rank_Inactive_Days;
int g_ZR_Rank_Minium_Damage;
int g_ZR_Rank_Top1_Point;
int g_ZR_Rank_Defenders_Top_List;

bool g_ZR_Rank_PostInfect;
bool g_ZR_Rank_Defenders_Enabled;
bool g_ZR_Rank_Defenders_Hud_Enabled;
bool g_ZR_Rank_Defenders_Save_Enable;
bool g_ZR_Rank_Defenders_Sound_Enable;

// Stores the main points, that are given after some events;
int g_ZR_Rank_Points[MAXPLAYERS + 1];
int g_ZR_Rank_ZombieKills[MAXPLAYERS + 1];
int g_ZR_Rank_HumanInfects[MAXPLAYERS + 1];
int g_ZR_Rank_RoundWins_Zombie[MAXPLAYERS + 1];
int g_ZR_Rank_RoundWins_Human[MAXPLAYERS + 1];
int g_ZR_Rank_NumPlayers = 0;
char g_ZR_Rank_SteamID[MAXPLAYERS + 1][64];

int g_MaxPlayers;
// Handle for the database;
Handle db;

// Top Defender Array
enum struct player_damange {
	int playerid;
	int damange;
}

// Top Defender
#define MAX_FILE_LEN 80
char g_ZR_Rank_Save_Sound[MAX_FILE_LEN];

bool ClientImune[MAXPLAYERS+1]={false,...};
bool ClientImuneTemp[MAXPLAYERS+1]={false,...};


char Zr_ColorValue[64];
char HudTopPosX[8];
char HudTopPosY[8];
char HudSavePosX[8];
char HudSavePosY[8];

int Top_Rank_Dmg[MAXPLAYERS+1];



// Check if it is MySQL that you set on the databases.cfg
bool IsMySql;