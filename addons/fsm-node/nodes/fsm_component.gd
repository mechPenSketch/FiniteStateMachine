@tool
class_name FSM_Component
extends Node
## A node representing one part of an FSM system. It is to be a child of an FSM node.
##
## In the FSM workspace, it is represented by a [GrpahNode].

var active = false

signal activate
signal deactivate

@export_group("Graph Workspace")
@export var graph_offset: Vector2

var associated_graph_node

func _ready():
	if !Engine.is_editor_hint():
		activate.connect(_activate)
		deactivate.connect(_deactivate)


func _get_configuration_warning():
	return "This is a base class not intended to be used as a node."


func _activate():
	pass


func _deactivate():
	pass


func get_class():
	return "FSM_Component"


func is_class(c):
	return c == get_class() or super.is_class(c)


## Returns whether this component is active.
func is_active()-> bool:
	return active
