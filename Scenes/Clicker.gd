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
	add_to_currency(0, 0)

var sleep = 0
func _process(delta):
	sleep += delta
	if sleep > 1:
		for i in range(len(data["score"]["buyer"])):
			if data["score"]["buyer"][i] > 0:
				add_to_currency(i, data["score"]["buyer"][i])
		sleep = 0

func update_text():
	if len(data["score"]["currencies"]) > 0:
		$Score/ScoreValue.text = str(data["score"]["currencies"][0])

func update_combo(newValue, canFail):
	$Score/ComboLabel.text = str(newValue) + 'x';
	if (newValue == 0):
		$Score/ComboLabel.visible = false;
		if canFail:
			get_parent().failNode();
	else:
		$Score/ComboLabel.visible = true;
	return newValue

func add_to_currency(tier:int, amount:int):
	if tier < len(data["score"]["currencies"]):
		data["score"]["currencies"][tier] += amount
	else:
		data["score"]["currencies"].append(0)
		add_to_currency(tier, amount)
	update_text()

func add_to_buyer(tier:int, amount:int):
	if tier < len(data["score"]["buyer"]):
		data["score"]["buyer"][tier] += amount
	else:
		data["score"]["buyer"].append(0)
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
