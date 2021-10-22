extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var points = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(points)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	points += 1
	$Label.text = str(points)
