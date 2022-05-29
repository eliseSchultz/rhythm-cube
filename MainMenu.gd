extends Node


var levelJson = {"note_placement":[16,24,32,44]}

var strCan = "soda_can"
var currPlacement = 0
var is_lamp_on = true
var missed_last = false
var hitPlacement = -99

var is_end_game = false;

var score = 0

signal input_pressed(input)


# Called when the node enters the scene tree for the first time.
func _ready():
	currPlacement = 0
	strCan = "soda_can"
	score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(is_end_game && Input.is_action_just_pressed("ui_end")):
		get_tree().quit()
	$Viewport/MainMenuVP/lamp/OmniLight.visible = is_lamp_on
		

func start_playing():
	$Viewport/MainMenuVP.start_playing()
	$PressSpace.visible = false;
	$PressSpaceBG.visible = false;
	$FBG.visible = true
	$F.visible = true
	
func end_game():
	if(score >= 120):
		$FinalScore.text = "S"
		$FinalScoreBG.text = "S"
	elif(score >= 100):
		$FinalScore.text = "A"
		$FinalScoreBG.text = "A"
	elif(score >= 80):
		$FinalScore.text = "B"
		$FinalScoreBG.text = "B"
	elif(score >= 30):
		$FinalScore.text = "C"
		$FinalScoreBG.text = "C"
	else:
		$FinalScore.text = "F"
		$FinalScoreBG.text = "F"
		
	$FBG.visible = false
	$F.visible = false
	
	$FinalScore.visible = true
	$FinalScoreBG.visible = true
	
	is_end_game = true;
	

func _on_BeatPlayer_measure(position):
	$Metronome.metronome_pulse();


func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	$Viewport/MainMenuVP.camera_pulse(song_position_in_beats, song_position_in_notes);
	if(currPlacement < levelJson["note_placement"].size() && song_position_in_notes == levelJson["note_placement"][currPlacement]):
		hitPlacement = levelJson["note_placement"][currPlacement] + 4;
		if($Metronome/Click.playing):
			$Metronome/Click.stop()
		$Metronome/Click.play()
		$F.modulate = Color("ef1543")
		currPlacement += 1;
	elif(hitPlacement == song_position_in_notes):
		$F.modulate = Color("6de735")
	else:
		$F.modulate = Color("c9ebff")
	if(!$GreenCheck.visible && song_position_in_notes == hitPlacement + 1):
		if($MissSound.playing):
			$MissSound.stop()
		$MissSound.play()
		score -= 20
		missed_last = true;
		$RedX.visible = true;
	if(song_position_in_notes % 4 == 2):
		missed_last = false;
		$RedX.visible = false;
		$GreenCheck.visible = false;
	

func _on_BeatPlayer_sig_time_off_beat(v2TimeOffBeat, input):
	if(input == "RIGHT_HIT" && int(v2TimeOffBeat.x) % 4 == 2):
		if($SwitchSound.playing):
			$SwitchSound.stop()
		$SwitchSound.play()
		score += 10;
		is_lamp_on = !is_lamp_on
	elif(int(v2TimeOffBeat.x) % 4 > 0):
		if($MissSound.playing):
			$MissSound.stop()
		$MissSound.play()
		score -= 20
		missed_last = true;
		$RedX.visible = true;
	elif(!missed_last && v2TimeOffBeat.x == hitPlacement):
		if(input == "LEFT_HIT"):
			if($HitSound.playing):
				$HitSound.stop()
			$HitSound.play()
			$GreenCheck.visible = true
			score += 30
	


func _on_MainMenuVP_camera_turn(strHexColor):
	$PressSpace.modulate = Color(strHexColor)
