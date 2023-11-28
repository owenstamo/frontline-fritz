/// @description Insert description here
// You can write your code in this editor

mouse_hovering = false;

container_width = obj_inventory.container_width;
container_height = obj_inventory.container_height;

relative_x = random(container_width) - container_width / 2;
relative_y = random(container_height) - container_height / 2;

image_angle = random(360);
image_xscale = 10;
image_yscale = 10;

array_push(obj_inventory.items_containing, self);

// The ground item (obj_item) that this inventory item (obj_inventory_item) represents
corresponding_item = noone;







