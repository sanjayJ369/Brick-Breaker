extends Control

var game_over = false 
var one = false 

func _process(delta):
	
	if game_over and not one:
		one = true 
		visible = true
		$pause_menu/CenterContainer/VBoxContainer/Button2.disabled = false
		$pause_menu/CenterContainer/VBoxContainer/Button3.disabled = false
		


func _on_Button2_pressed():
	get_tree().change_scene("res://scenes/menu/menu.tscn")
	#quit
	pass # Replace with function body.


func _on_Button3_pressed():
	
	get_tree().change_scene("res://scenes/levels/stage_"+str(Global.current_level)+".tscn")
	#restart
	pass # Replace with function body.
