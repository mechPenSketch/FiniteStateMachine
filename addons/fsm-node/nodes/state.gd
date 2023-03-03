@tool
@icon("icons/state.svg")
class_name State
extends FSM_Component

@export var transitions: Array[NodePath]
var transition_nodes = []

func _get_configuration_warning():
	return "" if get_parent().is_class("FSM") else "Parent should be FSM."

func _ready():
	super._ready()
	
	if !Engine.is_editor_hint():
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
	set_transitions()
	
	emit_signal("activate" if active else "deactivate")

func set_transitions():
	for t in transition_nodes:
		t.set_active(active)
