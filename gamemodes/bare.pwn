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

enum lobbyVariables
{
	lobby,
	rpnick[24],
	moder
}
new lv[MAX_PLAYERS][lobbyVariables];

#define MAX_DROPPED_WEAPON 100
enum weaponVariables
{
	id,
	weaponNum,
	Text3D: text3did,
	ammoCount
}
new droppedWeapon[MAX_DROPPED_WEAPON][weaponVariables];
new TOTAL_DROPPED_WEAPON = 0;

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

public OnPlayerSpawn(playerid)
{
	if(GetPVarInt(playerid, "ServerSpawn") != 1 || pi[playerid][logged] == false) return Kick(playerid);
	SetPVarInt(playerid, "ServerSpawn", 0);
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

public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "kicked", 0);
	GetPlayerName(playerid, pi[playerid][nick], 24);
	pi[playerid][logged] = false;
	pi[playerid][admin] = 0;

	GetPlayerName(playerid, lv[playerid][rpnick], 24);
	lv[playerid][lobby] = 0;
	lv[playerid][moder] = 0;

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

new TestVeh, TestObj, TestPturs, bool:fixMove, TestNujn;

forward furiousTimer();
public furiousTimer()
{
	new Float:vx,Float:vy,Float:vz, Float:tx, Float:ty, Float:tz; //Float:fa;
	//GetObjectPos(TestObj, x,y,z);
	GetVehiclePos(TestVeh, vx,vy,vz);
	if(TestNujn == 1) {
		GetObjectPos(TestPturs, tx,ty,tz);
		if(!(GetDistanceBetweenPoints(tx,ty,tz,vx,vy,vz) < 7)) {
			StopObject(TestPturs);
			MoveObject(TestPturs, vx, vy, vz, 5, 0,0, GetAngleBetweenPoints(tx,ty,vx,vy)-270);
		}
		else {
			DestroyObject(TestPturs);
			CreateExplosion(tx,ty,tz,2,5);
		}
	}
}

forward mainTimer();
public mainTimer()
{

	foreach(Player, i)
	{
		if(GetPVarInt(i, "kicked") < gettime() && GetPVarInt(i, "kicked") != 0) Kick(i);
		if(pi[i][logged] == false && GetPVarInt(i, "autoriseTimer") < gettime() && GetPVarInt(i, "autoriseTimer") != 0)
		{
			err(i, "Время на авторизацию вышло.");
			Kick(i);
		}
	}
}

