/// @description Insert description here
// You can write your code in this editor


if (!controls_showing){
	controls_showing = true;
	obj_text_ctrls.layer = layer_get_id("Instances");
} else {
	controls_showing = false;
	obj_text_ctrls.layer = layer_get_id("Hidden_Instances");
}
