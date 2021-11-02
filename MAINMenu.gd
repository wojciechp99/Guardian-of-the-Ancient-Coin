extends Node2D

var selected_level = "Level1"

func _ready():
	#Unlocks levels on main menu
	if Global.is_level2_unlocked:
		$Level2/Locked.visible = false
		$Level2/Label.visible = true
	if Global.is_level3_unlocked:
		$Level3/Locked.visible = false
		$Level3/Label.visible = true
	if Global.is_level4_unlocked:
		$Level4/Locked.visible = false
		$Level4/Label.visible = true
	if Global.is_level5_unlocked:
		$Level5/Locked.visible = false
		$Level5/Label.visible = true
	
	# Coins counter
	$CoinsCollected/Level1.text = "Level 1: " + String(Global.coins_level1) + "/17"
	$CoinsCollected/Level2.text = "Level 2: " + String(Global.coins_level2) + "/25"
	$CoinsCollected/Level3.text = "Level 3: " + String(Global.coins_level3) + "/40"
	$CoinsCollected/Level4.text = "Level 4: " + String(Global.coins_level4) + "/35"
	$CoinsCollected/Level5.text = "Level 5: " + String(Global.coins_level5) + "/3"
	
	#Shows when all coins are collected
	var all_coins_collected = Global.coins_level1 + Global.coins_level2 + Global.coins_level3
	all_coins_collected += Global.coins_level4 + + Global.coins_level5
	if all_coins_collected == 120:
		$All_coins.visible = true
	else:
		$All_coins.visible = false

func _process(delta):
	if Input.is_action_pressed("Play"):
		if selected_level == "Level1":
			get_tree().change_scene("res://Level1.tscn")
		elif selected_level == "Level2":
			get_tree().change_scene("res://Level2.tscn")
		elif selected_level == "Level3":
			get_tree().change_scene("res://Level3.tscn")
		elif selected_level == "Level4":
			get_tree().change_scene("res://Level4.tscn")
		elif selected_level == "Level5":
			get_tree().change_scene("res://Level5.tscn")
			
func _on_Button1level_pressed():
	selected_level = "Level1"

func _on_Button2level_pressed():
	selected_level = "Level2"

func _on_Button3level_pressed():
	selected_level = "Level3"

func _on_Button4level_pressed():
	selected_level = "Level4"

func _on_Button5level_pressed():
	selected_level = "Level5"
