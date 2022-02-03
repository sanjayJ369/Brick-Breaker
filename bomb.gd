extends StaticBody2D

export var brick_life = 15
var life = brick_life
var blast = false
export var blast_bombs = 0#if 0 it will not destroy the bombs if 1 it will destroy the bombs 
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
		if rays.get_node(node).is_colliding() and rays.get_node(node).get_collider() != null:
			if rays.get_node(node).get_collider().has_method("blast"):
				rays.get_node(node).get_collider().blast()
	
	
func blast():
	if blast_bombs == 1:
		life = 0
		


