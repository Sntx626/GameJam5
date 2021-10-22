extends Node2D

var bpm = 90;
var points = 0

func _ready():
	$Label.text = str(points)
	
func _on_Button_pressed():
	points += 1
	$Label.text = str(points)
