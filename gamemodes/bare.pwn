#include <a_samp>
#include <core>
#include <float>
#include <Pawn.CMD>
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>

#pragma tabsize 0

main()
{
	print("\n----------------------------------");
	print("  Bare Script MYEDIT 2\n");
	print("----------------------------------\n");
}

new art = -1;

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

CMD:test(playerid)
{
	if(art != -1) return SendClientMessage(playerid, -1, "Арта уже есть");
	new Float:x,Float:y,Float:z,Float:fa;
	GetPlayerFacingAngle(playerid,fa);
	GetPlayerPos(playerid, x,y,z);
	art = CreateObject(2064, x,y,z,  0, 0, fa);
	return 1;
}

CMD:deltest(playerid)
{
	DestroyObject(art);
	art = -1;
	return 1;
}

CMD:fire(playerid, params[])
{
	new Float:mnCos, Float:mnSin,  Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
	GetObjectRot(art, rx, ry, rz);
	GetObjectPos(art, x, y, z);
	if(sscanf(params, "ff", mnCos, mnSin)) return SendClientMessage(playerid, -1, "Неверный ввод");
	CreateExplosion(x+floatsin(rx)*mnSin,y+floatcos(ry)*mnCos,z, 0, 1);
	return 1;
}

CMD:rot(playerid, params[])
{
	new Float:rotate;
	sscanf(params, "f", rotate);
	SetObjectRot(art, 0,0,rotate);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

	return 0;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	TogglePlayerClock(playerid,0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("Bare Script");
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);

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
