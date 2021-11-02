extends KinematicBody2D

onready var Player = get_parent().get_node("Steve")

var is_moving_right = false
var gravity = 10
var velocity = Vector2(0, 0)
var speed = 32
var is_dead = false

func _ready():
	$AnimatedSprite.play("walk")
	
func _process(delta):
	if is_dead == false:
		move_character()
		detect_turn_around()

func move_character():
	velocity.x = speed if is_moving_right else -speed
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = not is_moving_right
		scale.x = -scale.x
	if $RayCast2D2.is_colliding() and is_on_floor():
		is_moving_right = not is_moving_right
		scale.x = -scale.x

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		$AnimatedSprite.stop()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()

func _on_Hitbox_body_entered(body):
	if is_dead == false and body == Player:
		body.ouch(position.x)
