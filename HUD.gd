extends CanvasLayer

func _physics_process(delta):
	_ready()

func _ready():
	var Coins_from_steve = get_parent().get_node("Steve").coins
	var Health_from_steve = get_parent().get_node("Steve").health
	$hp.text = String(Health_from_steve)
	$coins.text = String(Coins_from_steve)
	
