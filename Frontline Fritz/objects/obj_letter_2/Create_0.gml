/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

opened_letter_sprite = spr_letter_blank;
opened_letter_object = noone;

function set_letter(letter_sprite, letter_score) {
	opened_letter_sprite = letter_sprite;
	item_score = letter_score;
	opened_letter_object = instance_create_layer(0, -10000, layer_get_id("Opened_Letter"), obj_opened_letter);
	opened_letter_object.set_sprite_index(opened_letter_sprite);
}