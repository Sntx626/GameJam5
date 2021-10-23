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
	add_to_currency(0)

var sleep = 0
func _process(delta):
	sleep += delta
	if sleep > 1:
		for i in range(len(data["buyer"])):
			if data["buyer"][i]:
				add_to_currency((i+1)*data["buyer"][i])
		sleep = 0
	buy_upgrades()

func buy_upgrades():
	if Input.is_action_just_pressed("prestige"):
		if data["score"] >= 1000:
			add_to_buyer(len(data["buyer"])-1, 1)
			data["score"] = 0
	if Input.is_action_just_pressed("supremacy"):
		if data["buyer"][len(data["buyer"])-1] >= 10:
			add_to_buyer(len(data["score"]["currencies"]), 1)

func update_text():
	$Score/ScoreValue.text = str(data["score"])

func update_combo(newValue, canFail):
	$Score/ComboLabel.text = str(newValue) + 'x';
	if (newValue == 0):
		$Score/ComboLabel.visible = false;
		if canFail:
			get_parent().failNode();
	else:
		$Score/ComboLabel.visible = true;
	return newValue

func add_to_currency(amount:int):
	data["score"] += amount
	update_text()

func add_to_buyer(tier:int, amount:int):
	if tier < len(data["buyer"])-1:
		data["buyer"][tier] += amount
	else:
		data["buyer"].append(0)
		add_to_buyer(tier, amount)
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
