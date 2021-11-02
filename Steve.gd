extends KinematicBody2D

const SPEED = 180
const GRAVITY = 30
const JUMPFORCE = -500

var velocity = Vector2(0,0)
var isAttacking = false
var time_in_seconds = 1
var dead = false
var is_taking_damage = false
var timer
var x_move = false
var posision_from_enemy = 0
var is_jumping = false
var is_on_platform = false
var level1_coins = 0
var is_playing_sound_walk = false
export var scene_name :String
export var coins = 0
export var health = 5

onready var platform_detector = $PlatformDetector
onready var platform_detector2 = $PlatformDetector2

func _ready():
	var context = get_tree().get_current_scene().get_name()
	Global.scene_name = context

func _physics_process(delta):
	if not is_on_floor():
		$SoundWalking.stop()
		is_playing_sound_walk = false
	if Input.is_action_pressed("left") and isAttacking == false and dead == false:
		velocity.x = -SPEED
		$AttackArea.scale.x = -1
		$Sprite.play("run")
		$Sprite.flip_h = true
		$PlatformDetector.enabled = false
		$PlatformDetector2.enabled = true
		get_node("CollisionPolygon_h_left").disabled = false
		get_node("CollisionPolygon_h_right"). disabled = true
		if not is_playing_sound_walk and is_on_floor():
			play_walk_sound()
	elif Input.is_action_pressed("right") and isAttacking == false and dead == false:
		velocity.x = SPEED
		$AttackArea.scale.x = 1
		$Sprite.play("run")
		$Sprite.flip_h = false
		$PlatformDetector.enabled = true
		$PlatformDetector2.enabled = false
		get_node("CollisionPolygon_h_left").disabled = true
		get_node("CollisionPolygon_h_right"). disabled = false
		if not is_playing_sound_walk and is_on_floor():
			play_walk_sound()
	else:
		$SoundWalking.stop()
		is_playing_sound_walk = false
		if x_move == false:
			velocity.x = 0
		else:
			velocity.x = posision_from_enemy
		if isAttacking == false and dead == false:
			$Sprite.play("Idle")
	
	if not is_on_floor() and dead == false:
		if velocity.y < 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("jump_landing")
			isAttacking = false
			
	if is_on_floor() and dead == false and is_taking_damage == false:
		if Input.is_action_pressed("attack"):
			$Sprite.play("attack")
			$SoundAttack.play()
			isAttacking = true
			$AttackArea/CollisionPolygon2D.disabled = false
		
		if Input.is_action_pressed("attack2"):
			$Sprite.play("attack2")
			isAttacking = true
			$AttackArea/CollisionPolygon2D.disabled = false
	
	
	velocity.y += GRAVITY
	if velocity.y < 0:
		is_jumping = true
	else:
		is_jumping = false
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and isAttacking == false and dead == false:
		velocity.y = JUMPFORCE
	var snap = Vector2.DOWN * 16 if not is_jumping else Vector2.ZERO
	if $PlatformDetector.enabled == true:
		is_on_platform = platform_detector.is_colliding()
	elif $PlatformDetector2.enabled == true:
		is_on_platform = platform_detector2.is_colliding()
	_change()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, not is_on_platform)
	velocity.x = lerp(velocity.x,0,0.2)
	
	if dead:
		$Sprite.play("dead")
		yield($Sprite, "animation_finished")
		get_tree().change_scene("res://YouDied.tscn")

func _change():
	set_collision_mask_bit(5, true) if is_on_platform else set_collision_mask_bit(5, false)

func play_walk_sound():
	$SoundWalking.play()
	is_playing_sound_walk = true

func _on_attack_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		$AttackArea/CollisionPolygon2D.disabled = true
		isAttacking = false
	if $Sprite.animation == "attack2":
		$AttackArea/CollisionPolygon2D.disabled = true
		isAttacking = false

func attack_interaction():
	isAttacking = false
	$AttackArea/CollisionPolygon2D.set_deferred("disabled", true)

# Makes Player take damage when called
func ouch(var enemypos):
	if isAttacking == true:
		attack_interaction()
	if is_taking_damage == false:
		set_modulate(Color(1,0.3,0.3,0.3))
		if enemypos == 0:
			posision_from_enemy = 0
		elif position.x < enemypos:
			posision_from_enemy = -500
		else:
			posision_from_enemy = 500
		x_move = true
		velocity.y = JUMPFORCE * 0.7
		Input.action_release("left")
		Input.action_release("right")
		$Timer.start()
		$Timer2.start()
		$SoundDamage.play()
		health -= 1
		is_taking_damage = true
		if health <= 0:
			set_modulate(Color(1,1,1))
			dead = true
		if Global.scene_name == "MAINMenu":
			health += 1

func collect_coin():
	coins +=1

func _on_Timer_timeout():
	set_modulate(Color(1,1,1))
	is_taking_damage = false


func _on_Timer2_timeout():
	x_move = false


func _on_NEXTLevel_body_entered(body):
	# LEVEL 1,2,3,4,5 EXIT
	var level = get_tree().get_current_scene().get_name()
	if level == "Level1":
		Global.coins_level1 = coins
		Global.is_level2_unlocked = true
	elif level == "Level2":
		Global.coins_level2 = coins
		Global.is_level3_unlocked = true
	elif level == "Level3":
		Global.coins_level3 = coins
		Global.is_level4_unlocked = true
	elif level == "Level4":
		Global.coins_level4 = coins
		Global.is_level5_unlocked = true
	elif level == "Level5":
		Global.coins_level5 = coins
		Global.is_level5_unlocked = true
	get_tree().change_scene("res://LevelComplete.tscn")

