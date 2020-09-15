tool
extends EditorPlugin

func _enter_tree():
	pass

func _exit_tree():
	pass

func get_plugin_icon():
	return preload("main_scene/icon.svg")

func get_plugin_name():
	return "FSM"
