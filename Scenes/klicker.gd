extends Node2D

# score
var currencies = []
var buyer = []

# prestige
var chills = []
var chiller = []

# supremacy
var genres = []
var albums = []

func _ready():
	add_to_currency(0, 0)
	update_text()

var sleep = 0
func _process(delta):
	sleep += delta
	if sleep > 1:
		for i in range(len(buyer)):
			if buyer[i] > 0:
				add_to_currency(i, buyer[i])
		sleep = 0

func update_text():
	var txt = ""
	for i in range(len(currencies)):
		txt += "T" + str(i) + ": " + str(currencies[i]) + "\n"
	$Score.text = txt

func add_to_currency(tier:int, amount:int):
	if tier < len(currencies):
		currencies[tier] += amount
	else:
		currencies.append(0)
		add_to_currency(tier, amount)
	update_text()

func add_to_buyer(tier:int, amount:int):
	if tier < len(buyer):
		buyer[tier] += amount
	else:
		buyer.append(0)
		add_to_buyer(tier, amount)
	update_text()
