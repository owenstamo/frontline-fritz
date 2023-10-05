// Initialize

key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
key_shift = keyboard_check(vk_lshift);
key_jump = keyboard_check(vk_space);

reach_speed = move_speed;

// Sprint

if (key_shift) reach_speed = sprint_speed;

// Calculate Target Speed

var move = key_right - key_left;
reach_speed *= move;

// Calculate Movement/Acceleration

accelerateBy = move * acceleration;
decelerateBy = -sign(hsp) * deceleration;

accelerating = (abs(hsp) < abs(reach_speed));
decelerating = (abs(hsp) > abs(reach_speed));

if (accelerating)
{
	if (abs(hsp) + abs(accelerateBy) > abs(reach_speed))
	{
		hsp = reach_speed;
	}
	else
	{
		hsp += accelerateBy;
	}
} 
else if (decelerating) 
{
	if (abs(hsp) - abs(decelerateBy) < abs(reach_speed))
	{
		hsp = reach_speed;
	}
	else
	{
	hsp += decelerateBy;
	}
}
else
{
	hsp = reach_speed;
}

vsp += object_gravity;

// Jump

if (key_jump && place_meeting(x, y+1, oGround))
{
	vsp = -jump_power;
} 

// Collision

if (place_meeting(x+hsp, y, oGround))
{
	while (!place_meeting(x+sign(hsp), y, oGround)) 
	{
		x += sign(hsp);
	}
	hsp = 0;
}

if (place_meeting(x, y+vsp, oGround))
{
	while (!place_meeting(x, y+sign(vsp), oGround)) 
	{
		y += sign(vsp);
	}
	vsp = 0;
}

// Sprite Animation

if (hsp != 0)
{
	sprite_index = sprPlayerW;
	image_speed = walk_imagespeed * (hsp / move_speed);
	if (abs(hsp) > move_speed)
	{
		sprite_index = sprPlayerR;
		image_speed = run_imagespeed * (hsp / move_speed);
	}
	image_xscale = abs(image_xscale) * sign(hsp);
}
else if (!key_right && !key_left)
{
	sprite_index = sprPlayer;
	image_speed = sit_imagespeed;
}

// Move

x += hsp;
y += vsp;