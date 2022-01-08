extends RigidBody2D

export var life = 15
export var delay = 0.05
var life_time = 15
onready var audio = $AudioStreamPlayer2D

func _ready():
	life_time = life
	$Timer.start(life_time)
	$Timer2.start(delay)
	pass
	

func _on_Timer_timeout():
	queue_free()


func _on_ball_body_entered(body):
	
	if body.is_in_group("brick"):
		body.take_life()



func _on_Timer2_timeout():
	audio.play()
