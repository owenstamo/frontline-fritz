/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (instance_exists(objTextCtrls)){
	instance_destroy(objTextCtrls);
}
else{
	instance_create_layer(room_width / 2, room_height - 150, "Instances", objTextCtrls);
}
