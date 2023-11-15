#region Get keys down

var _key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
var _key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
var _key_shift = keyboard_check(vk_lshift);
var _key_jump = keyboard_check(vk_space);
var _key_jump_pressed = keyboard_check_pressed(vk_space);
var _key_jump_released = keyboard_check_released(vk_space);
var _key_power_jump = mouse_check_button(mb_right);
var _key_crouch = keyboard_check_pressed(ord("C"));
var _key_equip = keyboard_check_pressed(ord("F"));
var _key_pickup = keyboard_check_pressed(ord("E"));

#endregion

#region Set Sprinting

sprinting = _key_shift;
if (!_key_left && !_key_right || _key_left && _key_right) sprinting = false;

#endregion

#region Calculate Target Speed

var _target_speed = move_speed;

// Walk/move speed midair is different so jumping feels more like a leap than just levitating,
// and because going from sprint to walk while midair was such a large and fast change that it was a bit jarring and unrealistic
if (!grounded) _target_speed = move_speed_midair;

if (sprinting) _target_speed = sprint_speed;

if (is_power_jumping) _target_speed *= power_jump_charge_move_speed_mult;

var _target_direction = _key_right - _key_left

var _target_velocity = _target_direction * _target_speed;

#endregion

#region Check if the player started braking/turning

if  (_target_direction != sprinting_in_dir && sprinting_in_dir != 0 && !braking_or_turning) {
	braking_or_turning = true;
	started_braking_at_speed = phy_speed_x;
}
if (!braking_or_turning) started_braking_at_speed = 0;

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

#region Calculate Movement/Acceleration

var _accelerating = (phy_speed_x < _target_velocity && phy_speed_x >= 0) ||
                    (_target_velocity < phy_speed_x && phy_speed_x <= 0)

var _decelerating = (_target_velocity < phy_speed_x && phy_speed_x > 0) ||
                    (phy_speed_x < _target_velocity && phy_speed_x < 0)
				
if (!grounded && _target_direction == 0) {
	phy_speed_x -= midair_speed_decay * sign(phy_speed_x);
} 
else {
	if (_accelerating) {
		phy_speed_x += acceleration_magnitude * sign(_target_velocity - phy_speed_x);
	} 
	if (_decelerating) {
		var _deceleration_magnitude = grounded ? deceleration_magnitude : deceleration_magnitude_midair;
		phy_speed_x += _deceleration_magnitude * sign(_target_velocity - phy_speed_x);
	}
}

// If the speed passed the target velocity, set it to the target velocity
if (sign(previous_x_velocity - _target_velocity) != sign(phy_speed_x - _target_velocity)) {
	phy_speed_x = _target_velocity;
}
if (phy_speed_x == _target_velocity) {
	braking_or_turning = false;
}
	
if (sprinting && _target_direction == sign(phy_speed_x)) {
	sprinting_in_dir = _target_direction;
}
if (abs(phy_speed_x) <= move_speed && !_key_shift || // If the player is at walking speed or slower while not sprinting,
	phy_speed_x == _target_velocity && phy_speed_x == 0) { // Or they're just stationary
	sprinting_in_dir = 0;
}
			   
#endregion

#region Check grounded


if (phy_speed_y != 0)
	grounded = false;

if (place_meeting(x, y + 3, obj_impassable_object_parent))
	grounded = true

if (!grounded)
	braking_or_turning = false;

#endregion

#region Jump

if (grounded & !is_power_jumping) {
	if (crouching) {
		current_jump_power = crouching_jump_power;
	} 
	else {
		current_jump_power = jump_power;
	}
}

if ((_key_jump_pressed && _key_power_jump && grounded) || _key_jump && is_power_jumping) {
	if (!is_power_jumping) {
		pounce_jump_power = current_jump_power;
	}
	is_power_jumping = true;
	current_jump_power += 0.2;
	if (current_jump_power > pounce_jump_power + max_jump_adder) {
		is_power_jumping = false;
		phy_speed_y = -current_jump_power;
	}
} 
else if (_key_jump && grounded && !is_power_jumping) {
	if (!crouching) {
		current_jump_power = jump_power
		phy_speed_y = -current_jump_power;
	} 
	else {
		current_jump_power = crouching_jump_power
		phy_speed_y = -crouching_jump_power;
	}
	if (_key_jump_pressed) {
		is_pouncing = true;
	}
		
	grounded = false;
	braking_or_turning = false;
}

if (_key_jump_released) {
	is_power_jumping = false;
	if (grounded) {
		phy_speed_y = -current_jump_power;
		grounded = false;
		braking_or_turning = false;
	}
}

#endregion

#region Sprite Animation	

