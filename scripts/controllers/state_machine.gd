extends Node

@export var init_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child == State:
			states[child.name.to_lower()] = child # Add to dict
			child.transitioned.connect(on_child_transition) # Connect signal	
			
	if init_state:
		init_state.enter()
		current_state = init_state # Use init state as starting state

func _process(delta):
	if current_state:
		current_state.update(delta) # Provide delta to current state

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(delta) # Provide phsyics tick to current state

func on_child_transition(state, new_state_name): # State that called, which state to trans. to
	if state != current_state:
		return # Ignore signals not from current state
	
	var new_state = states.get(new_state_name.to_lower()) # Grab new state from dict in lower
	if !new_state: # If nonexistent, ignore
		return
	
	if current_state:
		current_state.exit() # Exit the current state
	
	new_state.enter() # Enter new state
	current_state = new_state # Set new state as current state
