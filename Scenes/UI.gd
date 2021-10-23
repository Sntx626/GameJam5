extends Node2D
var templateUp =    ". . . . . . . . . . . . . . . . "
var templateRight = "               .                "
var templateLeft =  "                               ."

var bpm = 208;
var showTimeBeat = 3;


var frequenz = 60000/bpm;
var showTime = frequenz*showTimeBeat;


var arrow_up_list = [];
var arrow_right_list = [];
var arrow_left_list = [];


var arrow_up_pressed = false;
var arrow_right_pressed = false;
var arrow_left_pressed = false;

var template = load("res://Scenes/TemplateGhostArrow.tscn");
func _ready():
	pass
var points = 0;

var timeCollapsed = 0;
var tick = 0;

var combo = 0;

func addArrow(parent, list):
		var instance = template.instance();
		var endPos = parent.position;
		instance.position = parent.position;
		instance.scale = parent.scale;
		instance.rotation_degrees = parent.rotation_degrees;
		instance.set("time", showTime)
		instance.set("start_pos", Vector2(endPos.x, endPos.y - 248))
		instance.set("end_pos", Vector2(endPos.x, endPos.y))
		list.append(instance);
		add_child(instance);

func pressedRowEvent(row):
	if (row.size() > 0):
		var points = row[0].getStagePoints();
		if (not points == -1):
			get_parent().klicker.add_to_currency(0,points)
			if (points > 0):
				get_parent().hitNode();
			if (points == row[0].get("stages_points")[0]):
				combo = get_parent().klicker.update_combo(combo + 1, true)
			elif (points == 0):
				combo = get_parent().klicker.update_combo(0, true)
			#get_parent().get_child(2).add_to_currency(0,row[0].getStagePoints())
			remove_child(row[0]);
			row.remove(0);

func clearRowFromStopped(row):
	while (row.size() > 0 && row[0].get("stopped") == true):
		remove_child(row[0])
		combo = get_parent().klicker.update_combo(0, true)
		row.remove(0)

func setArrowColor(arrow, r, g, b):
	arrow.modulate.r = r/255.0;
	arrow.modulate.g = g/255.0;
	arrow.modulate.b = b/255.0;

func _process(delta):
	timeCollapsed += delta * 1000;
	if (Input.is_action_just_pressed("A_up") && not arrow_up_pressed):
		setArrowColor($UI/ArrowTop, 66, 179, 245);
		arrow_up_pressed = true;
		pressedRowEvent(arrow_up_list);
	if (Input.is_action_just_pressed("A_left") && not arrow_left_pressed):
		setArrowColor($UI/ArrowLeft, 66, 179, 245);
		arrow_left_pressed = true;
		pressedRowEvent(arrow_left_list);
	if (Input.is_action_just_pressed("A_right") && not arrow_right_pressed):
		setArrowColor($UI/ArrowRight, 66, 179, 245);
		arrow_right_pressed = true;
		pressedRowEvent(arrow_right_list);
		
	if (Input.is_action_just_released("A_up") && arrow_up_pressed):
		setArrowColor($UI/ArrowTop, 255, 255, 255);
		arrow_up_pressed = false;
	if (Input.is_action_just_released("A_left") && arrow_left_pressed):
		setArrowColor($UI/ArrowLeft, 255, 255, 255);
		arrow_left_pressed = false;
	if (Input.is_action_just_released("A_right") && arrow_right_pressed):
		setArrowColor($UI/ArrowRight, 255, 255, 255);
		arrow_right_pressed = false;
	while (timeCollapsed > frequenz):
		tick += 1;
		timeCollapsed -= frequenz;
		if (templateUp[(tick+showTimeBeat)%templateUp.length()] == '.'):
			addArrow($UI/ArrowTop, arrow_up_list);
		if (templateRight[(tick+showTimeBeat)%templateRight.length()] == '.'):
			addArrow($UI/ArrowRight, arrow_right_list);
		if (templateLeft[(tick+showTimeBeat)%templateLeft.length()] == '.'):
			addArrow($UI/ArrowLeft, arrow_left_list);
		var song_audio_stream = get_parent().get("song_audio_stream");
		#for audio_stream in song_audio_stream:
		#	if (not audio_stream.playing):
		#		audio_stream.play(0)
	clearRowFromStopped(arrow_up_list)
	clearRowFromStopped(arrow_left_list)
	clearRowFromStopped(arrow_right_list)
