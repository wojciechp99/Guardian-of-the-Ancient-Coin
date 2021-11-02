extends KinematicBody2D

onready var Player = get_parent().get_node("Steve")
var speed = 100
var velocity = Vector2.ZERO
var is_looking_right = false
var player_in_range = false
var player_in_sight = false
var is_dead = false
var gravity = 5

func _ready():
	$AnimatedSprite.play("fly")

func _physics_process(delta):
	if not is_dead:
		if player_in_sight:
			velocity = Vector2.ZERO
			velocity = position.direction_to(Player.position) * speed
			velocity = move_and_slide(velocity)
		rotate_character()
		SightCheck()
	else:
		set_collision_layer_bit(3, false)
		set_collision_mask_bit(0, false)
		$Hitbox.set_collision_mask_bit(0, false)
		$Hitbox.set_collision_layer_bit(3, false)
		velocity.x = 0
		velocity.y += gravity
		velocity = move_and_slide(velocity, Vector2.UP)
	
# Checks the Player.x location and rotates KinemaicBody2D
func rotate_character():
	if Player.position.x < position.x:
		scale.x = scale.y * 1
	elif Player.position.x > position.x:
		scale.x = scale.y * -1


func _on_Vision_body_entered(body):
	if body == Player:
		player_in_range = true


func _on_Vision_body_exited(body):
	if body == Player:
		player_in_range = false

func SightCheck():
	if player_in_range:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, Player.position, [self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Steve":
				player_in_sight = true
			else:
				player_in_sight = false
				


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		is_dead = true
		$AnimatedSprite.stop()
		#$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		$SoundDeath.play()


func _on_Hitbox_body_entered(body):
	if body == Player and not is_dead:
		body.ouch(position.x)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
