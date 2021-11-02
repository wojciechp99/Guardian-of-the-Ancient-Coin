extends Area2D

var collected = false

func _on_purple_coin_body_entered(body):
	if not collected:
		collected = true
		$AnimationPlayer.play("collected")
		$SoundPurpleCoinCollected.play()
		body.collect_coin()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


