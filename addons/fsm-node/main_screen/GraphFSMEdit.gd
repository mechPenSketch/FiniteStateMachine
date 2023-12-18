@tool
extends GraphEdit

const CONNECT_COMP := "graph_comp"
const CONNECT_ISFFROM := "is_from"
const CONNECT_SNAP := "snap"

@export_group("Connection Lines")
@export_color_no_alpha var line_color: Color

var associated_fsm: FSM

var comp_connections = []
var pending_connection = {}

func _draw():
	for c in comp_connections:
		var from = c["from"].position_offset * zoom - scroll_offset
		var to = c["to"].position_offset * zoom - scroll_offset
		
		draw_line(from, to, line_color, get_connection_lines_thickness())
	
	if pending_connection:
		var target_pos: Vector2
		if CONNECT_SNAP in pending_connection and pending_connection[CONNECT_SNAP]:
			target_pos = pending_connection[CONNECT_SNAP].get_position()
		else:
			target_pos = get_local_mouse_position()
		
		var from_pos: Vector2
		var to_pos: Vector2
		
		if pending_connection[CONNECT_ISFFROM]:
			from_pos = pending_connection[CONNECT_COMP].position_offset * zoom - scroll_offset
			to_pos = target_pos
		else:
			from_pos = target_pos
			to_pos = pending_connection[CONNECT_COMP].position_offset * zoom - scroll_offset
		
		draw_line(from_pos, to_pos, line_color, get_connection_lines_thickness())


func _gui_input(event):
	if pending_connection:
		if event is InputEventMouseButton:
			if event.is_released() and event.get_button_index() == MOUSE_BUTTON_LEFT:
				pending_connection.clear()
				queue_redraw()
		
		elif event is InputEventMouseMotion:
			if pending_connection:
				for c in get_children():
					if c != pending_connection[CONNECT_COMP] and c._has_point(event.get_position() - c.position_offset):
						pending_connection[CONNECT_SNAP] = c
						queue_redraw()
						return
				
				pending_connection[CONNECT_SNAP] = null
				queue_redraw()


func _on_connection_request(str_from, from_port, str_to, to_port):
	
	# If the connection is not already made,
	if !is_node_connected(str_from, from_port, str_to, to_port):
		var gn_from = get_node(NodePath(str_from))
		var gn_to = get_node(NodePath(str_to))
		var nd_from = gn_from.associated_component
		var nd_to = gn_to.associated_component
		
		if nd_from is State and nd_to is Transition:
			# State to Transition
			
			#	If connection is successfully made,
			if connect_node(str_from, from_port, str_to, to_port) == OK:
				# Add Transition to the list
				nd_from.transitions.append(nd_to)
				
				# Update property list
				nd_from.notify_property_list_changed()
			
		elif nd_from is Transition and nd_to is State:
			# Transition to State
			
			#	For every connections
			for c in get_connection_list():
				# If "from" side is the same,
				if c["from"] == str_from:
					
					# Disconnect from that Node
					_on_disconnection_request(c["from"], c["from_port"], c["to"], c["to_port"])
					
			#	If connection is successfully made,
			if connect_node(str_from, from_port, str_to, to_port) == OK:
				# Set target State
				nd_from.target_state = nd_to
				
				# Update property list
				nd_from.notify_property_list_changed()


func _on_disconnection_request(str_from, from_port, str_to, to_port):
	disconnect_node(str_from, from_port, str_to, to_port)
	
	var gn_from = get_node(NodePath(str_from))
	var nd_from = gn_from.associated_component
	var connection_type = gn_from.get_connection_output_type(0)
	if connection_type == 1:
		# State to Transition
		var gn_to = get_node(NodePath(str_to))
		var nd_to = gn_to.associated_component
		nd_from.transitions.erase(nd_to)
	
	else:
		# Transition to State
		nd_from.target_state = null
		
	# Update property list
	nd_from.notify_property_list_changed()


func add_title_label(s: String):
	var fsm_title = Label.new()
	fsm_title.set_text(s)
	get_menu_hbox().add_child(fsm_title)
	get_menu_hbox().move_child(fsm_title, 0)


func connect_comp_nodes(connections: Array):
	comp_connections = []
	
	for c in connections:
		var dict = {
				"from": c["from"].associated_graph_node,
				"to": c["to"].associated_graph_node,
			}
		
		comp_connections.append(dict)


func set_associated_fsm(node):
	associated_fsm = node


func start_pending_connection(graph_ele: GraphElement, is_to: bool):
	pending_connection = {
			CONNECT_COMP: graph_ele,
			CONNECT_ISFFROM: is_to,
		}
