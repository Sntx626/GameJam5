extends Sprite

var start_pos = Vector2(400, 100);
var end_pos = Vector2(400, 400);
var time = 2000;
var timeTraveld = 0;
var stopped = false;

func _ready():
	pass # Replace with function body.
#update
func _process(delta):
	if not stopped:
		timeTraveld += delta*1000;
		var procentage = timeTraveld/time;
		var dir = end_pos - start_pos;
		dir = dir * procentage;
		dir += start_pos;
		position = dir;
		modulate.a = procentage;
		if (timeTraveld > time):
			stopped = true;
