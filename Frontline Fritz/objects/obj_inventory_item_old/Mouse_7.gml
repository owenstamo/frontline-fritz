/// @description Insert description here
// You can write your code in this editor

var _player = obj_player;

if (_player.is_holding_item) {
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
}

_player.equipped_item = corresponding_item;
_player.item_picked_up = true;
_player.equipped_item_spr = sprite_index;
_player.is_holding_item = true;

instance_destroy(id);

obj_inventory.inventory_open = false;
obj_inventory.dest_y_offset = obj_inventory.closed_y_offset;









