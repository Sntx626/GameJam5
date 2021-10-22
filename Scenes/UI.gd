extends Node2D
var templateUp =    ".        "
var templateRight = "   .     "
var templateLeft =  "      .  "

var bpm = 150;
var frequenz = 60000/bpm;

var arrow_up_list = [];
var arrow_right_list = [];
var arrow_left_list = [];

var template = load("res://Scenes/TemplateGhostArrow.tscn");
func _ready():
	updatePoints(0)
	pass
var points = 0;

var timeCollapsed = 0;
var tick = 0;

func updatePoints(newPoints):
	points = newPoints;
	$UI/Points.text = str(newPoints);

func _process(delta):
	timeCollapsed += delta * 1000;
	if (Input.is_action_just_released("A_up")):
		if (arrow_up_list.size() > 0):
			var timing = arrow_up_list[0].get('timeTraveld')/arrow_up_list[0].get('time');
			if (timing > 0.8 && timing < 0.95):
				updatePoints(points+1);
			remove_child(arrow_up_list[0]);
			arrow_up_list.remove(0);
	if (Input.is_action_just_released("A_left")):
		if (arrow_left_list.size() > 0):
			var timing = arrow_left_list[0].get('timeTraveld')/arrow_left_list[0].get('time');
			if (timing > 0.8 && timing < 0.95):
				updatePoints(points+1);
			remove_child(arrow_left_list[0]);
			arrow_left_list.remove(0);
	if (Input.is_action_just_released("A_right")):
		if (arrow_right_list.size() > 0):
			var timing = arrow_right_list[0].get('timeTraveld')/arrow_right_list[0].get('time');
			if (timing > 0.8 && timing < 0.95):
				updatePoints(points+1);
			remove_child(arrow_right_list[0]);
			arrow_right_list.remove(0);
			
	while (timeCollapsed > frequenz):
		print($UI/ArrowTop.position)
		tick += 1;
		timeCollapsed -= frequenz;
		if (templateUp[tick%templateUp.length()] == '.'):
			var instance = template.instance();
			var endPos = $UI/ArrowTop.position;
			instance.scale = $UI/ArrowTop.scale;
			instance.set("start_pos", Vector2(endPos.x, endPos.y - 400))
			instance.set("end_pos", Vector2(endPos.x, endPos.y + 50))
			arrow_up_list.append(instance);
			add_child(instance);
		if (templateRight[tick%templateUp.length()] == '.'):
			var instance = template.instance();
			instance.scale = $UI/ArrowRight.scale;
			var endPos = $UI/ArrowRight.position;
			#instance.set("start_pos", Vector2(endPos.x, endPos.y - 400))
			#instance.set("end_pos", Vector2(endPos.x, endPos.y + 50))
			instance.set("start_pos", Vector2(endPos.x + 400, endPos.y))
			instance.set("end_pos", Vector2(endPos.x - 50, endPos.y))
			instance.rotation_degrees = 90;
			arrow_right_list.append(instance);
			add_child(instance);
		if (templateLeft[tick%templateUp.length()] == '.'):
			var instance = template.instance();
			var endPos = $UI/ArrowLeft.position;
			instance.scale = $UI/ArrowLeft.scale;
			#instance.set("start_pos", Vector2(endPos.x, endPos.y - 400))
			#instance.set("end_pos", Vector2(endPos.x, endPos.y + 50))
			instance.set("start_pos", Vector2(endPos.x - 400, endPos.y))
			instance.set("end_pos", Vector2(endPos.x + 50, endPos.y))
			instance.rotation_degrees = -90;
			arrow_left_list.append(instance);
			add_child(instance);
	while (arrow_up_list.size() > 0 && arrow_up_list[0].get('stopped') == true):
		remove_child(arrow_up_list[0]);
		arrow_up_list.remove(0);
		pass;
	while (arrow_right_list.size() > 0 && arrow_right_list[0].get('stopped') == true):
		remove_child(arrow_right_list[0]);
		arrow_right_list.remove(0);
		pass;
	while (arrow_left_list.size() > 0 && arrow_left_list[0].get('stopped') == true):
		remove_child(arrow_left_list[0]);
		arrow_left_list.remove(0);
		pass;
