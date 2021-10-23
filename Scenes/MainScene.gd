extends Node2D

var bpm = 52;
var points = 0

var klicker = null
var song_audio_stream = [];
var main_instrument_audio_stream;
func _ready():
	klicker = $Klicker
	song_audio_stream.append($AudioStreamPlayer)
func hitNode():
	print("Test")
	pass;
