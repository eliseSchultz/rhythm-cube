extends Node

var levelJson = {"note_placement":[16,24,32,40,50,56,64,72,80,88,98,104,112,120,128,136,144,152,160,168,176,186,192,200,210,216,226,232,240,248,258,264]}

var strCan = "soda_can"
var currPlacement = 0
var is_lamp_on = true
var missed_last = false
var hit_last = false
var hitPlacement = -99

var is_end_game = false;

var score = 0

signal input_pressed(input)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	currPlacement = 0
	strCan = "soda_can"
	score = 0
	is_lamp_on = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(is_lamp_on):
		$Viewport/MainMenuVP/Camera.environment.ambient_light_color = Color("ffffff")		
	else:
		$Viewport/MainMenuVP/Camera.environment.ambient_light_color = Color("888888")
		

func start_playing():
	$Viewport/MainMenuVP.start_playing()
	$PressSpace.visible = false;
	$PressSpaceBG.visible = false;
	$FBG.visible = true
	$F.visible = true
	
func end_game():
	if(score >= 930):
		$FinalScore.text = "S"
		$FinalScoreBG.text = "S"
	elif(score >= 800):
		$FinalScore.text = "A"
		$FinalScoreBG.text = "A"
	elif(score >= 600):
		$FinalScore.text = "B"
		$FinalScoreBG.text = "B"
	elif(score >= 400):
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
	pass
	#$Metronome.metronome_pulse();


func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	$Viewport/MainMenuVP.camera_pulse(song_position_in_beats, song_position_in_notes);
	if(song_position_in_notes >= 60):
		$FBG.visible = false
		$F.visible = false
	if(currPlacement < levelJson["note_placement"].size() && song_position_in_notes == levelJson["note_placement"][currPlacement]):
		hitPlacement = levelJson["note_placement"][currPlacement] + 4;
		if($WarningSound.playing):
			$WarningSound.stop()
		$WarningSound.play()
		$SodaCanSprite.visible = true;
		$F.modulate = Color("ef1543")
		currPlacement += 1;
	if(hitPlacement == song_position_in_notes):
		$SodaCanSprite.visible = false;
		$F.modulate = Color("6de735")
	else:
		$F.modulate = Color("c9ebff")
	if(!hit_last && song_position_in_notes == hitPlacement + 1):
		if($MissSound.playing):
			$MissSound.stop()
		$MissSound.play()
		score -= 20
		missed_last = true;
		$RedX.visible = true;
	if(song_position_in_notes != hitPlacement && song_position_in_notes != hitPlacement + 1):
		hit_last = false;
		missed_last = false;
		$RedX.visible = false;
		$GreenCheck.visible = false;
	

func _on_BeatPlayer_sig_time_off_beat(v2TimeOffBeat, input):
	if(!hit_last && !missed_last):
		if(input == "RIGHT_HIT" && int(v2TimeOffBeat.x) % 4 == 2):
			if($SwitchSound.playing):
				$SwitchSound.stop()
			$SwitchSound.play()
			score += 10;
			is_lamp_on = !is_lamp_on
		elif(!missed_last && v2TimeOffBeat.x == hitPlacement):
			if(input == "LEFT_HIT"):
				successful_hit()
		elif(input == "LEFT_HIT"):
			if($MissSound.playing):
				$MissSound.stop()
			$MissSound.play()
			score -= 20
			missed_last = true;
			$RedX.visible = true;
	

func successful_hit():
	if($HitSound.playing):
		$HitSound.stop()
	$HitSound.play()
	hit_last = true;
	$GreenCheck.visible = true
	$Viewport/MainMenuVP.spawn_sodacan()
	score += 30
	


func _on_MainMenuVP_camera_turn(strHexColor):
	$PressSpace.modulate = Color(strHexColor)
