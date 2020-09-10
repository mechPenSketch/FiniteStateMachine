tool
extends Node

class_name FSM_Component

var active = false

# GRAPH
var position:= Vector2()

# SIGNALS
signal activate
signal deactivate

func _activate():
	pass

func _deactivate():
	pass

func _get_configuration_warning():
	return "This is a base class not intended to be used as a node."

func _ready():
	if !Engine.editor_hint:
		connect("activate", self, "_activate")
		connect("deactivate", self, "_deactivate")

func is_active():
	return active

func is_class(c):
	return c == get_class() or .is_class(c)
