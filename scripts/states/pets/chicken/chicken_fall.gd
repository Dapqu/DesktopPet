class_name ChickenFall
extends State
## Handles the chicken's behavior when it is falling from a height.
##
## This state manages gravity, horizontal movement during the fall,
## and transitions back to the roaming state when the chicken lands.

const GRAVITY := 330.0

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D
@export var move_speed := 200.0

var move_direction: int
var roam_time: float


## Randomizes the horizontal movement direction and duration for the chicken's fall.
func randomize_falling() -> void:
	randomize()
	# Choose between left (-1) or right (1)
	move_direction = randi_range(0, 1)
	if move_direction == 0:
		move_direction = -1
	roam_time = randf_range(1, 3)


## Updates the remaining time for the current fall direction or re-randomizes if time is up.
func update(delta: float) -> void:
	if roam_time > 0:
		roam_time -= delta
	else:
		randomize_falling()


## Applies gravity, horizontal movement, and checks for landing.
func physics_update(delta: float) -> void:
	# Apply horizontal movement based on the randomized direction and speed.
	chicken.velocity.x = move_direction * move_speed
	
	# Apply gravity and check if the chicken has landed on the ground.
	if chicken.global_position.y >= 720:
		chicken.global_position.y = 720
		chicken.velocity.y = 0
		transitioned.emit(self, "ChickenRoam")
	else:
		chicken.velocity.y += GRAVITY * delta
		visual.play("chicken_fall")
