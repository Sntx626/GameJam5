extends Node2D

var bpm = 52;
var points = 0

var clicker = null
var song_audio_stream = [];
var main_instrument_playtime = 2*1000;
var time_beetween_failure = 1 * 1000;
var last_fail = 0;
var play = false;

func list_files_in_dir(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files

var current_song = null
var current_beatmap = 0
func get_song(index:int) -> Dictionary:
	var song = null
	
	var file = File.new()
	for d in list_files_in_dir("res://Songs"):
		print(d)
		if file.file_exists("res://Songs/"+d+"/data.json"):
			file.open("res://Songs/"+d+"/data.json", File.READ)
			var p = JSON.parse(file.get_as_text())
			if typeof(p.result) == TYPE_DICTIONARY:
				if p.result["metadata"]["song_index"] == index:
					song = p.result
					$RythmGame.set_stop(true);
					for stream in song_audio_stream:
						stream.volume_db = -80;
					for i in range(len(song["beatmaps"])):
						song_audio_stream[i].stream = load("res://Songs/"+d+"/sounds/"+song["beatmaps"][i]["instrument"])
						print("loaded:", song["beatmaps"][i]["instrument"])
					var gui_img = load("res://Songs/" + d + "/gui_complete.PNG");
					$GuiSong.texture = gui_img
					$GuiSong.hframes = song["beatmaps"].size()
					$RythmGame.set("bpm", song["metadata"]["song_bpm"])
					$RythmGame.set_stop(false);
					$RythmGame.restart_song();
					break
			else:
				push_error("Unexpected results.")
			file.close()
	return song

func add_instrument():
	load_main_instrument(current_beatmap+1)

func load_main_instrument(i:int=0):
	current_beatmap = i;
	for j in range(current_beatmap):
		song_audio_stream[j].volume_db = -10;
	for j in range(current_beatmap, song_audio_stream.size()):
		song_audio_stream[j].volume_db = -80;
	if (play):
		song_audio_stream[current_beatmap].volume_db = -10;
	$RythmGame.set("templateUp", current_song["beatmaps"][current_beatmap]["center"])
	$RythmGame.set("templateRight", current_song["beatmaps"][current_beatmap]["right"])
	$RythmGame.set("templateLeft", current_song["beatmaps"][current_beatmap]["left"])
	$RythmGame.set("showTimeBeat", current_song["beatmaps"][current_beatmap]["beats_to_play"])

func tryReset():
	pass;

func startCall():
	for j in range(len(current_song["beatmaps"])):
		song_audio_stream[j].play(0);

func _ready():
	clicker = $Clicker
	song_audio_stream.append($AudioStream1)
	song_audio_stream.append($AudioStream2)
	song_audio_stream.append($AudioStream3)
	song_audio_stream.append($AudioStream4)
	song_audio_stream.append($AudioStream5)
	song_audio_stream.append($AudioStream6)
	load_song($Clicker.data["tier"], $Clicker.data["buyer"])

func load_song(song_index, beatmap_index):
	current_song = get_song(int(song_index)%len(list_files_in_dir("res://Songs")));
	load_main_instrument(beatmap_index)

func _process(delta):
	if not last_fail == 0:
		var timeCollapsed = delta * 1000;
		last_fail -= timeCollapsed;
		if (last_fail <= 0):
			last_fail = 0;
		
	#animation for guitar guy
	if $Clicker.data["buyer"] == 0 and $Clicker.data["tier"] == 0 and not $guitarPlayer.playing:
		$guitarPlayer.play("playing");
	
	if $Clicker.data["buyer"] == 1 and $Clicker.data["tier"] == 0 and not $guitarPlayer.toCampfire:
		$guitarPlayer.goToCampfire();
	
	if $Clicker.data["buyer"] == 3 and $Clicker.data["tier"] == 0 and not $campfire.playing:
		$campfire.play("goingOn");

func failNode():
	if (last_fail == 0):
		$AudioStreamFail.play(0)
		last_fail = time_beetween_failure;
	if (play):
		play = false;
		song_audio_stream[current_beatmap].volume_db = -80;

func hitNode():
	if (not play):
		play = true;
		song_audio_stream[current_beatmap].volume_db = -10;
	pass;

func _notification(event):
	if event == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST or event == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$Clicker.save_data()


func _on_campfire_animation_finished():
	if $campfire.animation == "goingOn" :
		$campfire.play("burning");
