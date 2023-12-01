#region Get keys down

var _key_right = (keyboard_check(ord("D")) || keyboard_check(vk_right));
var _key_left = (keyboard_check(ord("A")) || keyboard_check(vk_left));
var _key_up = (keyboard_check(ord("W")));
var _key_down = (keyboard_check(ord("S")));
var _key_shift = keyboard_check(vk_lshift);
var _key_jump = keyboard_check(vk_space);
var _key_jump_pressed = keyboard_check_pressed(vk_space);
var _key_jump_released = keyboard_check_released(vk_space);
var _key_power_jump = mouse_check_button(mb_right);
var _key_crouch = keyboard_check_pressed(ord("C"));
var _key_store = keyboard_check_pressed(ord("F"));

#endregion

#region Disable Sprite Collision Mask

	mask_index = -1;
	
#endregion

#region Check for Checkpoint

	if (place_meeting(x, y, obj_checkpoint)) {
		var _checkpoint = instance_place(x, y, obj_checkpoint);
		scr_set_checkpoint(_checkpoint.x, _checkpoint.y);
		instance_destroy(_checkpoint);
	}
	
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

obstacle_above = collision_line(x, bbox_top, x, bbox_top - min_space_to_uncrouch, obj_impassable_object_parent, false, true);

// When crouching, checks if the ceiling isnt too low to stop crouching
if (crouching && obstacle_above) can_uncrouch = false;
else can_uncrouch = true;

if (_key_crouch && can_uncrouch) {
	crouching = !crouching;
}

if (crouching) {
    if (_key_crouch) {
		physics_remove_fixture(id, currently_bound_fix);
		currently_bound_fix = physics_fixture_bind(crouch_fix, id);
    }
    _target_velocity /= 2;
}
else if (!crouching && _key_crouch) {
	physics_remove_fixture(id, currently_bound_fix);
	currently_bound_fix = physics_fixture_bind(default_fix, id);
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

if (place_meeting(x, bbox_bottom, obj_impassable_object_parent))
	grounded = true;

if (phy_speed_y != 0)
	grounded = false;
	
if (!grounded)
	braking_or_turning = false;

#endregion

#region Jump

jumped = false;

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
		jumped = true;
	}
} 
else if (_key_jump && grounded && !is_power_jumping) {
	if (!crouching) {
		current_jump_power = jump_power
		phy_speed_y = -current_jump_power;
		jumped = true;
	} 
	else {
		current_jump_power = crouching_jump_power
		phy_speed_y = -crouching_jump_power;
		jumped = true;
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
		jumped = true;
		grounded = false;
		braking_or_turning = false;
	}
}

if (jumped) {
	physics_remove_fixture(id, currently_bound_fix);
	currently_bound_fix = physics_fixture_bind(jump_fix, id);
}
else if (grounded && !prev_grounded_state) {
	if (crouching) {
		physics_remove_fixture(id, currently_bound_fix);
		currently_bound_fix = physics_fixture_bind(crouch_fix, id);
	}
	else {
		physics_remove_fixture(id, currently_bound_fix);
		currently_bound_fix = physics_fixture_bind(default_fix, id);
	}
}

#endregion

#region Climb

if (place_meeting(x,y, obj_climbable)) {
	can_climb = true;
}
else can_climb = false;

if (can_climb) {
	if (_key_up) {
		phy_speed_y = -climb_speed;
		climbing = true;
	}
	else if (_key_down) {
		phy_speed_y = climb_speed;
		climbing = true;
	}
	else climbing = false;
}
else climbing = false;

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

if (climbing) {
	sprite_index = spr_player_climb
	image_speed = climb_image_speed;
	
	if (phy_speed_y > 0) image_yscale = -abs(image_yscale);
	else image_yscale = abs(image_yscale);
}
else image_yscale = abs(image_yscale);

#endregion

#region Step up stairs

// If there's something in front of the player, but not in front 35 pixels higher than the player, evelate the player
var _possible_step = instance_place(x + phy_speed_x, y, obj_impassable_object_parent);
if (_possible_step != noone && 
	!place_meeting(x + phy_speed_x, y - 35, _possible_step) && phy_speed_y >= 0) {
	if (_possible_step.image_angle % 90 == 0) {
		phy_position_y = _possible_step.phy_position_y - 74;
		frames_since_last_stair_step = 0;
	}
}
frames_since_last_stair_step += 1;

#endregion

#region Store equipped item

if (is_holding_item && _key_store) {
	can_store = true;
	if (equipped_item.object_index == obj_letter) {
		num_of_letters = 0;
		for (i = 0; i < array_length(obj_inventory.items_containing); i++) {
			if (array_get(obj_inventory.items_containing, i).object_index == obj_letter) {
				num_of_letters += 1;
			}
		}
		if (num_of_letters >= 2) {
			can_store = false;
			instance_create_layer(0, -10000, layer_get_id("Alerts"), obj_alert, { sprite_index: spr_2_letters_alert })
		}
	}
	
	if (can_store) {
		equipped_item_spr = 0;
		is_holding_item = false;
	
		var _inventory_item = instance_create_layer(0, 0, layer_get_id("Inventory_Item"), obj_inventory_item);
		_inventory_item.corresponding_item = equipped_item;
		_inventory_item.sprite_index = equipped_item.sprite_index;
	
		array_push(obj_inventory.items_containing, equipped_item) 
		equipped_item = noone;
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
prev_grounded_state = grounded;
previous_x_velocity = phy_speed_x;
previous_y_velocity = phy_speed_y;

#endregion