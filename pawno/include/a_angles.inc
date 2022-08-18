// a_angles.inc
// Angle functions
// Created by:
// Tannz0rz

#if defined _a_angles_included
  #endinput
#endif
#define _a_angles_included

#include <a_samp>

stock IsPlayerBehindPlayer(playerid, targetid, Float:dOffset)
{

	new
	    Float:pa,
	    Float:ta;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
	
	GetPlayerFacingAngle(playerid, pa);
	GetPlayerFacingAngle(targetid, ta);
	
	if(AngleInRangeOfAngle(pa, ta, dOffset) && IsPlayerFacingPlayer(playerid, targetid, dOffset)) return true;

	return false;

}

stock Float:GetXAngleBetweenPoints(Float:x, Float:y, Float:z, Float:vX, Float:vY, Float:vZ, Float:rz)
{
	new Float:vec1X, Float:vec1Y, Float:vec1Z;
	new Float:vec2X, Float:vec2Y, Float:vec2Z;
	new Float:angX;
	new Float:nX, Float:nY, Float:nZ;
	nX = x+floatsin(-rz,degrees);
	nY = y+floatcos(-rz,degrees);
	//nZ = z;
	
	vec1X = nX-x; vec1Y = nY-y; vec1Z = nZ-z;
	vec2X = vX-x; vec2Y = vY-y; vec2Z = vZ-z;

	angX = asin( floatabs(vec1X*vec2X + vec1Y*vec2Y + vec1Z*vec2Z) / (floatsqroot(vec1X*vec1X + vec1Y*vec1Y + vec1Z*vec1Z) * floatsqroot(vec2X*vec2X + vec2Y*vec2Y + vec2Z*vec2Z)));
	return angX;
}

stock Float:GetAngleBetweenPoints(Float:x, Float:y, Float:pX, Float:pY)
{

	new Float:ang, Float:bX, Float:bY, Float:nX, Float:nY; 


	/*if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);*/

	bX = x-pX; bY = y-pY;
	nX = 0; nY = 1;
	//printf("%f %f %f %f", bX, bY, (bX*nX+bY*nY), (floatsqroot(bX*bX+bY*bY)*floatsqroot(nX*nX+nY*nY)));
	ang = (asin((bX*nX+bY*nY)/(floatsqroot(bX*bX+bY*bY)*floatsqroot(nX*nX+nY*nY))));
	if(bX < 0) ang = (acos((bX*nX+bY*nY)/(floatsqroot(bX*bX+bY*bY)*floatsqroot(nX*nX+nY*nY)))+90);

	//ang = -(acos((x*pX+y*pY)/(floatsqroot(x*x+y*y)*floatsqroot(pX*pX+pY*pY))));
	
 	return ang;

}

stock SetPlayerToFacePlayer(playerid, targetid)
{

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, X, Y, Z);
	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	
	SetPlayerFacingAngle(playerid, ang);

 	return 0;

}

stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(AngleInRangeOfAngle(-ang, pA, dOffset)) return true;

	return false;

}

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{

	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;

	return false;

}
