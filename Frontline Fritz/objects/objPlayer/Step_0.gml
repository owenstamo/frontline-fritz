#region Get keys down

var _key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
var _key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
var _key_shift = keyboard_check(vk_lshift);
var _key_jump = keyboard_check(vk_space);
var _key_crouch = keyboard_check_pressed(ord("C"));

#endregion

#region Calculate Target Speed

var _target_speed = move_speed;

// Walk/move speed midair is different so jumping feels more like a leap than just levitating,
// and because going from sprint to walk while midair was such a large and fast change that it was a bit jarring and unrealistic
if (!grounded) _target_speed = move_speed_midair;

if (_key_shift) _target_speed = sprint_speed;

var _target_direction = _key_right - _key_left

var _target_velocity = _target_direction * _target_speed;

#endregion

#region Crouch

if (_key_crouch) {
	crouching = !crouching;
}

if (crouching) {
    if (_key_crouch) {
		// This doesn't work, but I'm keeping it in case it does in the future
        physics_remove_fixture(self, currently_bound_fix);
        currently_bound_fix = physics_fixture_bind(crouch_fix, self);
    }
    _target_velocity /= 2;
}
else if (!crouching && _key_crouch) {
	// Same for this
    physics_remove_fixture(self, currently_bound_fix);
    currently_bound_fix = physics_fixture_bind(default_fix, self);
}

#endregion

#region Check grounded

if (place_meeting(x, y + 1, objImpassableObjectParent))
	grounded = true;
	
if (phy_speed_y != 0)
	grounded = false;

#endregion

#region Calculate Movement/Acceleration

var _previous_x_speed = phy_speed_x;

var _accelerating = (phy_speed_x < _target_velocity && phy_speed_x >= 0) ||
                    (_target_velocity < phy_speed_x && phy_speed_x <= 0)

var _decelerating = (_target_velocity < phy_speed_x && phy_speed_x > 0) ||
                    (phy_speed_x < _target_velocity && phy_speed_x < 0)
				
if (!grounded && _target_direction == 0) {
	phy_speed_x -= midair_speed_decay * sign(phy_speed_x);
} else {
	if (_accelerating) {
		phy_speed_x += acceleration_magnitude * sign(_target_velocity - phy_speed_x);
	} 
	if (_decelerating) {
		var _deceleration_magnitude = grounded ? deceleration_magnitude : deceleration_magnitude_midair;
		phy_speed_x += _deceleration_magnitude * sign(_target_velocity - phy_speed_x);
	}
}

// If the speed passed the target velocity, set it to the target velocity
if (sign(_previous_x_speed - _target_velocity) != sign(phy_speed_x - _target_velocity)) {
	phy_speed_x = _target_velocity;
}

/*
// Clamp the magnitude of friction acceleration to be at most the x velocity, so that it doesn't overshoot and increase/decrease speed past zero
var _accel_from_friction = min(abs(friction_acceleration), abs(phy_speed_x));

//Clamp the magnitude of walking acceleration so that it--summed with the friction accel.--won't cause the speed to exceed the target speed (but don't let it go below 0)
var _accel_from_walking = max(min(_target_speed - _accel_from_friction - abs(phy_speed_x), walking_acceleration), 0);

phy_speed_x += _accel_from_walking * sign(_target_velocity) +
			   _accel_from_friction * -sign(phy_speed_x);
			
			
show_debug_message(_accel_from_friction);
*/

			   
#endregion

#region Jump

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

if (place_meeting(x + hsp, y, objImpassableObjectParent))
{
	var _instance = instance_place(x + hsp, y, objImpassableObjectParent);
	
	if (_instance)
	{
		show_debug_message("instance exists")
	}
	
	if (collision_point(_instance.x, _instance.y - 20, objImpassableObjectParent, false, true) == noone)
	{
		y = _instance.y - (_instance.sprite_height / 2);
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