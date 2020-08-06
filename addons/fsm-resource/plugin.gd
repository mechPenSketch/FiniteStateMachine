tool
extends EditorPlugin


func _enter_tree():
	
	# ADDING NODES UNIQUE TO THIS PLUGIN
	add_custom_type("FSM", "Node", preload("res://addons/fsm-resource/classes/fsm.gd"), preload("res://addons/fsm-resource/icons/fsm.svg"))


func _exit_tree():
	
	# REMOVING NODES UNIQUE TO THIS PLUGIN
	remove_custom_type("FSM")
