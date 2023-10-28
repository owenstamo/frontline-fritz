/// @description Insert description here
// You can write your code in this editor

// Horizontal speed
hsp = 0;
// Vertical speed
vsp = 0;
// Whether or not the player is touching the ground
grounded = true;
// Whether or not the player is crouching
crouching = false;

// Stop this object from rotating
phy_fixed_rotation = true;


#region This doesn't work (but I'm keeping it in case it does in the future):

// Define collision shapes
default_fix = physics_fixture_create();
physics_fixture_set_polygon_shape(default_fix);
physics_fixture_add_point(default_fix, 0,8);
physics_fixture_add_point(default_fix, 17,8);
physics_fixture_add_point(default_fix, 17,22);
physics_fixture_add_point(default_fix, 0,22);


crouch_fix = physics_fixture_create();
physics_fixture_set_polygon_shape(crouch_fix);
physics_fixture_add_point(crouch_fix, 0,13);
physics_fixture_add_point(crouch_fix, 17,13);
physics_fixture_add_point(crouch_fix, 17,22);
physics_fixture_add_point(crouch_fix, 0,22);

// Set default collision Mask

currently_bound_fix = physics_fixture_bind(default_fix, self);

#endregion
