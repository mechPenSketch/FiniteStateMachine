tool
extends GraphEdit

var associated_fsm
var title

func _on_connection_request(str_from, from_port, str_to, to_port):
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
	else:
		# TRANSITION TO STATE
		
		#	FOR EVERY CONNECTIONS
		for c in get_connection_list():
			# IF EITHER SIDE MATCHES
			if c["from"] == str_from or c["to"] == str_to:
				
				# DISCONNECT FROM THAT NODE
				disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
				
				#	IF THE CONNECTION IS SUCESSFULLY MADE,
				if connect_node(str_from, from_port, str_to, to_port) == OK:
					# SET TARGET STATE
					nd_from.target_state = nd_from.get_path_to(gn_to.associated_component)

func set_associated_fsm(node):
	associated_fsm = node
