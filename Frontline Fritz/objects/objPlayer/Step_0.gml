#region Get keys down

var _key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
var _key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
var _key_shift = keyboard_check(vk_lshift);
var _key_jump = keyboard_check(vk_space);
var _key_crouch = keyboard_check_pressed(ord("C"));

#endregion

#region Calculate Target Speed

var _reach_speed = move_speed;

if (_key_shift) _reach_speed = sprint_speed;

var _move = _key_right - _key_left;
_reach_speed *= _move;

#endregion

#region Crouch

if (_key_crouch) {
	crouching = !crouching;
}

if (crouching) {
	_reach_speed /= 2;
}

#endregion

#region Calculate Movement/Acceleration

var _accelerate_by = _move * acceleration;
var _decelerate_by = -sign(phy_speed_x) * deceleration;

var _accelerating = (abs(phy_speed_x) < abs(_reach_speed));
var _decelerating = (abs(phy_speed_x) > abs(_reach_speed));

if (_accelerating)
{
	if (abs(phy_speed_x) + abs(_accelerate_by) > abs(_reach_speed))
	{
		phy_speed_x = _reach_speed;
	}
	else
	{
		phy_speed_x += _accelerate_by;
	}
} 
else if (_decelerating) 
{
	if (abs(phy_speed_x) - abs(_decelerate_by) < abs(_reach_speed))
	{
		phy_speed_x = _reach_speed;
	}
	else
	{
	phy_speed_x += _decelerate_by;
	}
}
else
{
	phy_speed_x = _reach_speed;
}

if (phy_speed_y != 0)
	grounded = false;

#endregion

#region Jump

// For some reason, if the player is against the wall, place_meeting returns true (but not for the ground??), 
// so adding 1 to the x value ensures it doesn't return true when against the left wall, and vise versa for the right. 
// Thus, when combining these, the player must be against the left *and* right wall (which is mostly impossible) for this problem to occur
if (place_meeting(x + 1, y + 1, objAllCollidable) && place_meeting(x - 1, y + 1, objAllCollidable))
	grounded = true;

if (_key_jump && grounded)
{
	phy_speed_y = -jump_power;
	grounded = false;
}

#endregion

#region Collision (no longer in use)
/*
if (place_meeting(x+phy_speed_x, y, objGround))
{
	while (!place_meeting(x+sign(phy_speed_x), y, objGround)) 
	{
		x += sign(phy_speed_x);
	}
	phy_speed_x = 0;
}

if (place_meeting(x, y+phy_speed_y, objGround))
{
	while (!place_meeting(x, y+sign(phy_speed_y), objGround)) 
	{
		y += sign(phy_speed_y);
	}
	
	if (phy_speed_y > 0) {
		grounded = true;
	}
	
	phy_speed_y = 0;
}
*/
#endregion

#region Stairs ###(fix)###

if (place_meeting(x + hsp, y, objAllCollidable))
{
	var instance = instance_place(x + hsp, y, objAllCollidable);
	
	if (instance)
	{
		show_debug_message("instance exists")
	}
	
	if (collision_point(instance.x, instance.y - 20, objAllCollidable, false, true) == noone)
	{
		y = instance.y - (instance.sprite_height / 2);
	}
}

#endregion

#region Sprite Animation	

if (!grounded)
{
	if (phy_speed_y < -4.5)	
		sprite_index = sprPlayerJumpAscending;
	else if (phy_speed_y > 6)
		sprite_index = sprPlayerJumpDescending;
	else
		sprite_index = sprPlayerJumpPeak;
}
else if (phy_speed_x != 0 || _key_left || _key_right)
{
	var _min_image_speed = 1;
	sprite_index  = sprPlayerWalk;
	image_speed = max(abs(walk_imagespeed * (phy_speed_x / move_speed)), _min_image_speed);
	if (_key_shift && !crouching)
	{
		sprite_index = sprPlayerRun;
		image_speed = max(abs(run_imagespeed * (phy_speed_x / move_speed)), _min_image_speed);
	}
}
else
{
	sprite_index = sprPlayerIdle;
	image_speed = sit_imagespeed;
}

if (sign(phy_speed_x)) != 0
{
	image_xscale = abs(image_xscale) * sign(phy_speed_x);
}

#endregion