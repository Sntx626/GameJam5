extends Sprite

var start_pos = Vector2(400, 100);
var end_pos = Vector2(400, 400);
var time = 2000;
var timeTraveld = 0;
var stopped = false;

var min_destroy = 0.5;
var stages_offset = [0.05, 0.15, 0.3]
var stages_color = [[0, 171, 83], [245, 245, 66], [171, 0, 14]]
var stages_points = [3, 2, 1]

var canBePressed = false;

var offset_time = 0.1
var min_time = 1-offset_time
var max_time = 1+offset_time

func isPressable():
	var pressTime = timeTraveld/time;
	return pressTime > min_time && pressTime < max_time;

func getStagePoints():
	var pressTime = abs(1-timeTraveld/time);
	for i in range(stages_offset.size()):
		if (pressTime < stages_offset[i]):
			return stages_points[i]
	if (pressTime > min_destroy):
		return -1;
	return 0;

func interpolate1D(start, end, x):
	return start*(1-x) + end*x;

func interpolate2D(start1, end1, start2, end2, x, y):
	var s = interpolate1D(start1, end1, x)
	var t = interpolate1D(start2, end2, x)
	return interpolate1D(s, t, y)

func setStageColor():
	var pressTime = abs(1-timeTraveld/time);
	#if (pressTime  > stages_offset[stages_offset.size()] && pressTime < stages_offset[stages_offset.size()]+offset_time):	
		
	for i in range(stages_offset.size()):
		if (pressTime < stages_offset[i]):
			set_color(stages_color[i][0], stages_color[i][1], stages_color[i][2])
			return
	set_color(255, 255, 255);

func getStageColor():
	var pressTime = abs(1-timeTraveld/time);
	#if (pressTime  > stages_offset[stages_offset.size()] && pressTime < stages_offset[stages_offset.size()]+offset_time):	
		
	for i in range(stages_offset.size()):
		if (pressTime < stages_offset[i]):
			return Vector3(stages_color[i][0], stages_color[i][1], stages_color[i][2])
	return Vector3(255, 255, 255)
	

func set_color(r, g, b):
	modulate.r = r/255.0;
	modulate.g = g/255.0;
	modulate.b = b/255.0;
	

func _ready():
	set_color(255, 255, 255)
	pass # Replace with function body.
#update
func _process(delta):
	if not stopped:
		timeTraveld += delta*1000;
		setStageColor();
		var procentage = timeTraveld/time;
		var dir = end_pos - start_pos;
		dir = dir * procentage;
		dir += start_pos;
		position = dir;
		modulate.a = (0.2 + (procentage*4)/5) if (procentage < 1) else 0;
		if (timeTraveld > time+time*offset_time):
			stopped = true;
