class_name ChickenAvoid
extends State
## Manages the chicken's behavior when avoiding the mouse pointer.
##
## In the ChickenAvoid state, the chicken will run away from the mouse pointer 
## at an increased speed. If the mouse moves a certain distance away, the chicken 
## will transition back to its roaming state.

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D
@export var move_speed := 120.0

var screen_left_bound: float = 25.0
var screen_right_bound: float


## Keeps the chicken within screen boundaries.
func boundary() -> void:
	if chicken.position.x <= screen_left_bound:
			chicken.position.x = screen_left_bound
	elif chicken.position.x >= screen_right_bound:
		chicken.position.x = screen_right_bound


## Sets the screen boundaries when entering the state.
func enter() -> void:
	screen_right_bound = DisplayServer.screen_get_size().x - 25.0


## Handles movement, animation, and state transition based on mouse position.
func physics_update(_delta: float) -> void:
	if chicken:
		# Calculate the direction away from the mouse
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var direction: Vector2 = mouse_position - chicken.global_position
		
		# Move the chicken in the opposite direction of the mouse at increased speed
		chicken.velocity.x = -direction.normalized().x * move_speed
		
		# Ensure the chicken stays within the screen boundaries
		boundary()
		
		# Play the running animation
		visual.play("chicken_run")
		
		# Transition back to ChickenRoam if the mouse is far enough away
		if direction.length() > 300:
			transitioned.emit(self, "ChickenRoam")


## Transition to ChickenDrag if the mouse reaches the chicken.
func _on_mouse_area_mouse_entered():
	transitioned.emit(self, "ChickenDrag")
