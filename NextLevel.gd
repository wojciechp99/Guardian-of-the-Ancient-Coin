extends Button

var scene_name = ""

func _ready():
	scene_name = Global.scene_name
	if scene_name == "Level5":
		$".".visible = false


func _on_NextLevel_pressed():
	if scene_name == "Level1":
		level2()
	elif scene_name == "Level2":
		level3()
	elif scene_name == "Level3":
		level4()
	elif scene_name == "Level4":
		level5()
	else:
		get_tree().change_scene("res://MAINMenu.tscn")


func level2():
	get_tree().change_scene("res://Level2.tscn")

func level3():
	get_tree().change_scene("res://Level3.tscn")
	
func level4():
	get_tree().change_scene("res://Level4.tscn")
	
func level5():
	get_tree().change_scene("res://Level5.tscn")
