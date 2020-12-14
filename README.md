# Zr-Rank-Anubis-Edition
 
### Improved version of zombiereloaded plugin with support for CS:GO and CS:S

* This plugin is an updated version of Hallucinogenic Troll plugin, under a new author.

* Test & Compile, SouceMod 1.10.0-6492
* Sorry for my English.

* Author Hallucinogenic Troll, Anubis Edition
* Version = 1.7-A, Anubis Edition

### Decription:Zr-Rank-Anubis-Edition

* A simple classification system for servers with Zombiereloaded plug-ins (which is currently supported).
* Added Top Defenders system.
* ZombiePlegue support remains.
* Added system for the Top 1 player not to become a zombie (another player will become a zombie instead).
* Fixed some bugs.
* Added Web Folder for those interested .PHP.

### Server ConVars

* zr_rank_startpoints - How many points that a new player starts.
* zr_rank_infecthuman - How many points you get when you infect an human (0 will disable it).
* zr_rank_killzombie - How many points you get when you kill a zombie (0 will disable it).
* zr_rank_killzombie_headshot - How many points you get when you kill a zombie with an headshot.
* zr_rank_stabzombie_left - How many points you get when you stab a zombie with left mouse button (0 will disable it).
* zr_rank_stabzombie_right - How many points you get when you stab a zombie with right mouse button (0 will disable it).
* zr_rank_killzombie_knife - How many points you get when you kill a zombie with a knife (0 will disable it).
* zr_rank_killzombie_he - How many points you get when you kill a zombie with a HE Grenade (0 will disable it).
* zr_rank_killzombie_smokeflashbang - How many points you get when you kill a zombie with a Smoke Grenade or a Flashbang (0 will disable it).
* zr_rank_maxplayers_top - Max number of players that are shown in the top commands.
* zr_rank_minplayers - Minimum players for activating the rank system (0 will disable this function).
* zr_rank_prefix - Prefix to be used in every chat's plugin.
* zr_rank_beinginfected - How many points you lost if you got infected by a zombie.
* zr_rank_beingkilled - How many points you lost if you get killed by an human.
* zr_rank_allow_warmup - Allow players to get or lose points during Warmup.
* zr_rank_suicide - How many points do you lose when you suicide (0 will disable it).
* zr_rank_roundwin_zombie - How many points you get by winning a round as a zombie.
* zr_rank_roundwin_human - How many points you get by winning a round as an human.
* zr_rank_inactive_days - How many days a player needs to be inactive and deleted from the database (0 will disable it).
* zr_rank_defenders_enabled - Plugin is enabled or disabled.", _, true, 0.0, true, 1.0);
* zr_rank_defenders_top_list - How many players will be listed on the top list. (1.0-20.0).
* zr_rank_defenders_minium_damage - The total minimum damage for players to be listed. (1.0-5000.0).
* zr_rank_defenders_save_enabled - Save Top 1 from turning zombie.
* zr_rank_defenders_sound_enabled - Save sound enabled or disabled.
* zr_rank_defenders_hudsave_position - The X and Y position for the HudSave.
* zr_rank_defenders_hudtop_position - The X and Y position for the HudTop.
* zr_rank_defenders_myhudtop_position - The X and Y position for the MyHudTop.
* zr_rank_defenders_hud_colors - RGB color value for the hud.
* zr_rank_defenders_sound - Saved from becoming a zombie,Sound.

### Commands

* sm_rank - Shows a player rank in the menu.
* sm_mystats - Shows all the stats of a player.
* sm_top - Shows the Top Players List, order by points.
* sm_topkills - Show the Top Players List, order by Zombie Kills.
* sm_topinfects - Show the Top Players List, order by Infected Humans.
* sm_humanwins - Show the Top Players List, order by Round Wins as a Human.
* sm_zombiewins - Show the Top Players List, order by Round Wins as a Zombie.
* sm_resetmyrank - It lets a player reset his rank all by himself.

### Commands Admin

* sm_resetrank_all - Deletes all the players that are in the database.

<h3>MySQL</h3>
<p>Add this to your databases.cfg in <i>addons/sourcemod/configs</i> and change it as you need.

```
"zr_rank"
{
  "driver"    "mysql"
  "host"      "YOUR_HOST_ADDRESS"
  "database"  "YOUR_DATABASE_NAME"
  "user"      "DATABASE_USERNAME"
  "pass"      "USERNAME_PASSWORD"
}
```
### Natives

```SourcePawn
/*********************************************************
 * Get's the number of a player's points
 *
 * @param client		The client to get the points
 * @return				The number of points		
 *********************************************************/
native int ZR_Rank_GetPoints(int client);

/*********************************************************
 * Get's the number of a player's Zombie Kills
 *
 * @param client		The client to get the zombie kills
 * @return				The number of points		
 *********************************************************/
native int ZR_Rank_GetZombieKills(int client);

/*********************************************************
 * Get's the number of a player's Human Infects
 *
 * @param client		The client to get the zombie kills
 * @return				The number of points		
 *********************************************************/
native int ZR_Rank_GetHumanInfects(int client);

/*********************************************************
 * Get's the number of a player's Round Wins as Zombie
 *
 * @param client		The client to get the round wins
 * @return				The number of round wins		
 *********************************************************/
native int ZR_Rank_GetRoundWins_Zombie(int client);

/*********************************************************
 * Get's the number of a player's Round Wins as Human
 *
 * @param client		The client to get the round wins
 * @return				The number of round wins		
 *********************************************************/
native int ZR_Rank_GetRoundWins_Human(int client);

/*********************************************************
 * Sets points to a certain player
 *
 * @param client		The client to get the points
 * @param points		Number of points to set
 * @return				The number of points	
 *********************************************************/
native bool ZR_Rank_SetPoints(int client, int points);

/*********************************************************
 * Reset a Player's Stats
 *
 * @param client		The client to reset the data
 * @noreturn
 *********************************************************/
native bool ZR_Rank_ResetPlayer(int client);
```

![alt text](https://i.ibb.co/dfTn8D6/1.jpg)
![alt text](https://i.ibb.co/V9mSXPc/2.jpg)
![alt text](https://i.ibb.co/txMMmr3/3.jpg)
