extends StaticBody2D

export var brick_life = 15
var life = brick_life
var blast = false
onready var ani = $AnimatedSprite
onready var rays = $rays



# Called when the node enters the scene tree for the first time.
func _ready():

	$brick_life.text = str(life)
	
func _process(delta):
	

	if life < 10 and life > 1:
		ani.play("on")
	
	if life == 0:
		$brick_life.text = "  "
		$CollisionShape2D.disabled = true
		#$Timer.start(0.5)
		ani.play("blast")
		destroy()
		yield($AnimatedSprite, "animation_finished")
		queue_free()
	
func take_life():
	life -= 1
	$brick_life.text = str(life)
	if life == 0:
		pass
		#destroy()#destroy all the adjasent blocks 
		
func destroy():
	var count = $rays.get_child_count()
	for i in range(count):
		var node = "RayCast2D" + String(i+1)
		if rays.get_node(node).is_colliding():
			if rays.get_node(node).get_collider().has_method("take_life"):
				rays.get_node(node).get_collider().take_life()
	


func _on_Timer_timeout():
	queue_free()



func _on_AnimatedSprite_animation_finished():
	if blast:
		queue_free()
