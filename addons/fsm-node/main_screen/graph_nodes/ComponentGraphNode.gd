tool
extends GraphNode

var associated_component:Node

func _gui_input(e):
	
	if e is InputEventMouse:
		# GET MOUSE POSITION X
		var mouse_x = e.get_position().x
		
		# GET WIDTH
		var width = get_size().x
		
		if mouse_x <= width / 4:
			print("Left")
		elif mouse_x >= width * 0.75:
			print("Right")

func _on_dragged(_from, to):
	associated_component.graph_offset = to

func set_name(val):
	.set_name(val)
	$Name.set_text(val)

func set_associated_component(node):
	associated_component = node
