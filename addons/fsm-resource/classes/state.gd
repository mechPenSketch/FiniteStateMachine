tool
extends Resource

class_name State, "../icons/state.svg"

export(String) var name

# GRAPH
var position:= Vector2()

var fsm
export(Array, int) var transition_indexes

func get_class():
	return "State"

func state_logic(param = null):
	pass

func set_fsm(f):
	fsm = f

func state_on():
	pass
	
func state_off():
	pass
