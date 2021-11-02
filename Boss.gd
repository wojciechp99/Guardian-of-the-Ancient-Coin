extends KinematicBody2D

const BULLET_SCENE = preload("res://boss_bullet.tscn")
onready var Player = get_parent().get_node("Steve")

var health = 5
var is_dead = false
var is_taking_damage = false
var knockbackvar = Vector2.ZERO

var gravity = 10
var velocity = Vector2(0, 0)
var speed = 80
var detect_player = false
#var is_upgrading = false
var waking_up = true
var is_attacking = false
var is_on_cooldown = false
var can_take_damage = true

var player_position
var dir_posision_2d

func _ready():
	is_on_cooldown = true
	$AnimatedSprite.play("sleep2")

func _process(delta):
	if is_dead:
		return
	if health == 0:
		death()
		return
	
	if is_taking_damage:
		knockbackvar = knockbackvar.move_toward(Vector2.ZERO, 200 * delta)
		velocity.y += gravity * delta
		knockbackvar = move_and_slide(knockbackvar, Vector2.UP)
		return
	
	if $AnimationPlayer.current_animation == "attack" or $AnimationPlayer.current_animation == "range_attack":
		return
	
	if not waking_up:
		if not is_on_cooldown and not is_attacking:
			is_attacking = true
			# Allow boss to shot on specified degree
			player_position = Player.get_global_position()
			dir_posision_2d = get_node("Position2D").get_global_position()
			var new_vector = Vector2(player_position.x - dir_posision_2d.x, player_position.y - dir_posision_2d.y)
			var changed_to_deg = rad2deg(new_vector.normalized().angle())
			
			# Checks degree
			if changed_to_deg < 30 and changed_to_deg > -30 and Player.position.x > position.x \
			or changed_to_deg < 210 and changed_to_deg > 150 and Player.position.x < position.x:
				$AnimationPlayer.play("range_attack")
				$AnimatedSprite.play("Attack")
			else:
				is_attacking = false
				is_on_cooldown = true
				$Timer3.start()
		else:
			move_character()
			rotate_character()
		if is_on_cooldown:
			$AnimatedSprite.play("Walk")

# Function used in AnimationPlayer
func create_bullet():
	shoot_bullet()
	$SoundShot.play()

# Function that creates bullet
func shoot_bullet():
	var bullet = BULLET_SCENE.instance()
	bullet.dir = get_node("Position2D").get_global_position()
	get_parent().add_child(bullet)
	bullet.set_position(get_node("Position2D").get_global_position())

func death():
	is_dead = true
	Global.is_boss_dead = true
	$AnimatedSprite.play("death")
	
func move_character():
	if Player.position.x < position.x + 30:
		velocity.x = -speed
		$AnimatedSprite.play("Walk")
	elif Player.position.x > position.x - 30:
		velocity.x = speed
		$AnimatedSprite.play("Walk")
	
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func rotate_character():
	if Player.position.x > position.x:
		scale.x = scale.y * 1
	elif Player.position.x < position.x:
		scale.x = scale.y * -1

# Function used in AnimationPlayer
func hit():
	$AttackDetector.monitoring = true
	detect_player = false
	$SoundAttack.play()

# Function used in AnimationPlayer
func end_of_hit():
	$AttackDetector.monitoring = false
# Function used in AnimationPlayer

func start_walk():
	$AnimatedSprite.play("Walk")
	detect_player = true
	is_attacking = false

func _on_Area2D_body_entered(body):
	if body == Player and not is_dead:
		detect_player = true

func _on_Area2D_body_exited(body):
	if body == Player:
		detect_player = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
	if $AnimatedSprite.animation == "sleep2":
		waking_up = false

func _on_PlayerDetector_body_entered(body):
	if is_dead or is_taking_damage or waking_up:
		return
	is_attacking = true
	$AnimatedSprite.play("melee_attack")
	$AnimationPlayer.play("attack")

func _on_AttackDetector_body_entered(body):
	if body == Player:
		body.ouch(position.x)

func _on_Timer_timeout():
	is_on_cooldown = false

func _on_Timer3_timeout():
	is_on_cooldown = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "range_attack":
		is_attacking = false
		is_on_cooldown = true
		$Timer.start()

# Makes boss to lose 1 heath and change his color to red if he is not dead
func take_damage():
	health -= 1
	if health == 0:
		$SoundDeath.play()
	else:
		$SoundDamage.play()
	if health > 0:
		set_modulate(Color(1,0.3,0.3,0.3))

func _on_Hitbox_area_entered(area):
	if not can_take_damage or waking_up or health == 0:
		return
	else:
		if area.is_in_group("Sword"):
			is_taking_damage = true
			take_damage()
			$Timer2.start()
			can_take_damage = false
			$AnimationPlayer.stop()
			$AnimatedSprite.stop()
			$AnimatedSprite.play("damage")
			if Player.position.x <= position.x:
				knockbackvar = Vector2.RIGHT * 150
			else:
				knockbackvar = Vector2.LEFT * 150
			
func _on_Timer2_timeout():
	set_modulate(Color(1,1,1))
	is_taking_damage = false
	can_take_damage = true

func _on_Timer4_timeout():
	is_on_cooldown = false

func _on_DamageTOPlayer_body_entered(body):
	if is_dead or not can_take_damage:
		return
	if body == Player:
		body.ouch(position.x)
