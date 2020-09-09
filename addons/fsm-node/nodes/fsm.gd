tool
extends Node

class_name FSM, "icons/fsm.svg"

var current_state
var state_tranistion_indexes
export(NodePath) var starting_state

func _ready():
	# If this is not Editor Hint
	if !Engine.editor_hint:
	# If the starting_state is defnied, we'll use it
		if starting_state:
			current_state = get_node(starting_state)
			current_state.set_active(true)
	# Otherwise, we'll use the first state in our children
		else:
			for c in get_children():
				if c.get_class() == "State":
					current_state = c
					c.set_active(true)
					break

func _get_configuration_warning():
	# to get called by update_configuration_warning() when there's a change in tree
	
	for c in get_children():
		if c.is_class("State"):
			return ""
	return "Add at least one State to this node."
	
func activate_state(s):
	# SET STATE
	current_state = s
	current_state.set_active(true)

func change_state(s):
	deactivate_state()
	activate_state(s)

func deactivate_state():
	current_state.set_active(false)

func get_class():
	return "FSM"

func is_class(c):
	return c == get_class() or .is_class(c)
