extends Node2D

const default_button_text = "s, left\nd, up\nf, right"
const default_key_text = "Keybinds:\nLeft Arrow:\nCenter Arrow:\nRight Arrow:"

var prestige = false
var supremacy = false

func _ready():
	pass

# ! prestige and supremacy need to be reset
func _process(delta):
	if get_parent().data["score"] >= get_parent().calculate_target_points(get_parent().data["buyer"], get_parent().data["tier"]):
		prestige = true
	else:
		prestige = false
	if get_parent().data["buyer"] >= len(get_parent().get_parent().current_song["beatmaps"])-1 and get_parent().data["score"] >= get_parent().calculate_target_points(get_parent().data["buyer"], get_parent().data["tier"]):
		supremacy = true
	else:
		supremacy = false
	update()

func update():
	var button_text = default_button_text
	var key_text = default_key_text
	
	if supremacy:
		button_text += "\nk"
		key_text += "\nNextSong:"
	elif prestige:
		button_text += "\nj"
		key_text += "\nNextInstrument:"
	
	$KeybindsButtons.text = button_text
	$KeybindsKeys.text = key_text
