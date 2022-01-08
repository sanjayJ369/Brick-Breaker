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

func _ready():
	for i in range(50):
		sprites.append(dust.instance())
		sprites[i].global_position = Vector2(0,0)
		get_parent().add_child(sprites[i])
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
			
	
func aim_test1(delta,line):

	line.clear_points()
	curve.clear_points()
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		
		
		var points 
		var bounces = 0
		var b = ball.instance()
		var total_balls 
		var sprites = []
		var p = []
		var debug = []
		b.position = cannon_loc
		b.linear_velocity = comp()
		get_parent().add_child(b)
		line.add_point(Vector2.ZERO)
		
		while true:
			var nob
			var coll = b.move_and_collide(b.linear_velocity*delta)
			var pl = 0
			var l = []
			if coll:
				
				line.add_point(line.to_local(b.position))
				curve.add_point(b.global_position)
				var vec = (b.position-cannon_loc).normalized()
				#var dis = pow((pow(b.position.x-cannon_loc.x,2)+ pow(b.position.y- cannon_loc.y,2)),0.5)
				#nob = int(dis/intervel)
				l.append(curve.get_baked_length() - pl)
				pl = curve.get_baked_length()
				bounces += 1
				b.linear_velocity = b.linear_velocity.bounce(coll.normal)
				
			points = curve.get_baked_points()
			total_balls = curve.get_baked_length()
				
			var num
			var s = 0
			if points.size() > 2 :
				
				for i in range(curve.get_point_count() - 1):
					
					var dis = distance(points[i],points[i+1])
					num = int(dis/intervel)
					#print(num,"		",dis/intervel,"		",dis,"	",points[i],"	",points[i+1])
				
					for j in range(num+1):
						
						if num != 0:
						#sprites.append(dust.instance())
						#sprites[p].global_position = curve.interpolate(i,j*(1/num))
							p.push_back(curve.interpolate(i,j*(1/num)))
							debug.push_back(Vector2(i,j*(1/num)))
						#get_parent().add_child(sprites[p])
						#p += 1
				
			
			if bounces >= max_bounces:
				#for i in sprites:
				#	print(i.global_position)
				#	i.queue_free()
				for i in p:
					print(i)
					
				print("##########################")
				for i in debug:
					print(i)
				print("$$$$$$$$$$$$$$$$$$$$$$$$$$")
				for i in line.get_points():
					print(i)
				print("%%%%%%%%%%%%%%%%%%%%%%%%%%")
				b.queue_free()
				break	
	
func aim_test2(delta,line):

	line.clear_points()
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		
		var bounces = 0
		var b = ball.instance()
		b.position = cannon_loc
		b.linear_velocity = comp()
		get_parent().add_child(b)
		line.add_point(Vector2.ZERO)
		###################
		var points = []
		var dis 
		var num
		var curve1 = Curve2D.new()

		
		while true:
			
			var coll = b.move_and_collide(b.linear_velocity*delta)
			
			if coll:
				
				line.add_point(line.to_local(b.position))
				bounces += 1
				b.linear_velocity = b.linear_velocity.bounce(coll.normal)
				
			points = line.get_points()	
			
			for i in points:
				curve1.add_point(i)
				
			var s = 0
				
			for i in range(points.size()-1):
				
				dis = distance(points[i],points[i+1])
				num = int(dis/intervel)
				
				
				
				for j in range(num+1):
					if s == 50:
						break
					sprites[s].global_position = curve1.interpolate(i,j*(1/num))
					s += 1
					print("working",s)
				
			if bounces >= max_bounces:
				
				b.queue_free()
				break	
				
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		
		for i in sprites:
			print(i.global_position)
		
		

			
func add_balls(pos,num):
	var b = []
	var p = []
	for i in range(num):
		b.append(dust.instance())
		p.append(pos*i)
	for i in range(num):
		b[i].position = pos[i]
		get_parent().add_child(b[i])

	
func distance(a,b):
	return abs(pow(pow((a.x-b.x),2) + pow((a.y-b.y),2),0.5))
