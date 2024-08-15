extends Node
## This script manages a state machine, controlls transitions between states.
##
## The state machine allows an object to switch between different states, each
## of which controls specific behavior. States are represented as nodes that
## inherit from the State class. This script handles the setup, updates,
## and transitions of these states.

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


## Called when the node enters the scene tree. Initializes the state machine.
func _ready():
	# Loop through all children of the node and register states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	# Enter the initial state if it's set
	if initial_state:
		initial_state.enter()
		current_state = initial_state


## Called every frame to update the current state.
func _process(delta):
	if current_state:
		current_state.update(delta)


## Called every physics frame to update the physics for the current state.
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


## Handles state transitions when a state emits a transition signal.
## The state machine will switch to the new state specified by the signal.
func on_child_transition(state, new_state_name) -> void:
	# Only handle the transition if it originates from the current active state
	if state != current_state:
		return
	
	# Retrieve the new state from the states dictionary
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Exit the current state and enter the new state
	if current_state:
		current_state.exit()
	new_state.enter()
	
	# Update the current state to the new state
	current_state = new_state
