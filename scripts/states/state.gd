class_name State
extends Node
## Base State class for a state machine.
##
## This class serves as a base for all states in a state machine. It defines the 
## structure and common functionality that states must implement. Each state should 
## handle its own logic for entering, exiting, updating, and physics updates. States 
## can also signal transitions to other states.

signal transitioned  # Signal emitted when the state wants to transition to another state


## Called when entering the state.
## Override this function in derived classes to define behavior when the state is entered.
func enter() -> void:
	pass


## Called when exiting the state.
## Override this function in derived classes to define behavior when the state is exited.
func exit() -> void:
	pass


## Called every frame to update the state.
## Override this function in derived classes to define per-frame logic.
func update(_delta: float) -> void:
	pass


## Called every physics frame to update the state.
## Override this function in derived classes to define physics-related logic.
func physics_update(_delta: float) -> void:
	pass
