@tool
@icon("icons/transition.svg")
class_name Transition
extends FSM_Component

var target_state_node
var incoming_signals

## The State to change to when condition is met.
@export var target_state: NodePath

func _ready():
	super._ready()
	
	if !Engine.is_editor_hint():
		# TARGET STATE
		target_state_node = get_node(target_state)
		
		# SIGNALS
		incoming_signals = get_incoming_connections()
		set_active(false)


func _get_configuration_warning():
	return "" if get_parent().is_class("FSM") else "Parent should be FSM."


## To recieve a signal that should be emmited when the state is to be changed.
func _condition():
	get_parent().change_state(target_state_node)


func get_class():
	return "Transition"


## (Dis)connects all incoming signals depending on the activation of the state(s) connected to it.
func set_active(b:bool):
	if b:
		for d in incoming_signals:
			d["signal"].connect(d["callable"])
	else:
		for d in incoming_signals:
			d["signal"].disconnect(d["callable"])
