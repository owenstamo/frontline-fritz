/// @description Insert description here
// You can write your code in this editor

var _key_tab_pressed = keyboard_check_pressed(vk_tab);

if (_key_tab_pressed) {
	if (inventory_open) {
		inventory_open = false;
		dest_y_offset = closed_y_offset;
	}
	else {
		inventory_open = true;
		dest_y_offset = 0;
	}
}

current_y_offset += (dest_y_offset - current_y_offset) * open_speed;




