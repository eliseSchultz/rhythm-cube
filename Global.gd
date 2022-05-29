extends Node

var startedPlayer = false

signal sig_hit_input(input)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!$BeatPlayer.playing && Input.is_action_just_pressed("ui_accept")):
		startedPlayer = true
		$MainMenu.start_playing()
		$BeatPlayer.play_from_beat(0,0)
	if(startedPlayer && !$BeatPlayer.playing):
		$MainMenu.end_game()
		
	if($BeatPlayer.playing):
		handle_input();

func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	pass # Replace with function body.

func handle_input():
	if(Input.is_action_just_pressed("LEFT_HIT")):
		emit_signal("sig_hit_input", "LEFT_HIT")
	if(Input.is_action_just_pressed("RIGHT_HIT")):
		emit_signal("sig_hit_input", "RIGHT_HIT")
	pass
