tool
extends GraphEdit

var associated_fsm
var title

func _is_in_input_hotzone(np_gn, _i, m_pos):
	var graph_node = get_node(np_gn)
	var rect2 = graph_node.get_rect()
	print(rect2, m_pos)
	return Rect2(rect2.position, rect2.size * Vector2(0.25, 1)).has_point(m_pos)

func _is_in_output_hotzone(np_gn, _i, m_pos):
	var graph_node = get_node(np_gn)
	var rect2 = graph_node.get_rect()
	var d_pos_x = rect2.size.x * 0.75
	return Rect2(rect2.position + Vector2(d_pos_x, 0), rect2.size * Vector2(0.25, 1)).has_point(m_pos)

func _on_connection_request(str_from, from_port, str_to, to_port):
	
	# IF THE CONNECTION IS NOT ALREADY MADE
	if !is_node_connected(str_from, from_port, str_to, to_port):
		var gn_from = get_node(str_from)
		var gn_to = get_node(str_to)
		var nd_from = gn_from.associated_component
		
		var connection_type = gn_from.get_connection_output_type(0)
		if connection_type == 1:
			# STATE TO TRANSITION
			
			#	GET RELATIVE NODEPATH
			var target_np = nd_from.get_path_to(gn_to.associated_component)
			
			#	IF THE CONNECTION IS SUCESSFULLY MADE,
			if connect_node(str_from, from_port, str_to, to_port) == OK:
				# ADD TRANSITION TO THE LIST
				nd_from.transitions += [target_np]
						
				# UPDATE PROPERTY LIST
				nd_from.property_list_changed_notify()
		else:
			# TRANSITION TO STATE
			
			#	FOR EVERY CONNECTIONS
			for c in get_connection_list():
				# IF EITHER SIDE MATCHES
				if c["from"] == str_from or c["to"] == str_to:
					
					# DISCONNECT FROM THAT NODE
					_on_disconnection_request(c["from"], c["from_port"], c["to"], c["to_port"])
					
			#	IF THE CONNECTION IS SUCESSFULLY MADE,
			if connect_node(str_from, from_port, str_to, to_port) == OK:
				# SET TARGET STATE
				nd_from.target_state = nd_from.get_path_to(gn_to.associated_component)
				
				# UPDATE PROPERTY LIST
				nd_from.property_list_changed_notify()

func _on_disconnection_request(str_from, from_port, str_to, to_port):
	disconnect_node(str_from, from_port, str_to, to_port)
	
	var gn_from = get_node(str_from)
	var nd_from = gn_from.associated_component
	var connection_type = gn_from.get_connection_output_type(0)
	if connection_type == 1:
		# STATE TO TRANSITION
		var gn_to = get_node(str_to)
		var nd_to = gn_to.associated_component
		#	GET RELATIVE NODEPATH
		var target_np = nd_from.get_path_to(nd_to)
		nd_from.transitions.erase(target_np)
	else:
		# TRANSITION TO STATE
		nd_from.target_state = null
		
	# UPDATE PROPERTY LIST
	nd_from.property_list_changed_notify()
	
func set_associated_fsm(node):
	associated_fsm = node
