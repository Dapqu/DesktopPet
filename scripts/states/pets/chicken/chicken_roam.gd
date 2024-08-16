class_name ChickenRoam
extends State
## Manages the chicken's roaming behavior within screen boundaries.
##
## In this state, the chicken moves in a random direction (-1, 0, or 1) at a
## constant speed for a randomly determined duration. If the chicken reaches
## the screen's edges, it changes direction to stay within the boundaries.

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D
@export var move_speed := 40.0

var move_direction: int
var roam_time: float

var screen_left_bound: float = 25.0
var screen_right_bound: float

var idle_animations: Array[String] = ["chicken_idle", "chicken_idle_blink"]


## Randomizes the direction and duration for roaming.
func randomize_roaming() -> void:
	randomize()
	move_direction = randi_range(-1, 1)
	roam_time = randf_range(1, 3)


## Plays the appropriate animation based on the chicken's movement.
func animation() -> void:
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


## Ensures the chicken stays within screen boundaries.
func boundary() -> void:
	if chicken.position.x <= screen_left_bound:
		chicken.position.x = screen_left_bound
		move_direction = 1
	elif chicken.position.x >= screen_right_bound:
		chicken.position.x = screen_right_bound
		move_direction = -1


## Sets up screen boundaries and initializes roaming behavior.
func enter() -> void:
	screen_right_bound = DisplayServer.screen_get_size().x - 25.0
	randomize_roaming()


## Updates roaming time or randomizes it when necessary.
func update(delta: float) -> void:
	# Update the roaming time or randomize roaming if the time is up
	if roam_time > 0:
		roam_time -= delta
	else:
		randomize_roaming()


## Handles movement, animation, and transitions based on state.
func physics_update(_delta: float) -> void:
	if chicken:
		# Calculate direction towards the mouse
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var direction: Vector2 = mouse_position - chicken.global_position
		
		# Apply movement based on direction and speed
		chicken.velocity.x = move_direction * move_speed
		
		boundary()
		
		# Play appropriate animation based on movement
		animation()
		
		# Transition to ChickenAvoid state if the mouse is close
		if direction.length() < 200:
			transitioned.emit(self, "ChickenAvoid")
