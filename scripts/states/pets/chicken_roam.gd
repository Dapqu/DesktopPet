class_name ChickenRoam
extends State
## This state controls the chicken's roaming behavior within the screen bounds.
##
## The ChickenRoam state is part of the chicken's state machine. In this state,
## the chicken will move in a random direction (-1, 0, 1) at a set speed for a
## random amount of time. If the chicken reaches the screen boundaries, the
## direction will change to ensure it stays within the screen.

@export var chicken: CharacterBody2D
@export var move_speed := 40.0

var move_direction: int
var roam_time: float

var screen_left_bound: float = 25.0
var screen_right_bound: float


## Randomizes the direction and duration for roaming within this state.
func randomize_roaming() -> void:
	randomize()
	move_direction = randi_range(-1, 1)
	roam_time = randf_range(1, 3)


## Called when the chicken enters the ChickenRoam state.
## Sets up the screen boundaries and initializes roaming behavior.
func enter() -> void:
	screen_right_bound = DisplayServer.screen_get_size().x - 25.0
	randomize_roaming()


## Updates the chicken's position and handles boundary detection while in this state.
func update(delta: float) -> void:
	# Check if the chicken hits the screen boundaries and adjust direction
	if chicken.position.x <= screen_left_bound:
		chicken.position.x = screen_left_bound
		move_direction = 1
	elif chicken.position.x >= screen_right_bound:
		chicken.position.x = screen_right_bound
		move_direction = -1
	
	# Update the roaming time or randomize roaming if the time is up
	if roam_time > 0:
		roam_time -= delta
	else:
		randomize_roaming()


## Applies the movement based on the current direction and speed within this state.
func physics_update(_delta: float) -> void:
	if chicken:
		chicken.velocity.x = move_direction * move_speed
