// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
// (Windows-1251 CYRRILIC)
#include <a_samp>
#include <core>
#include <float>
#include <crashdetect>
#include <a_angles>
#include <Pawn.CMD>
#include <streamer>
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>
#include <a_mysql>
#include <foreach>
#include <colandreas>

#define mainColor "{709640}"
#define mainColorHex 0x709640FF
#define grey "{AFAFAF}"
#define greyHex 0xAFAFAFFF

#define TORSO 3
#define PAH 4
#define LEFT_ARM 5
#define RIGHT_ARM 6
#define LEFT_LEG 7
#define RIGHT_LEG 8
#define HEAD 9

#define scm SendClientMessage
#define err(%0,%1) SendSpecialMessage(0,%0,0xB83B3BFF,%1)
#define suc(%0,%1) SendSpecialMessage(1,%0,0x519960FF,%1)
#define inf(%0,%1) SendSpecialMessage(2,%0,0x929292FF,%1)
#define n(%0) pi[%0][nick]	
#define rpn(%0) lv[%0][rpnick]
#define f(%0,%1,%2) format(%0,sizeof(%0),%1,%2)
#define spvi SetPVarInt
#define gpvi GetPVarInt

stock SendSpecialMessage(type, playerid, color = -1, text[])
{
	new string[144];
	switch(type)
	{
		case 0: f(string, "X   {FFE5E5}%s", text);
		case 1: f(string, "›    {B7D8BD}%s", text);
		case 2: f(string, "!    {B2B2B2}%s", text);
	}
	scm(playerid, color, string);
	return 1;
}

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#pragma tabsize 0

main()
{
	print("\n----------------------------------");
	print("  Bare Script MYEDIT 2\n");
	print("----------------------------------\n");
}

new MySQL:sql;
#define mysqlip "127.0.0.1"
#define mysqlroot "root"
#define mysqlpass ""
#define mysqldb "mil"

#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif

enum dialogId
{
	dRegister,
	dLogin
}

enum playerVariables
{
	nick[24],
	bool:logged,
	admin
}
new pi[MAX_PLAYERS][playerVariables];

#define BIG_WEAPON_IGLA 1
#define BIG_WEAPON_JAVEL 2

enum lobbyVariables
{
	lobby,
	rpnick[24],
	moder,
	bigWeapon
}
new lv[MAX_PLAYERS][lobbyVariables];

#define MAX_CRATES 100
#define CRATE_PTUR 0
#define CRATE_IGLA 1
enum cratesVariables
{
	crateID,
	crateType,
	crateCount,
	crateLife,
	Text3D: crateText
}
new crate[MAX_CRATES][cratesVariables];
new TOTAL_CRATES;

#define MAX_PTUR 5
enum pturVariables
{
	pturHeadID,
	pturSoshkiID,
	Text3D: pturText,
	pturRocket,
	bool:pturFilled,
	bool:pturFixMove,
	pturTargetID,
	pturTargetTimer
}
new ptur[MAX_PTUR][pturVariables];
new TOTAL_PTUR, STARTED_PTUR_ID;

#define MAX_D30 5

enum d30Variables
{
	d30HeadID,
	d30SoshkiID,
	Text3D: d30Text,
	d30Bullet,
	bool:d30FixMove
}
new d30[MAX_D30][d30Variables];
new TOTAL_D30;

new STARTED_IGLA_ID, IGLA_TARGET;

#define MAX_DROPPED_WEAPON 100
enum weaponVariables
{
	drID,
	weaponNum,
	Text3D: text3did,
	ammoCount
}
new droppedWeapon[MAX_DROPPED_WEAPON][weaponVariables];
new TOTAL_DROPPED_WEAPON = 0;

#define ATTACH_SLOT_BIG_WEAPON 0

new VehicleNames[212][] =
{
    "Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
    "Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
    "Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
    "Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
    "Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
    "Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
    "Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
    "Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring A","Hotring B",
    "Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
    "Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
    "Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
    "Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
    "Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
    "Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
    "Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car","Police Car",
    "Police Car","Police Ranger","Picador","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
    "Stair Trailer","Boxville","Farm Plow","U Trailer"
};

new str[256];
new dstr[2048];
new query[1024];

SendMessageToAdmin(color, message[])
{
	foreach(Player, i)
	{
		if(pi[i][admin] > 0) scm(i, color, message);
	}
}

CMD:a(playerid, params[])
{
	if(pi[playerid][admin] <= 0) return 1;
	new messs[100];
	if(sscanf(params, "s[100]", messs)) return inf(playerid, "Чат администрации: /a [text]");
	f(str, "[A-%d] %s[%d]: {f6b26b}%s", pi[playerid][admin], n(playerid), playerid, messs);
	SendMessageToAdmin(0xe69138FF, str);
	return 1;
}

CMD:ogoto(playerid, params[])
{
	if(pi[playerid][admin] < 8) return 1;
	if(sscanf(params, "d", params[0])) return inf(playerid, "Телепорт к объекту: /ogoto [objectid]");
	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(params[0], x,y,z);
	SetPlayerPos(playerid, x+1, y+1, z+1);
	return 1;
}

stock Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ) return floatsqroot(floatadd(floatadd(floatpower(floatsub(X, PointX), 2.0), floatpower(floatsub(Y, PointY), 2.0)), floatpower(floatsub(Z, PointZ), 2.0))); 
stock Float:GetDistanceBetweenPlayers(playerid, otherplayerid) { new Float:X[2], Float:Y[2], Float:Z[2]; GetPlayerPos(playerid, X[0], Y[0], Z[0]); GetPlayerPos(otherplayerid, X[1], Y[1], Z[1]); return GetDistanceBetweenPoints(X[0], Y[0], Z[0], X[1], Y[1], Z[1]); }

stock KickEx(playerid)
{
	if(GetPVarInt(playerid, "kicked") > 0) return Kick(playerid);
    SetPVarInt(playerid, "kicked", gettime()+2);
    return 1;
}
#if defined _ALS_Kick 
        #undef Kick 
#else 
        #define _ALS_Kick 
#endif 
#define Kick KickEx 

stock SpawnPlayerEx(playerid)
{
	SetPVarInt(playerid, "ServerSpawn", 1);
	return SpawnPlayer(playerid); 
        
}
#if defined _ALS_SpawnPlayer 
        #undef SpawnPlayer 
#else 
        #define _ALS_SpawnPlayer 
#endif 
#define SpawnPlayer SpawnPlayerEx

stock PreloadAnimLib(playerid, animlib[])
{
   ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
   return 1;
}

