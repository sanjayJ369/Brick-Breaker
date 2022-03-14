extends Control

var is_paused = false setget set_is_paused

export(bool) var retry_button = false

var game_over = false
var re = false

func _process(delta):
	
	if game_over and not re:
		
		retry()
		re = true
	
	if $CenterContainer/VBoxContainer/Button.is_hovered() == true:
		$text/Sprite.texture = load("res://ui_elements/Menu/Buttons/Play_pressed.png")
	else:
		$text/Sprite.texture = load("res://ui_elements/Menu/Buttons/Play.png")
	if $CenterContainer/VBoxContainer/Button2.is_hovered() == true:
		$Sprite2.texture = load("res://ui_elements/Menu/Buttons/close_pressed.png")
	else:
		$Sprite2.texture = load("res://ui_elements/Menu/Buttons/close.png")
	if $CenterContainer/VBoxContainer/Button3.is_hovered() == true:
		$Sprite3.texture = load("res://ui_elements/Menu/Buttons/Restart_pressed.png")
	else:
		$Sprite3.texture = load("res://ui_elements/Menu/Buttons/Restart.png")
		

func _unhandled_input(event):
	if event.is_action_pressed("pause") and not retry_button:
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value 
	get_tree().paused = is_paused
	visible = is_paused

func _on_Button_pressed():
	
	self.is_paused = false
	pass # Replace with function body.

func _on_Button2_pressed():
	
	get_tree().change_scene("res://scenes/menu/menu.tscn")
	pass # Replace with function body.


func _on_Button3_pressed():
	
	self.is_paused = false
	get_tree().change_scene("res://scenes/levels/stage_"+str(Global.current_level)+".tscn")
	pass # Replace with function body.

func retry():
	
	visible = true
	$text.visible = false
	$retry.visible = true
	$CenterContainer/VBoxContainer/Button.disabled = true
