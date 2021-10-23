extends Node2D

const default_button_text = "a, left\nw, up\nd, right"
const default_key_text = "Keybinds:\nLeft Arrow:\nCenter Arrow:\nRight Arrow:"

var prestige = false
var supremacy = false

func _ready():
	pass

# ! prestige and supremacy need to be reset
func _process(delta):
	if len(get_parent().data["score"]["currencies"]) > 0:
		if get_parent().data["score"]["currencies"][len(get_parent().data["score"]["currencies"])-1] >= 1000:
			prestige = true
		else:
			prestige = false
	
	if len(get_parent().data["score"]["buyer"]) > 0:
		if get_parent().data["score"]["buyer"][len(get_parent().data["score"]["buyer"])-1] >= 10:
			supremacy = true
		else:
			supremacy = false
	update()

func update():
	var button_text = default_button_text
	var key_text = default_key_text
	
	if prestige:
		button_text += "\np"
		key_text += "\nPrestige:"
	
	if supremacy:
		button_text += "\no"
		key_text += "\nSupremacy:"
	
	$KeybindsButtons.text = button_text
	$KeybindsKeys.text = key_text
