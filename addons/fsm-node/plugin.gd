tool
extends EditorPlugin

var MainPanel = preload("main_screen/MainPanel.tscn")
var main_panel_instance

var graph_fsm_edit_root
var GraphFsmEdit = preload("main_screen/GraphFSMEdit.tscn")
var GraphStateEdit = preload("main_screen/graph_nodes/GraphState.tscn")
var GraphTransitionEdit = preload("main_screen/graph_nodes/GraphTransition.tscn")

var toolbar_btns:Dictionary
var toolbar_btns_pressed_methods:Dictionary

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
	pass
	
func _on_move_pressed():
	pass
	
func _on_state_pressed():
	pass
	
func _on_transition_pressed():
	pass

func _on_addstate_pressed():
	pass
	
func _on_addtransition_pressed():
	pass

# GRAPHWORKS
func check_drawable_fsm_then_children(node):
	# IF NODE EXTENDS FROM CLASS FSM
	if node.is_class("FSM"):
		# ADD NEW FSM GRAPH
		# GIVE IT A LABEL
		# ADD STATES AND TRANSITIONS
		pass
	
	# REPEAT STEP WITH CHILDREN
	for c in node.get_children():
		check_drawable_fsm_then_children(c)

func update_graph_fsm():
	# CLEAR PREVIOUS FSM GRAPHS
	for c in graph_fsm_edit_root.get_children():
		c.queue_free()
		
	check_drawable_fsm_then_children(get_tree().get_edited_scene_root())

# INTERFACE INTERACTIONS
