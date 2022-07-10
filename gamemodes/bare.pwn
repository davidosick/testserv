#include <a_samp>
#include <core>
#include <float>
#include <Pawn.CMD>
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>

#define scm SendClientMessage



#pragma tabsize 0

main()
{
	print("\n----------------------------------");
	print("  Bare Script MYEDIT 2\n");
	print("----------------------------------\n");
}

new art = -1, shot, shotDist, Float:shotDist0, Float:z0;
new str[144];

public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);
	return 1;
}

CMD:test(playerid, params[])
{
	sscanf(params, "d", params[0]);
	format(str, 144, "%f",z0+((-shotDist*shotDist+shotDist0*shotDist)/params[0]));
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	SetPlayerPos(0, x,y,z0+((-shotDist*shotDist+shotDist0*shotDist)/params[0]));
	scm(0, -1, str);
}

CMD:art(playerid)
{
	if(art != -1) return SendClientMessage(playerid, -1, "јрта уже есть");
	new Float:x,Float:y,Float:z,Float:fa;
	GetPlayerFacingAngle(playerid,fa);
	GetPlayerPos(playerid, x,y,z);
	CreateObject(2063, x,y,z,  0, 0, fa);
	art = CreateObject(2064, x,y,z,  0, 25, fa);
	shot = CreateObject(2065, x,y,z,  0, 25, fa);
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
	new Float:dist,  Float:x, Float:y, Float:z, Float:ry, Float:rx, Float:rz;
	new Float:B, A, Float:REALROT, speed;
	GetObjectRot(art, rx, ry, rz);
	GetObjectPos(art, x, y, z);
	rz = rz+90;

	//                       60   10
	if(sscanf(params, "dd", speed, A)) return SendClientMessage(playerid, -1, "speed G");

	REALROT = -(ry-25);
	format(str, 144, "REALROT %f", REALROT);
	scm(playerid, -1, str);
	B = floattan(REALROT, degrees) * 2 * speed * speed * floatcos(REALROT, degrees) * floatcos(REALROT, degrees);
	format(str, 144, "B %f", B);
	scm(playerid, -1, str);
	dist = -((-B-B)/2*A)/100;
	format(str, 144, "dist %f", dist);
	scm(playerid, -1, str);

	shotDist = 0;
	shotDist0 = dist;
	z0 = z;
	MoveObject(shot, x-floatsin(-rz,degrees)*3, y-floatcos(-rz,degrees)*3, z+(REALROT/20), 100);

	//CreateExplosion(x-floatsin(-rz,degrees)*dist,y-floatcos(-rz,degrees)*dist,z, 0, 1);
	return 1;
}

public OnObjectMoved(objectid)
{
	if(objectid == shot)
	{
		shotDist++;
		new Float:x, Float:y, Float:z, Float:ry, Float:rx, Float:rz;
		GetObjectRot(shot, rx, ry, rz);
		GetObjectPos(shot, x, y, z);
		if(shotDist >= shotDist0)
		{
			CreateExplosion(x,y,z, 0, 1);
			DestroyObject(shot);
			return 1;
		}
		MoveObject(shot, x-floatsin(-rz,degrees)*shotDist, y-floatcos(-rz,degrees)*shotDist, z0+((-shotDist*shotDist+shotDist0*shotDist)/40), 3);
		SetPlayerPos(0, x-floatsin(-rz,degrees)*shotDist, y-floatcos(-rz,degrees)*shotDist, z0+((-shotDist*shotDist+shotDist0*shotDist)/40));
	}
	return 1;
}

CMD:veh(playerid, params[])
{
	sscanf(params, "d", params[0]);
	new Float:x,Float:y,Float:z,Float:fa;
	GetPlayerFacingAngle(playerid,fa);
	GetPlayerPos(playerid, x,y,z);
	return CreateVehicle(params[0], x, y, z, fa, 0, 0, 0);
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
