#region This doesn't work (but I'm keeping it in case it does in the future):

// Define collision shapes

mask_index = -1;
uncrouch_height = min_space_to_uncrouch;
can_uncrouch = true;

default_fix = physics_fixture_create();
physics_fixture_set_polygon_shape(default_fix);
physics_fixture_add_point(default_fix, -20,13);
physics_fixture_add_point(default_fix, 47,13);
physics_fixture_add_point(default_fix, 47,70);
physics_fixture_add_point(default_fix, -20,70);
physics_fixture_set_density(default_fix,0);
physics_fixture_set_restitution(default_fix,0);
physics_fixture_set_collision_group(default_fix,0);
physics_fixture_set_linear_damping(default_fix,0.1);
physics_fixture_set_angular_damping(default_fix,0.1);
physics_fixture_set_friction(default_fix,0);
physics_fixture_set_awake(default_fix, true)


crouch_fix = physics_fixture_create();
physics_fixture_set_polygon_shape(crouch_fix);
physics_fixture_add_point(crouch_fix, -20,50);
physics_fixture_add_point(crouch_fix, 47,50);
physics_fixture_add_point(crouch_fix, 47,70);
physics_fixture_add_point(crouch_fix, -20, 70);
physics_fixture_set_density(crouch_fix,0);
physics_fixture_set_restitution(crouch_fix,0);
physics_fixture_set_collision_group(crouch_fix,0);
physics_fixture_set_linear_damping(crouch_fix,0.1);
physics_fixture_set_angular_damping(crouch_fix,0.1);
physics_fixture_set_friction(crouch_fix,0);
physics_fixture_set_awake(crouch_fix, true)

jump_fix = physics_fixture_create();
physics_fixture_set_polygon_shape(jump_fix);
physics_fixture_add_point(jump_fix, 10,50);
physics_fixture_add_point(jump_fix, 20,50);
physics_fixture_add_point(jump_fix, 20,70);
physics_fixture_add_point(jump_fix, 10, 70);
physics_fixture_set_density(jump_fix,0);
physics_fixture_set_restitution(jump_fix,0);
physics_fixture_set_collision_group(jump_fix,0);
physics_fixture_set_linear_damping(jump_fix,0.1);
physics_fixture_set_angular_damping(jump_fix,0.1);
physics_fixture_set_friction(jump_fix,0);
physics_fixture_set_awake(jump_fix, true)
// Set default collision Mask

currently_bound_fix = physics_fixture_bind(default_fix, id);

#endregion
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

// Whether player was airborne last step
prev_grounded_state = true
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
jumped = false;
just_landed = false;
is_power_jumping = false
is_pouncing = false;

// Declare variables for equipped objects / inventory
is_holding_item = false;
equipped_item = noone;
equipped_item_spr = 0;
equipped_item_anim = 0;