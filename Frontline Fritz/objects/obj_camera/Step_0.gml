if (follow != noone)
{
	x_to = follow.x + x_offset
	y_to = follow.y + y_offset
}

x += (x_to - x)/xd;
y += (y_to - y) / yd;

camera_set_view_pos(view_camera[0], x-(cam_width * 0.5), y - (cam_height * 0.5));