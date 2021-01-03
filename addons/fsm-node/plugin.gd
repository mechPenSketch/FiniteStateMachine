tool
extends EditorPlugin

var editor_selection

var MainPanel = preload("main_screen/MainPanel.tscn")
var main_panel_instance

var behind_popup
var PopupNewState = preload("res://addons/fsm-node/popups/NewState.tscn")
var PopupNewTransition = preload("res://addons/fsm-node/popups/NewTransition.tscn")
var popup_new_state
var popup_new_transition
var parent_fsm

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
	editor_selection = get_editor_interface().get_selection()
	editor_selection.connect("selection_changed", self, "_on_selection_changed")
	
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
	
	# ADD POPUP DIALOGS
	behind_popup = get_script_create_dialog().get_parent()
	popup_new_state = PopupNewState.instance()
	behind_popup.add_child(popup_new_state)
	popup_new_state.connect("confirmed", self, "_make_new_state")
	popup_new_transition = PopupNewTransition.instance()
	behind_popup.add_child(popup_new_transition)
	popup_new_transition.connect("confirmed", self, "_make_new_transition")
	
	# GRAPHWORKS
	graph_fsm_edit_root = main_panel_instance.get_node("ScrollContainer/VBoxContainer")
	get_tree().connect("node_added", self, "_on_node_added_to_tree")
	get_tree().connect("node_removed", self, "_on_node_removed_from_tree")
	get_tree().connect("node_renamed", self, "_on_node_in_tree_renamed")

func _exit_tree():
	
	# REMOVE POPUP DIALOGS
	popup_new_transition.queue_free()
	popup_new_state.queue_free()
	
	# DISCONNECT SIGNALS
	for k in toolbar_btns.keys():
		toolbar_btns[k].disconnect("pressed", self, toolbar_btns_pressed_methods[k])
	
	toolbar_btns = {}
	
	# REMOVE MAIN PANEL
	if main_panel_instance:
		main_panel_instance.queue_free()
	
	editor_selection.disconnect("selection_changed", self, "_on_selection_changed")

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
func _on_selection_changed():
	for n in editor_selection.get_selected_nodes():
		if n is FSM:
			parent_fsm = n
			set_add_component_disabled(false)
			return
		elif n is FSM_Component:
			parent_fsm = n.get_parent()
			set_add_component_disabled(false)
			return
	
	set_add_component_disabled(true)

func _on_select_pressed():
	tool_mode = TOOL_SELECT
	
func _on_move_pressed():
	tool_mode = TOOL_MOVE
	
func _on_state_pressed(b):
	select_state = b
	
func _on_transition_pressed(b):
	select_transition = b

func _on_addstate_pressed():
	popup_new_state.popup_centered()
	
func _on_addtransition_pressed():
	popup_new_transition.popup_centered()

func _make_new_state():
	# GENERATE NEW EVENT
	var inst_state = State.new()
	
	#	NAME OF NEW EVENT
	var nd_input = popup_new_state.find_node("Name")
	var new_name = nd_input.get_text()
	if new_name:
		inst_state.set_name(new_name)
		
		# CLEAR INPUT
		nd_input.clear()
	parent_fsm.add_child(inst_state)
	inst_state.set_owner(get_tree().get_edited_scene_root())

func _make_new_transition():
	# GENERATE NEW EVENT
	var inst_state = Transition.new()
	
	#	NAME OF NEW EVENT
	var nd_input = popup_new_transition.find_node("Name")
	var new_name = nd_input.get_text()
	if new_name:
		inst_state.set_name(new_name)
		
		# CLEAR INPUT
		nd_input.clear()
	parent_fsm.add_child(inst_state)
	inst_state.set_owner(get_tree().get_edited_scene_root())

func set_add_component_disabled(b:bool):
	toolbar_btns["addstate"].set_disabled(b)
	toolbar_btns["addtransition"].set_disabled(b)

# GRAPHWORKS
func _on_node_added_to_tree(node):
	
	if node is FSM:
		# ADD NEW FSM GRAPH
		var gfe_instance = GraphFsmEdit.instance()
		graph_fsm_edit_root.add_child(gfe_instance)
		node.associated_graph_edit = gfe_instance
		gfe_instance.set_associated_fsm(node)
		
		# GIVE IT A LABEL
		var fsm_title = Label.new()
		fsm_title.set_text(node.get_name())
		gfe_instance.get_zoom_hbox().add_child(fsm_title)
		gfe_instance.get_zoom_hbox().move_child(fsm_title, 0)
		gfe_instance.title = fsm_title
	
	elif node is FSM_Component:
		var parent = node.get_parent()
		if parent is FSM:
			var gfe = parent.associated_graph_edit
			
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
		var gfe = node.associated_graph_edit
		graph_fsm_edit_root.remove_child(gfe)
		gfe.queue_free()
		
	elif node is FSM_Component:
		# DISCONNECT FROM AFFECTED NODE
		var parent = node.get_parent()
		if parent is FSM:
			var parent_edit = parent.associated_graph_edit
			var node_name = node.get_name()
			for c in parent_edit.get_connection_list():
				if c["from"] == node_name or c["to"] == node_name:
					parent_edit.disconnect_node(c["from"], 0, c["to"], 0)
		
		node.associated_graph_node.queue_free()

func _on_node_in_tree_renamed(node):
	if node is FSM:
		node.associated_graph_edit.title.set_text(node.get_name())
		
	elif node is FSM_Component:
		node.associated_graph_node.set_name(node.get_name())

func add_graph_node(key, fsm_root, base):
	var gn = GraphNodes[key].instance()
	fsm_root.add_child(gn)
	base.associated_graph_node = gn
	gn.set_associated_component(base)
	
	gn.set_offset(base.graph_offset)
	gn.set_name(base.get_name())
	
# INTERFACE INTERACTIONS
