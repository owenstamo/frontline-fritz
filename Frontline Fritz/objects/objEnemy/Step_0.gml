#region Get go to positions

var _player = instance_nearest(x, y, objPlayer);
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

#region Check grounded

if (place_meeting(x, y + 1, objImpassableObjectParent)) {
	grounded = true;
	is_climbing = false;
}

if (phy_speed_y != 0) {
	grounded = false;
}

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

obstacle = collision_line(x, bbox_bottom, x + (phy_speed_x * 100), bbox_bottom, objImpassableObjectParent, false, true);
if (!obstacle && place_meeting(x + phy_speed_x * 2, y, objImpassableObjectParent)) {
	obstacle = instance_place(x + phy_speed_x * 2, y, objImpassableObjectParent);
}

if (obstacle != noone) {
	// Calculate the required jump distance
    var height = bbox_bottom - obstacle.bbox_top;
	var time_of_flight = (2 * jump_power) / room_gravity
	
	var discriminant = sqrt(jump_power * jump_power - 2 * room_gravity * -height);
	var time_to_height_1 = (jump_power + discriminant) / room_gravity;
	var time_to_height_2 = (jump_power - discriminant) / room_gravity;

// Choose the positive time
	var time_to_height = max(time_to_height_1, time_to_height_2);
	
	var max_jump_height = (jump_power * jump_power) / ((2 * room_gravity * 0.1) / 30);
	
	var max_jump_distance;
	
	if (height > max_jump_height) max_jump_distance = 3;
	else max_jump_distance = (abs(phy_speed_x) * 30) * time_to_height;
	
	if (height > max_jump_height && (bbox_bottom - bbox_top) * climb_height_factor >= height && place_meeting(x + phy_speed_x * 2, y, objImpassableObjectParent)) {
		is_climbing = true;
	}
	if (is_climbing) {	
		phy_speed_y = -climb_speed;
	}
	
	if (((phy_speed_x > 0 && obstacle.bbox_left - bbox_right <= max_jump_distance)
		|| (phy_speed_x < 0 && bbox_left - obstacle.bbox_right <= max_jump_distance))
		&& height > stair_height 
		&& grounded
		&& !is_climbing) {
		phy_speed_y -= jump_power;
	}
}

#endregion

#region Step up stairs

if (place_meeting(x + phy_speed_x * 2, y, objImpassableObjectParent) && 
	!place_meeting(x + phy_speed_x * 2, y - stair_height, objImpassableObjectParent) && phy_speed_y >= 0) {
	var _step_instance = instance_place(x + phy_speed_x * 2, y, objImpassableObjectParent)
	if (_step_instance.image_angle % 90 == 0) {
		phy_position_y += _step_instance.bbox_top - bbox_bottom - 5;
		frames_since_last_stair_step = 0;
	}
}

frames_since_last_stair_step += 1;

#endregion


