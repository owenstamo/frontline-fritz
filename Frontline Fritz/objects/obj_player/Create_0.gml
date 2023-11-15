/// @description Insert description here
// You can write your code in this editor

// Whether or not the player is touching the ground
grounded = true;
// Whether or not the player is crouching
crouching = false;
// Whether or not the player is sprinting
sprinting = false;

// Whether or not the player is braking/quickly turning around
braking_or_turning = false;
// The speed the player was at when they started braking/quickly turning around
started_braking_at_speed = 0;
// The direction that the player is/just was sprinting. Sets to zero once the player is fully stationary.
sprinting_in_dir = false;

// The amount of frames since the player last went up a step. Exists to disable fall animation while going up stairs
frames_since_last_stair_step = 0;

// Whether or not the player was holding the left key in the previous step
prev_key_left = false;
// Whether or not the player was holding the right key in the previous step
prev_key_right = false;

previous_x_velocity = 0;
previous_y_velocity = 0;

// Reference physics speeds from other objects
phy_speed_x = 0;
phy_speed_y = 0;

// Stop this object from rotating
phy_fixed_rotation = true;

// Set Current Jump Power and whether player is pouncing:
current_jump_power = jump_power;
pounce_jump_power = 0;
is_power_jumping = false
is_pouncing = false;

// Declare variables for equipped objects / inventory
is_holding_item = false;
item_picked_up = false;
equipped_item = noone;
equipped_item_spr = 0;
equipped_item_anim = 0;

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
