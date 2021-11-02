extends Node

signal LeverChanged

var scene_name = ""

var is_level2_unlocked = false
var is_level3_unlocked = false
var is_level4_unlocked = false
var is_level5_unlocked = false

var coins_level1 = 0
var coins_level2 = 0
var coins_level3 = 0
var coins_level4 = 0
var coins_level5 = 0

var is_boss_dead = false

func LeverChanged():
	emit_signal("LeverChanged")
