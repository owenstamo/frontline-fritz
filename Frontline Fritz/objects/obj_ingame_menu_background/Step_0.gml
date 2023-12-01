var _key_esc_pressed = keyboard_check_pressed(vk_escape);

if (_key_esc_pressed) {
	if (menu_open) {
		menu_open = false;
		dest_y_offset = closed_y_offset;
	}
	else {
		menu_open = true;
		dest_y_offset = 0;
	}
}

current_y_offset += (dest_y_offset - current_y_offset) * open_speed;