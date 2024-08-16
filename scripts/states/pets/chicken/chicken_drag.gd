class_name ChickenDrag
extends State
## Manages the chicken's behavior when being dragged by the user.
##
## In this state, the chicken can be dragged to a new position by clicking and 
## dragging the mouse. When the mouse is released, the chicken transitions back 
## to the previous state or another specified state.

@export var chicken: CharacterBody2D
@export var visible_clickable_area: CollisionPolygon2D
@export var visual: AnimatedSprite2D

var mouse_offset: Vector2
var original_points: PackedVector2Array


## Expands the given polygon points outward by a specified distance.
func expand_polygon(polygon_points: PackedVector2Array, distance: float = 1000.0) -> PackedVector2Array:
	var center: Vector2 = get_polygon_center(polygon_points)
	var expanded_points: PackedVector2Array = []
	
	for point in polygon_points:
		var direction: Vector2 = (point - center).normalized()
		var expanded_point: Vector2 = point + direction * distance
		expanded_points.append(expanded_point)
	
	return expanded_points


## Computes the center of the polygon.
func get_polygon_center(polygon_points: PackedVector2Array) -> Vector2:
	var center: Vector2 = Vector2.ZERO
	
	for point in polygon_points:
		center += point
	
	center /= polygon_points.size()
	return center


## Initializes the original polygon points from the clickable area.
func enter() -> void:
	original_points = visible_clickable_area.polygon


## Handles dragging the chicken and updating its position.
func physics_update(_delta: float) -> void:
	if chicken:
		# Start dragging when the mouse button is pressed
		if Input.is_action_just_pressed("left_mouse_button"):
			# Expand the VisibleClickableArea for a smoother dragging feel
			visible_clickable_area.polygon = expand_polygon(visible_clickable_area.polygon)
			
			chicken.velocity = Vector2.ZERO
			# Maintain the mouse offset for a better click and drag effect
			mouse_offset = get_viewport().get_mouse_position() - chicken.global_position
		elif Input.is_action_just_pressed("right_mouse_button"):
			transitioned.emit(self, "ChickenSit")
		
		# Continue dragging while the mouse button is held down
		if Input.is_action_pressed("left_mouse_button"):
			chicken.velocity = Vector2.ZERO
			chicken.global_position = get_viewport().get_mouse_position() - mouse_offset
		# Release dragging and restore original clickable area on mouse release
		elif Input.is_action_just_released("left_mouse_button"):
			visible_clickable_area.polygon = original_points
			
			if chicken.global_position.y < 1200:
				transitioned.emit(self, "ChickenFall")
		
		# Stop any horizontal movement of the chicken during this state
		chicken.velocity.x = 0
		
		visual.play("chicken_fright")


## Transitions to the ChickenAvoid state when the mouse exits the chicken's area.
func _on_mouse_area_mouse_exited():
	transitioned.emit(self, "ChickenAvoid")
