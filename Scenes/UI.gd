extends Node2D
var templateUp =    ".   . . .   . .."
var templateRight = "  .       .     "
var templateLeft =  "  .       .     "

var bpm = 52*4;

var frequenz = 60000/bpm;
var showTime = frequenz*2;

var upP = false;
var leftP = false;
var rightP = false;

var arrow_up_list = [];
var arrow_right_list = [];
var arrow_left_list = [];

var template = load("res://Scenes/TemplateGhostArrow.tscn");
func _ready():
	pass
var points = 0;

var timeCollapsed = 0;
var tick = 0;

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
			get_parent().klicker.add_to_currency(0,row[0].getStagePoints())
			#get_parent().get_child(2).add_to_currency(0,row[0].getStagePoints())
			remove_child(row[0]);
			row.remove(0);

func clearRowFromStopped(row):
	while (row.size() > 0 && row[0].get("stopped") == true):
		remove_child(row[0])
		row.remove(0)

func _process(delta):
	timeCollapsed += delta * 1000;
	if (Input.is_action_just_pressed("A_up") && not upP):
		upP = true;
		pressedRowEvent(arrow_up_list);
	if (Input.is_action_just_pressed("A_left") && not leftP):
		leftP = true;
		pressedRowEvent(arrow_left_list);
	if (Input.is_action_just_pressed("A_right") && not rightP):
		rightP = true;
		pressedRowEvent(arrow_right_list);
	if (Input.is_action_just_released("A_up") && upP):
		upP = false;
	if (Input.is_action_just_released("A_left") && leftP):
		leftP = false;
	if (Input.is_action_just_released("A_right") && rightP):
		rightP = false;
	while (timeCollapsed > frequenz):
		print($UI/ArrowTop.position)
		tick += 1;
		timeCollapsed -= frequenz;
		if (templateUp[tick%templateUp.length()] == '.'):
			addArrow($UI/ArrowTop, arrow_up_list);
		if (templateRight[tick%templateRight.length()] == '.'):
			addArrow($UI/ArrowRight, arrow_right_list);
		if (templateLeft[tick%templateLeft.length()] == '.'):
			addArrow($UI/ArrowLeft, arrow_left_list);
	clearRowFromStopped(arrow_up_list)
	clearRowFromStopped(arrow_left_list)
	clearRowFromStopped(arrow_right_list)
