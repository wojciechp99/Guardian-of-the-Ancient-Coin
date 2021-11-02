extends Area2D

onready var Player = get_parent().get_node("Steve")
onready var tileset = get_parent().get_node("TileMap")
const BULLET_SPEED = 200
var SPEED_x = 1
var SPEED_y = 0
var direction = Vector2(1, 0)
var motion
var player_position
var new_vector

export var dir : Vector2

func _ready():
	player_position = Player.get_global_position()
	new_vector = Vector2(player_position.x - dir.x, player_position.y - dir.y)
	rotation_degrees = rad2deg(new_vector.normalized().angle())
	$AnimatedSprite.play("idle")

func _process(delta):
	motion = (new_vector.normalized()) * BULLET_SPEED
	position = position + motion * delta

func _on_boss_bullet_body_entered(body):
	if body == Player:
		queue_free()
		body.ouch(position.x)
	elif body == tileset:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