stock PreloadAllAnimLibs (playerid)
{
        PreloadAnimLib(playerid,"AIRPORT");             
        PreloadAnimLib(playerid,"Attractors");          
        PreloadAnimLib(playerid,"BAR");         
        PreloadAnimLib(playerid,"BASEBALL");            
        PreloadAnimLib(playerid,"BD_FIRE");             
        PreloadAnimLib(playerid,"BEACH");               
        PreloadAnimLib(playerid,"benchpress");          
        PreloadAnimLib(playerid,"BF_injection");                
        PreloadAnimLib(playerid,"BIKED");               
        PreloadAnimLib(playerid,"BIKEH");                 
        PreloadAnimLib(playerid,"BIKELEAP");              
        PreloadAnimLib(playerid,"BIKES");                 
        PreloadAnimLib(playerid,"BIKEV");                 
        PreloadAnimLib(playerid,"BIKE_DBZ");              
        PreloadAnimLib(playerid,"BLOWJOBZ");              
        PreloadAnimLib(playerid,"BMX");           
        PreloadAnimLib(playerid,"BOMBER");                
        PreloadAnimLib(playerid,"BOX");           
        PreloadAnimLib(playerid,"BSKTBALL");              
        PreloadAnimLib(playerid,"BUDDY");                 
        PreloadAnimLib(playerid,"BUS");           
        PreloadAnimLib(playerid,"CAMERA");                
        PreloadAnimLib(playerid,"CAR");           
        PreloadAnimLib(playerid,"CARRY");                 
        PreloadAnimLib(playerid,"CAR_CHAT");              
        PreloadAnimLib(playerid,"CASINO");                
        PreloadAnimLib(playerid,"CHAINSAW");              
        PreloadAnimLib(playerid,"CHOPPA");                
        PreloadAnimLib(playerid,"CLOTHES");               
        PreloadAnimLib(playerid,"COACH");                 
        PreloadAnimLib(playerid,"COLT45");                
        PreloadAnimLib(playerid,"COP_AMBIENT");           
        PreloadAnimLib(playerid,"COP_DVBYZ");             
        PreloadAnimLib(playerid,"CRACK");                 
        PreloadAnimLib(playerid,"CRIB");                  
        PreloadAnimLib(playerid,"DAM_JUMP");              
        PreloadAnimLib(playerid,"DANCING");               
        PreloadAnimLib(playerid,"DEALER");                
        PreloadAnimLib(playerid,"DILDO");                 
        PreloadAnimLib(playerid,"DODGE");                 
        PreloadAnimLib(playerid,"DOZER");                 
        PreloadAnimLib(playerid,"DRIVEBYS");              
        PreloadAnimLib(playerid,"FAT");           
        PreloadAnimLib(playerid,"FIGHT_B");               
        PreloadAnimLib(playerid,"FIGHT_C");               
        PreloadAnimLib(playerid,"FIGHT_D");               
        PreloadAnimLib(playerid,"FIGHT_E");               
        PreloadAnimLib(playerid,"FINALE");                
        PreloadAnimLib(playerid,"FINALE2");               
        PreloadAnimLib(playerid,"FLAME");                 
        PreloadAnimLib(playerid,"Flowers");               
        PreloadAnimLib(playerid,"FOOD");                  
        PreloadAnimLib(playerid,"Freeweights");           
        PreloadAnimLib(playerid,"GANGS");                 
        PreloadAnimLib(playerid,"GHANDS");                
        PreloadAnimLib(playerid,"GHETTO_DB");             
        PreloadAnimLib(playerid,"goggles");               
        PreloadAnimLib(playerid,"GRAFFITI");              
        PreloadAnimLib(playerid,"GRAVEYARD");             
        PreloadAnimLib(playerid,"GRENADE");               
        PreloadAnimLib(playerid,"GYMNASIUM");             
        PreloadAnimLib(playerid,"HAIRCUTS");              
        PreloadAnimLib(playerid,"HEIST9");                
        PreloadAnimLib(playerid,"INT_HOUSE");             
        PreloadAnimLib(playerid,"INT_OFFICE");            
        PreloadAnimLib(playerid,"INT_SHOP");              
        PreloadAnimLib(playerid,"JST_BUISNESS");                  
        PreloadAnimLib(playerid,"KART");                  
        PreloadAnimLib(playerid,"KISSING");               
        PreloadAnimLib(playerid,"KNIFE");                 
        PreloadAnimLib(playerid,"LAPDAN1");               
        PreloadAnimLib(playerid,"LAPDAN2");               
        PreloadAnimLib(playerid,"LAPDAN3");               
        PreloadAnimLib(playerid,"LOWRIDER");              
        PreloadAnimLib(playerid,"MD_CHASE");              
        PreloadAnimLib(playerid,"MD_END");                
        PreloadAnimLib(playerid,"MEDIC");                 
        PreloadAnimLib(playerid,"MISC");                  
        PreloadAnimLib(playerid,"MTB");           
        PreloadAnimLib(playerid,"MUSCULAR");              
        PreloadAnimLib(playerid,"NEVADA");                
        PreloadAnimLib(playerid,"ON_LOOKERS");            
        PreloadAnimLib(playerid,"OTB");           
        PreloadAnimLib(playerid,"PARACHUTE");             
        PreloadAnimLib(playerid,"PARK");                  
        PreloadAnimLib(playerid,"PAULNMAC");              
        PreloadAnimLib(playerid,"ped");           
        PreloadAnimLib(playerid,"PLAYER_DVBYS");                  
        PreloadAnimLib(playerid,"PLAYIDLES");             
        PreloadAnimLib(playerid,"POLICE");                
        PreloadAnimLib(playerid,"POOL");                  
        PreloadAnimLib(playerid,"POOR");                  
        PreloadAnimLib(playerid,"PYTHON");                
        PreloadAnimLib(playerid,"QUAD");                  
        PreloadAnimLib(playerid,"QUAD_DBZ");              
        PreloadAnimLib(playerid,"RAPPING");               
        PreloadAnimLib(playerid,"RIFLE");                 
        PreloadAnimLib(playerid,"RIOT");                  
        PreloadAnimLib(playerid,"ROB_BANK");              
        PreloadAnimLib(playerid,"ROCKET");                
        PreloadAnimLib(playerid,"RUSTLER");               
        PreloadAnimLib(playerid,"RYDER");                 
        PreloadAnimLib(playerid,"SCRATCHING");            
        PreloadAnimLib(playerid,"SHAMAL");                
        PreloadAnimLib(playerid,"SHOP");                  
        PreloadAnimLib(playerid,"SHOTGUN");               
        PreloadAnimLib(playerid,"SILENCED");              
        PreloadAnimLib(playerid,"SKATE");                 
        PreloadAnimLib(playerid,"SMOKING");               
        PreloadAnimLib(playerid,"SNIPER");                
        PreloadAnimLib(playerid,"SPRAYCAN");              
        PreloadAnimLib(playerid,"STRIP");                 
        PreloadAnimLib(playerid,"SUNBATHE");              
        PreloadAnimLib(playerid,"SWAT");                  
        PreloadAnimLib(playerid,"SWEET");                 
        PreloadAnimLib(playerid,"SWIM");                  
        PreloadAnimLib(playerid,"SWORD");                 
        PreloadAnimLib(playerid,"TANK");                  
        PreloadAnimLib(playerid,"TATTOOS");               
        PreloadAnimLib(playerid,"TEC");           
        PreloadAnimLib(playerid,"TRAIN");                 
        PreloadAnimLib(playerid,"TRUCK");                 
        PreloadAnimLib(playerid,"UZI");           
        PreloadAnimLib(playerid,"VAN");           
        PreloadAnimLib(playerid,"VENDING");               
        PreloadAnimLib(playerid,"VORTEX");                
        PreloadAnimLib(playerid,"WAYFARER");              
        PreloadAnimLib(playerid,"WEAPONS");               
        PreloadAnimLib(playerid,"WUZI");                  
   return 1;
}

CheckPlayerAttachedObjects(playerid)
{
	RemovePlayerAttachedObject(playerid, ATTACH_SLOT_BIG_WEAPON);
	if(lv[playerid][bigWeapon] > 0 && gpvi(playerid, "bigWeaponAim") == 0)
	{
		switch(lv[playerid][bigWeapon])
		{
			case BIG_WEAPON_IGLA: SetPlayerAttachedObject(playerid,ATTACH_SLOT_BIG_WEAPON,3253,1,0.270999,-0.212999,-0.027000,0.000000,13.799999,0.000000,1.000000,1.000000,1.000000);
		}
	}
	if(lv[playerid][bigWeapon] > 0 && gpvi(playerid, "bigWeaponAim") > 0)
	{
		switch(lv[playerid][bigWeapon])
		{
			case BIG_WEAPON_IGLA: SetPlayerAttachedObject(playerid,ATTACH_SLOT_BIG_WEAPON,3253,6,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "ServerSpawn") != 1 || pi[playerid][logged] == false) return Kick(playerid);
	SetPVarInt(playerid, "ServerSpawn", 0);
	PreloadAllAnimLibs(playerid);
	CheckPlayerAttachedObjects(playerid);
	return 1;
}

stock ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPVarInt(playerid, "USEDIALOGID", dialogid);
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2); 
        
}
#if defined _ALS_ShowPlayerDialog 
        #undef ShowPlayerDialog 
#else 
        #define _ALS_ShowPlayerDialog 
#endif 
#define ShowPlayerDialog ShowPlayerDialogEx 

stock IsVehiclePlane(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 417: return 1;
		case 425: return 1;
		case 447: return 1;
		case 460: return 1;
		case 469: return 1;
		case 476: return 1;
		case 487: return 1;
		case 488: return 1;
		case 497: return 1;
		case 511: return 1;
		case 512: return 1;
		case 513: return 1;
		case 519: return 1;
		case 520: return 1;
		case 548: return 1;
		case 553: return 1;
		case 563: return 1;
		case 577: return 1;
		case 592: return 1;
		case 593: return 1;
		default: return 0;
	}
	return 0;
}

public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "kicked", 0);
	spvi(playerid, "iglaTarget", -1);
	spvi(playerid, "chatTimer", -1);
	GetPlayerName(playerid, pi[playerid][nick], 24);
	pi[playerid][logged] = false;
	pi[playerid][admin] = 0;

	GetPlayerName(playerid, lv[playerid][rpnick], 24);
	lv[playerid][lobby] = 1; // TEST
	lv[playerid][moder] = 0;
	lv[playerid][bigWeapon] = 0;

	mysql_format(sql, query, sizeof(query), "SELECT `id` FROM `accounts` WHERE `nick` = '%e'", n(playerid));
	mysql_tquery(sql, query, "IsPlayerRegistrated", "dd", playerid, -1);
	return 1;
}

