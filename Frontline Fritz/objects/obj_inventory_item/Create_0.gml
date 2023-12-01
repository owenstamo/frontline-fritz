/// @description Insert description here
// You can write your code in this editor

mouse_hovering = false;
mouse_over = false;

container_width = obj_inventory.container_width;
container_height = obj_inventory.container_height;

relative_x = random(container_width) - container_width / 2;
relative_y = random(container_height) - container_height / 2;

image_angle = random(360);
image_xscale = 10;
image_yscale = 10;

// The ground item (obj_item) that this inventory item (obj_inventory_item) represents
corresponding_item = noone;

function set_mouse_hovering(_set_to) {
	if(_set_to) {
		mouse_hovering = true;
		layer = layer_get_id("Inventory_Item_Glowing");
	} else {
		mouse_hovering = false;
		layer = layer_get_id("Inventory_Item");
	}
}


function update_mouse_hovering() {
	var _instances_count = instance_number(obj_inventory_item);
	var _lowest_dist = infinity;
	var _closest_instance = noone;

	for(var i = 0; i < _instances_count; i++) {
		var _instance = instance_find(obj_inventory_item, i);
		var _dist = _instance.distance_to_point(mouse_x, mouse_y);
		if (_dist < _lowest_dist && _instance.mouse_over) {
			if (_closest_instance != noone)
				_closest_instance.set_mouse_hovering(false);
			_closest_instance = _instance;
			_closest_instance.set_mouse_hovering(true);
		
			_lowest_dist = _dist;
		} else {
			_instance.set_mouse_hovering(false);
		}
	}
}

