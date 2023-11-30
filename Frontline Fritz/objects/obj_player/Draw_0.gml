draw_self();
scr_draw_item();

flag = phy_debug_render_aabb | phy_debug_render_collision_pairs | phy_debug_render_obb;

physics_world_draw_debug(flag);

draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

draw_circle(bbox_right, bbox_bottom, 10, true)