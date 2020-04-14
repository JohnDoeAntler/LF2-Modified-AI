class object
{
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