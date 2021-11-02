extends Button

var scene_name = "1"

func _ready():
	scene_name = Global.scene_name
	
func return_value(level):
	scene_name = level
	print(scene_name)
	return scene_name

func _on_TryAgain_pressed():
	print(scene_name)
	if scene_name == "Level1":
		level1()
	elif scene_name == "Level2":
		level2()
	elif scene_name == "Level3":
		level3()
	elif scene_name == "Level4":
		level4()
	elif scene_name == "Level5":
		level5()
	else:
		get_tree().change_scene("res://MAINMenu.tscn")


func level1():
	get_tree().change_scene("res://Level1.tscn")

func level2():
	get_tree().change_scene("res://Level2.tscn")

func level3():
	get_tree().change_scene("res://Level3.tscn")
	
func level4():
	get_tree().change_scene("res://Level4.tscn")
	
func level5():
	get_tree().change_scene("res://Level5.tscn")
