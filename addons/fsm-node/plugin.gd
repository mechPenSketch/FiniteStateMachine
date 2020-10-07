tool
extends EditorPlugin

var MainPanel = preload("main_screen/MainPanel.tscn")
var main_panel_instance

var graph_fsm_edit_root
var GraphFsmEdit = preload("main_screen/GraphFSMEdit.tscn")
var GraphStateNode = preload("main_screen/graph_nodes/GraphState.tscn")
var GraphTransitionNode = preload("main_screen/graph_nodes/GraphTransition.tscn")

var toolbar_btns:Dictionary
var toolbar_btns_pressed_methods:Dictionary
var tool_mode
enum {TOOL_SELECT, TOOL_MOVE}
var select_state:bool = true
var select_transition:bool = true

func _enter_tree():
	main_panel_instance = MainPanel.instance()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	make_visible(false)
	
	# SET TOOLBAR BUTTONS
	toolbar_btns = {
		"select": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Select"),
		"move": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Move"),
		"state":  main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer2/State"),
		"transition":  main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer2/Transition"),
		"addstate": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer3/AddState"),
		"addtransition": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer3/AddTransition")
	}
	
	# REUSE GODOT ICONS
	toolbar_btns["select"].set_button_icon(get_editor_interface().get_base_control().get_icon("ToolSelect", "EditorIcons"))
	toolbar_btns["move"].set_button_icon(get_editor_interface().get_base_control().get_icon("ToolMove", "EditorIcons"))
	
	# DEFINE PRESS METHODS
	toolbar_btns_pressed_methods = {
		"select": "_on_select_pressed",
		"move": "_on_move_pressed",
		"state": "_on_state_pressed",
		"transition": "_on_transition_pressed",
		"addstate": "_on_addstate_pressed",
		"addtransition": "_on_addtransition_pressed"
	}
	
	# CONNECT SIGNALS
	for k in toolbar_btns.keys():
		toolbar_btns[k].connect("pressed", self, toolbar_btns_pressed_methods[k])
		
	# SET TOOLSELECT AND FSM TO PRESS
	toolbar_btns["select"].set_pressed(true)
	
	# GRAPHWORKS
	graph_fsm_edit_root = main_panel_instance.get_node("ScrollContainer/VBoxContainer")

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
func add_state_node(fsm_root, base):
	var gsn = GraphStateNode.instance()
	fsm_root.add_child(gsn)
	gsn.associated_component = base
	base.associated_graph_node = gsn
	
	gsn.set_offset(base.graph_offset)
	gsn.set_name(base)
	
func add_transition_node(fsm_root, base):
	var gtn = GraphTransitionNode.instance()
	fsm_root.add_child(gtn)

func check_drawable_fsm_then_children(node):
	# IF NODE EXTENDS FROM CLASS FSM
	if node.is_class("FSM"):
		# ADD NEW FSM GRAPH
		var gfe_instance = GraphFsmEdit.instance()
		graph_fsm_edit_root.add_child(gfe_instance)
		node.associate_graph_edit = gfe_instance
		gfe_instance.associated_fsm = node
		
		# GIVE IT A LABEL
		var fsm_title = Label.new()
		fsm_title.set_text(node.get_name())
		gfe_instance.get_zoom_hbox().add_child(fsm_title)
		gfe_instance.get_zoom_hbox().move_child(fsm_title, 0)
		
		# ADD STATES AND TRANSITIONS
		for c in node.get_children():
			if c.is_class("State"):
				add_state_node(node, c)
			#elif c.is_class("Transition"):
				#add_transition_node(node, c)
		
	# REPEAT STEP WITH CHILDREN
	for c in node.get_children():
		check_drawable_fsm_then_children(c)

func update_graph_fsm():
	# CLEAR PREVIOUS FSM GRAPHS
	for c in graph_fsm_edit_root.get_children():
		c.queue_free()
		
	check_drawable_fsm_then_children(get_tree().get_edited_scene_root())

# INTERFACE INTERACTIONS
