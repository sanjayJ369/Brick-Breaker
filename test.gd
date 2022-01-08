extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var curve = Curve2D.new()
var speed = 4
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
const FOLLOW_SPEED = 4.0

func _physics_process(delta):
	var mouse_pos = get_local_mouse_position()

	$Sprite.position = $Sprite.position.linear_interpolate(mouse_pos, delta * FOLLOW_SPEED)
