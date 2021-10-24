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
		add_to_currency((data["tier"]+1)*(data["buyer"]+data["tier"])*(1+(data["combo"]/10))*delta)
	else:
		add_to_currency((data["tier"]+1)*(data["buyer"]+data["tier"])*delta)
	buy_upgrades()

func calculate_target_points(buyer, tier):
	return (100*(buyer+1))*(tier+1)

func buy_upgrades():
	if data["buyer"] >= len(get_parent().current_song["beatmaps"])-1 and data["score"] >= calculate_target_points(data["buyer"], data["tier"]):
		if Input.is_action_pressed("supremacy"):
			increase_tier()
			data["score"] = 0
			data["buyer"] = 0
			get_parent().load_song(data["tier"], data["buyer"])
	elif data["score"] >= calculate_target_points(data["buyer"], data["tier"]):
		if Input.is_action_pressed("prestige") and data["buyer"] < len(get_parent().current_song["beatmaps"]):
			add_to_buyer()
			data["score"] = 0
			get_parent().load_main_instrument(data["buyer"])

const average_intervall = 3
func last_second_average():
	var temp = 0
	for i in clickt:
		temp += i[0]
	return temp/average_intervall

func update_text():
	$Score/ScoreValue.text = str(int(data["score"]))
	$Score/ComboLabel/AverageScoreGain.text = str("+" + str(round(last_second_average()*10)/10)+ "/s")
	$Score/ScoreTarget.text = "Target: " + str(calculate_target_points(data["buyer"], data["tier"]))

func update_combo(newValue, canFail):
	data["combo"] = newValue
	$Score/ComboLabel.text = str(newValue) + 'x';
	if (newValue == 0):
		#$Score/ComboLabel.visible = false;
		#if canFail:
		#	get_parent().failNode();
		pass
	else:
		$Score/ComboLabel.visible = true;
	return newValue

var clickt = []
func add_to_currency(amount:float=1):
	data["score"] += amount
	
	var temp = OS.get_ticks_usec()
	clickt.append([amount, temp])
	for i in range(len(clickt)):
		if clickt[i][1] < OS.get_ticks_usec()-1000000*average_intervall:
			clickt.pop_front()
		else:
			break
	
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
	
	file.open("res://Saves/clicks.dat", File.WRITE)
	file.store_string(JSON.print(clickt))
	file.close()
