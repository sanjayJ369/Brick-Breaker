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

onready var bomb = get_node("golden_bomb")###################

var edge_backgrounds = [preload("res://back_grounds/background_scenes/leaf_background.tscn"),preload("res://back_grounds/background_scenes/rock_background.tscn"),
preload("res://back_grounds/background_scenes/wood_background.tscn")]

var backgrounds = [preload("res://back_grounds/Background/blue.tscn"),preload("res://back_grounds/Background/brown.tscn"),
preload("res://back_grounds/Background/gray.tscn"),preload("res://back_grounds/Background/green.tscn"),preload("res://back_grounds/Background/pink.tscn"),
preload("res://back_grounds/Background/purple.tscn"),preload("res://back_grounds/Background/yellow.tscn")]



var start_bricks = Vector2(50,36)
onready var golden_brick = get_node("golden_brick")

func _ready():
	
	if bomb != null:
		bomb.connect("nuclear",self,"_on_golden_bomb_nuclear")
		print("connected")
	
	$aimer.cannon_loc = cannon_body.position
	
	cannon_loc = cannon_body.position
	balls_left = balls
	randomize()
	#create_field()
	create_background()
	pass # Replace with function body.

func _process(delta):

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
	
	var num = randi() % backgrounds.size()
	var background = backgrounds[num].instance()
	add_child(background)
	
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
	
	$bricks.queue_free()
