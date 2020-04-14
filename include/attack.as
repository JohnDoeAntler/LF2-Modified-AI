#include "object.as";

class attack : object
{
	int team;
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
   
	attack(){dx=0;dy=0;dz=0;}
   
	attack()
	{
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
};