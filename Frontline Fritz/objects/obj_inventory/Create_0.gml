/// @description Insert description here
// You can write your code in this editor

randomize()

items_containing = [];

// The distance between the edge of the sprite and the container, horizontally and vertically (respectively)
container_buffer_x = sprite_width * 0.23;
container_buffer_y = sprite_height * 0.3;
// The width and height of the region which the center of any inventory_item must fall within
container_width = sprite_width - container_buffer_x * 2;
container_height = sprite_height - container_buffer_y * 2;

inventory_open = false;

closed_y_offset = camera_get_view_height(view_camera[0]) / 2 + sprite_height * 0.5 + 20;
dest_y_offset = closed_y_offset
current_y_offset = dest_y_offset;

x = obj_camera.x;
y = obj_camera.y + current_y_offset;

open_speed = 0.3;










