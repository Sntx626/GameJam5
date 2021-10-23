extends Node2D

var bpm = 52;
var points = 0

var clicker = null
var song_audio_stream = [];
var main_instrument_playtime = 2*1000;
var time_beetween_failure = 1 * 1000;
var last_fail = 0;
var play = false;

var index_main_instrument = 0;
var song_index = 0;
var song_instruments = [[
	preload("res://Sounds/GameJamLofi1_52Bpm/HiHats.wav"),
	preload("res://Sounds/GameJamLofi1_52Bpm/Kick.wav"),
	preload("res://Sounds/GameJamLofi1_52Bpm/Bass.wav"),
	preload("res://Sounds/GameJamLofi1_52Bpm/Lead.wav"),
	preload("res://Sounds/GameJamLofi1_52Bpm/Regen.wav"),
	preload("res://Sounds/GameJamLofi1_52Bpm/Rhodes.wav")
],
[
	preload("res://Sounds/Song2/Drums.wav"),
	preload("res://Sounds/Song2/Bass.wav"),
	preload("res://Sounds/Song2/Lead.wav"),
	preload("res://Sounds/Song2/Pluck.wav"),
	preload("res://Sounds/Song2/Ambience.wav")
]]
var song_beatmaps = [[
	[
		". . . . . . . . . . . . . . . . ",
		"               .                ",
		"                               .",
		3
	],
	[
		".     ",
		"  .   ",
		"    . ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	]
],[
	[
		". . . ..",
		" ",
		" ",
		3
	],
	[
		".     ",
		"  .   ",
		"    . ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	],
	[
		" ",
		" ",
		" ",
		3
	]
]
]
var song_bpm = [
	208,
	150
]

func add_instrument():
	load_main_instrument(index_main_instrument+1)
		
func load_main_instrument(i):
	index_main_instrument = i;
	for j in range(index_main_instrument):
		song_audio_stream[j].volume_db = -10;
	for j in range(index_main_instrument, song_audio_stream.size()):
		song_audio_stream[j].volume_db = -80;
	$RythmGame.set("templateUp", song_beatmaps[song_index][index_main_instrument][0])
	$RythmGame.set("templateRight", song_beatmaps[song_index][index_main_instrument][1])
	$RythmGame.set("templateLeft", song_beatmaps[song_index][index_main_instrument][2])
	$RythmGame.set("showTimeBeat", song_beatmaps[song_index][index_main_instrument][3])
	
func load_song(i):
	$RythmGame.set_stop(true);
	song_index = i;
	for stream in song_audio_stream:
		stream.volume_db = -80;
	for j in range(song_instruments[i].size()):
		song_audio_stream[j].stream = song_instruments[i][j];
	load_main_instrument(index_main_instrument)
	$RythmGame.set("bpm", song_bpm[i])
	$RythmGame.set_stop(false);
	$RythmGame.restart_song();

func tryReset():
	pass;

func startCall():
	for j in range(song_instruments[song_index].size()):
		song_audio_stream[j].play(0);
	pass;

func _ready():
	clicker = $Clicker
	song_audio_stream.append($AudioStream1)
	song_audio_stream.append($AudioStream2)
	song_audio_stream.append($AudioStream3)
	song_audio_stream.append($AudioStream4)
	song_audio_stream.append($AudioStream5)
	song_audio_stream.append($AudioStream6)
	load_song($Clicker.data["tier"]);
	load_main_instrument($Clicker.data["buyer"])

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
		song_audio_stream[index_main_instrument].volume_db = -80;

func hitNode():
	if (not play):
		play = true;
		song_audio_stream[index_main_instrument].volume_db = -10;
	pass;

func _notification(event):
	if event == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST or event == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$Clicker.save_data()
