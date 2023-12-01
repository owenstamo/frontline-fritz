// Get player 
var _player = instance_nearest(x, y, obj_player);

#region Check grounded


if (place_meeting(x, y + 1, obj_impassable_object_parent)) {
	grounded = true;
	is_climbing = false;
}

if (phy_speed_y != 0) {
	grounded = false;
}

#endregion

#region Determine status

if (knocked_out) {
	time_elapsed++
	if (time_elapsed >= knockout_time * room_speed) {
		knocked_out = false;
		collapsed = false;
		phy_active = true;
		time_elapsed = 0;
	}
}

if (killed_player) {
	time_elapsed++
	if (time_elapsed >= player_death_time * room_speed) {
		room_restart();
	}
}

if (!knocked_out) {
	if (_player != noone)
	{
	    if (!collision_line( x, y, _player.x, _player.y, obj_impassable_object_parent, false, false ) ) status = "chasing";
		else if (audio_is_playing(snd_meow_1) || audio_is_playing(snd_meow_2)) status = "chasing";
		else status = "idle";

		if (collision_circle(x,y+75, 200, obj_player, false, true)) {
			status = "killing";
			audio_play_sound(snd_player_death, 0, false, 1, 0, 1);
			killed_player = true;
		}
	}
	else status = "idle"
	
	knockout_instance = collision_circle(x,y+75, 190, obj_knockout_parent, false, true);
	if (knockout_instance) {
		collision_speed = knockout_instance.phy_speed_y;
		if (collision_speed >= min_knockout_collision_speed && !prev_hit) {
			status = "falling";
			knocked_out = true;
		}
	}
}

#endregion

// Switch Behavior
switch (status) {

	case "idle":
		phy_active = true;
		if (!killed_player) {
			sprite_index = spr_enemy_idle;
			image_speed = enemy_idle_imagespeed;
		}
		else {
			sprite_index = spr_enemy_kill;
			image_speed = enemy_idle_imagespeed;
		}
	break;
	case "chasing":
	
		#region Get go to positions

		var _goto_x = _player.x;
		var _goto_y = _player.y;

		#endregion

		#region Calculate Target Speed

		var _target_speed = move_speed;

		var _target_direction;
		if (abs(x - _goto_x) < min_distance_to_player && abs(y - _goto_y) < min_distance_to_player) _target_direction = 0
		else _target_direction = -sign(x - _player.x)

		var _target_velocity = _target_direction * _target_speed;

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

		#region Calculate Jump

		//Check for obstacle in front

		obstacle = collision_line(x, bbox_bottom, x + (phy_speed_x * 100), bbox_bottom, obj_impassable_object_parent, false, true);
		if (!obstacle && place_meeting(x + phy_speed_x * 2, y, obj_impassable_object_parent)) {
			obstacle = instance_place(x + phy_speed_x * 2, y, obj_impassable_object_parent);
		}
		
		if (place_meeting(bbox_left, bbox_bottom, obj_impassable_object_parent))
			climb_obstacle = instance_place(bbox_left, bbox_bottom, obj_impassable_object_parent);
		else if (place_meeting(bbox_right, bbox_bottom, obj_impassable_object_parent))
			climb_obstacle = instance_place(bbox_right, bbox_bottom, obj_impassable_object_parent);

		if (obstacle != noone) {
			// Calculate the required jump distance
		    var _height = bbox_bottom - obstacle.bbox_top;
			var _climb_height;
			var _time_of_flight = (2 * jump_power) / room_gravity
	
			var _discriminant = sqrt(jump_power * jump_power - 2 * room_gravity * -_height);
			var _time_to_height_1 = (jump_power + _discriminant) / room_gravity;
			var _time_to_height_2 = (jump_power - _discriminant) / room_gravity;

		// Choose the positive time
			var _time_to_height = max(_time_to_height_1, _time_to_height_2);
	
			var _max_jump_height = (jump_power * jump_power) / ((2 * room_gravity * 0.1) / 30);
	
			var _max_jump_distance;
	
			if (_height > _max_jump_height) _max_jump_distance = 3;
			else _max_jump_distance = (abs(phy_speed_x) * 30) * _time_to_height;
	
			if (climb_obstacle != noone) {
				_climb_height = bbox_bottom - climb_obstacle.bbox_top;
				if (_climb_height <= (bbox_bottom - bbox_top) * climb_height_factor) {
					//is_climbing = true;
				}
			}
			if (is_climbing) {	
				phy_speed_y = -climb_speed;
			}
	
			if (((phy_speed_x > 0 && obstacle.bbox_left - bbox_right <= _max_jump_distance)
				|| (phy_speed_x < 0 && bbox_left - obstacle.bbox_right <= _max_jump_distance))
				&& _height > stair_height 
				&& grounded
				&& !is_climbing) {
				phy_speed_y -= jump_power;
			}
		}

		#endregion

		#region Step up stairs

		if (place_meeting(x + phy_speed_x * 2, y, obj_impassable_object_parent) && 
			!place_meeting(x + phy_speed_x * 2, y - stair_height, obj_impassable_object_parent) && phy_speed_y >= 0) {
			var _step_instance = instance_place(x + phy_speed_x * 2, y, obj_impassable_object_parent)
			if (_step_instance.image_angle % 90 == 0) {
				phy_position_y += _step_instance.bbox_top - bbox_bottom - 5;
				frames_since_last_stair_step = 0;
			}
		}

		frames_since_last_stair_step += 1;

		#endregion
		
		#region Sprite animation
			if (phy_speed_x != 0) {
				sprite_index = spr_enemy_walk;
				image_speed = enemy_walk_imagespeed * (phy_speed_x / move_speed);
			}
			else {
				sprite_index = spr_enemy_idle;
				image_speed = enemy_idle_imagespeed;
			}
		#endregion
		
	break;
	
	case "killing":
		instance_deactivate_object(obj_player);
		sprite_index = spr_enemy_kill;
	break;
	
	case "falling":
		sprite_index = spr_enemy_fall;
		if (image_index >= 2) collapsed = true;
		if (collapsed) { 
			image_speed = 0;
			image_index = 2;
		}
		else image_speed = enemy_fall_imagespeed
		phy_active = false;
		
	break;
}

// Set previous values

prev_hit = collision_circle(x,y+75, 190, obj_knockout_parent, false, true);
