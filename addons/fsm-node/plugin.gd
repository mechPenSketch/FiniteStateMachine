tool
extends EditorPlugin


func _enter_tree():
	
	# ADDING NODES UNIQUE TO THIS PLUGIN
	add_custom_type("FSM", "Node", preload("classes/fsm.gd"), preload("icons/fsm.svg"))
	add_custom_type("State", "Node", preload("classes/state.gd"), preload("icons/state.svg"))
	add_custom_type("Transition", "Node", preload("classes/transition.gd"), preload("icons/transition.svg"))


func _exit_tree():
	
	# REMOVING NODES UNIQUE TO THIS PLUGIN
	remove_custom_type("FSM")
	remove_custom_type("State")
	remove_custom_type("Transition")
