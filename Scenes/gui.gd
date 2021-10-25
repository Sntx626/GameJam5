extends Sprite


func _ready():
	pass

func _process(_delta):
	frame = get_parent().clicker.data["buyer"]
