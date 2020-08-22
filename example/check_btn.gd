extends CheckButton

func _on_stop_activated():
	set_disabled(false)

func _on_wait_activated():
	set_disabled(true)
