extends StaticBody2D

export var code = "0"
var is_open = false
var levers = []
var was_opened = false

func _ready():
	levers = get_node("Levers").get_children()
	Global.connect("LeverChanged",self, "_change_state")
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("idle")

# Function connected with signal from Global.gd
func _change_state():
	var codeFromLever = ""
	for lever in levers:
		codeFromLever += lever.state
	if code == codeFromLever and not was_opened:
		is_open = true
		$AnimationPlayer.play("open")
		$SoundDoorOpen.play()
	elif code != codeFromLever and was_opened:
		is_open = false
		$AnimationPlayer.play_backwards("open")
		$SoundDoorOpen.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if not is_open and anim_name == "open":
		was_opened = false
		$AnimationPlayer.play("idle")
	if is_open and anim_name == "open":
		was_opened = true