forward IsPlayerRegistrated(playerid, retval);
public IsPlayerRegistrated(playerid, retval)
{
	if(cache_num_rows() && retval == -1 || retval == 1) 
	{
		SetPVarInt(playerid, "autoriseTimer", gettime()+30);
		format(dstr, sizeof(dstr), "\t{FFFFFF}Добро пожаловать на %sMilitary Training{FFFFFF}.\n\nАккаунт %s%s{FFFFFF} зарегистрирован. Введите свой пароль.", mainColor, mainColor, n(playerid));

		ShowPlayerDialog(playerid, dLogin, DIALOG_STYLE_INPUT, "{FFFFFF}Авторизация", dstr, "Войти", "Выйти");
	}
	if(!cache_num_rows() && retval == -1 || retval == 0) 
	{
		SetPVarInt(playerid, "autoriseTimer", gettime()+120);
		format(dstr, sizeof(dstr), "\t{FFFFFF}Добро пожаловать на %sMilitary Training{FFFFFF}.\n\nАккаунт %s%s{FFFFFF} не зарегистрирован. Введите свой пароль.", mainColor, mainColor, n(playerid));

		ShowPlayerDialog(playerid, dRegister, DIALOG_STYLE_PASSWORD, "{FFFFFF}Регистрация", dstr, "Войти", "Выйти");
	}
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    //if(strfind(inputtext, "'", true) != -1 || strfind(inputtext, "=", true) != -1) return 1;
	for(new i; i < strlen(inputtext); i++)
	{
     	if(inputtext[i] == '%') inputtext[i] = '#';
     	else if(inputtext[i] == '\\') inputtext[i] = '#';
     	else if(inputtext[i] == '=') inputtext[i] = '~';
     	else if(inputtext[i] == '`') inputtext[i] = '~';
     	else if(inputtext[i] == '{' && inputtext[i+7] == '}') strdel(inputtext, i, i+8);
	}
	if(GetPVarInt(playerid,"USEDIALOGID") != dialogid) return 1;
	SetPVarInt(playerid, "USEDIALOGID", -1);
	switch(dialogid)
	{
		case dRegister:
		{
			if(pi[playerid][logged] == true || !response) return Kick(playerid);
			if((strlen(inputtext) > 31) || (strlen(inputtext) < 6)) 
			{
				IsPlayerRegistrated(playerid, 0);
				return err(playerid, "Пароль не должен быть длиннее 32 и короче 6 символов.");
			}

			mysql_format(sql, query, sizeof(query), "INSERT INTO `accounts` (nick,pass) VALUES ('%e','%e')", n(playerid), inputtext);
			mysql_tquery(sql, query);
			suc(playerid, "Вы успешно зарегистрировались.");
			pi[playerid][logged] = true;
			SpawnPlayer(playerid);
		}
		case dLogin:
		{
			if(pi[playerid][logged] == true || !response) return Kick(playerid);
			if((strlen(inputtext) > 31) || (strlen(inputtext) < 6)) 
			{
				IsPlayerRegistrated(playerid, 1);
				return err(playerid, "Пароль не должен быть длиннее 32 и короче 6 символов.");
			}
			mysql_format(sql, query, sizeof(query), "SELECT * FROM `accounts` WHERE `nick` = '%e' AND `pass` = '%e'", n(playerid), inputtext);
			mysql_tquery(sql, query, "LoginPlayer", "d", playerid);
			

		}
	}
	return 1;
}

forward LoginPlayer(playerid);
public LoginPlayer(playerid)
{
	if(pi[playerid][logged] == true) return Kick(playerid);
	if(!cache_num_rows()) 
	{
		IsPlayerRegistrated(playerid, 1);
		return err(playerid, "Неверный пароль.");
	}
	SpawnPlayer(playerid);
	suc(playerid, "Успешная авторизация.");
	pi[playerid][logged] = true;
	cache_get_value_name_int(0, "admin", pi[playerid][admin]);
	if(pi[playerid][admin] > 0) { f(str, "Вы авторизовались как администратор %d уровня.", pi[playerid][admin]); scm(playerid, greyHex, str); }
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(pi[playerid][logged] == false) return err(playerid, "Вы не авторизованы.");
	return 1;
}

new gPartText1[256];
new gPartText2[256];

stock longText(text[])
{
	strmid(gPartText1,text,0,256,256);
	strmid(gPartText2,text,128,256,256);
	strdel(gPartText1,128,256);
	return 1;
}

