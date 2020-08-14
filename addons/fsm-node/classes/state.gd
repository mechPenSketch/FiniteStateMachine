tool
extends Node

class_name State

var active = false

export(Array, NodePath) var transitions
var transition_nodes = []

# GRAPH
var position:= Vector2()

# SIGNALS
signal activate
signal deactivate

func _get_configuration_warning():
	return "" if get_parent() is FSM else "Parent should be FSM."

func _ready():
	if !Engine.editor_hint:
		set_physics_process(false)
		set_process(false)
		set_process_input(false)
		
		for np in transitions:
			transition_nodes += [get_node(np)]

func get_class():
	return "State"

func set_active(b:bool):
	active = b
	
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
	
	emit_signal("activate" if active else "deactivate")

func set_transitions():	
	for t in transitions:
		t.set_active(active)
