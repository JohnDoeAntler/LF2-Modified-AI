#include "object.as";

class person : object
{
	int blink;
	int team;
	int holding;
	int armor;
	/*
	int id;
	int frame;
	int state;
	int facing;
	float x;
	float y;
	float z;
	float dx;
	float dy;
	float dz;
	float vx;
	float vy;
	float vz;
	*/
   
	person(){dx=0;dy=0;dz=0;}
   
	person(bool d)
	{
		if(d)
		{
			blink = self.blink;
			id = self.id;
			team = self.team;
			frame = self.frame;
			state = self.state;
			facing = self.facing ? -1 : 1;
			x = self.x;
			y = self.y;
			z = self.z;
			dx = 0;
			dy = 0;
			dz = 0;
			vx = self.x_velocity;
			vy = self.y_velocity;
			vz = self.z_velocity;
			holding = (self.weapon_held != -1 ? self.weapon_type : -1);
		}
		else
		{
			blink = target.blink;
			id = target.id;
			team = target.team;
			frame = target.frame;
			state = target.state;
			facing = target.facing ? -1 : 1;
			x = target.x;
			y = target.y;
			z = target.z;
			dx = target.x - self.x;
			dy = target.y - self.y;
			dz = target.z - self.z;
			vx = target.x_velocity;
			vy = target.y_velocity;
			vz = target.z_velocity;
			holding = (target.weapon_held != -1 ? target.weapon_type : -1);
		}
	}
   
	float absDx(){
		return abs(dx);
	}

	float absDy(){
		return abs(dy);
	}

	float absDz(){
		return abs(dz);
	}
	
	bool isStanding()			{return state == 0;}
	bool isWalking()			{return state == 1;}
	bool isRunning()			{return state == 2;}
	bool isAttacking()			{return state == 3;}
	bool isJumping()			{return state == 4;}
	bool isDashing()			{return state == 5 || (frame >= 90 && frame <= 98);}
	bool isRowing()				{return state == 6;}
	bool isDefending()			{return state == 7;}
	bool isBrokenDefend()		{return state == 8;}
	bool isCatching()			{return state == 9;}
	bool isCaughting()			{return state == 10;}
	bool isInjuring()			{return state == 11 || state == 16;}
	bool isFalling()			{return state == 12;}
	bool isFrozen()				{return state == 13;}
	bool isLying()				{return state == 14;}
	bool isDrinking()			{return state == 17;}
	bool isOnFire()				{return state == 18;}
	bool isSkilling()			{return frame > 234;}
	bool idsVulnerableFalling()	{return frame != 184 && frame != 195 && frame != 190 && frame != 191;}
};