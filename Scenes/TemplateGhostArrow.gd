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
var max_scale: Vector2 = Vector2(1, 1)
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

func anim_get_speed(begin_time, end_time): # end-begin
	return 1000/(time*(begin_time-end_time))

var is_anim_0_playing = false
var is_anim_1_playing = false
var is_anim_2_playing = false
func setStageColor():
	var pressTime = abs(1-timeTraveld/time);
	#if (pressTime  > stages_offset[stages_offset.size()] && pressTime < stages_offset[stages_offset.size()]+offset_time):	
		
	for i in range(stages_offset.size()):
		if (pressTime < stages_offset[i]):
			if i == 2 and not is_anim_0_playing:
				is_anim_0_playing = true
				$AnimationPlayer.playback_speed = anim_get_speed(stages_offset[2], stages_offset[1])
				$AnimationPlayer.play("white_to_red")
			elif i == 1 and not is_anim_1_playing:
				is_anim_1_playing = true
				$AnimationPlayer.playback_speed = anim_get_speed(stages_offset[1], stages_offset[0])
				$AnimationPlayer.play("red_to_purple")
			elif i == 0 and not is_anim_2_playing:
				is_anim_2_playing = true
				$AnimationPlayer.playback_speed = anim_get_speed(stages_offset[0], 0)
				$AnimationPlayer.play("purple_to_blue")
			return

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
	
func bezier_not_really(val:float):
	return 0.2 * pow(1-val, 3) + 3 * 1.2 * pow(1-val, 2) * val + 3 * 0.9 * (1-val) * pow(val, 2) + pow(val, 3);

func _ready():
	$AnimationPlayer.play("flight")
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
		modulate.a = bezier_not_really(procentage);
		scale = max_scale * bezier_not_really(procentage);
		#scale = (max_scale - max_scale * 0.2) * procentage + max_scale * 0.2;
		if (timeTraveld > time+time*offset_time):
			stopped = true;
