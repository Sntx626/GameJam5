extends Node2D

#JSON.print(my_dictionary, "\t")

#var data = {
#	"score": {
#		"currencies": [],	# e.g. scores
#		"buyer": []			# e.g. passive score
#	},
#	"prestige": {
#		"currencies": [], 	# e.g. chills
#		"buyer": []			# e.g. chiller
#	},
#	"supremacy": {
#		"currencies": [],	# e.g. genres
#		"buyer": []			# e.g. albums
#	}
#}
func load_data():
	var file = File.new()
	file.open("res://Saves/save_game.dat", File.READ)
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
	print("saved")

var data = null

func _ready():
	load_data()
	add_to_currency(0, 0)
	update_text()

var sleep = 0
func _process(delta):
	sleep += delta
	if sleep > 1:
		for i in range(len(data["score"]["buyer"])):
			if data["score"]["buyer"][i] > 0:
				add_to_currency(i, data["score"]["buyer"][i])
		sleep = 0

func update_text():
	#var txt = ""
	#for i in range(len(currencies)):
	#	txt += "T" + str(i) + ": " + str(currencies[i]) + "\n"
	if len(data["score"]["currencies"]) > 0:
		$Score/ScoreValue.text = str(data["score"]["currencies"][0])

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
