@tool
extends CompGraphElement

var left: float
var leftest: float
var right: float
var rightest: float
var up: float
var down: float

func draw_frame(size):
	var half_width = size.x / 2
	var half_height = size.y / 2
	half_height += get_theme_constant("border_margin", THEME_TYPE)
	
	right = half_width
	rightest = right + half_height
	left = -right
	leftest = left - half_height
	
	down = half_height
	up = -down
	
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


func mouse_is_in(event: InputEvent)-> bool:
	var mouse_in_local = event.get_position() - get_global_position()
	var mouse_posx = mouse_in_local.x
	var mouse_posy = mouse_in_local.y
	
	if mouse_posx > leftest and mouse_posx < rightest:
		is_hover = mouse_posx <= left or mouse_posx >= right
		if is_hover:
			hover_is_right = mouse_posx > 0
			var pos_from_cor = abs(mouse_in_local) - Vector2(right, 0)
			var opp_y = down - pos_from_cor.y
			return pos_from_cor.y < down and opp_y > pos_from_cor.x
		else:
			return mouse_posy > up and mouse_posy < down
	else:
		return false
