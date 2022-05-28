extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal input_pressed(input)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_BeatPlayer_measure(position):
	$Metronome.metronome_pulse();


func _on_BeatPlayer_note(position):
	$Viewport/MainMenuVP.camera_pulse(position);
