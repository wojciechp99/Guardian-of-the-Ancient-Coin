extends StaticBody2D

onready var Player = get_parent().get_node("Steve")

const BULLET_SCENE = preload('res://bullet.tscn')

var properties = {
	LEFT = Vector2(-1, 0),
	RIGHT = Vector2(1, 0),
	UP = Vector2(0, -1),
	DOWN = Vector2(0, 1)
}
var is_on_cooldown = false
var can_play_sound = false

export var direction = "right"
export var cooldown = 1.0
export var delay = 0.0
export var was_delayed = false

func _ready():
	$Timer2.wait_time = delay
	$Timer2.start()
	if direction == "left":
		direction = properties.LEFT
	elif direction == "up":
		direction = properties.UP
	elif direction == "down":
		direction = properties.DOWN
	else:
		direction = properties.RIGHT

func _process(delta):
	if not is_on_cooldown and was_delayed:
		if can_play_sound:
			$SoundShot.play()
		creat_bullet()

func creat_bullet():
	var bullet = BULLET_SCENE.instance()
	bullet.dir = direction
	get_parent().add_child(bullet)
	bullet.set_position(get_node("Position2D").get_global_position())
	is_on_cooldown = true
	$Timer.wait_time = cooldown
	$Timer.start()

func _on_Timer_timeout():
	is_on_cooldown = false

func _on_Timer2_timeout():
	was_delayed = true

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	can_play_sound = true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	can_play_sound = false
