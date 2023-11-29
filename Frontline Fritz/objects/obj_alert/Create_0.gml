/// @description Insert description here
// You can write your code in this editor

closed_y_offset = camera_get_view_height(view_camera[0]) / 2 + sprite_height * 0.5 + 20;
opened_y_offset = camera_get_view_height(view_camera[0]) * 0.4;
dest_y_offset = opened_y_offset;
current_y_offset = closed_y_offset;
open_speed = 0.3;

image_xscale = 3;
image_yscale = 3;

timer = 0;

close_time = 100;

for (i = 0; i < instance_number(obj_alert); i++) {
	other_instance = instance_find(obj_alert, i);
	if (other_instance.id != id) {
		other_instance.timer = other_instance.close_time;
	}
}




