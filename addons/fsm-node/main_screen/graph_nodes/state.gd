@tool
extends CompGraphElement

var radius_sqaured: float

func _has_point(point)-> bool:
	if point.distance_squared_to(Vector2()) <= radius_sqaured:
		var length_thrice_squared = point.x * 3
		length_thrice_squared **= 2
		hover_over_connection = length_thrice_squared > radius_sqaured

		connection_is_right = point.x > 0
		
		return !hover_over_connection
	
	else:
		hover_over_connection = false
		return false


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
