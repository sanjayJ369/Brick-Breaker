extends Control

var button = preload("res://scenes/menu/level_select_button.tscn")
var unlock = Global.levels_unlocked

func _ready():
	
	for i in range(30):
	
		var bb = button.instance()
		bb.name = str(i+1)
		if i+1 <= unlock:
			bb.disabled = false
		else:
			bb.disabled = true
		if i < 9:
			bb.set_button_icon(load("res://ui_elements/Menu/Levels/0"+str(i+1)+".png"))
		else:
			bb.set_button_icon(load("res://ui_elements/Menu/Levels/"+str(i+1)+".png"))
		get_node("GridContainer").add_child(bb)
		
	
	for lvl in $GridContainer.get_children():
		if int(lvl.name) <= unlock:
			lvl.connect("pressed", self, "go_to_level",[int(lvl.name)])
			
	#for i in range(get_node("GridContainer").get_child_count()):
	#	Global.levels.append("level_names")#laod all the levels 

func go_to_level(var level):
	
	get_tree().change_scene("res://scenes/levels/stage_"+str(level)+".tscn")


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/menu/menu.tscn")
