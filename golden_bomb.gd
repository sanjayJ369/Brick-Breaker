extends StaticBody2D

export var brick_life = 15
var life = brick_life

onready var ani = $AnimatedSprite
onready var audio = $AudioStreamPlayer2D
signal nuclear

var check = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$brick_life.text = str(life)
	
func _process(delta):
	
	if life < 10 and life >= 1:
		ani.play("on")
		
	if life <= 0:
		$brick_life.text = " "
		
	if check < 1 and life == 0:
		check = check + 1
		$brick_life.text = " "
		emit_signal("nuclear")
		ani.position = ani.to_local(Vector2(512,448))
		ani.play("blast")
		audio.play()
		yield($AnimatedSprite, "animation_finished")
		queue_free()
		
func take_life():
	life -= 1
	$brick_life.text = str(life)
	

