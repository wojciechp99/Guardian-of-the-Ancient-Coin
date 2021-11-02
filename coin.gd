extends Area2D

var collected = false

func _on_coin_body_entered(body):
	if not collected:
		collected = true
		$AnimationPlayer.play("collected")
		$SoundCoinCollect.play()
		body.collect_coin()
		#print("coin collected")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
