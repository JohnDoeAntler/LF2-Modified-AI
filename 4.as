#include "include/person.as";
#include "include/item.as";
#include "include/attack.as";
#include "include/object.as";

// AI decsion references: https://www.lf-empire.de/forum/showthread.php?tid=8085
// OOP references: https://www.lf-empire.de/forum/showthread.php?tid=10502

void id()
{
	clr();
	// initialization
    A(0,0);
    D(0,0);
    J(0,0);
    up(0,0);
    down(0,0);
    left(0,0);
    right(0,0);
	
	person me = person(true);
	
	person@ competitor 	= null;
	person@ teammate 	= null;
	attack@ ball		= null;
	item@ weapon		= null;
	item@ drink			= null;
	
	array<person> 		enemies;
	array<person> 		teammates;
	array<attack> 		attacks;
	array<item> 		weapons;
	array<item> 		drinks;
	
	for(int i=0; i<400; i++){
		if(loadTarget(i) != -1 && target.num != self.num )
		{
			float dx = (self.facing ? self.x - target.x : target.x - self.x);
			// enemy detection
			if(target.type == 0){
				if(target.team != self.team)
				{
					enemies.insertLast(person(false));
					if(@competitor == null || (competitor.state == 14 && target.state != 14) || (competitor.absDx() > abs(dx) && target.state != 14)) @competitor = enemies[enemies.length()-1];
				}
			}
			
			// attack detection
			if(target.type == 3){
				if(target.team != self.team)
				{
					attacks.insertLast(attack());
					if(@ball == null || (ball.absDx() > abs(dx))) @ball = attacks[attacks.length()-1];
				}
			}
			
			// weapon detection
			if(target.type == 1){
				weapons.insertLast(item());
				if(@weapon == null || (weapon.absDx() > abs(dx))) @weapon = weapons[weapons.length()-1];
			}
			
			// drink detection
			if(target.type == 6){
				drinks.insertLast(item());
				if(@drink == null || (drink.absDx() > abs(dx))) @drink = drinks[drinks.length()-1];
			}
		}
	}
	
	if (enemies.length == 0 && mode == 1)
	{
		right();
	}
	
	float cx = competitor.absDx() + (xpos(me, competitor) ? competitor.vx : -1.0 * competitor.vx);
	float cy = competitor.absDy() + competitor.vy;
	float cz = competitor.absDz() + (zpos(me, competitor) ? competitor.vx : -1.0 * competitor.vx);
	
	// run attack > escape > normal attack > dash attack
	
	if ((me.frame >= 60 && me.frame <= 69) || (me.frame >= 80 && me.frame <= 84))
	{
		if (cz > 10){
			if (zpos(me, competitor))
			{
				down(1,1);
			}else
			{
				up(1,1);
			}
		}
	}
	
	if (self.frame == 214){
		if (cx < 60 || competitor.isDashing()) A();
	}
	
	print("hp: " + self.hp + "\r\ncx: " + cx + "\r\ncz: " + cz + "\r\n");
	
	int attackrange 			= 465;
	int xattackrange 			= 120;
	int attackrangez			= 50;
	int attackrangezwidth		= 12;
	
	int dashattackrange			= 225;
	int xdashattackrange		= 50;
	int dashattackrangez		= 50;
	int dashattackrangezwidth	= 20;
	
	int runattackrange			= 120;
	int xrunattackrange			= 57;
	int runattackrangez			= 15;
	int runattackrangezwidth	= 0;
	
	// attack recognition
	
	if (ball != null)
	{
		if (ball.absDx() + (xpos(me, ball) ? ball.vx : -1.0 * ball.vx) < 120 && ball.absDz() + ball.vz < 20 && xfac(ball, me))
		{
			print("defending ball\r\n");
			D();
			trace(me, ball);
		}
	}
	
	if (weapon != null)
	{
		if (weapon.absDx() + (xpos(me, weapon) ? weapon.vx : -1.0 * weapon.vx) < 120 && weapon.absDz() + weapon.vz < 10 && xfac(weapon, me) && weapon.isAttacking())
		{
			print("defending weapon\r\nabs: " + weapon.absDx() + "\r\nvx: " + (xpos(me, weapon) ? weapon.vx : -1.0 * weapon.vx) + "\r\nframe: " + weapon.frame + "\r\nisAttacking: " + (weapon.isAttacking() ? "t" : "f") + "\r\n1: " + (weapon.state == 1001 ? "t" : "f") + "\r\n2: " + (weapon.state == 1002 ? "t" : "f") + "\r\nid: " + weapon.id);
			
			D();
			trace(me, weapon);
		}
	}

	// enemy recognition
	
	if(competitor.blink == 0 && competitor.state != 14 && competitor.id < 100)
	{
		if (competitor.isInjuring() && cx < 200 && cz < 40 && enemies.length == 1)
		{
			if (cx < 50)
			{
				if (me.isRunning())
				{
					if(me.facing == 1) left();
					else right();
				}else
				{
					trace(me, competitor, true);
				}
			}else
			{
				trace(me, competitor);
				if (abs(cx - 260) < cx && abs(cz - 45) < cz && me.isRunning())
				{
					J();
					trace(me, competitor);
				}
			}
		}else if (me.isStanding() || me.isWalking())
		{
			print("standing or walking\r\n");
			
			if (competitor.isDashing() && xfac(competitor, me) && cx < 120 && cz < 20)
			{
				// defending
				print("defending dash");
				D();
				trace(me, competitor, true);
			}else if (inrange(attackrange, xattackrange, attackrangez, attackrangezwidth, cx, cz) 	// competitor in attack range
				&& me.holding == -1 																// not holding weapon
				&& !((competitor.isInjuring() && cx < 200 && cz < 35)) 								// not in catch range
				&& !(competitor.id == 9 && competitor.frame >= 280 && competitor.frame <= 287)		// competitor(dennis) is not doing c_foot
				&& !(competitor.id == 7 && competitor.frame >= 255 && competitor.frame <= 261))		// competitor(firen) is not doing burn_run
			{
				// normal attack
				if (xfac(me, competitor)) A();
				else trace(me, competitor);
			}else if (cx < runattackrange && cx > xrunattackrange && cz < runattackrangez && xfac(me, competitor))
			{
				// run attack
				trace(me, competitor);
			}else if(cx < dashattackrange && cz < dashattackrangez)
			{
				// dash attack
				trace(me, competitor);
			}else if (me.holding != -1)
			{
				// throw weapon
				trace(me, competitor, true);
				J();
			}else if (cx < 150 && cz < 50 && self.mp > 350 && enemies.length == 1)
			{
				DuJ();
			}else if (cx > 250 && cz < 15 && self.mp > 150 && enemies.length == 1)
			{
				if (xpos(me, competitor)) DrA();
				else DlA();
			}else
			{
				// walk close from competitor
				if (me.x < 50)
				{
					right();
				}else if (me.x > bg_width - 50)
				{
					left();
				}else{
					trace(me, competitor, true);
				}
			}
		}else if (me.isRunning())
		{
			print("running\r\n");
			
			if (cx < 120 && cz < 20 && competitor.isDashing())
			{
				D();
			}else if (cx < runattackrange && cx > xrunattackrange && cz < runattackrangez && xfac(me, competitor))
			{
				print ("run attack");
				A();
			}else if(cx < dashattackrange && cz < dashattackrangez && !competitor.isDashing() && !competitor.isRunning())
			{
				print ("dash");
				trace(me, competitor);
				
				J();
			}else
			{
				print ("nothing");
				if (zpos(me, competitor)) down(1,1);
				else up(1,1);
				J();
			}
		}else if (me.isDashing())
		{
			print("dashing\r\n");
			if(inrange(dashattackrange, xdashattackrange, dashattackrangez, dashattackrangezwidth, cx, cz) && xfac(me, competitor))
			{
				if (cx < 80)
				A();
			}else if (cx < dashattackrange && cz < dashattackrangez && self.mp > 12)
			{
				if (me.facing == 1) left();
				else right();
			}
		}else if (me.isAttacking())
		{
			print("attacking\r\n");
			if (competitor.isDashing() && xfac(competitor, me) && cx < 100 && cz < 20)
			{
				print("defending dash");
				D();
			}
		}else if (me.isJumping()) 
		{
			if (me.holding != -1)
			{
				trace(me, competitor, true);
				A();
			}else if (cx > 40 && cx < 150)
			{
				// jump attack
				trace(me, competitor);
				A();
			}
		}else if (me.frame >= 80 && me.frame <= 84)
		{
			print("frame 1\r\n");
		}else if (me.isCatching())
		{
			print (self.ctimer + "\r\n");
			if (self.ctimer > 60) A();
			else 
			{
				if (xpos(me, competitor)) right(1,1);
				else left(1,1);
				A();
				if (xpos(me, competitor)) DrA();
				else DlA();
			}
		}
	}else 
	{
		// walk off to get a comfortable distance
		if (xpos(me, competitor)) left();
		else right();
		if (me.z < bg_zwidth1 + 20)
		{
			down();
		}else if (me.z > bg_zwidth2 - 20)
		{
			up();
		}else if (cz > 60)
		{
			if (zpos(me, competitor)) down(1,1);
			else up(1,1);
		}else {
			if (zpos(me, competitor)) up();
			else down();
		}
	}
}

