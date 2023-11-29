/// @description Insert description here
// You can write your code in this editor

current_y_offset += (dest_y_offset - current_y_offset) * open_speed;

timer += 1;

if (timer >= close_time) {
	dest_y_offset = closed_y_offset;
	if (abs(current_y_offset - dest_y_offset) < 0.001) {
		instance_destroy(id);
	}
}