CMD:test2(playerid, params[])
{

	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(gpvi(playerid, "rightArmHit") > 0 && GetPlayerWeapon(playerid) > 0) SetPlayerArmedWeapon(playerid, 0);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Untitled");

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

	for(new i; i < MAX_DROPPED_WEAPON; i++)
		droppedWeapon[i][id] = -1;
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
		if(strfind(line, "CreateDynamicObject") != -1)
		{
			strdel(line, strlen(line)-8, strlen(line));
			strdel(line, 0, 31);
			if (sscanf(line, "p<,>dffffffs[64]", oId, x,y,z,rx,ry,rz, trash) == 0)
				obj = CreateDynamicObject(oId, x,y,z, rx,ry,rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 300, 300);
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
	SetPlayerPos(playerid, x,y,z+5);
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
		if(droppedWeapon[i][id] == -1)
		{
			droppedWeapon[i][id] = CreateDynamicObject(weaponObject, x+floatsin(-fa,degrees)*0.5, y+floatcos(-fa,degrees)*0.5, z-0.95, 90, 0, fa+135);
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
	DestroyDynamicObject(droppedWeapon[index][id]);
	DestroyDynamic3DTextLabel(droppedWeapon[index][text3did]);
	ApplyAnimation(playerid, "WUZI", "WUZI_GRND_CHK", 4.1, false, true, true, false, 0, true);
	droppedWeapon[index][id] = -1;
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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (gpvi(playerid, "rightArmHit") == 0 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && newkeys & KEY_CTRL_BACK)
	{
		for(new i; i < MAX_DROPPED_WEAPON; i++)
		{
			new Float:x, Float:y, Float:z, Float:px, Float:py, Float:pz;
			GetPlayerPos(playerid, px, py, pz);
			GetDynamicObjectPos(droppedWeapon[i][id], x,y,z);
			if(GetDistanceBetweenPoints(px, py, pz, x,y,z) <= 1.5) 
			{
				if(GetWeaponInThatSlot(playerid, GetWeaponSlot(droppedWeapon[i][weaponNum])) != droppedWeapon[i][weaponNum] && GetWeaponInThatSlot(playerid, GetWeaponSlot(droppedWeapon[i][weaponNum])) != 0) return err(playerid, "У вас есть оружие подобного типа.");
				PickWeapon(playerid, i);
				break;
			}
		}
	}
	return 1;
}

CMD:test(playerid)
{
	GivePlayerWeapon(playerid, 24, 228);
	new i = 30+random(2);
	GivePlayerWeapon(playerid, i, 123);
	GivePlayerWeapon(playerid, 17, 5);
	GivePlayerWeapon(playerid, 1, 1);
	return 1;
}


CMD:test1(playerid)
{
	new Float:x, Float:y, Float:z, Float:fa;
	GetPlayerPos(playerid, x,y,z);
	GetPlayerFacingAngle(playerid, fa);
	TestObj = CreateObject(3285, x+floatsin(-fa,degrees)+0.010972, y+floatcos(-fa,degrees)+0.000656, z-0.51+0.114702, 0, 0, fa+280);
	CreateObject(3284, x+floatsin(-fa,degrees)*1, y+floatcos(-fa,degrees)*1, z-0.51, 0, 0, fa+280);

	return 1;
}

CMD:testfire(playerid)
{
	new Float:x, Float:y, Float:z, Float:rZ, Float:rX, Float:rY, Float:vX, Float:vY, Float:vZ;
	GetVehiclePos(TestVeh, vX, vY, vZ);
	GetObjectPos(TestObj, x,y,z);
	GetObjectRot(TestObj, rX, rY, rZ);
	TestPturs = CreateObject(3790, x+0.152819, y+0.887239, z+0.153364, rX, rY, GetAngleBetweenPoints(x,y,vX,vY)-270);
	ApplyAnimation(playerid, "BSKTBALL", "BBALL_IDLELOOP", 2.0, false, false, false, false, 0, true); // popravilPtur
	TestNujn = 1;
}

CMD:testptur(playerid)
{
	new Float:x, Float:y, Float:z, Float:rZ, Float:rY, Float:rX, Float:nX, Float:nY, Float:vX, Float:vY, Float:vZ, Float:fa, Float:angFront, Float:angTank, Float:dist;
	new minDistCar = -1, Float:minDist = 9999.0;
	GetObjectPos(TestObj, x,y,z);
	GetObjectRot(TestObj, rX, rY, rZ);
	foreach (new vehicleid : Vehicle) {
		GetVehiclePos(vehicleid, vX,vY,vZ);
		if(GetDistanceBetweenPoints(x,y,z,vX,vY,vZ) > 100) continue;
		fa = -rZ-90;
		nX = x+floatsin(-fa,degrees)*-1.4;
		nY = y+floatcos(-fa,degrees)*1.5;
		angFront = (GetAngleBetweenPoints(x,y,nX,nY) < 0) ? (GetAngleBetweenPoints(x,y,nX,nY)+360) : (GetAngleBetweenPoints(x,y,nX,nY));
		angTank =  (GetAngleBetweenPoints(x,y,vX,vY) < 0) ? (GetAngleBetweenPoints(x,y,vX,vY)+360) : (GetAngleBetweenPoints(x,y,vX,vY));
		dist = angTank-angFront;
		if(dist < minDist && dist < 20 && dist > -20) { minDistCar = vehicleid; minDist = dist; }
	}
	if(minDistCar == -1) return err(playerid, "ПТУР не навёлся ни на одно близлежайщее транспортное средство.");
	f(str, "ПТУР навёлся на Rhino %s[%d].", VehicleNames[GetVehicleModel(minDistCar)-400], minDistCar);
	suc(playerid, str);
	MoveObject(TestObj, (fixMove == true) ? (x+0.001) : (x-0.001),y,z, 0.01, 0.0, 0.0, GetAngleBetweenPoints(x,y,vX,vY));
	if(fixMove == true) fixMove = true; 
		else fixMove = false;
	return 1;
}

public OnObjectMoved(objectid)
{
	
	return 1;
}

CMD:veh(playerid)
{
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	TestVeh = CreateVehicle(432, x,y,z, 0, 1, 0, 1);
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(TestVeh, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(TestVeh, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
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
