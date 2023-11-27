// Initialize _player variable

var _player = instance_nearest(x, y, obj_player);

// Get key pressed events

var _key_pickup = keyboard_check_pressed(ord("E"));
var _key_drop = keyboard_check_pressed(ord("Q"));

// Get nearest child object

var _nearest_item = noone;
var _nearest_distance = undefined;

with (obj_item_parent) {
    var _distance = point_distance(x, y, _player.x, _player.y);

    if ((_nearest_distance == undefined || _distance < _nearest_distance) && id != _player.equipped_item) {
        _nearest_distance = _distance;
        _nearest_item = id;
    }
}

// Brigthen object when near

var _distance_to_player = point_distance(x, y, _player.x, _player.y);

if (!hidden) {
	if (_distance_to_player < pickup_distance && id == _nearest_item && !just_dropped) {
		can_pick_up = true;
		layer = layer_get_id("Glowing_Instances");
	} else {
		can_pick_up = false;
		layer = layer_get_id("Instances");
	}
}

// Pickup and drop item (I feel like we should put these functionalities in obj_player step event, I tried but it would crash)

if (_player.is_holding_item && (_key_drop || can_pick_up && _key_pickup && !hidden)) {
	_player.equipped_item.phy_position_x = _player.x;
	_player.equipped_item.phy_position_y = _player.y;
	_player.equipped_item.phy_speed_x = _player.phy_speed_x;
	_player.equipped_item.phy_speed_y = _player.phy_speed_y;
	_player.equipped_item.phy_rotation = 0;

	_player.equipped_item.hidden = false;
	_player.equipped_item.layer = layer_get_id("Glowing_Instances");
	_player.equipped_item.just_dropped = true;
	_player.equipped_item = noone;
	_player.is_holding_item = false;
	_player.equipped_item_spr = 0;
	
	if (!audio_is_playing(snd_drop)) {
		audio_play_sound(snd_drop, 1, false);
	}
}

if (can_pick_up && _key_pickup && !hidden) {
	_player.equipped_item = id;
	_player.item_picked_up = true;
	hidden = true;
	layer = layer_get_id("Hidden_Instances");
	_player.equipped_item_spr = sprite_index;
	_player.is_holding_item = true;
	
	if (!audio_is_playing(snd_pickup)) {
		audio_play_sound(snd_pickup, 1, false);
	}
}

just_dropped = false;