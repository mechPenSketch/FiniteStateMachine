extends AnimationPlayer

signal countdown_finished

func _on_countdown_finished():
	play("Idle")

func _on_wait_activated():
	play("Countdown")
