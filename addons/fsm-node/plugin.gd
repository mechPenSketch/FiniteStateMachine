tool
extends EditorPlugin

var MainPanel = preload("main_screen/MainPanel.tscn")
var main_panel_instance
var main_panel_graphedit

var toolbar_btns:Dictionary
var toolbar_btns_pressed_methods:Dictionary

func _enter_tree():
	main_panel_instance = MainPanel.instance()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	make_visible(false)
	main_panel_graphedit = main_panel_instance.get_node("GraphEdit")
	
	# SET TOOLBAR BUTTONS
	toolbar_btns = {
		"select": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Select"),
		"move": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer/Move"),
		"fsm": main_panel_instance.get_node("MarginContainer/HBoxContainer/HBoxContainer2/FSM"),
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
		"fsm": "_on_fsm_pressed",
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
	toolbar_btns["fsm"].set_pressed(true)

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

func _on_fsm_pressed():
	
	# UN-PRESS STATE AND TRANSITION
	pass
	
func _on_state_pressed():
	
	# UN-PRESS FSM
	pass
	
func _on_transition_pressed():
	
	# UN-PRESS FSM
	pass

func _on_addstate_pressed():
	pass
	
func _on_addtransition_pressed():
	pass

func check_drawable_fsm_then_children(node):
	for c in node.get_children():
		check_drawable_fsm_then_children(c)

func update_graph_fsm():
	# CLEAR PREVIOUS DIAGRAM
	for c in main_panel_graphedit.get_children():
		c.queue_free()
		
	check_drawable_fsm_then_children(get_tree().get_edited_scene_root())