bool xpos(object o1, object o2)
{
	return o1.dx < o2.dx;
}

bool zpos(object o1, object o2)
{
	return o1.dz < o2.dz;
}

bool xfac(object o1, object o2){
	return o1.facing == 1 == xpos(o1, o2);
}

bool inrange(int range, int xrange, int rangez, int zwidth, float cx, float cz)
{
	float result = float(cx * rangez) / range;
	
	return cx < range 
		&& cx > xrange
		&& cz < rangez
		&& (cz < zwidth
			|| (cz < result + zwidth 
			&& cz > result - zwidth));
}

void trace(object me, object competitor, bool isWalk = false)
{
	if (competitor.absDx() + (xpos(me, competitor) ? competitor.vx : -1.0 * competitor.vx) > 5)
	{
		if (isWalk)
		{
			if (xpos(me, competitor)) right(1,1);
			else left(1,1);
		}else
		{
			if (xpos(me, competitor)) right();
			else left();
		}
	}else
	{
		if (isWalk)
		{
			if (me.facing == 1) right(1,1);
			else left(1,1);
		}else
		{
			if (me.x < 5)
			{
				right();
			}else if (me.x > bg_width - 5)
			{
				left();
			}else if (me.facing == 1) right();
			else left();
		}
	}
	
	if (zpos(me, competitor)) down(1,1);
	else up(1,1);
}