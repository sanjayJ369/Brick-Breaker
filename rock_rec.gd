extends StaticBody2D

export var brick_life = 15
var life = brick_life

# Called when the node enters the scene tree for the first time.
func _ready():
	$brick_life.text = str(life)
func take_life():
	life -= 1
	$brick_life.text = str(life)
	if life == 0:
		queue_free()
