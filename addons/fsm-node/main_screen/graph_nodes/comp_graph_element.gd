@tool
class_name CompGraphElement extends GraphElement

const THEME_TYPE = "CompGraphElement"

var associated_component: FSM_Component

var comp_name: String
var is_inherited: bool

var is_hover: bool
var hover_is_right: bool
var current_state: int

func _draw():
	var font = get_theme_font("font")
	var text = get_name()
	var str_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER)
	
	draw_frame(str_size)
	
	var pos = global_position - str_size / Vector2(2, -4)
	var font_color
	if is_inherited:
		font_color = get_theme_color("font_inherited", THEME_TYPE)
	else:
		font_color = Color.WHITE
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, font_color)


func _on_dragged(_from, to):
	associated_component.position_offset = to


func draw_frame(size):
	var radius = size.x / 2 + 10
	draw_circle(global_position, radius, get_theme_color("frame", THEME_TYPE))
	
	draw_arc(global_position, radius, 0, 2 * PI, 32, get_border_color(), get_theme_constant("border_width", THEME_TYPE))


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
	is_hover = b


func set_hover_is_right(b: bool):
	hover_is_right = b
