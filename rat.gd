extends KinematicBody2D

onready var Player = get_parent().get_node("Steve")

export var is_not_underground = false

var gravity = 10
var velocity = Vector2(0, 0)
var speed = 80
var is_dead = false
var detect_player = false
var is_underground = true
var is_animation_playing = false
var play_sound_walk = true
var is_attacking = false

func _ready():
	if is_not_underground:
		start_with_spawning()
		rotate_rat()
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta):
	if is_dead == false:
		if is_underground or is_attacking:
			return
		elif is_underground == false and velocity.x == 0 and not is_dead:
			$AnimatedSprite.play("idle")
			stop_play_sound_idle()
		if detect_player:
			if $AnimationPlayer.current_animation == "attack" and not is_dead:
				return
			if play_sound_walk:
				play_sound_idle()
			move_character()
			rotate_rat()


func play_sound_idle():
	$SoundWalk.play()
	play_sound_walk = false
	
func stop_play_sound_idle():
	$SoundWalk.stop()
	play_sound_walk = true

func move_character():
	if Player.position.x < position.x:
		velocity.x = -speed
		$AnimatedSprite.play("walk")
	elif Player.position.x > position.x:
		velocity.x = speed
		$AnimatedSprite.play("walk")
	else:
		velocity.x = 0
		$AnimatedSprite.play("idle")
		stop_play_sound_idle()
		
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func start_with_spawning():
	is_underground = false
	$AnimatedSprite.play("idle")

func _on_Area2D_body_entered(body):
	if body == Player:
		detect_player = true
		if is_underground:
			$AnimatedSprite.play("spawn")


func _on_Area2D_body_exited(body):
	if body == Player:
		detect_player = false
		if is_underground == false and not is_dead:
			$AnimatedSprite.play("idle")
			stop_play_sound_idle()

func rotate_rat():
	if Player.position.x < position.x -25:
		scale.x = scale.y * 1
	elif Player.position.x > position.x +25:
		scale.x = scale.y * -1

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		$AnimationPlayer.stop()
		$AnimatedSprite.stop()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		$SoundRatDeath.play()
		$Timer.start()


func _on_Hitbox_body_entered(body):
	if body == Player:
		body.ouch(position.x)

func hit():
	$AttackDetector.monitoring = true
	detect_player = false
	$SoundAttack.play()

func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walk():
	is_attacking = false
	$AnimatedSprite.play("walk")
	detect_player = true

func _on_PlayerDetector_body_entered(body):
	if is_dead == false and not is_underground:
		is_attacking = true
		$AnimatedSprite.play("attack")
		$AnimationPlayer.play("attack")

func _on_AttackDetector_body_entered(body):
	if is_dead == false and body == Player:
		body.ouch(position.x)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "spawn":
		is_underground = false

func _on_Timer_timeout():
	queue_free()

