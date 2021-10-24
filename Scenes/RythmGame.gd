extends Node2D
var templateUp =    ". . . . . . . . . . . . . . . . "
var templateRight = "               .                "
var templateLeft =  "                               ."

var bpm:int = 208;
var showTimeBeat:int = 3;

var restart_next_tick = true;
var stop = true;

func getFrequenz()->float:
	return 60000.0/float(bpm)
func getShowTime():
	return getFrequenz()*showTimeBeat

var arrow_up_list = [];
var arrow_right_list = [];
var arrow_left_list = [];

var arrow_up_pressed = false;
var arrow_right_pressed = false;
var arrow_left_pressed = false;

var template = load("res://Assets/arrow/ghost_arrow.tscn");
var template_particle = load("res://Scenes/ArrowParticel.tscn");
func _ready():
	pass
var points = 0;

var timeCollapsed = 0;
var tick = 0;

var combo = 0;

func restart_song():
	restart_next_tick = true;
func set_stop(newStop):
	stop = newStop;
	clearAll();

func addArrow(parent, list):
		var instance = template.instance();
		var endPos = parent.position;
		instance.position = parent.position;
		instance.scale = parent.scale;
		instance.rotation_degrees = parent.rotation_degrees;
		instance.set("time", getShowTime())
		instance.set("end_pos", Vector2(endPos.x, endPos.y))
		if endPos.x > 260:
			endPos.x -= 24
		elif endPos.x < 252:
			endPos.x += 24
		instance.set("start_pos", Vector2(endPos.x, endPos.y - 196))
		list.append(instance);
		add_child(instance);

func pressedRowEvent(row):
	if (row.size() > 0):
		var points = row[0].getStagePoints();
		if (not points == -1):
			if (points > 0):
				var replays = int(get_parent().clicker.data["tier"] + 1) / len(get_parent().list_files_in_dir("res://Songs"))
				var multi = (replays) if (replays > 0) else 1;
				get_parent().clicker.add_to_currency(points*multi)
				get_parent().hitNode();
				var part = template_particle.instance();
				add_child(part)
			if (points == row[0].get("stages_points")[0]):
				combo = get_parent().clicker.update_combo(combo + 1, true)
			elif (points == 0):
				combo = get_parent().clicker.update_combo(0, true)
			#get_parent().get_child(2).add_to_currency(0,row[0].getStagePoints())
			remove_child(row[0]);
			row.remove(0);

func clearRowFromStopped(row):
	while (row.size() > 0 && row[0].get("stopped") == true):
		remove_child(row[0])
		combo = get_parent().clicker.update_combo(0, true)
		row.remove(0)

func setArrowColor(arrow, r, g, b):
	arrow.modulate.r = r/255.0;
	arrow.modulate.g = g/255.0;
	arrow.modulate.b = b/255.0;

func clearAll():
	while (arrow_left_list.size() > 0):
		remove_child(arrow_left_list[0])
		arrow_left_list.remove(0)
	while (arrow_right_list.size() > 0):
		remove_child(arrow_right_list[0])
		arrow_right_list.remove(0)
	while (arrow_up_list.size() > 0):
		remove_child(arrow_up_list[0])
		arrow_up_list.remove(0)

func _process(delta):
	if not stop:
		timeCollapsed += delta * 1000;
		if (restart_next_tick):
			restart_next_tick = false;
			tick = 0;
			timeCollapsed = 0;
			clearAll();
			get_parent().startCall();
		if (Input.is_action_just_pressed("A_up") && not arrow_up_pressed):
			setArrowColor($ArrowTop, 66, 179, 245);
			arrow_up_pressed = true;
			pressedRowEvent(arrow_up_list);
		if (Input.is_action_just_pressed("A_left") && not arrow_left_pressed):
			setArrowColor($ArrowLeft, 66, 179, 245);
			arrow_left_pressed = true;
			pressedRowEvent(arrow_left_list);
		if (Input.is_action_just_pressed("A_right") && not arrow_right_pressed):
			setArrowColor($ArrowRight, 66, 179, 245);
			arrow_right_pressed = true;
			pressedRowEvent(arrow_right_list);
			
		if (Input.is_action_just_released("A_up") && arrow_up_pressed):
			setArrowColor($ArrowTop, 255, 255, 255);
			arrow_up_pressed = false;
		if (Input.is_action_just_released("A_left") && arrow_left_pressed):
			setArrowColor($ArrowLeft, 255, 255, 255);
			arrow_left_pressed = false;
		if (Input.is_action_just_released("A_right") && arrow_right_pressed):
			setArrowColor($ArrowRight, 255, 255, 255);
			arrow_right_pressed = false;
		while (timeCollapsed >= getFrequenz()):
			tick += 1;
			timeCollapsed -= getFrequenz();
			if (templateUp[(tick+showTimeBeat)%templateUp.length()] == '.'):
				addArrow($ArrowTop, arrow_up_list);
			if (templateRight[(tick+showTimeBeat)%templateRight.length()] == '.'):
				addArrow($ArrowRight, arrow_right_list);
			if (templateLeft[(tick+showTimeBeat)%templateLeft.length()] == '.'):
				addArrow($ArrowLeft, arrow_left_list);
			var song_audio_stream = get_parent().get("song_audio_stream");
			#for audio_stream in song_audio_stream:
			#	if (not audio_stream.playing):
			#		audio_stream.play(0)
		clearRowFromStopped(arrow_up_list)
		clearRowFromStopped(arrow_left_list)
		clearRowFromStopped(arrow_right_list)
