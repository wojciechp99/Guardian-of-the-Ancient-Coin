extends Area2D

var was_opened = false
var coin_scene = preload("res://coin.tscn")
var amount_of_coins_dropped = 5
var coins_to_drop = amount_of_coins_dropped


func _on_chest_body_entered(body):
	$AnimationPlayer.play("open")
	$SoundChestOpen.play()
	if not was_opened:
		while coins_to_drop != 0:
			var coin = coin_scene.instance()
			get_tree().create_timer(1)
			coin.global_position = global_position
			get_tree().get_root().add_child(coin)
			coins_to_drop -= 1
			yield(get_tree().create_timer(0.5), "timeout")
		was_opened = true


func _on_chest_body_exited(body):
	$AnimationPlayer.play_backwards("open")