if (!grounded && frames_since_last_stair_step > 3) {
	if (is_pouncing) {
		if (sprite_index == spr_player_pounce_1) {
			sprite_index = spr_player_pounce_2;
			is_pouncing = false;
		}
		else {
			sprite_index = spr_player_pounce_1;
		}
	}
	else {
		if (phy_speed_y < -4.5)	
			sprite_index = spr_player_jump_ascending;
		else if (phy_speed_y > 6)
			sprite_index = spr_player_jump_descending;
		else
			sprite_index = spr_player_jump_peak;
	}
}
else if (braking_or_turning) {
	if (sign(phy_speed_x) == sign(started_braking_at_speed)) {
		if (abs(phy_speed_x) < abs(started_braking_at_speed) * 0.2)
			sprite_index = spr_player_brake_3;
		else if (abs(phy_speed_x) < abs(started_braking_at_speed) * 0.4)
			sprite_index = spr_player_brake_2;
		else if (abs(phy_speed_x) < abs(started_braking_at_speed) * 0.6)
			sprite_index = spr_player_brake_1;
			
		if (phy_speed_x != 0)
			image_xscale = abs(image_xscale) * sign(phy_speed_x);

	} 
	else {

		if (abs(phy_speed_x) < _target_speed * 0.25)
			sprite_index = spr_player_turn_1;
		else if (abs(phy_speed_x) < _target_speed * 0.5)
			sprite_index = spr_player_turn_2;
		else if (abs(phy_speed_x) < _target_speed * 0.75)
			sprite_index = spr_player_turn_3;
		else
			sprite_index = spr_player_turn_4;
			
		if (phy_speed_x != 0)
			image_xscale = -abs(image_xscale) * sign(phy_speed_x);
	}
}
else if ((phy_speed_x != 0 || _key_left || _key_right) && !(_key_left && _key_right)) {
	var _min_image_speed = 0.5;
	var _image_speed_multiplier = walk_imagespeed;
	sprite_index  = spr_player_walk;
	if (crouching) {
		sprite_index = spr_player_crouch;
		_image_speed_multiplier = crouch_imagespeed;
	}
	else if (_key_shift) {
		sprite_index = spr_player_run;
		_image_speed_multiplier = run_imagespeed;
	}
	image_speed = _image_speed_multiplier * max(abs(phy_speed_x / move_speed), _min_image_speed);
}
else if (crouching) {
	sprite_index = spr_player_crouch;
	image_speed = 0;
	image_index = 2;
}
else {
	sprite_index = spr_player_idle;
	image_speed = sit_imagespeed;
}

if (sign(phy_speed_x) != 0 && !braking_or_turning) {
	image_xscale = abs(image_xscale) * sign(phy_speed_x);
}

if (is_power_jumping) {
	if (!crouching && current_jump_power - jump_power < (0.5 * max_jump_adder) || crouching && current_jump_power - crouching_jump_power < (0.5 * max_jump_adder)) { 
		sprite_index = spr_player_pounce_1;
	}
	else {
		sprite_index = spr_player_pounce_2;
	}
}

#endregion

#region Step up stairs

// If there's something in front of the player, but not in front 35 pixels higher than the player, evelate the player
if (place_meeting(x + phy_speed_x * 2, y, obj_impassable_object_parent) && 
	!place_meeting(x + phy_speed_x * 2, y - 35, obj_impassable_object_parent) && phy_speed_y >= 0) {
	var _step_instance = instance_place(x + phy_speed_x * 2, y, obj_impassable_object_parent)
	if (_step_instance.image_angle % 90 == 0) {
		phy_position_y = _step_instance.phy_position_y - 74;
		frames_since_last_stair_step = 0;
	}
}
frames_since_last_stair_step += 1;

#endregion

#region Check to toggle equipped item

if (equipped_item != noone) {
	if (_key_equip && !is_holding_item) {
		equipped_item_spr = equipped_item.sprite_index;
		is_holding_item = true;
	}
	else if (_key_equip && is_holding_item) {
		equipped_item_spr = 0;
		is_holding_item = false;
	}
	else if (item_picked_up) {
		equipped_item_spr = equipped_item.sprite_index;
		is_holding_item = true;
		item_picked_up = false;
	}
}

#endregion

#region Footsteps

if (sprite_index = spr_player_walk) {
	if (floor(image_index)== 1 || floor(image_index) == 4) {
		if (!audio_is_playing(snd_walk)) {
			var _p = random_range(.9,1.1);
			audio_play_sound(snd_walk, 0, false, 1, 0, _p);
		}
	}
}
if sprite_index = spr_player_crouch {
	if (floor(image_index) == 2 || floor(image_index) == 4 || floor(image_index) == 0) {
		if (!audio_is_playing(snd_crouch)){
			var _p = random_range(.9,1.1);
			audio_play_sound(snd_crouch, 0, false, 1, 0, _p);
		}
	}
}
if sprite_index = spr_player_run {
	if (floor(image_index )== 1 || floor(image_index) == 2 || floor(image_index) == 4 || floor(image_index) == 5) {
		if (!audio_is_playing(snd_run)) {
			var _p = random_range(.9,1.1);
			audio_play_sound(snd_run, 0, false, 1, 0, _p);
		}
	}
}
if sprite_index = spr_player_brake_3 {
	if (!audio_is_playing(snd_brake)) {
		var _p = random_range(.9,1.1);
		audio_play_sound(snd_brake, 0, false, 1, 0, _p);
	}
}

#endregion



#region Set prev values (MAKE SURE THIS HAPPENS LAST!!)

prev_key_right = _key_right;
prev_key_left = _key_left
previous_x_velocity = phy_speed_x;
previous_y_velocity = phy_speed_y;

#endregion