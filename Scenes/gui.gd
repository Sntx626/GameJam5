extends Sprite


func _ready():
	pass

func _process(delta):
	frame = get_parent().clicker.data["buyer"]
	
