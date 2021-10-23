extends Node2D

var bpm = 52;
var points = 0

var klicker = null
var audio_stream = null


func _ready():
	klicker = $Klicker
	audio_stream = $AudioStreamPlayer
