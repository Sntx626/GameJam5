extends Node2D

var bpm = 52;
var points = 0

var klicker = null
var song_audio_stream = [];
var main_instrument_audio_stream;
var main_instrument_playtime = 2*1000;
var time_beetween_failure = 1 * 1000;
var last_fail = 0;
var play = false;

func _ready():
	klicker = $Klicker
	song_audio_stream.append($AudioStreamBass)
	song_audio_stream.append($AudioStreamLead)
	song_audio_stream.append($AudioStreamHiHats)
	song_audio_stream.append($AudioStreamKick)
	song_audio_stream.append($AudioStreamRegen)
	song_audio_stream.append($AudioStreamRhodes)
	main_instrument_audio_stream = $AudioStreamHiHats
	main_instrument_audio_stream.volume_db = -80;

func _process(delta):
	if not last_fail == 0:
		var timeCollapsed = delta * 1000;
		last_fail -= timeCollapsed;
		if (last_fail <= 0):
			last_fail = 0;

func failNode():
	if (last_fail == 0):
		$AudioStreamFail.play(0)
		last_fail = time_beetween_failure;
	if (play):
		play = false;
		main_instrument_audio_stream.volume_db = -80;

func hitNode():
	if (not play):
		play = true;
		main_instrument_audio_stream.volume_db = -10;
	pass;
