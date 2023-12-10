@tool
extends CompGraphElement

func draw_frame(size):
	var half_width = size.x / 2
	var half_height = size.y / 2
	half_height += get_theme_constant("border_margin", THEME_TYPE)
	
	var right = half_width
	var rightest = right + half_height
	var left = -right
	var leftest = left - half_height
	
	var down = half_height
	var up = -down
	
	var points = [
		Vector2(leftest, 0),
		Vector2(left, up),
		Vector2(right, up),
		Vector2(rightest, 0),
		Vector2(right, down),
		Vector2(left, down),
	]
	
	draw_colored_polygon(points, get_theme_color("frame", THEME_TYPE))
	
	points.append(points[0])
	draw_polyline(points, get_border_color(), get_theme_constant("border_width", THEME_TYPE))