CMD:test2(playerid)
{
	if(TOTAL_D30 >= MAX_D30) return err(playerid, "На карте слишком много Д-30.");
	new i, di = -1, Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	for(i=0; i < MAX_D30; i++)
	{
		if(!IsValidDynamicObject(d30[i][d30HeadID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(d30[i][d30HeadID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 10) return err(playerid, "Очень близко стоит еще одна Д-30.");
	}
	new Float:fa;
	GetPlayerFacingAngle(playerid, fa);
	for(i = 0; i < MAX_D30; i++) if(d30[i][d30HeadID] == -1) { di = i; break; }
	if(di == -1) return err(playerid, "ERROR #1545 SEND SYSTEM ADMINISTRATOR");
	fa += 90;
	d30[di][d30HeadID] = CreateDynamicObject(2064, x+floatsin(-fa,degrees), y+floatcos(-fa,degrees), z-0.895437, 0, 0, fa);
	d30[di][d30SoshkiID] = CreateDynamicObject(2063, x+floatsin(-fa,degrees), y+floatcos(-fa,degrees), z-0.895437, 0, 0, fa);
	d30[di][d30Text] = CreateDynamic3DTextLabel("{f6b26b}Гаубица Д-30\n{f9cb9c}Не заряжена\n{fce5cd}'Y' - зарядить\n'NUM8', 'NUM2' - угол возвышения (0°)\n'NUM4', 'NUM6' - угол поворота (0°)\n'H' - выстрел (10 м)", 0xFFFFFFFF,
	 x+floatsin(-fa,degrees), y+floatcos(-fa,degrees)*1, z-0.51, 10);
	d30[di][d30Bullet] = -1;
	d30[di][d30FixMove] = false;
	TOTAL_D30++;
	return 1;
}

/*
new art = -1, shot,  Float:shotDist0, Float:z0, Float:x0, Float:y0, dustId, bool:per;
CMD:art(playerid)
{
	if(art != -1) return SendClientMessage(playerid, -1, "Арта уже есть!!");
	new Float:x,Float:y,Float:z,Float:fa;
	GetPlayerFacingAngle(playerid,fa);
	GetPlayerPos(playerid, x,y,z);
	SetPlayerPos(playerid, x,y,z+3);
	z = z - 0.4;
	CreateObject(2063, x,y,z,  0, 0, fa);
	art = CreateObject(2064, x,y,z,  0, 25, fa);
	shot = CreateObject(2065, x,y,z,  0, 25, fa);
	return 1;
}


CMD:fire(playerid, params[])
{
	new Float:dist,  Float:x, Float:y, Float:z, Float:ry, Float:rx, Float:rz;
	new Float:B, A, Float:REALROT, speed;
	GetObjectRot(art, rx, ry, rz);
	GetObjectPos(art, x, y, z);
	rz = rz+90;

	//                       60   10
	if(sscanf(params, "dd", speed, A)) return SendClientMessage(playerid, -1, "speed G");

	REALROT = -(ry-25);
	//format(str, 144, "REALROT %f", REALROT);
	//scm(playerid, -1, str);
	B = floattan(REALROT, degrees) * 2 * speed * speed * floatcos(REALROT, degrees) * floatcos(REALROT, degrees);
	//format(str, 144, "B %f", B);
	//scm(playerid, -1, str);
	dist = -((-B-B)/2*A)/100;
	//format(str, 144, "dist %f", dist);
	//scm(playerid, -1, str);

	dustId = CreateObject(18713, x,y,z,0,0,0);

	shotDist0 = dist;
	z0 = z;
	x0 = x;
	y0 = y;
	new Float:halfdist = dist/2;
	MoveObject(art, x-floatsin(-rz,degrees)*(-1), y-floatcos(-rz,degrees)*(-1), (z-0.5), 9);
	per = true;
	MoveObject(shot, x-floatsin(-rz,degrees)*(dist/2), y-floatcos(-rz,degrees)*(dist/2), (z+((-halfdist*halfdist+shotDist0*halfdist)/250)), 75);
	return 1;
}

public OnObjectMoved(objectid)
{
	if(objectid == shot)
	{
		new Float:x, Float:y, Float:z, Float:ry, Float:rx, Float:rz;
		GetObjectRot(shot, rx, ry, rz);
		rz = rz+90;
		GetObjectPos(shot, x, y, z);
		if(shotDist0 == 0)
		{
			CreateExplosion(x,y,z, 0, 1);
			DestroyObject(shot);
			return 1;
		}
		MoveObject(shot, x-floatsin(-rz,degrees)*shotDist0, y-floatcos(-rz,degrees)*shotDist0, z0, 75);
		DestroyObject(dustId);
		shotDist0 = 0;
	}
	if(objectid == art && per == true)
	{
		MoveObject(art, x0, y0, z0, 9);
		per = false;
	}
	return 1;
}



CMD:rot(playerid, params[])
{
	// 25 - MIN
	// -30 - MAX
	new Float:rx, Float:ry, Float:rz;
	sscanf(params, "fff", rx, ry, rz);
	SetObjectRot(art, rx,ry,rz);
	SetObjectRot(shot, rx,ry,rz);
	return 1;
}*/

public OnPlayerCommandText(playerid, cmdtext[])
{

	return 0;
}

public OnPlayerText(playerid, text[])
{
    if(pi[playerid][logged] == false)  { err(playerid, "Вы не авторизованы."); return 0; }
	if(lv[playerid][lobby] > 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			ApplyAnimation(playerid, "PED", "IDLE_chat", 4.1, 0, 1, 1, 1, 1);
			spvi(playerid, "chatTimer", gettime()+(floatround((5*strlen(text)/128), floatround_ceil)));
		} 
		f(str, "%s(%d) говорит: %s", rpn(playerid), playerid, text);
		longText(str);
		const distance = 20;
		foreach(Player, i)
		{
			if(GetDistanceBetweenPlayers(playerid, i) < distance/16)
			{
				scm(i, 0xE1E1E1FF, gPartText1);
				if(strlen(str) > 128) scm(i, 0xE1E1E1FF, gPartText2);
			}
			else if(GetDistanceBetweenPlayers(playerid, i) < distance/8)
			{
				scm(i, 0xBFBFBFFF, gPartText1);
				if(strlen(str) > 128) scm(i, 0xBFBFBFFF, gPartText2);
			}
			else if(GetDistanceBetweenPlayers(playerid, i) < distance/4)
			{
				scm(i, 0xA2A2A2FF, gPartText1);
				if(strlen(str) > 128) scm(i, 0xA2A2A2FF, gPartText2);
			}
			else if(GetDistanceBetweenPlayers(playerid, i) < distance/2)
			{
				scm(i, 0x818181FF, gPartText1);
				if(strlen(str) > 128) scm(i, 0x818181FF, gPartText2);
			}
			else if(GetDistanceBetweenPlayers(playerid, i) < distance)
			{
				scm(i, 0x666666FF, gPartText1);
				if(strlen(str) > 128) scm(i, 0x666666FF, gPartText2);
			}
		}
	}
    return 0; 
}


public OnPlayerDeath(playerid, killerid, reason)
{
	spvi(playerid, "ServerSpawn", 1);

	// обнуление ранений
	spvi(playerid, "torsoHit", 0);
	spvi(playerid, "pahHit", 0);
	spvi(playerid, "leftArmHit", 0);
	spvi(playerid, "rightArmHit", 0);
	spvi(playerid, "leftLegHit", 0);
	spvi(playerid, "rightLegHit", 0);
	spvi(playerid, "headHit", 0);
   	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

new TestVeh;

forward furiousTimer();
public furiousTimer()
{
	if(STARTED_PTUR_ID != -1) {
		new Float:vx,Float:vy,Float:vz, Float:tx, Float:ty, Float:tz, Float:resx, Float:resy, Float:resz;
		GetVehiclePos(ptur[STARTED_PTUR_ID][pturTargetID], vx,vy,vz);
		GetDynamicObjectPos(ptur[STARTED_PTUR_ID][pturRocket], tx,ty,tz);
		CA_RayCastLineID(tx,ty,tz, vx,vy,vz, resx,resy,resz);
		//f(str, "%f %f %f", resx,resy,resz);
		//scm(0,-1,str);
		if(!(GetDistanceBetweenPoints(tx,ty,tz,vx,vy,vz) < 7) && (resx == 0.0 && resy == 0.0 && resz == 0.0) && IsValidVehicle(ptur[STARTED_PTUR_ID][pturTargetID])) {
			StopDynamicObject(ptur[STARTED_PTUR_ID][pturRocket]);
			MoveDynamicObject(ptur[STARTED_PTUR_ID][pturRocket], vx, vy, vz, 30, 0,0, GetAngleBetweenPoints(tx,ty,vx,vy)-270);
			SetDynamicObjectRot(ptur[STARTED_PTUR_ID][pturRocket],0,0, GetAngleBetweenPoints(tx,ty,vx,vy)-270);
		}
		else {
			DestroyDynamicObject(ptur[STARTED_PTUR_ID][pturRocket]);
			ptur[STARTED_PTUR_ID][pturRocket] = -1;
			ptur[STARTED_PTUR_ID][pturTargetID] = -1;
			if(!(resx == 0.0 && resy == 0.0 && resz == 0.0)) CreateExplosion(resx,resy,resz,2,5);
			else CreateExplosion(tx,ty,tz,2,5);
			STARTED_PTUR_ID = -1;
		}
	}
	if(STARTED_IGLA_ID != -1 && IsValidDynamicObject(STARTED_IGLA_ID)) {
		new Float:vx,Float:vy,Float:vz, Float:tx, Float:ty, Float:tz, Float:rz, Float:resx, Float:resy, Float:resz;
		GetVehiclePos(IGLA_TARGET, vx,vy,vz);
		GetDynamicObjectPos(STARTED_IGLA_ID, tx,ty,tz);
		CA_RayCastLineID(tx,ty,tz, vx,vy,vz, resx,resy,resz);
		if(!(GetDistanceBetweenPoints(tx,ty,tz,vx,vy,vz) < 7) && (resx == 0.0 && resy == 0.0 && resz == 0.0) && IsValidVehicle(IGLA_TARGET)) {
			StopDynamicObject(STARTED_IGLA_ID);
			rz = GetAngleBetweenPoints(tx,ty,vx,vy)-270;
			MoveDynamicObject(STARTED_IGLA_ID, vx, vy, vz, (GetVehicleModel(IGLA_TARGET) == 520) ? (100.0) : (50.0), GetXAngleBetweenPoints(tx,ty,tz,vx,vy,vz,rz), 0, rz);
			SetDynamicObjectRot(STARTED_IGLA_ID, GetXAngleBetweenPoints(tx,ty,tz,vx,vy,vz,rz), 0, rz);
		}
		else {
			DestroyDynamicObject(STARTED_IGLA_ID);
			STARTED_IGLA_ID = -1;
			IGLA_TARGET = -1;
			if(!(resx == 0.0 && resy == 0.0 && resz == 0.0)) CreateExplosion(resx,resy,resz,2,5);
			else CreateExplosion(tx,ty,tz,2,5);
		}
	}
}

forward mainTimer();
public mainTimer()
{
	for(new i=0; i<MAX_CRATES; i++)
		if(IsValidDynamicObject(crate[i][crateID]) && crate[i][crateCount] == 0 && crate[i][crateLife] < gettime()) DestroyCrate(i);
	foreach(Player, i)
	{
		if(GetPVarInt(i, "kicked") < gettime() && GetPVarInt(i, "kicked") != 0) Kick(i);
		if(gpvi(i, "chatTimer") != -1 && gpvi(i, "chatTimer") < gettime()) { ClearAnimations(i); spvi(i, "chatTimer", -1); }
		if(pi[i][logged] == false && GetPVarInt(i, "autoriseTimer") < gettime() && GetPVarInt(i, "autoriseTimer") != 0)
		{
			err(i, "Время на авторизацию вышло.");
			Kick(i);
		}
		if(gpvi(i, "iglaTarget") != -1) 
		{
			if(!IsValidVehicle(gpvi(i, "iglaTarget")) || !IsVehicleStreamedIn(gpvi(i, "iglaTarget"), i)) { pc_cmd_igla(i); }
			else {
				new Float:vx, Float:vy, Float:vz, Float:x, Float:y, Float:z;
				GetPlayerPos(i, x,y,z);
				GetVehiclePos(gpvi(i, "iglaTarget"), vx, vy,vz);
				SetPlayerFacingAngle(i,GetAngleBetweenPoints(x,y,vx,vy)-180);
				SetPlayerCameraPos(i, x,y,z+1);
				SetPlayerCameraLookAt(i, vx,vy,vz);
			}
		}
	}
}

CreateCrate(playerid, type, count)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	if(TOTAL_CRATES >= MAX_CRATES) return err(playerid, "На карте слишком много ящиков.");
	new i=0;
	for(i=0; i < MAX_CRATES; i++)
	{
		if(!IsValidDynamicObject(crate[i][crateID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(crate[i][crateID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 5) return err(playerid, "Очень близко стоит еще один ящик.");
	}
	TOTAL_CRATES ++;
	for(i = 0; i<MAX_CRATES; i++)
	{
		if(crate[i][crateID] == -1) break;
	}
	crate[i][crateID] = CreateDynamicObject(3283, x,y,z-0.979988, 0,0,random(180));
	crate[i][crateType] = type;
	crate[i][crateCount] = count;
	switch(type)
	{
		case CRATE_PTUR: f(str, "{93c47d}Ящик с ПТУРС (%d шт.)\n{d9ead3}'/pturfill' - зарядить\n{d9ead3}'/getcrate' - поднять", count);
		case CRATE_IGLA: f(str, "{93c47d}Ящик с ПЗРК «Игла» (%d шт.)\n{d9ead3}'/pzrkget' - взять", count);
	}	
	crate[i][crateText] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, x,y,z-0.979988, 10);
	return 1;
}

UpdateCrate(crID, count)
{
	crate[crID][crateCount] += count;
	switch(crate[crID][crateType])
	{
		case CRATE_PTUR: f(str, "{93c47d}Ящик с ПТУРС (%d шт.)\n{d9ead3}'/pturfill' - зарядить\n{d9ead3}'/getcrate' - поднять", crate[crID][crateCount]);
		case CRATE_IGLA: f(str, "{93c47d}Ящик с ПЗРК «Игла» (%d шт.)\n{d9ead3}'/pzrkget' - взять", crate[crID][crateCount]);
	}	
	UpdateDynamic3DTextLabelText(crate[crID][crateText], 0xFFFFFFFF, str);
	if(crate[crID][crateCount] == 0) crate[crID][crateLife] = gettime()+30;
}

DestroyCrate(crID)
{
	DestroyDynamicObject(crate[crID][crateID]);
	crate[crID][crateID] = -1;
	crate[crID][crateType] = -1;
	crate[crID][crateCount] = -1;
	crate[crID][crateLife] = -1;
	DestroyDynamic3DTextLabel(crate[crID][crateText]);
	TOTAL_CRATES--;
}

CMD:pzrkget(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if(gpvi(playerid, "rightArmHit") > 0) return err(playerid, "Ваша правая рука повреждена.");
	new nearCrate = -1;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	new i2=0;
	for(i2=0; i2 < MAX_CRATES; i2++)
	{
		if(!IsValidDynamicObject(crate[i2][crateID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(crate[i2][crateID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 5) { nearCrate = i2; break; }
	}
	if(nearCrate == -1 || crate[nearCrate][crateType] != CRATE_IGLA || crate[nearCrate][crateCount] <= 0) return err(playerid, "Рядом нет ящиков с ПЗРК.");
	if(lv[playerid][bigWeapon] > 0) return err(playerid, "У вас уже есть ручное крупнокалиберное оружие.");
	suc(playerid, "Вы подобрали ПЗРК «Игла», для прицеливания и выстрела используйте '/igla'.");
	lv[playerid][bigWeapon] = BIG_WEAPON_IGLA;
	CheckPlayerAttachedObjects(playerid);
	ApplyAnimation(playerid, "WUZI", "WUZI_GRND_CHK", 4.1, false, true, true, false, 0, true);
	UpdateCrate(nearCrate, -1);
	return 1;
}

CMD:igla(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if(gpvi(playerid, "rightArmHit") > 0) return err(playerid, "Ваша правая рука повреждена.");
	if(lv[playerid][bigWeapon] == 0) return err(playerid, "У вас нет ПЗРК.");
	if(gpvi(playerid, "bigWeaponAim") == BIG_WEAPON_IGLA) {
		if(STARTED_IGLA_ID != -1 && IsValidDynamicObject(STARTED_IGLA_ID)) lv[playerid][bigWeapon] = 0;
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid, 1);
		spvi(playerid, "bigWeaponAim", 0);
		CheckPlayerAttachedObjects(playerid);
		spvi(playerid, "iglaTarget", -1);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	inf(playerid, "Для выхода из режима прицеливания снова введите '/igla'; смена цели - ПКМ; выстрел - ЛКМ.");
	spvi(playerid, "bigWeaponAim", BIG_WEAPON_IGLA);
	CheckPlayerAttachedObjects(playerid);
	ApplyAnimation(playerid, "SHOP", "SHP_GUN_AIM", 4.1, true, true, true, true, 0, true);
	TogglePlayerControllable(playerid, false);
	//ApplyAnimation(playerid, "ROCKET", "ROCKETFIRE", 4.1, false, false, false, false, 0, false);  // выстрел иглы
	return 1;
}

CMD:pturfill(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	if(gpvi(playerid, "rightArmHit") > 0) return err(playerid, "Ваша правая рука повреждена.");
	new Float:x, Float:y, Float:z, i1, nearPtur = -1, nearCrate = -1;
	GetPlayerPos(playerid, x,y,z);
	for(i1=0; i1 < MAX_PTUR; i1++)
	{
		if(!IsValidDynamicObject(ptur[i1][pturHeadID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(ptur[i1][pturHeadID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 2.0) { nearPtur = i1; break; }
	}
	new i2=0;
	for(i2=0; i2 < MAX_CRATES; i2++)
	{
		if(!IsValidDynamicObject(crate[i2][crateID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(crate[i2][crateID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 5) { nearCrate = i2; break; }
	}
	if(nearCrate == -1 || nearPtur == -1) return err(playerid, "ПТРК или его заряд далеки друг от друга.");
	if(ptur[nearPtur][pturFilled] == true) return err(playerid, "ПТРК уже заряжен.");
	if(crate[nearCrate][crateCount] == 0) return err(playerid, "Ящик пустой.");
	if(crate[nearCrate][crateType] != CRATE_PTUR) return err(playerid, "В данном ящике не лежит ПТУРС.");
	ApplyAnimation(playerid, "WUZI", "WUZI_GRND_CHK", 4.1, false, true, true, false, 0, true);
	UpdateCrate(nearCrate, -1);
	ptur[nearPtur][pturFilled] = true;
	UpdateDynamic3DTextLabelText(ptur[nearPtur][pturText], 0xFFFFFFFF, "{45818E}ПТРК «Конкурс»\n{45818E}Заряжен\n{a2c4c9}'Y', 'H' - поворот\n'ПКМ' - корректировка\n'N' - огонь\n2x'SPACE' - поднять");
	return 1;
}

CMD:testptur(playerid)
{
	CreateCrate(playerid,CRATE_PTUR,1);
	return 1;
}

CMD:testpzrk(playerid)
{
	CreateCrate(playerid,CRATE_IGLA,1);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(gpvi(playerid, "rightArmHit") > 0 && GetPlayerWeapon(playerid) > 0) SetPlayerArmedWeapon(playerid, 0);
	return 1;
}

public OnGameModeInit()
{
	CA_Init();

	SetGameModeText("Untitled");

	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 1000);
	Streamer_VisibleItems(STREAMER_OBJECT_TYPE_DYNAMIC, 1000);

	SetTimer("mainTimer", 1000, true);
	SetTimer("furiousTimer", 50, true);

	SetGravity(0.012);
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(24.0);
 	ShowPlayerMarkers(2);
	DisableInteriorEnterExits();

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

	sql = mysql_connect(mysqlip, mysqlroot, mysqlpass, mysqldb);
	if(mysql_errno() != 0) print("Could not connect to database!");
	else print("Mysql connect FINE.");

	for(new i = 0; i < MAX_DROPPED_WEAPON; i++)
		droppedWeapon[i][drID] = -1;
	TOTAL_DROPPED_WEAPON = 0;
	for(new i = 0; i < MAX_PTUR; i++)
		ptur[i][pturHeadID] = -1;
	TOTAL_PTUR = 0;
	STARTED_PTUR_ID = -1;
	for(new i = 0; i < MAX_CRATES; i++)
		crate[i][crateID] = -1;
	TOTAL_CRATES = 0;
	for(new i = 0; i < MAX_D30; i++)
		d30[i][d30HeadID] = -1;
	TOTAL_D30 = 0;

	STARTED_IGLA_ID = -1;
	IGLA_TARGET = -1;
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pi[playerid][admin] < 2) return 1;
	new Float:x2, Float:y2, Float:z2, Float:fa;
	if(sscanf(params, "d", params[0])) return inf(playerid, "Телепорт к игроку: /goto [playerid]");
	if(pi[params[0]][logged] == false) return err(playerid, "Игрок не авторизован!");
	GetPlayerFacingAngle(params[0], fa);
	GetPlayerPos(params[0], x2,y2,z2);
	SetPlayerPos(playerid, x2+floatsin(-fa, degrees),y2+floatcos(-fa, degrees),z2);
	f(str, "Вы телепортировались к %s[%d].", n(params[0]), params[0]);
	suc(playerid, str);
	return 1;
}


CMD:gethere(playerid, params[])
{
	if(pi[playerid][admin] < 3) return 1;
	new Float:x2, Float:y2, Float:z2, Float:fa;
	if(sscanf(params, "d", params[0])) return inf(playerid, "Телепорт игрока к себе: /gethere [playerid]");
	if(pi[params[0]][logged] == false) return err(playerid, "Игрок не авторизован!");
	GetPlayerFacingAngle(playerid, fa);
	GetPlayerPos(playerid, x2,y2,z2);
	SetPlayerPos(params[0], x2+floatsin(-fa, degrees),y2+floatcos(-fa, degrees),z2);
	f(str, "Вы телепортировали %s[%d] к себе.", n(params[0]), params[0]);
	suc(playerid, str);
	f(str, "Вас телепортировал %s[%d] к себе.", n(playerid), playerid);
	inf(params[0], str);
	return 1;
}

CMD:importmap(playerid, params[])
{
	if(pi[playerid][admin] < 10) return 1;
	new filename[24];
	if(sscanf(params, "s[24]", filename)) return scm(playerid, -1, "Введите название карты включая .txt");
	new File:fi = fopen(filename, io_read);

    if (fi == File:0)
		return err(playerid, "Такого файла не существует!");

	new line[256], oId, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, trash[64], obj, tex1[24], tex2[24], color, slot, toid;
	while ((fread(fi, line)))
	{
		if(strfind(line, "//") != -1) continue;
		if(strfind(line, "CreateDynamicObject") != -1)
		{
			strdel(line, strlen(line)-8, strlen(line));
			strdel(line, 0, 31);
			if (sscanf(line, "p<,>dffffffs[64]", oId, x,y,z,rx,ry,rz, trash) == 0)
				obj = CA_CreateDynamicObject_SC(oId, x,y,z, rx,ry,rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 1500, 1500);
		}
		if(strfind(line, "SetDynamicObjectMaterial") != -1)
		{
			strdel(line, strlen(line)-4, strlen(line));
			strdel(line, 0, 35);
			if (sscanf(line, "p<,>dds[24]s[24]x", slot, toid, tex1, tex2, color) == 0)
			{
				strdel(tex1, 0, 1);
				strdel(tex1, strlen(tex1)-1, strlen(tex1));
				strdel(tex2, 0, 1);
				strdel(tex2, strlen(tex2)-1, strlen(tex2));
				SetDynamicObjectMaterial(obj, slot, toid, tex1, tex2, color);
			}
		}

	}
	SetPlayerPos(playerid,1019.660156, 3856.523925, 3.740791+3);
	f(str, "Вы успешно импортировали карту %s.", filename);
	suc(playerid, str);

	fclose(fi);
	return 1;
}

RemovePlayerWeapon(playerid, weaponid)
{
    if(!IsPlayerConnected(playerid) || weaponid < 0 || weaponid > 50)
        return 1;
    new saveweapon[13], saveammo[13];
    for(new slot = 0; slot < 13; slot++)
        GetPlayerWeaponData(playerid, slot, saveweapon[slot], saveammo[slot]);
    ResetPlayerWeapons(playerid);
    for(new slot; slot < 13; slot++)
    {
        if(saveweapon[slot] == weaponid || saveammo[slot] == 0)
            continue;
        GivePlayerWeapon(playerid, saveweapon[slot], saveammo[slot]);
    }

    GivePlayerWeapon(playerid, 0, 1);
	return 1;
}

SendPlayerRolePlayDamage(playerid, bodypart)
{
	if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid)) return 1;
	switch(bodypart)
	{
		case RIGHT_ARM:
		{
			spvi(playerid, "rightArmHit", gpvi(playerid, "rightArmHit")+1);
			switch(random(3))
			{
				case 0: ApplyAnimation(playerid, "PED", "DAM_ARMR_FRMBK", 3.1, false, true, true, false, 0, true); // rightHandHit1
				case 1: ApplyAnimation(playerid, "PED", "DAM_ARMR_FRMFT", 3.1, false, true, true, false, 0, true); // rightHandHit2
				case 2: ApplyAnimation(playerid, "PED", "DAM_ARMR_FRMRT", 3.1, false, true, true, false, 0, true);
			}	
			if(GetPlayerWeapon(playerid) > 0) DropPlayerWeapon(playerid, GetPlayerWeapon(playerid));
			SetPlayerArmedWeapon(playerid, 0);
			inf(playerid, "Вы ранены в ПРАВУЮ руку, вы не сможете носить оружие до излечения ранения.");
		}
	}
	return 1;
}



DropPlayerWeapon(playerid, weaponid)
{
	if(!IsPlayerConnected(playerid) || weaponid < 0 || weaponid > 50 || TOTAL_DROPPED_WEAPON >= MAX_DROPPED_WEAPON)
        return 1;
	new weaponObject;
	switch(weaponid)
	{
		case 1: weaponObject = 331;
		case 2: weaponObject = 333;
		case 3: weaponObject = 334;
		case 4: weaponObject = 335;
		case 5: weaponObject = 336;
		case 6: weaponObject = 337;
		case 7: weaponObject = 338;
		case 8: weaponObject = 339;
		case 9: weaponObject = 341;
		case 10: weaponObject = 321;
		case 11: weaponObject = 322;
		case 12: weaponObject = 323;
		case 13: weaponObject = 324;
		case 14: weaponObject = 325;
		case 15: weaponObject = 326;
		case 16: weaponObject = 342;
		case 17: weaponObject = 343;
		case 18: weaponObject = 344;
		case 19: weaponObject = 345;
		case 20: weaponObject = 345;
		case 21: weaponObject = 345;
		case 22: weaponObject = 346;
		case 23: weaponObject = 347;
		case 24: weaponObject = 348;
		case 25: weaponObject = 349;
		case 26: weaponObject = 350;
		case 27: weaponObject = 351;
		case 28: weaponObject = 352;
		case 29: weaponObject = 353;
		case 30: weaponObject = 355;
		case 31: weaponObject = 356;
		case 32: weaponObject = 372;
		case 33: weaponObject = 357;
		case 34: weaponObject = 358;
		case 35: weaponObject = 359;
		case 36: weaponObject = 360;
		case 37: weaponObject = 361;
		case 38: weaponObject = 362;
		case 39: weaponObject = 363;
		case 40: weaponObject = 364;
		case 41: weaponObject = 365;
		case 42: weaponObject = 366;
		case 43: weaponObject = 367;
		case 44: weaponObject = 368;
		case 45: weaponObject = 369;
		case 46: weaponObject = 371;
	}
	new Float:x, Float:y, Float:z, Float:fa;
	GetPlayerPos(playerid, x,y,z);
	GetPlayerFacingAngle(playerid, fa);
	//0.5 0.5 -0.95 90 0 135
	for(new i; i < MAX_DROPPED_WEAPON; i++)
	{
		if(droppedWeapon[i][drID] == -1)
		{
			droppedWeapon[i][drID] = CreateDynamicObject(weaponObject, x+floatsin(-fa,degrees)*0.5, y+floatcos(-fa,degrees)*0.5, z-0.95, 90, 0, fa+135);
			droppedWeapon[i][weaponNum] = weaponid;
			droppedWeapon[i][ammoCount] = GetPlayerAmmo(playerid);
			new wn[36];
			GetWeaponName(weaponid, wn, 36);
			f(str, "{6aa84f}%s\n{93c47d}%d патрон\n{b6d7a8}Нажмите 'H' для подбора", wn, droppedWeapon[i][ammoCount]);
			droppedWeapon[i][text3did] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, x+floatsin(-fa,degrees)*0.5, y+floatcos(-fa,degrees)*0.5, z-0.95, 25);
			TOTAL_DROPPED_WEAPON++;
			break;
		}

	}
	RemovePlayerWeapon(playerid, weaponid);
	return 1;
}

CMD:drop(playerid)
{
	suc(playerid, "Вы выбросили оружие на землю.");
	DropPlayerWeapon(playerid, GetPlayerWeapon(playerid));
}

PickWeapon(playerid, index)
{
	if(gpvi(playerid, "rightArmHit") > 0) return inf(playerid, "Вы не можете это поднять.");
	GivePlayerWeapon(playerid, droppedWeapon[index][weaponNum], droppedWeapon[index][ammoCount]);
	DestroyDynamicObject(droppedWeapon[index][drID]);
	DestroyDynamic3DTextLabel(droppedWeapon[index][text3did]);
	ApplyAnimation(playerid, "WUZI", "WUZI_GRND_CHK", 4.1, false, true, true, false, 0, true);
	droppedWeapon[index][drID] = -1;
	TOTAL_DROPPED_WEAPON--;
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{

    if(playerid != INVALID_PLAYER_ID && issuerid != INVALID_PLAYER_ID && 
		IsPlayerConnected(playerid) && IsPlayerConnected(issuerid)) SendPlayerRolePlayDamage(playerid, bodypart);
    return 1;
}

stock GetWeaponSlot(weaponid)
{
    switch(weaponid)
    {
        case 1: return 0;
        case 2..9: return 1;
        case 22..24: return 2;
        case 25..27: return 3;
        case 28, 29, 32: return 4;
        case 30, 31: return 5;
        case 33, 34: return 6;
        case 35..38: return 7;
        case 16..18, 39: return 8;
        case 41..43: return 9;
        case 10..15: return 10;
        case 44..46: return 11;
        case 40: return 12;
    }
    return 0xFFFF;
}

stock GetWeaponInThatSlot(playerid, slot)
{
	new weaponid, ammoo;
	GetPlayerWeaponData(playerid, slot, weaponid, ammoo);
	if(weaponid != 0) return weaponid;
	else return 0;
}

FirePtur(playerid, pid)
{
	if(ptur[pid][pturFilled] == false) return err(playerid, "ПТРК не заряжен.");
	if(STARTED_PTUR_ID != -1) return err(playerid, "Подождите.");
	if(ptur[pid][pturTargetID] == -1 || ptur[pid][pturTargetTimer] < gettime()) return err(playerid, "ПТРК не навёлся.");
	if(!IsVehicleStreamedIn(ptur[pid][pturTargetID], playerid)) return err(playerid, "Данное транспортное средство покинуло зону стрима.");
	UpdateDynamic3DTextLabelText(ptur[pid][pturText], 0xFFFFFFFF,"{45818E}ПТРК «Конкурс»\n{76a5af}Не заряжен\n{a2c4c9}'Y', 'H' - поворот\n'ПКМ' - корректировка\n'N' - огонь\n2x'SPACE' - поднять");
	ptur[pid][pturFilled] = false;
	STARTED_PTUR_ID = pid;
	new Float:x, Float:y, Float:z, Float:rZ, Float:rX, Float:rY, Float:vX, Float:vY, Float:vZ;
	GetVehiclePos(ptur[pid][pturTargetID], vX, vY, vZ);
	GetDynamicObjectPos(ptur[pid][pturHeadID], x,y,z);
	GetDynamicObjectRot(ptur[pid][pturHeadID], rX,rY,rZ);
	ptur[pid][pturRocket] = CreateDynamicObject(3790, x+0.152819, y+0.887239, z+0.153364, rX, rY, GetAngleBetweenPoints(x,y,vX,vY)-270);
	MoveDynamicObject(ptur[pid][pturRocket], vX, vY, vZ, 30, 0,0, GetAngleBetweenPoints(x,y,vX,vY)-270);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	/*if(newkeys & KEY_FIRE)
	{
		new Float:x, Float:y, Float:z, Float:fa, Float:resx, Float:resy, Float:resz;
		GetPlayerPos(playerid, x,y,z);
		GetPlayerFacingAngle(playerid, fa);
		CA_RayCastLineID(x,y,z,x+floatsin(-fa, degrees)*10, y+floatcos(-fa, degrees)*10, z+0.5, resx,resy,resz);
		CreateDynamicObject(1598, resx,resy,resz,0,0,0);
		f(str, "%f %f %f", resx,resy,resz);
		scm(0,-1,str);
	}*/
	if (gpvi(playerid, "rightArmHit") == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && newkeys & KEY_CTRL_BACK)
	{
		for(new i; i < MAX_DROPPED_WEAPON; i++)
		{
			new Float:x, Float:y, Float:z, Float:px, Float:py, Float:pz;
			GetPlayerPos(playerid, px, py, pz);
			GetDynamicObjectPos(droppedWeapon[i][drID], x,y,z);
			if(GetDistanceBetweenPoints(px, py, pz, x,y,z) <= 1.5) 
			{
				if(GetWeaponInThatSlot(playerid, GetWeaponSlot(droppedWeapon[i][weaponNum])) != droppedWeapon[i][weaponNum] && GetWeaponInThatSlot(playerid, GetWeaponSlot(droppedWeapon[i][weaponNum])) != 0) return err(playerid, "У вас есть оружие подобного типа.");
				PickWeapon(playerid, i);
				return 1;
				//break;
			}
		}
	}
	if(gpvi(playerid, "rightArmHit") == 0 && GetPlayerWeapon(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_CTRL_BACK || newkeys & KEY_YES || newkeys & KEY_HANDBRAKE || newkeys & KEY_NO))
	{
		new ci, i = -1, Float:x,Float:y,Float:z, Float:rX, Float:rY, Float: rZ;
		GetPlayerPos(playerid,x,y,z);
		for(ci=0; ci < MAX_PTUR; ci++)
		{
			if(!IsValidDynamicObject(ptur[ci][pturHeadID])) continue;
			new Float:oX, Float:oY, Float:oZ;
			GetDynamicObjectPos(ptur[ci][pturHeadID], oX, oY, oZ);
			if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 2.0) { i = ci; break; }
		}
		if(i != -1)
		{
			GetDynamicObjectRot(ptur[i][pturHeadID], rX, rY, rZ);
			if(newkeys & KEY_CTRL_BACK) SetDynamicObjectRot(ptur[i][pturHeadID], 0,0,rZ+1);
			if(newkeys & KEY_YES) SetDynamicObjectRot(ptur[i][pturHeadID], 0,0,rZ-1);
			if(newkeys & KEY_HANDBRAKE) FindPturTarget(playerid, i);
			if(newkeys & KEY_NO) FirePtur(playerid, i);
			ApplyAnimation(playerid, "BSKTBALL", "BBALL_IDLELOOP", 2.0, false, false, false, false, 0, true);
		}
	}
	if(gpvi(playerid, "rightArmHit") == 0 && GetPlayerWeapon(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_HANDBRAKE || newkeys & KEY_FIRE) && gpvi(playerid, "bigWeaponAim") == BIG_WEAPON_IGLA && lv[playerid][bigWeapon] == BIG_WEAPON_IGLA)
	{
		if(newkeys & KEY_HANDBRAKE)
		{
			new maxPlaneID = -1, firstPlaneID = -1;
			foreach(new vid : Vehicle)
			{
				if(!IsVehicleStreamedIn(vid, playerid) || !IsVehiclePlane(vid) ) continue;
				if(firstPlaneID == -1) firstPlaneID = vid;
				if(vid > gpvi(playerid, "iglaTarget")) { spvi(playerid, "iglaTarget", vid); break; }
				//printf("%d %d", firstPlaneID, gpvi(playerid, "iglaTarget"));
				//nearPlane = vid;
				maxPlaneID = vid;
			}
			//if(gpvi(playerid, "iglaTarget") == nearPlane) return 1;
			if(maxPlaneID == -1 && gpvi(playerid, "iglaTarget") == -1) { err(playerid, "Рядом не летает ни одного воздушного судна."); pc_cmd_igla(playerid); return 1; }
			if(!IsValidVehicle(gpvi(playerid, "iglaTarget"))) return 1;
			new Float:vx, Float:vy, Float:vz, Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x,y,z);
			GetVehiclePos(gpvi(playerid, "iglaTarget"), vx, vy,vz);
			SetPlayerFacingAngle(playerid,GetAngleBetweenPoints(x,y,vx,vy)-180);
			SetPlayerCameraPos(playerid, x,y,z+1);
			SetPlayerCameraLookAt(playerid, vx,vy,vz);
			f(str, "Игла обнаружила %s[%d].", VehicleNames[GetVehicleModel(gpvi(playerid, "iglaTarget"))-400], gpvi(playerid, "iglaTarget"));
			inf(playerid, str);
			if(gpvi(playerid, "iglaTarget") == maxPlaneID) spvi(playerid, "iglaTarget", -1);
		}
		else if (newkeys & KEY_FIRE)
		{
			if(lv[playerid][bigWeapon] != BIG_WEAPON_IGLA || gpvi(playerid, "bigWeaponAim") != BIG_WEAPON_IGLA) return 1;
			if(gpvi(playerid, "iglaTarget") == -1 || !IsValidVehicle(gpvi(playerid, "iglaTarget")) || !IsVehicleStreamedIn(gpvi(playerid, "iglaTarget"), playerid)
			|| !IsVehiclePlane(gpvi(playerid, "iglaTarget"))) return err(playerid, "Данное транспортное средство не подходит.");
			if(STARTED_IGLA_ID != -1 || IsValidDynamicObject(STARTED_IGLA_ID)) return err(playerid, "Подождите...");
			new Float:x, Float:y, Float:z, Float:fa, Float:vX, Float:vY, Float:vZ, Float:rZ;
			GetPlayerPos(playerid, x,y,z);
			GetPlayerFacingAngle(playerid, fa);
			GetVehiclePos(gpvi(playerid, "iglaTarget"), vX, vY,vZ);
			if(vZ <= z+3.0) return err(playerid, "Транспорт летит слишком низко.");
			rZ = GetAngleBetweenPoints(x,y,vX,vY)-270;
			STARTED_IGLA_ID = CreateDynamicObject(3790, x+floatsin(-fa, degrees), y+floatcos(-fa, degrees), z+0.3, GetXAngleBetweenPoints(x,y,z,vX,vY,vZ,rZ), 0, rZ);
			GameTextForPlayer(playerid, "~w~ROCKET~n~~g~STARTED", 3000, 1);
			ApplyAnimation(playerid, "ROCKET", "ROCKETFIRE", 4.1, false, false, false, false, 0, false);
			IGLA_TARGET = gpvi(playerid, "iglaTarget");
			pc_cmd_igla(playerid);
		}
	}
	return 1;
}

CMD:test(playerid, params[])
{
	sscanf(params, "d", params[0]);
	GivePlayerWeapon(playerid, params[0], 999);
	//	SetObjectRot(to, GetXAngleBetweenPoints(x,y,z,vX,vY,vZ,rz), 0, GetAngleBetweenPoints(x,y,vX,vY)-270);
	return 1;
}

CMD:testo(playerid, params[])
{
	/*sscanf(params, "d", params[0]);
	new Float:x, Float:y, Float:z, Float:fa;
	GetPlayerPos(playerid, x,y,z);
	GetPlayerFacingAngle(playerid, fa);
	CA_CreateDynamicObject_DC(params[0], x+floatsin(-fa, degrees), y+floatcos(-fa, degrees), z+0.5, 0,0,0);*/
}


CMD:test1(playerid)
{
	if(TOTAL_PTUR >= MAX_PTUR) return err(playerid, "На карте слишком много ПТРК.");
	new i, di = -1, Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	for(i=0; i < MAX_PTUR; i++)
	{
		if(!IsValidDynamicObject(ptur[i][pturHeadID])) continue;
		new Float:oX, Float:oY, Float:oZ;
		GetDynamicObjectPos(ptur[i][pturHeadID], oX, oY, oZ);
		if(GetDistanceBetweenPoints(x,y,z,oX,oY,oZ) < 10) return err(playerid, "Очень близко стоит еще один ПТРК.");
	}
	new Float:fa;
	GetPlayerFacingAngle(playerid, fa);
	for(i = 0; i < MAX_PTUR; i++) if(ptur[i][pturHeadID] == -1) { di = i; break; }
	if(di == -1) return err(playerid, "ERROR #1542 SEND SYSTEM ADMINISTRATOR");
	ptur[di][pturHeadID] = CreateDynamicObject(3285, x+floatsin(-fa,degrees)+0.010972, y+floatcos(-fa,degrees)+0.000656, z-0.51+0.114702, 0, 0, fa+280);
	ptur[di][pturSoshkiID] = CreateDynamicObject(3284, x+floatsin(-fa,degrees)*1, y+floatcos(-fa,degrees)*1, z-0.51, 0, 0, fa+280);
	ptur[di][pturText] = CreateDynamic3DTextLabel("{45818E}ПТРК «Конкурс»\n{76a5af}Не заряжен\n{a2c4c9}'Y', 'H' - поворот\n'ПКМ' - корректировка\n'N' - огонь\n2x'SPACE' - поднять", 0xFFFFFFFF,
	 x+floatsin(-fa,degrees), y+floatcos(-fa,degrees)*1, z-0.51, 10);
	ptur[di][pturRocket] = -1;
	ptur[di][pturFilled] = false;
	ptur[di][pturTargetID] = -1;
	TOTAL_PTUR++;
	return 1;
}

FindPturTarget(playerid, tempPturID)
{
	new Float:x, Float:y, Float:z, Float:rZ, Float:rY, Float:rX, Float:nX, Float:nY, Float:vX, Float:vY, Float:vZ, Float:fa, Float:angFront, Float:angTank, Float:dist;
	new Float:resx, Float:resy, Float:resz;
	new minDistCar = -1, Float:minDist = 9999.0;
	new tempPtur = ptur[tempPturID][pturHeadID];
	GetDynamicObjectPos(tempPtur, x,y,z);
	GetDynamicObjectRot(tempPtur, rX, rY, rZ);
	foreach (new vehicleid : Vehicle) {
		GetVehiclePos(vehicleid, vX,vY,vZ);
		CA_RayCastLineID(x,y,z, vX,vY,vZ, resx,resy,resz);
		if(GetDistanceBetweenPoints(x,y,z,vX,vY,vZ) > 150 || !IsVehicleStreamedIn(vehicleid, playerid) || IsVehiclePlane(vehicleid)) continue;
		if(!(resx == 0.0 && resy == 0.0 && resz == 0.0)) continue;
		fa = -rZ-90;
		nX = x+floatsin(-fa,degrees)*-1.4;
		nY = y+floatcos(-fa,degrees)*1.5;
		angFront = (GetAngleBetweenPoints(x,y,nX,nY) < 0) ? (GetAngleBetweenPoints(x,y,nX,nY)+360) : (GetAngleBetweenPoints(x,y,nX,nY));
		angTank =  (GetAngleBetweenPoints(x,y,vX,vY) < 0) ? (GetAngleBetweenPoints(x,y,vX,vY)+360) : (GetAngleBetweenPoints(x,y,vX,vY));
		dist = angTank-angFront;
		if(dist < minDist && dist < 20 && dist > -20) { minDistCar = vehicleid; minDist = dist; }
	}
	if(minDistCar == -1) return err(playerid, "ПТРК не навёлся ни на одно близлежайщее транспортное средство.");
	f(str, "ПТРК навёлся на %s[%d].", VehicleNames[GetVehicleModel(minDistCar)-400], minDistCar);
	suc(playerid, str);
	ptur[tempPturID][pturTargetID] = minDistCar;
	ptur[tempPturID][pturTargetTimer] = gettime()+15;
	MoveDynamicObject(tempPtur, (ptur[tempPturID][pturFixMove] == true) ? (x+0.001) : (x-0.001),y,z, 0.01, 0.0, 0.0, GetAngleBetweenPoints(x,y,vX,vY));
	if(ptur[tempPturID][pturFixMove] == true) ptur[tempPturID][pturFixMove] = false; 
		else ptur[tempPturID][pturFixMove] = true;
	return 1;
}

CMD:veh(playerid, params[]) // TEST
{
	if(IsValidVehicle(TestVeh)) return 1;
	sscanf(params, "d", params[0]);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	TestVeh = CreateVehicle(params[0], x,y,z, 0, 1, 0, 1);
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(TestVeh, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(TestVeh, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
	PutPlayerInVehicle(playerid, TestVeh, 0);
	return 1;
}

CMD:delveh(playerid) // TEST
{
	if(!IsValidVehicle(TestVeh)) return 1;
	DestroyVehicle(TestVeh);
	return 1;
}
/*
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}*/
