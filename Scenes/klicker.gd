extends Node2D

var currency_t0 = 0
var currency_t1 = 0
var currency_t2 = 0
var currency_t3 = 0

func _ready():
	$Label.text = get_text()

func _on_Button_pressed():
	currency_t0 += 1
	$Label.text = get_text()

func get_text():
	var txt = "currency_t0: " + str(currency_t0) + "\n"
	txt += "currency_t1: " + str(currency_t1) + "\n"
	txt += "currency_t1: " + str(currency_t2) + "\n"
	txt += "currency_t1: " + str(currency_t3)
	return txt
