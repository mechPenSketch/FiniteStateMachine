@tool
extends GraphEdit

var associated_fsm: FSM

var comp_connections = []

func _draw():
	
	for c in comp_connections:
		var from = c["from"].position_offset * zoom - scroll_offset
		var to = c["to"].position_offset * zoom - scroll_offset
		
		draw_line(from, to, Color.WHITE, get_connection_lines_thickness())


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
