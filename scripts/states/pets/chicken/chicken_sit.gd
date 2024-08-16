class_name ChickenSit
extends State
## Manages the chicken's behavior when being right_clicked by the user.
##
## In this state, the chicken will be sitting, remain stationary, until being
## right_click again, which transition it back to ChickenRoam state.

@export var chicken: CharacterBody2D
@export var visual: AnimatedSprite2D


func physics_update(_delta: float) -> void:
	if chicken:
		chicken.velocity = Vector2.ZERO
		visual.play("chicken_sit")
		
		if Input.is_action_just_pressed("right_mouse_button"):
			transitioned.emit(self, "ChickenRoam")
