extends Node

var startedPlayer = false

signal sig_hit_input(input)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!$BeatPlayer.playing && Input.is_action_just_pressed("ui_accept")):
		startedPlayer = true;
	if(startedPlayer && !$BeatPlayer.playing):
		$BeatPlayer.play_from_beat(0,0)
		
	handle_input();

func _on_BeatPlayer_note(position):
	pass # Replace with function body.

func handle_input():
	if(Input.is_action_just_pressed("LEFT_HIT")):
		emit_signal("sig_left_hit")
	pass
