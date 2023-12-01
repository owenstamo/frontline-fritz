// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_set_checkpoint(input_x, input_y){
	global.checkpoint_x = input_x;
	global.checkpoint_y = input_y;
	show_debug_message("checkpoint set to:")
	show_debug_message(global.checkpoint_x)
	show_debug_message(global.checkpoint_y)
}