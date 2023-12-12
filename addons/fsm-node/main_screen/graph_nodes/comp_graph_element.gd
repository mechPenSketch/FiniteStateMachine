@tool
class_name CompGraphElement extends GraphElement

const THEME_TYPE = "CompGraphElement"

var associated_component: FSM_Component

var comp_name: String
var is_inherited: bool

var hover_over_connection: bool
var connection_is_right: bool
var current_state: int

var dragg_offset: Vector2

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.get_button_index():
			MOUSE_BUTTON_LEFT:
				if hover_over_connection:
					if connection_is_right:
						print("r")
					else:
						print("L")


func _draw():
	var font = get_theme_font("font")
	var str_size = font.get_string_size(comp_name, HORIZONTAL_ALIGNMENT_CENTER)
	
	draw_frame(str_size)
	
	var str_pos = str_size / Vector2(-2, 4)
	var font_color
	if is_inherited:
		font_color = get_theme_color("font_inherited", THEME_TYPE)
	else:
		font_color = Color.WHITE
	draw_string(font, str_pos, comp_name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, font_color)


func _on_dragged(_from, to):
	associated_component.position_offset = to


## Override
func draw_frame(size):
	pass


func get_border_color():
	if is_selected():
		return get_theme_color("border_selected", THEME_TYPE)
	else:
		return get_theme_color("border", THEME_TYPE)


func set_associated_component(node):
	associated_component = node


## Visually indicates that the component is inherited via scene.
func set_inheritance():
	$Name.set_theme_type_variation("Inherited")


func set_comp_name(val):
	comp_name = val


func set_hover(b: bool):
	hover_over_connection = b


func set_connection_is_right(b: bool):
	connection_is_right = b
