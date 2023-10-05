if (follow != noone)
{
	xTo = follow.x + x_offset
	yTo = follow.y + y_offset
}

x += (xTo - x)/xd;

yRange = 100;

if (abs(y - yTo) > yRange)
{
    y += (yTo - y) / yd;
}

camera_set_view_pos(view_camera[0], x-(camWidth * 0.5), y - (camHeight * 0.5));