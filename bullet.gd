extends Area2D

onready var Player = get_parent().get_node("Steve")
onready var tileset = get_parent().get_node("TileMap")
onready var platform = get_parent().get_node("TileMap3")
const BULLET_SPEED = 200
var SPEED_x = 1
var SPEED_y = 0
var motion
var direction

export var dir : Vector2

func _ready():
	if dir == Vector2(-1,0):
		rotation_degrees = 180
	elif dir == Vector2(0,1):
		rotation_degrees = 90
	elif dir == Vector2(0,-1):
		rotation_degrees = -90
	direction = dir
	$AnimatedSprite.play("idle")

func _process(delta):
	motion = direction * BULLET_SPEED
	position = position + motion * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bullet_body_entered(body):
	if body == Player:
		queue_free()
		body.ouch(position.x)
	elif body == tileset or body == platform:
		queue_free()

