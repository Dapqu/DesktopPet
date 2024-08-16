class_name ChickenRoam
extends State
## This state manages the chicken's roaming behavior within the screen boundaries.
##
## As part of the chicken's state machine, the ChickenRoam state allows the chicken
## to move in a random direction (-1, 0, or 1) at a constant speed for a randomly
## determined duration. If the chicken reaches the edge of the screen, its direction
## will change to keep it within the screen limits.

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D
@export var move_speed := 40.0

var move_direction: int
var roam_time: float

var screen_left_bound: float = 25.0
var screen_right_bound: float

var idle_animations := ["chicken_idle", "chicken_idle_blink"]


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
	if chicken:
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


## Applies the movement based on the current direction and speed within this state,
## also flip the sprite and play the animation according to actor's movement.
func physics_update(_delta: float) -> void:
	if chicken:
		chicken.velocity.x = move_direction * move_speed
		
		# Flip the sprite based on the direction of movement
		if chicken.velocity.x > 0:
			visual.flip_h = false
		elif chicken.velocity.x < 0:
			visual.flip_h = true
		
		# Play walking animation if the chicken is moving
		if abs(chicken.velocity.x) > 0:
			visual.play("chicken_walk")
		else:
			# Avoid replaying the same idle animation if it's already playing
			if (visual.is_playing() and visual.animation in idle_animations):
				pass
			else:
				# Randomly choose an idle animation if the chicken is not moving
				if (idle_animations.is_empty()):
					visual.play("chicken_idle")
				visual.play(idle_animations[randi() % idle_animations.size()])
