extends Node2D

onready var ray1 = $RayCast2D
onready var ray2 = $RayCast2D2
onready var ray3 = $RayCast2D3
onready var line1 = $Line2D
onready var line2 = $Line2D2
onready var line3 = $Line2D3
export var loc = Vector2(512,700)
export var max_bounces = 5
export var radius = 8
var ball = preload("res://scenes/ball/ball_k.tscn")
var dust = preload("res://sprites/cannon/dust.tscn")
var vel_max = 500
var cannon_loc = loc
export var aim_length = 60
export var intervel = 1
var curve = Curve2D.new()
var sprites = []
var colours = [Color("6cd9f1"),Color("a4cc42"),Color("f7ec8a"),Color("f18b72"),Color("f89cc0"),Color("f2bc7e")]

func _ready():
	
	randomize()

	line1.global_position = loc - Vector2(radius,0)
	line2.global_position = loc
	line3.global_position = loc + Vector2(radius,0)

func _process(delta):
	
	aim_test(delta,line2)
	#aiming(line2,ray2,Vector2.ZERO)
	pass
	
func aiming(l,r,s):
	var line = l
	var ray = r
	line.clear_points()
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		line.add_point(Vector2.ZERO)
		ray.global_position = line.global_position
		ray.cast_to = (get_global_mouse_position()-line.global_position-s).normalized()*1000
		ray.force_raycast_update()
		var pre = null
		var bounces = 0
		while true:

			if not ray.is_colliding():
				var pt = ray.global_position + ray.cast_to
				line.add_point(line.to_local(pt))
				break
				
			var coll = ray.get_collider()
			var pt = ray.get_collision_point()
			
			line.add_point(line.to_local(pt))
	
			
			if (not coll.is_in_group("brick")) and (not coll.is_in_group("wall")):
				
				break
				
			var normal = ray.get_collision_normal()
		
			
			if normal == Vector2.ZERO:
				break
				
			if pre != null:
				pre.set_collision_layer_bit(1,true)
				pre.set_collision_mask_bit(0,true)
				
				
			pre = coll
			
			pre.set_collision_layer_bit(1,false)
			pre.set_collision_mask_bit(0,false)
		
				
			ray.global_position = pt 
			ray.cast_to = ray.cast_to.bounce(normal)
			ray.force_raycast_update()
			bounces += 1
			
			if bounces >= max_bounces:
				
				break
				
		if pre != null:
			pre.set_collision_layer_bit(1,true)
			pre.set_collision_mask_bit(0,true)
			
func aim_test(delta,line):

	line.clear_points()
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		
		
		var bounces = 0
		var b = ball.instance()
		b.position = cannon_loc
		b.linear_velocity = comp()
		get_parent().add_child(b)
		line.add_point(Vector2.ZERO)
		
		while true:
			
			var coll = b.move_and_collide(b.linear_velocity*delta)
			
			if coll:
				
				line.add_point(line.to_local(b.position))
				bounces += 1
				b.linear_velocity = b.linear_velocity.bounce(coll.normal)
				
				
			if bounces >= max_bounces:
				
				b.queue_free()
				break
			
			
func comp():
	
	var pos = get_viewport().get_mouse_position()
	var v_x = vel_max*((pos.x-cannon_loc.x)/(pow((pow(abs(pos.x-cannon_loc.x),2)+pow(abs(pos.y-cannon_loc.y),2)),0.5)))
	var v_y = vel_max*((cannon_loc.y-pos.y)/(pow((pow(abs(pos.x-cannon_loc.x),2)+pow(abs(pos.y-cannon_loc.y),2)),0.5)))*-1

	return Vector2(v_x,v_y)
			
	


func _on_Timer_timeout():
	var num = randi() % colours.size()
	line2.set_default_color(colours[num])
	line1.set_default_color(colours[num])
	line3.set_default_color(colours[num])
	pass
