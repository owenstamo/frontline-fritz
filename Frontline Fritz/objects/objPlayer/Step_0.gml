#region Get keys down

var _key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
var _key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
var _key_shift = keyboard_check(vk_lshift);
var _key_jump = keyboard_check(vk_space);

#endregion

#region Calculate Target Speed

var _reach_speed = move_speed;

if (_key_shift) _reach_speed = sprint_speed;

var _move = _key_right - _key_left;
_reach_speed *= _move;

#endregion

#region Calculate Movement/Acceleration

var _accelerate_by = _move * acceleration;
var _decelerate_by = -sign(hsp) * deceleration;

var _accelerating = (abs(hsp) < abs(_reach_speed));
var _decelerating = (abs(hsp) > abs(_reach_speed));

if (_accelerating)
{
	if (abs(hsp) + abs(_accelerate_by) > abs(_reach_speed))
	{
		hsp = _reach_speed;
	}
	else
	{
		hsp += _accelerate_by;
	}
} 
else if (_decelerating) 
{
	if (abs(hsp) - abs(_decelerate_by) < abs(_reach_speed))
	{
		hsp = _reach_speed;
	}
	else
	{
	hsp += _decelerate_by;
	}
}
else
{
	hsp = _reach_speed;
}

vsp += object_gravity;
if (vsp > 2 * object_gravity || vsp < 0) {
	grounded = false;
}

#endregion

#region Jump

if (_key_jump && place_meeting(x, y+1, objGround))
{
	vsp = -jump_power;
	image_index = 0;
} 

#endregion

#region Collision

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
	
	if (vsp > 0) {
		grounded = true;
	}
	
	vsp = 0;
}

#endregion

#region Sprite Animation	

if (!grounded)
{
	if (vsp < -2) {
		sprite_index = sprPlayerJumpAscending;
	} else if (vsp > 8) {
		sprite_index = sprPlayerJumpDescending;
	} else {
		sprite_index = sprPlayerJumpPeak;
	}
}
else if (hsp != 0 || _key_left || _key_right)
{
	var _min_image_speed = 1;
	sprite_index  = sprPlayerWalk;
	image_speed = max(abs(walk_imagespeed * (hsp / move_speed)), _min_image_speed);
	if (_key_shift)
	{
		sprite_index = sprPlayerRun;
		image_speed = max(abs(run_imagespeed * (hsp / move_speed)), _min_image_speed);
	}
}
else
{
	sprite_index = sprPlayerIdle;
	image_speed = sit_imagespeed;
}

if (sign(hsp)) != 0
{
	image_xscale = abs(image_xscale) * sign(hsp);
}

#endregion

#region Move

x += hsp;
y += vsp;

#endregion