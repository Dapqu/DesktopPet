extends CharacterBody2D
## Chicken pet class.
##
## This class represents a chicken pet character in the game. The chicken can move 
## and play different animations based on its velocity. It also updates the 
## clickable area dynamically, allowing mouse events to interact with the chicken.

@export var collision_polygon_2d: CollisionPolygon2D
@export var visual: AnimatedSprite2D

var idle_animations := ["chicken_idle", "chicken_idle_blink"]


## Called every physics frame to update the chicken's movement and animations.
func _physics_process(_delta):
	# Play walking animation if the chicken is moving
	if abs(velocity.x) > 0:
		visual.play("chicken_walk")
	else:
		# Avoid replaying the same idle animation if it's already playing
		if (visual.is_playing() and visual.animation in idle_animations):
			return
		
		# Randomly choose an idle animation if the chicken is not moving
		if (idle_animations.is_empty()):
			visual.play("chicken_idle")
		visual.play(idle_animations[randi() % idle_animations.size()])
		
		print(visual.animation)
	
	# Flip the sprite based on the direction of movement
	visual.flip_h = velocity.x < 0
	
	# Move the chicken and handle collisions
	move_and_slide()
	
	# Update the clickable area after movement
	update_click_polygon()


## Updates the clickable area of the chicken.
## Mouse events outside this area will be passed through.
func update_click_polygon() -> void:
	var collision_polygon_2d_arr := collision_polygon_2d.polygon
	for i in range(collision_polygon_2d_arr.size()):
		collision_polygon_2d_arr[i] = to_global(collision_polygon_2d_arr[i])
	get_window().mouse_passthrough_polygon = collision_polygon_2d_arr
