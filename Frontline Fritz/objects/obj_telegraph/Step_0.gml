if (place_meeting(x, y, obj_player)) {
	_player = instance_place(x, y, obj_player);
	instance_destroy(_player)
	sprite_index = spr_player_win
}
show_debug_message(image_index)
if (sprite_index == spr_player_win && image_index >= 58) {
	room_goto(rm_win_screen);
}


