extends CharacterBody2D
## Chicken pet class.
##
## This class represents a chicken pet character in the game. It updates the 
## clickable area dynamically, allowing mouse events to interact with the chicken.

@export var collision_polygon_2d: CollisionPolygon2D


## Called every physics frame to update the chicken's movement.
func _physics_process(_delta):
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
