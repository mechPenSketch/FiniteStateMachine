tool
extends GraphEdit

var associated_fsm

func _on_connection_request(str_from, from_port, str_to, to_port):
	var gn_from = get_node(str_from)
	var gn_to = get_node(str_to)
	var nd_from = gn_from.associated_component
	
	var connection_type = gn_from.get_connection_input_type(0)
	if connection_type == 1:
		# STATE TO TRANSITION
		
		#	GET RELATIVE NODEPATH
		var target_np = nd_from.get_path_to(gn_to.associated_component)
		
		if connect_node(str_from, from_port, str_to, to_port) == OK:
			nd_from.transitions += [target_np]
	else:
		# TRANSITION TO STATE
		pass

func set_associated_fsm(node):
	associated_fsm = node
