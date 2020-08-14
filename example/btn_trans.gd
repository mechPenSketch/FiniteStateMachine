extends Transition

class_name ButtonTransition

# ASSOCIATED BUTTON
export (NodePath) var np_button
var button

func condition_is_met()->bool:
	return button.pressed

func set_fsm(f):
	.set_fsm(f)
	button = f.get_node(np_button) 
