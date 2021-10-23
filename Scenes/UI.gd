extends Node2D
var templateUp =    ". . .   . . .   "
var templateRight = " .              "
var templateLeft =  "      .       . "

var bpm = 208;
var showTimeBeat = 3;
var frequenz = 60000/bpm;
var showTime = frequenz*showTimeBeat;


var arrow_up_list = [];
var arrow_right_list = [];
var arrow_left_list = [];

var template = load("res://Scenes/TemplateGhostArrow.tscn");
func _ready():
	updateCombo(0);
	pass
var points = 0;

var timeCollapsed = 0;
var tick = 0;

var combo = 0;

func updateCombo(newValue):
	combo = newValue
	$UI/ComboLabel.text = str(newValue) + 'x';
	if (newValue == 0):
		$UI/ComboLabel.visible = false;
	else:
		$UI/ComboLabel.visible = true;

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
				updateCombo(combo + 1)
				get_parent().hitNode();
			else:
				updateCombo(0)
			#get_parent().get_child(2).add_to_currency(0,row[0].getStagePoints())
			remove_child(row[0]);
			row.remove(0);

func clearRowFromStopped(row):
	while (row.size() > 0 && row[0].get("stopped") == true):
		remove_child(row[0])
		updateCombo(0)
		row.remove(0)



func _process(delta):
	timeCollapsed += delta * 1000;
	if (Input.is_action_just_released("A_up")):
		pressedRowEvent(arrow_up_list);
	if (Input.is_action_just_released("A_left")):
		pressedRowEvent(arrow_left_list);
	if (Input.is_action_just_released("A_right")):
		pressedRowEvent(arrow_right_list);
	
	while (timeCollapsed > frequenz):
		tick += 1;
		timeCollapsed -= frequenz;
		if (templateUp[(tick+showTimeBeat)%templateUp.length()] == '.'):
			addArrow($UI/ArrowTop, arrow_up_list);
		if (templateRight[(tick+showTimeBeat)%templateUp.length()] == '.'):
			addArrow($UI/ArrowRight, arrow_right_list);
		if (templateLeft[(tick+showTimeBeat)%templateUp.length()] == '.'):
			addArrow($UI/ArrowLeft, arrow_left_list);
		var song_audio_stream = get_parent().get("song_audio_stream");
		for audio_stream in song_audio_stream:
			if (not audio_stream.playing):
				audio_stream.play(0)
	clearRowFromStopped(arrow_up_list)
	clearRowFromStopped(arrow_left_list)
	clearRowFromStopped(arrow_right_list)
