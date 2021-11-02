extends KinematicBody2D

onready var Player = get_parent().get_node("Steve")

var is_moving_right = true
var gravity = 10
var velocity = Vector2(0, 0)
var speed = 32
var is_dead = false

func _ready():
	$AnimatedSprite.play("walk")

func _process(delta):
	if is_dead == false:
		if $AnimationPlayer.current_animation == "Attack":
			return
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

func hit():
	$AttackDetector.monitoring = true
	$SoundAttack.play()

func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walk():
	$AnimatedSprite.play("walk")
	
func _on_PlayerDetector_body_entered(body):
	if is_dead == false:
		$AnimatedSprite.play("attack")
		$AnimationPlayer.play("Attack")

func _on_AttackDetector_body_entered(body):
	if is_dead == false:
		body.ouch(position.x)

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		$AnimationPlayer.stop()
		$AnimatedSprite.stop()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		$SoundDeath.play()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()

func _on_Hitbox_body_entered(body):
	if body == Player:
		body.ouch(position.x)
