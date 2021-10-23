extends Node2D

func load_data():
	var file = File.new()
	if file.file_exists("res://Saves/save_game.dat"):
		file.open("res://Saves/save_game.dat", File.READ)
	else:
		file.open("res://Saves/default_save_game.dat", File.READ)
	var p = JSON.parse(file.get_as_text())
	if typeof(p.result) == TYPE_DICTIONARY:
		data = p.result
	else:
		push_error("Unexpected results.")
	file.close()

func save_data():
	var file = File.new()
	file.open("res://Saves/save_game.dat", File.WRITE)
	file.store_string(JSON.print(data, "\t"))
	file.close()

var data = null

func _ready():
	load_data()
	update_combo(data["combo"], false)

func _process(delta):
	if data["combo"] > 0:
		add_to_currency((data["tier"]+1)*data["buyer"]*data["combo"]*delta)
	else:
		add_to_currency((data["tier"]+1)*data["buyer"]*delta)
	buy_upgrades()

func buy_upgrades():
	if data["buyer"] >= 4:
		if Input.is_action_pressed("supremacy"):
			increase_tier()
			data["score"] = 0
			data["buyer"] = 0
			get_parent().load_main_instrument()
	elif data["score"] >= 1000:
		if Input.is_action_pressed("prestige"):
			add_to_buyer()
			data["score"] = 0
			get_parent().add_instrument()

func update_text():
	$Score/ScoreValue.text = str(int(data["score"]))

func update_combo(newValue, canFail):
	data["combo"] = newValue
	$Score/ComboLabel.text = str(newValue) + 'x';
	if (newValue == 0):
		$Score/ComboLabel.visible = false;
		if canFail:
			get_parent().failNode();
	else:
		$Score/ComboLabel.visible = true;
	return newValue

func add_to_currency(amount:float=1):
	data["score"] += amount
	update_text()

func add_to_buyer(amount:float=1):
	data["buyer"] += amount
	update_text()

func increase_tier(amount:int=1):
	data["tier"] += amount
	update_text()

func _del_save_game():
	var file = File.new()
	file.open("res://Saves/default_save_game.dat", File.READ)
	var p = JSON.parse(file.get_as_text())
	if typeof(p.result) == TYPE_DICTIONARY:
		data = p.result
		print("reset")
	else:
		push_error("Unexpected results.")
	file.close()
	
	var dir = Directory.new()
	dir.remove("res://Saves/save_game.dat")
	
	update_text()
