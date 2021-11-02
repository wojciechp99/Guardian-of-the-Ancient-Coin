extends Area2D

var coin_scene = preload("res://coin.tscn")


func _on_Clay_pot_area_entered(area):
	if area.is_in_group("Sword"):
		var coin = coin_scene.instance()
		coin.global_position = global_position
		get_tree().get_root().add_child(coin)
		$AnimationPlayer.play("Destroyed")
		$SoundPotBreak.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
