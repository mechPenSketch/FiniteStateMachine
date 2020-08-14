tool
extends Node

class_name FSMr

export(Array, Resource) var states
export(Array, Resource) var transitions

export(int) var starting_state_index
var current_state
var state_tranistion_indexes

func _ready():
	if !Engine.editor_hint:
		if states.size():
			for i in states.size():
				states[i].set_fsm(self)
			activate_state(starting_state_index)
		
		if transitions.size():
			for i in transitions.size():
				transitions[i].set_fsm(self)

func activate_state(i):
	# SET STATE
	current_state = states[i]
	current_state.state_on()

func change_state(i):
	deactivate_state()
	activate_state(i)

func deactivate_state():
	current_state.state_off()

func get_class():
	return "FSM"

# TO BE CALLED FROM _process(delta), _physics_process(delta) or _input(event)
func logic_flow(param = null):
	current_state.state_logic(param)
	transition_to_another_state()

func transition_to_another_state():
	var transes = current_state.transition_indexes
	for i in transes.size():
		var j = transes[i]
		var trans = transitions[j]
		if trans.condition_is_met():
			change_state(trans.target_state_index)
			break
