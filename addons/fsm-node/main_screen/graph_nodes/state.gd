@tool
extends CompGraphElement

var radius_sqaured: float

func _on_gui_input(event):
	var length_thrice_squared = event.get_position().x - get_global_position().x
	length_thrice_squared *= 3
	length_thrice_squared **= 2
	is_hover = length_thrice_squared > radius_sqaured
	
	hover_is_right = event.get_position().x > get_global_position().x
	
	super._on_gui_input(event)


func draw_frame(size):
	var radius
	if size.x >= size.y:
		radius = size.x
	else:
		radius = size.y
	radius /= 2
	radius += get_theme_constant("border_margin", THEME_TYPE)
	if get_parent() is GraphEdit:
		radius *= get_parent().zoom
	
	radius_sqaured = radius ** 2
	
	draw_circle(Vector2.ZERO, radius, get_theme_color("frame", THEME_TYPE))
	
	draw_arc(Vector2.ZERO, radius, 0, 2 * PI, 32, get_border_color(), get_theme_constant("border_width", THEME_TYPE))


func mouse_is_in(event: InputEvent)-> bool:
	return event.get_position().distance_squared_to(get_global_position()) <= radius_sqaured
