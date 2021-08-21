tool
extends GraphNode

var associated_component:Node

var is_connectable = true

func _gui_input(e):
	
	if is_connectable:
		var mouse_position = e.get_position() + get_offset()
		if e is InputEventMouse:
			if get_parent()._is_in_input_hotzone(get_path(), 0, mouse_position):
				get_material().set_shader_param("is_hovered", true)
				get_material().set_shader_param("hover_is_right", false)
			elif get_parent()._is_in_output_hotzone(get_path(), 0, mouse_position):
				get_material().set_shader_param("is_hovered", true)
				get_material().set_shader_param("hover_is_right", true)
			else:
				get_material().set_shader_param("is_hovered", false)

func _mouse_exited():
	get_material().set_shader_param("is_hovered", false)

func _on_dragged(_from, to):
	associated_component.graph_offset = to

func set_name(val):
	.set_name(val)
	$Name.set_text(val)

func set_associated_component(node):
	associated_component = node
