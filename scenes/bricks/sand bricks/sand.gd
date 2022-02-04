extends StaticBody2D


export var brick_life = 15
export(bool) var infinite_balls = false 
var life = brick_life

# Called when the node enters the scene tree for the first time.
func _ready():
	if !infinite_balls:
		$brick_life.text = str(life)
func take_life():
	if !infinite_balls:
		life -= 1
		$brick_life.text = str(life)
	if life == 0:
		queue_free()
		
func kill_ball():
	pass
