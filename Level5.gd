extends Node2D


func _ready():
	Global.is_boss_dead = false

func _process(delta):
	if Global.is_boss_dead:
		$Shooting_trap.cooldown = 99999
		$DOORS/Door2/Levers/Lever.visible = true
		$DOORS/Door2/Levers/Lever.set_collision_mask_bit(0, true)
