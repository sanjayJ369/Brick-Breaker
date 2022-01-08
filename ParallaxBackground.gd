extends ParallaxBackground


export var speed = 21
export var xy = 0#0 for y and 1 for x


func _process(delta):
	if xy == 0:
		scroll_offset.y += speed * delta
	elif xy == 1:
		scroll_offset.x += speed * delta
