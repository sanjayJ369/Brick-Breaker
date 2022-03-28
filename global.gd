extends Node

var level = []
var levels_unlocked = 1
var current_level = 1
var volume = 0

const SAVE_DIR = "user://saves/"

var save_path = "user://save.dat"

func _ready():
	
	loaddata()
	
	pass



func savedata(var lev):
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	var data = {
		"levels_unlocked" : lev
	}
	pass
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path,File.WRITE,"game123")
	if error == OK:
		file.store_var(data)
		file.close()
		
func loaddata():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path,File.READ,"game123")
		if error == OK:
			var player_data = file.get_var()
			levels_unlocked = player_data["levels_unlocked"]
			print(player_data["levels_unlocked"])
			file.close()
			
