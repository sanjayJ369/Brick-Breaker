extends StaticBody2D


export var brick_life = 15
var life 
var value = 100
onready var bar = $ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready():
	
	life = brick_life
	bar.value = value
	
func _process(delta):
	
	bar.value = round((float(life)/brick_life)*100)
	
	
func take_life():
	
	life -= 1
	if life == 0:
		switch_scene("hi")


func switch_scene(scene):
	play_transition()
	get_tree().change_scene("res://scenes/main.tscn")
	
func play_transition():
	pass#TO DO
