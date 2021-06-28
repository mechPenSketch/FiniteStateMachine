tool
extends GraphNode

var associated_component:Node

var is_connectable = true

func _gui_input(e):
	
	if is_connectable:
		if e is InputEventMouse:
			# GET MOUSE POSITION X
			var mouse_x = e.get_position().x
			
			# GET WIDTH
			var width = get_size().x
			
			if mouse_x <= width / 4:
				get_material().set_shader_param("is_hovered", true)
				get_material().set_shader_param("hover_is_right", false)
				if e is InputEventMouseButton and e.is_pressed():
					print("connect from...")
			elif mouse_x >= width * 0.75:
				get_material().set_shader_param("is_hovered", true)
				get_material().set_shader_param("hover_is_right", true)
				if e is InputEventMouseButton and e.is_pressed():
					print("connect to...")
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
