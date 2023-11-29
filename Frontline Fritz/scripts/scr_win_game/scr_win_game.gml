// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_win_game(){
	all_items = obj_inventory.items_containing;
	total_score = 0;
	for(i = 0; i < array_length(all_items); i++) {
		total_score += array_get(all_items, i).item_score;
	}
	room_goto(rm_win_screen);
	show_debug_message(total_score)
}