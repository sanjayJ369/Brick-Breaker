extends StaticBody2D


export var brick_life = 15
var life 
var value = 100
onready var bar = $ProgressBar
export(bool) var exit_bar = false
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
	
	if exit_bar == false:
		play_transition()
		get_tree().change_scene("res://scenes/main.tscn")
		
	elif exit_bar == true:
		get_tree().quit()

	
func play_transition():
	pass#TO DO
