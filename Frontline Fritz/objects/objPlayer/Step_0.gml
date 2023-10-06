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

accelerate_by = move * acceleration;
decelerate_by = -sign(hsp) * deceleration;

accelerating = (abs(hsp) < abs(reach_speed));
decelerating = (abs(hsp) > abs(reach_speed));

if (accelerating)
{
	if (abs(hsp) + abs(accelerate_by) > abs(reach_speed))
	{
		hsp = reach_speed;
	}
	else
	{
		hsp += accelerate_by;
	}
} 
else if (decelerating) 
{
	if (abs(hsp) - abs(decelerate_by) < abs(reach_speed))
	{
		hsp = reach_speed;
	}
	else
	{
	hsp += decelerate_by;
	}
}
else
{
	hsp = reach_speed;
}

vsp += object_gravity;

// Jump

if (key_jump && place_meeting(x, y+1, objGround))
{
	vsp = -jump_power;
	jumping = true;
	image_index = 0;
} 

// Collision

if (place_meeting(x+hsp, y, objGround))
{
	while (!place_meeting(x+sign(hsp), y, objGround)) 
	{
		x += sign(hsp);
	}
	hsp = 0;
}

if (place_meeting(x, y+vsp, objGround))
{
	while (!place_meeting(x, y+sign(vsp), objGround)) 
	{
		y += sign(vsp);
	}
	vsp = 0;
	jumping = false;
}

// Sprite Animation

jump_last_index = sprite_get_number(sprPlayerJump) - 1;

if jumping 
{
	sprite_index = sprPlayerJump;
	image_speed = jump_imagespeed;
	if (floor(image_index) == jump_last_index)
	{
		image_index = jump_last_index;
	}
}
else if (hsp != 0)
{
	sprite_index = sprPlayerWalk;
	image_speed = walk_imagespeed * (hsp / move_speed);
	if (abs(hsp) > move_speed)
	{
		sprite_index = sprPlayerRun;
		image_speed = run_imagespeed * (hsp / move_speed);
	}
}
else if (!key_right && !key_left)
{
	sprite_index = sprPlayerIdle;
	image_speed = sit_imagespeed;
}

if sign(hsp) != 0
{
	image_xscale = abs(image_xscale) * sign(hsp);
}

// Move

x += hsp;
y += vsp;