// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// ITEM SPRITES MUST BE CENTERED AND around 10x10 for best performance

function scr_draw_item() {
	
	if (equipped_item_spr != 0 && is_holding_item) {
		var _sub_num = sprite_get_number(equipped_item_spr);
		if _sub_num > 1  {
			if (equipped_item_anim <= _sub_num - 1) {equipped_item_anim += image_speed;}
			else {equipped_item_anim = 0;}
		}
		else {equipped_item_anim = 0;}
		var _img = ceil(image_index) - 1;
		
				
		// Set rotations:
		object_rotation = 0;
		
		if (equipped_item_spr == spr_rifle) {object_rotation = -10;}
		
		else {object_rotation = -40;}
		
	    // FUNCTIONS (To reduce redundancy)
		// offset_x and offset_y are the offsets away from origin of player to put the origin of item sprite
		
		function draw_item(offset_x, offset_y) {
				if (image_xscale > 0) {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offset_x * image_xscale), y+(offset_y * image_xscale), image_xscale, image_yscale, object_rotation, c_white, 1);}
				else {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offset_x * image_xscale), y+(offset_y * -image_xscale), image_xscale, image_yscale, -object_rotation, c_white, 1);}
		}
		function draw_item_ext(offset_x, offset_y, rotation, xscaleMultiplier) {
				if (image_xscale > 0) {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offset_x * image_xscale), y+(offset_y * image_xscale), image_xscale * xscaleMultiplier, image_yscale, rotation, c_white, 1);}
				else {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offset_x * image_xscale), y+(offset_y * -image_xscale), image_xscale * xscaleMultiplier, image_yscale, -rotation, c_white, 1);}
		}
		
		// DRAW FOR IDLE ANIMATION
		
		if (sprite_index == spr_player_idle) {
			if ((_img >= 0 && _img <= 2) || _img == 20) {draw_item(5, 2.5);}
			else if ((_img == 3) || _img == 19) {draw_item_ext(4, 2.5, object_rotation - 5, 1);}
			else {draw_item_ext(3, 2.5, object_rotation - 10, 1);}
		}
		
		// DRAW FOR WALK ANIMATION
		
		if (sprite_index == spr_player_walk) {
			if (_img == 0 || _img == 2 || _img == 3 || _img == 5) {draw_item(6, 3.5);}
			else {draw_item(6, 4.5);}
		}
		
		// DRAW FOR RUN ANIMATION
		
		if (sprite_index == spr_player_run) {
			if (_img == 0) {draw_item(6, 2.5);}
			else if (_img == 1) {draw_item(7, 5.5);}
			else if (_img == 2) {draw_item(8, 4.5);}
			else if (_img == 3) {draw_item(7, 5.5);}
			else if (_img == 4) {draw_item(6, 4.5);}
			else {draw_item(7, 3.5);}
		}
		
		// DRAW FOR JUMP ANIMATION
		
		if (sprite_index == spr_player_pounce_1) {draw_item(5, 7.5);}
		if (sprite_index == spr_player_pounce_2) {draw_item(5, 7.5);}
		if (sprite_index == spr_player_jump_ascending) {draw_item(6, 3.5);}
		if (sprite_index == spr_player_jump_peak) {draw_item(6, 3.5);}
		if (sprite_index == spr_player_jump_descending) {draw_item(7, 8.5);}
		
		// DRAW FOR CROUCH
		
		if (sprite_index == spr_player_crouch) {
			if (_img == 0 || _img == 1 || _img == 4 || _img == 5) {draw_item(8, 6.5);}
			else if (_img == 2 || _img == 3 || _img == 6 || _img == 7) {draw_item(8, 7.5);}
			else {draw_item(8, 6.5);}
		}
		
		// DRAW FOR TURN
		
		if (sprite_index == spr_player_brake_1) {draw_item(9, 5.5);}
		if (sprite_index == spr_player_brake_2) {draw_item(9, 6.5);}
		if (sprite_index == spr_player_brake_3) {draw_item(9, 7.5);}
		if (sprite_index == spr_player_turn_1) {draw_item_ext(4, 8.5, object_rotation + 30, 1);}
		if (sprite_index == spr_player_turn_2) {draw_item_ext(5, 7.5, object_rotation + 60, 1);}
		if (sprite_index == spr_player_turn_3) {draw_item_ext(-3, 7.5, object_rotation + 90, -1);}
		if (sprite_index == spr_player_turn_4) {draw_item_ext(-2, 7.5, object_rotation + 90, -1);}
	}
}