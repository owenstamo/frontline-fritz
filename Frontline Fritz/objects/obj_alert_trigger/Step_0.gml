/// @description Insert description here
// You can write your code in this editor

time_since_triggered += 1;

if (place_meeting(x, y, obj_player)) {
	if (time_since_triggered >= frames_between_triggers) {
		alert = instance_create_layer(0, -10000, layer_get_id("Alerts"), obj_alert, { sprite_index: alert_sprite })
		time_since_triggered = 0;
	}
}








