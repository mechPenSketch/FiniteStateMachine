tool
extends Resource

class_name Transition

var position:= Vector2()

var fsm
var target_state_index

func condition_is_met()->bool:
	return false

func get_class():
	return "Transition"

func get_current_state():
	return fsm.current_state

func set_fsm(f):
	fsm = f

func transition_on():
	pass
	
func transition_off():
	pass
