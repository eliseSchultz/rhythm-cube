extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var metronome_click = false; 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
	
func metronome_pulse():
	visible = true;
	$Pulse.start()
	if(metronome_click):
		if($Click.playing):
			$Click.stop();
		$Click.play();

func _on_BeatPlayer_measure(position):
	if(position % 2 == 0):
		visible = false;
	else:
		visible = true;


func _on_Pulse_timeout():
	visible = false;
