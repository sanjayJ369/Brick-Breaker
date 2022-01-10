extends KinematicBody2D

var linear_velocity = Vector2(500,500)
export var ball_life = 9
var aim = true
onready var audio = $AudioStreamPlayer2D
var delay = 0.05

func _ready():
	
	$Timer.start(ball_life)
	$Timer2.start(delay)
	

func _physics_process(delta):
	
	var coll = move_and_collide(linear_velocity*delta)
	if coll:
		linear_velocity = linear_velocity.bounce(coll.normal)
		if coll.collider.has_method("take_life") and aim == true:
			coll.collider.take_life()
		if coll.collider.has_method("kill_ball") and aim == true:
			queue_free()
			

func _on_Timer_timeout():
	queue_free()



func _on_Timer2_timeout():
	audio.play()
