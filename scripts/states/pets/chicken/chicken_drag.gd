class_name ChickenDrag
extends State
## Manages the chicken's behavior when being dragged by the user.
##
## In this state, the chicken can be dragged to a new position by clicking and 
## dragging the mouse. When the mouse is released, the chicken transitions back 
## to the previous state or another specified state.

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D

#var pressed = false
#var mouse_offset: Vector2

func physics_update(_delta: float) -> void:
	if chicken:
		# Dragging functionality need more work, so far is not good for release
		#if Input.is_action_just_pressed("left_mouse_button"):
			#mouse_offset = get_viewport().get_mouse_position() - chicken.global_position
		#
		#if Input.is_action_pressed("left_mouse_button"):
			#chicken.global_position = get_viewport().get_mouse_position() - mouse_offset
		#elif Input.is_action_just_released("left_mouse_button"):
			#transitioned.emit(self, "ChickenAvoid")
		
		chicken.velocity = Vector2(0, 0)
		
		visual.play("chicken_fright")


## Transition back to ChickenAvoid when the mouse exist the chicken.
func _on_mouse_area_mouse_exited():
	transitioned.emit(self, "ChickenAvoid")
