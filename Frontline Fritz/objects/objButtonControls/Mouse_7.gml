/// @description Insert description here
// You can write your code in this editor


if (!controls_showing){
	controls_showing = true;
	objTextCtrls.layer = layer_get_id("Instances");
} else {
	controls_showing = false;
	objTextCtrls.layer = layer_get_id("Hidden_Instances");
}
