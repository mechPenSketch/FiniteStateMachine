tool
extends Transition

var further_condition = true

# Called when the transition is activated.
func _activate():
	pass

# Called when transition's condition is met.
#	This will be called while active.
func _condition():
	if further_condition:
		._condition()

# Called when the transition is deactivated.
func _deactivate():
	pass
