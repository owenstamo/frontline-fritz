/// @description Insert description here
// You can write your code in this editor

opened = false;

closed_y_offset = 0;
dest_y_offset = closed_y_offset;
current_y_offset = closed_y_offset;
open_speed = 0.3;

function set_sprite_index(new_sprite_index) {
	sprite_index = new_sprite_index;
	closed_y_offset = camera_get_view_height(view_camera[0]) / 2 + sprite_height * 0.5 + 20;
	if (!opened) {
		dest_y_offset = closed_y_offset;
		current_y_offset = closed_y_offset;
	}
	show_debug_message(sprite_get_height(new_sprite_index))
	show_debug_message(sprite_get_width(new_sprite_index))
	image_xscale = 3 * (256 / sprite_get_width(new_sprite_index));
	image_yscale = 3 * (300 / sprite_get_height(new_sprite_index));
}

set_sprite_index(spr_letter_blank);
