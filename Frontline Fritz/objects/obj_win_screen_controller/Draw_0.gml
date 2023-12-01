/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(font);
draw_set_color(make_color_rgb(255,255,255))


if (timer < 150) {
	draw_text(mid_x, mid_y, string_insert(total_score, "Score: ", 8))
} 
else {
	draw_text(mid_x, mid_y, "To be continued?")
}





