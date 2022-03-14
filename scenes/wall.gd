extends Node2D



######balls###########
export var balls = 60#-1 for infinite balls 
export var delay = 0.2
var balls_left
var can_shoot = true
var ball = preload("res://scenes/ball/ball_k.tscn")
export var vel_max = 1000
export var ball_life = 60
var v_x = 0
var v_y = 0
######################
var cannon_loc = Vector2(512,700)
var bricks = [preload("res://scenes/bricks/square.tscn"),preload("res://scenes/bricks/circle.tscn")]
onready var cannon_body = $Sprite2
var rota = 0
var crota = (PI/2)

export var loc = Vector2(512,700)
export var max_bounces = 60

var bomb = null###################

var edge_backgrounds = [preload("res://back_grounds/background_scenes/leaf_background.tscn"),preload("res://back_grounds/background_scenes/rock_background.tscn"),
preload("res://back_grounds/background_scenes/wood_background.tscn")]

var backgrounds = [preload("res://back_grounds/Background/blue.tscn"),preload("res://back_grounds/Background/brown.tscn"),
preload("res://back_grounds/Background/gray.tscn"),preload("res://back_grounds/Background/green.tscn"),preload("res://back_grounds/Background/pink.tscn"),
preload("res://back_grounds/Background/purple.tscn"),preload("res://back_grounds/Background/yellow.tscn")]
var brick_count = 10
var sounds = [preload("res://sounds/selected sounds for brick breaker game/backgound2.ogg"),preload("res://sounds/selected sounds for brick breaker game/background1.mp3")
,preload("res://sounds/selected sounds for brick breaker game/background3.mp3")]
var volume = -24

var current_level
export(bool) var menu

var start_bricks = Vector2(50,36)
var golden_brick = null

var scene_change = null
var retry = false

func _ready():
	
	if has_node("golden_brick") == true:
		golden_brick = get_node("golden_brick")
		
	if has_node("golden_bomb") == true:
		bomb = get_node("golden_bomb")
		
	if has_node("scenechanger"):
		scene_change = get_node("scenechanger")
		scene_change.connect("scene_changed",self,"switch_scene")
		pass
		
	current_level = Global.current_level
	
	
	for i in $bricks.get_children():
		brick_count += i.get_child_count()
	
	if bomb != null:
		bomb.connect("nuclear",self,"_on_golden_bomb_nuclear")
	
	
	$aimer.cannon_loc = cannon_body.position
	$aimer.max_bounces = max_bounces + 1
	cannon_loc = cannon_body.position
	balls_left = balls
	randomize()
	#create_field()
	create_background()
	pass # Replace with function body.

func _process(delta):
	
	print(Global.current_level)
	
	var ball_in_scene = get_node("ball").get_child_count()
	
	if balls_left == 0 and ball_in_scene == 0:
		if has_node("GUI") and not retry:
			print("changed the variable")
			get_node("GUI").get_node("pause_menu").game_over = true
			retry = true
		
	
	if set_bricks_value() == 0 and menu == false:
		
		Global.levels_unlocked = Global.current_level + 1
		play_transition()
	
	$Sprite.position = cannon_1()
	cannon_body.rotate((crota-rota))
	crota = rota
	if balls == -1:
		$Label.text = str("INFINITE")
	else:
		$Label.text = str(balls_left)
	
	if Input.is_action_pressed("shoot"):
		shoot_balls()
		
func shoot_balls():
	
	if can_shoot == true and (balls_left > 0 or balls == -1):
		
		var new_ball = ball.instance()
		new_ball.global_position = cannon_loc
		new_ball.linear_velocity = comp()
		new_ball.ball_life =  ball_life
		get_node("ball").add_child(new_ball)
		
		if balls != -1:
			balls_left -= 1
			
		can_shoot = false
		$shoot_delay.start(delay)
		yield($shoot_delay,"timeout")
		can_shoot = true
		
	pass
	
func comp():
	
	var pos = get_viewport().get_mouse_position()
	v_x = vel_max*((pos.x-cannon_loc.x)/(pow((pow(abs(pos.x-cannon_loc.x),2)+pow(abs(pos.y-cannon_loc.y),2)),0.5)))
	v_y = vel_max*((cannon_loc.y-pos.y)/(pow((pow(abs(pos.x-cannon_loc.x),2)+pow(abs(pos.y-cannon_loc.y),2)),0.5)))*-1

	return Vector2(v_x,v_y)
	
	
func create_field():
	
	var brick_pos = start_bricks
	
	
	for i in range(6):
		
		for j in range(10):
			var select_brick = randi() % bricks.size()
			var new_brick = bricks[select_brick].instance()
			new_brick.position = brick_pos
			add_child(new_brick)
			brick_pos.x += 100
			
		brick_pos.x = start_bricks.x
		brick_pos.y += 75
		
	pass
	
func create_background():
	
	var num1 = randi() % sounds.size()
	var num = randi() % backgrounds.size()
	var background = backgrounds[num].instance()
	add_child(background)
	var music = sounds[num1]
	if music != null:
		$AudioStreamPlayer.stream = music
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.volume_db = volume 
	num = randi() % edge_backgrounds.size()
	var edge = edge_backgrounds[num].instance()
	add_child(edge)
	
func cannon():
	var pos = get_viewport().get_mouse_position()
	var m = (cannon_loc.y-pos.y)/(pos.x-cannon_loc.x)
	m = abs(m)
	var radi = 25
	var g = cannon_loc.x
	var f = cannon_loc.y*-1
	var p = pow(g,2)+pow(f,2)-pow(radi,2)
	var q = -1*((m*cannon_loc.x)+(m*cannon_loc.y))
	var a = 1 + pow(m,2)
	var b = (2*q) + (2*g) + (2*f*m)
	var c = pow(q,2) + (2*f*q) + p
	var d = pow(b,2) - (4*a*c)
	var x = ((-1*b) + pow(d,0.5))/(2*a)
	var y = (m*x) + q
	
	return Vector2(x,y)
	pass

func cannon_1():
	var pos = get_viewport().get_mouse_position()
	var radii = 150
	var x
	var y
	var m
	if pos.x-cannon_loc.x != 0:
		m = (cannon_loc.y-pos.y)/(pos.x-cannon_loc.x)
		x = pow((pow(radii,2)/(pow(m,2)+1)),0.5)
		y = x*m
		if m < 0:
			x = -x
	else:
		x = 0
		y = radii
	rota = atan2((cannon_loc.y-pos.y),(pos.x-cannon_loc.x))#*(180/PI)
	
	return Vector2(cannon_loc.x+x,cannon_loc.y-abs(y))
	
#func destroy():
#	print("receved the signal")
#	bomb.disconnect("nuclear",self,destroy())
#	pass

func _on_golden_bomb_nuclear():
	
	if $bricks != null:
		$bricks.queue_free()


func _on_golden_bomb2_nuclear():
	
	if $bricks != null:
		$bricks.queue_free()


func set_bricks_value():
	
	var num = 0
	
	if $bricks != null:
		for i in $bricks.get_children():
			num += i.get_child_count()
		
	return num


func play_transition():
	
	get_node("scenechanger").change_scene(0)
	pass
	
func switch_scene():
	
	Global.current_level = current_level + 1
	get_tree().change_scene("res://scenes/levels/stage_"+str(current_level+1)+".tscn")
	
	pass


func node_name():
	return str(name.replace("@", "").replace(str(int(name)), ""))


