extends CanvasLayer

export(bool) var levels_gui = true
var master_bus = AudioServer.get_bus_index("Master")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_paused = false setget set_is_paused



func _on_HSlider_value_changed(value):
	
	Global.volume = value 
	
	AudioServer.set_bus_volume_db(master_bus,value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus,true)
	else:
		AudioServer.set_bus_mute(master_bus,false)
	pass 


func set_is_paused(value):
	is_paused = value 
	get_tree().paused = is_paused
	$pause_menu.visible = is_paused


func _on_Button_pressed():
	if levels_gui == true:
		$pause_menu.is_paused = true
	else:
		self.is_paused = false
	pass # Replace with function body.


func _on_Button3_pressed():
	self.is_paused = true

