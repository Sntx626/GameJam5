extends Node2D

var currencies = []
var buyer = []

func _ready():
	$Label.text = get_text()

var sleep = 0
func _process(delta):
	sleep += delta
	if sleep > 1:
		for i in range(len(buyer)):
			add_to_currency(i, buyer[i])
		sleep = 0
		$Label.text = get_text()

func get_text():
	var txt = ""
	for i in range(len(currencies)):
		txt += "T" + str(i) + ": " + str(currencies[i]) + "\n"
	return txt

func add_to_currency(tier:int, amount:int):
	if tier < len(currencies):
		currencies[tier] += amount
	else:
		currencies.append(0)
		add_to_currency(tier, amount)
	$Label.text = get_text()

func add_to_buyer(tier:int, amount:int):
	if tier < len(buyer):
		buyer[tier] += amount
	else:
		buyer.append(0)
		add_to_buyer(tier, amount)
	$Label.text = get_text()
