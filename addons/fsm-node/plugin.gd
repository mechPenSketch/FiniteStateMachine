tool
extends EditorPlugin

var MainPanel = preload("main_screen/MainPanel.tscn")
var main_panel_instance

var graph_fsm_edit_root
var GraphFsmEdit = preload("main_screen/GraphFSMEdit.tscn")
var GraphNodes = {"state": preload("main_screen/graph_nodes/GraphState.tscn"),
"transition":  preload("main_screen/graph_nodes/GraphTransition.tscn")}

var toolbar_btns:Dictionary
var toolbar_btns_pressed_methods:Dictionary
var tool_mode
enum {TOOL_SELECT, TOOL_MOVE}
var select_state:bool = true
var select_transition:bool = true

func _enter_tree():
	# SET UP MAIN SCREEN
	main_panel_instance = MainPanel.instance()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	make_visible(false)
	
	# SET TOOLBAR
	#	GET BUTTONS
	toolbar_btns = {
		"select": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Select"),
		"move": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Move"),
		"state":  main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer2/State"),
		"transition":  main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer2/Transition"),
		"addstate": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer3/AddState"),
		"addtransition": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer3/AddTransition")
	}
	
	#	REUSE GODOT ICONS
	toolbar_btns["select"].set_button_icon(get_editor_interface().get_base_control().get_icon("ToolSelect", "EditorIcons"))
	toolbar_btns["move"].set_button_icon(get_editor_interface().get_base_control().get_icon("ToolMove", "EditorIcons"))
	
	#	DEFINE PRESS METHODS
	toolbar_btns_pressed_methods = {
		"select": "_on_select_pressed",
		"move": "_on_move_pressed",
		"state": "_on_state_pressed",
		"transition": "_on_transition_pressed",
		"addstate": "_on_addstate_pressed",
		"addtransition": "_on_addtransition_pressed"
	}
	
	#	CONNECT SIGNALS
	for k in toolbar_btns.keys():
		toolbar_btns[k].connect("pressed", self, toolbar_btns_pressed_methods[k])
	
	# GRAPHWORKS
	graph_fsm_edit_root = main_panel_instance.get_node("ScrollContainer/VBoxContainer")
	get_tree().connect("node_added", self, "_on_node_added_to_tree")
	get_tree().connect("node_removed", self, "_on_node_removed_from_tree")
	get_tree().connect("node_renamed", self, "_on_node_in_tree_renamed")

func _exit_tree():
	# DISCONNECT SIGNALS
	for k in toolbar_btns.keys():
		toolbar_btns[k].disconnect("pressed", self, toolbar_btns_pressed_methods[k])
	
	toolbar_btns = {}
	
	if main_panel_instance:
		main_panel_instance.queue_free()

func get_plugin_icon():
	return preload("main_screen/icon.svg")

func get_plugin_name():
	return "FSM"

func has_main_screen():
	return true
	
func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

# TOOLBAR BUTTON FUNCTIONS
func _on_select_pressed():
	tool_mode = TOOL_SELECT
	
func _on_move_pressed():
	tool_mode = TOOL_MOVE
	
func _on_state_pressed(b):
	select_state = b
	
func _on_transition_pressed(b):
	select_transition = b

func _on_addstate_pressed():
	pass
	
func _on_addtransition_pressed():
	pass

# GRAPHWORKS
func _on_node_added_to_tree(node):
	
	if node is FSM:
		# ADD NEW FSM GRAPH
		var gfe_instance = GraphFsmEdit.instance()
		graph_fsm_edit_root.add_child(gfe_instance)
		node.associate_graph_edit = gfe_instance
		gfe_instance.set_associated_fsm(node)
		
		# GIVE IT A LABEL
		var fsm_title = Label.new()
		fsm_title.set_text(node.get_name())
		gfe_instance.get_zoom_hbox().add_child(fsm_title)
		gfe_instance.get_zoom_hbox().move_child(fsm_title, 0)
		gfe_instance.title = fsm_title
		
		# REARRANGE PLACEMENT
		var selfnode_pos = node.get_position_in_parent()
		var selfgraph_indx = gfe_instance.get_index()
		var target_indx
		for i in range(selfgraph_indx-1, 0, -1):
			if graph_fsm_edit_root.get_child(i).associated_fsm.get_position_in_parent() > selfnode_pos:
				target_indx = i
			else:
				break
		if target_indx != null:
			graph_fsm_edit_root.move_child(gfe_instance, target_indx)
			
		# PREPARE IT TO GET CONNECTED
		node.connect("ready", self, "_on_fsm_ready", [node], CONNECT_ONESHOT)
	
	elif node is FSM_Component:
		var parent = node.get_parent()
		if parent is FSM:
			var gfe = parent.associate_graph_edit
			
			var is_state = node is State
			add_graph_node("state" if is_state else "transition", gfe, node)
			if is_state:
				# IF THERE ARE ANY CONNECTIONS
				if node.transitions:
					for t in node.transitions:
						parent.connections += [{"from": node, "to": node.get_node(t)}]
				
			else:
				# IF THERE IS ANY CONNECTION
				if node.target_state:
					parent.connections += [{"from": node, "to": node.get_node(node.target_state)}]

func _on_node_removed_from_tree(node):
	if node is FSM:
		node.associate_graph_edit.queue_free()
		
	elif node is FSM_Component:
		node.associated_graph_node.queue_free()

func _on_node_in_tree_renamed(node):
	if node is FSM:
		node.associate_graph_edit.title.set_text(node.get_name())
		
	elif node is FSM_Component:
		node.associated_graph_node.set_name(node.get_name())

func _on_fsm_ready(fsm_node):
	#	CONNECT EVERYTHING TOGETHER
	for c in fsm_node.connections:
		fsm_node.associate_graph_edit.connect_node(c["from"].get_name(), 0, c["to"].get_name(), 0)

func add_graph_node(key, fsm_root, base):
	var gn = GraphNodes[key].instance()
	fsm_root.add_child(gn)
	base.associated_graph_node = gn
	gn.set_associated_component(base)
	
	gn.set_offset(base.graph_offset)
	gn.set_name(base.get_name())

# INTERFACE INTERACTIONS
