// Initialize player variable

var player = instance_nearest(x, y, objPlayer);

// Get key pressed events

var _key_pickup = keyboard_check_pressed(ord("E"));
var _key_drop = keyboard_check_pressed(ord("Q"));

// Get nearest child object

var nearest_item = noone;
var nearest_distance = -1;

var distance_to_player = point_distance(x, y, player.x, player.y);

with (objItem) {

    var distance = point_distance(x, y, player.x, player.y);

    if ((nearest_distance == -1 || distance < nearest_distance) && id != player.equipped_item) {
        nearest_distance = distance;
        nearest_item = id;
    }
}
// Brighten item when near

var distance_to_player = point_distance(x, y, player.x, player.y);

	// I couldnt figure out a way to make it brighter (since image_alpha only goes up to 1)
	// so for now we are going to make it darker when the player gets near but I don't know
	// if you guys are fine with doing a separate "glow" sprite for each item

if (image_alpha != 0) {
	if (distance_to_player < pickup_distance) {
		can_pick_up = true;
	    image_alpha = 0.5;
	} else {
		can_pick_up = false;
	    image_alpha = 1;
	}
}

// Pickup and drop item (I feel like we should put these functionalities in objPlayer step event, I tried but it would crash)

if (can_pick_up && _key_pickup && image_alpha != 0) {
	player.equipped_item = nearest_item;
	player.item_picked_up = true;
	image_alpha = 0;
}

if (player.is_holding_item && _key_drop) {
	player.equipped_item.x = player.x;
	player.equipped_item.y = player.y;
	player.equipped_item.image_alpha = 1;
	player.equipped_item.gravity = item_gravity;
	drop_speed_x = player.phy_speed_x;
	player.equipped_item = noone;
	player.is_holding_item = false;
}

// If item is in air. (We need to change this and put physics variables)
	
if (gravity == item_gravity) {
   
	vspeed += gravity;
	hspeed = 100;

    if (place_meeting(x, y + vspeed, objImpassableObjectParent)) {
        vspeed = 0;
		hspeed = 0;
		gravity = 0;
    } else {
        y += vspeed;
		hspeed = 100
	}
}