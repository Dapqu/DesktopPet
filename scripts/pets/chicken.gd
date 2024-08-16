extends CharacterBody2D
## Chicken pet class.
##
## This class represents a chicken pet character in the game. It dynamically updates
## the clickable area, allowing mouse interactions with the chicken only within the
## defined polygon area.

@export var visible_clickable_area: CollisionPolygon2D
@export var visual: AnimatedSprite2D


## Called every physics frame to update the chicken's movement and interactions.
func _physics_process(_delta):
	# Flip the sprite based on the direction of movement
	if velocity.x > 0:
		visual.flip_h = false
	elif velocity.x < 0:
		visual.flip_h = true
	
	# Move the chicken and handle collisions
	move_and_slide()
	
	# Update the clickable area after movement
	update_click_polygon()


## Updates the clickable area of the chicken.
## Mouse events outside this area will be passed through.
func update_click_polygon() -> void:
	var polygon_points: PackedVector2Array = visible_clickable_area.polygon
	for i in range(polygon_points.size()):
		polygon_points[i] = to_global(polygon_points[i])
	get_window().mouse_passthrough_polygon = polygon_points
