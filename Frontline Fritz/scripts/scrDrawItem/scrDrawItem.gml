// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// ITEM SPRITES MUST BE CENTERED AND around 10x10 for best performance

function scrDrawItem(){
	
	if (equipped_item_spr != noone && is_holding_item = true) {
		var sub_num = sprite_get_number(equipped_item_spr);
		if sub_num > 1  {
			if (equipped_item_anim <= sub_num - 1) {equipped_item_anim += image_speed;}
			else {equipped_item_anim = 0;}
		}
		else {equipped_item_anim = 0;}
		var img = ceil(image_index) - 1;
		
				
		// Set rotations:
		objectRotation = 0;
		
		if (equipped_item_spr = sprRifle) {objectRotation = -10;}
		
		else {objectRotation = -40;}
		
	    // FUNCTIONS (To reduce redundancy)
		// offsetX and offsetY are the offsets away from origin of player to put the origin of item sprite
		
		function drawItem(offsetX, offsetY) {
				if (image_xscale > 0) {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offsetX * image_xscale), y+(offsetY * image_xscale), image_xscale, image_yscale, objectRotation, c_white, 1);}
				else {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offsetX * image_xscale), y+(offsetY * -image_xscale), image_xscale, image_yscale, -objectRotation, c_white, 1);}
		}
		function drawItemExt(offsetX, offsetY, rotation, xscaleMultiplier) {
				if (image_xscale > 0) {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offsetX * image_xscale), y+(offsetY * image_xscale), image_xscale * xscaleMultiplier, image_yscale, rotation, c_white, 1);}
				else {draw_sprite_ext(equipped_item_spr, equipped_item_anim, x+(offsetX * image_xscale), y+(offsetY * -image_xscale), image_xscale * xscaleMultiplier, image_yscale, -rotation, c_white, 1);}
		}
		
		// DRAW FOR IDLE ANIMATION
		
		if (sprite_index == sprPlayerIdle) {
			if ((img >= 0 && img <= 2) || img == 20) {drawItem(5, 2.5);}
			else if ((img == 3) || img == 19) {drawItemExt(4, 2.5, objectRotation - 5, 1);}
			else {drawItemExt(3, 2.5, objectRotation - 10, 1);}
		}
		
		// DRAW FOR WALK ANIMATION
		
		if (sprite_index == sprPlayerWalk) {
			if (img == 0 || img == 2 || img == 3 || img == 5) {drawItem(6, 3.5);}
			else {drawItem(6, 4.5);}
		}
		
		// DRAW FOR RUN ANIMATION
		
		if (sprite_index == sprPlayerRun) {
			if (img == 0) {drawItem(6, 2.5);}
			else if (img == 1) {drawItem(7, 5.5);}
			else if (img == 2) {drawItem(8, 4.5);}
			else if (img == 3) {drawItem(7, 5.5);}
			else if (img == 4) {drawItem(6, 4.5);}
			else {drawItem(7, 3.5);}
		}
		
		// DRAW FOR JUMP ANIMATION
		
		if (sprite_index == sprPlayerPounce1) {drawItem(5, 7.5);}
		if (sprite_index == sprPlayerPounce2) {drawItem(5, 7.5);}
		if (sprite_index == sprPlayerJumpAscending) {drawItem(6, 3.5);}
		if (sprite_index == sprPlayerJumpPeak) {drawItem(6, 3.5);}
		if (sprite_index == sprPlayerJumpDescending) {drawItem(7, 8.5);}
		
		// DRAW FOR CROUCH
		
		if (sprite_index == sprPlayerCrouch) {
			if (img == 0 || img == 1 || img == 4 || img == 5) {drawItem(8, 6.5);}
			else if (img == 2 || img == 3 || img == 6 || img == 7) {drawItem(8, 7.5);}
			else {drawItem(8, 6.5);}
		}
		
		// DRAW FOR TURN
		
		if (sprite_index == sprPlayerBrake1) {drawItem(9, 5.5);}
		if (sprite_index == sprPlayerBrake2) {drawItem(9, 6.5);}
		if (sprite_index == sprPlayerBrake3) {drawItem(9, 7.5);}
		if (sprite_index == sprPlayerTurn1) {drawItemExt(4, 8.5, objectRotation + 30, 1);}
		if (sprite_index == sprPlayerTurn2) {drawItemExt(5, 7.5, objectRotation + 60, 1);}
		if (sprite_index == sprPlayerTurn3) {drawItemExt(-3, 7.5, objectRotation, -1);}
		if (sprite_index == sprPlayerTurn4) {drawItemExt(-2, 7.5, objectRotation, -1);}
	}
}