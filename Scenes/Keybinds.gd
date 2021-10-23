extends Node2D

const default_button_text = "a, left\nw, up\nd, right"
const default_key_text = "Keybinds:\nLeft Arrow:\nCenter Arrow:\nRight Arrow:"

var prestige = false
var supremacy = false

func _ready():
	pass

# ! prestige and supremacy need to be reset
func _process(delta):
	if get_parent().data["score"] >= 1000:
		prestige = true
	else:
		prestige = false
	print(len(get_parent().get_parent().current_song["beatmaps"]))
	if get_parent().data["buyer"] >= len(get_parent().get_parent().current_song["beatmaps"])-1:
		supremacy = true
	else:
		supremacy = false
	update()

func update():
	var button_text = default_button_text
	var key_text = default_key_text
	
	if supremacy:
		button_text += "\no"
		key_text += "\nSupremacy:"
	elif prestige:
		button_text += "\np"
		key_text += "\nPrestige:"
	
	$KeybindsButtons.text = button_text
	$KeybindsKeys.text = key_text
