extends Area2D


export var state = "0"
var can_change = true

func _ready():
	$Sprite.frame = int(state)

func _process(delta):
	_ready()


func _on_Lever_area_entered(area):
	if can_change:
		if area.is_in_group("Sword"):
			if state == "1":
				$SoundLeverChange.play()
				state = "0"
			else:
				$SoundLeverChange.play()
				state = "1"
			Global.LeverChanged()
			can_change = false
			$Timer.start()


func _on_Timer_timeout():
	can_change = true
