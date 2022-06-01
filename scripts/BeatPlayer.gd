extends AudioStreamPlayer


export var bpm := 88
export var measures := 4
export var notes_per_measure := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var song_position_in_notes = 1
var sec_per_beat = 60.0 / bpm
var sec_per_note = 60.0 / bpm * notes_per_measure

var last_reported_beat = 0
var last_reported_note = 0
var beats_before_start = 1
var measure = 1
var note = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)
signal note(song_position_in_beats, song_position_in_notes)
signal sig_time_off_beat(v2TimeOffBeat)


func _ready():
	sec_per_beat = 60.0 / bpm
	sec_per_note = 60.0 / bpm / notes_per_measure


func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		song_position_in_notes = int(floor(song_position / sec_per_note)) + beats_before_start * notes_per_measure
		report_beat()
		report_note()


func report_beat():
	if last_reported_beat < song_position_in_beats:
		measure = measure % measures
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func report_note():
	if last_reported_note < song_position_in_notes:
		note = note % notes_per_measure
		emit_signal("note", song_position_in_beats, song_position_in_notes)
		last_reported_note = song_position_in_notes
		note += 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func time_after_note():
	closest = int(round(song_position / sec_per_note)) 
	time_off_beat = abs(closest * sec_per_note - song_position)
	return Vector2(closest, time_off_beat)
	pass

func play_from_beat(beat, offset):
	song_position_in_beats = beat
	last_reported_beat = beat - 1
	song_position_in_notes = beat * notes_per_measure
	last_reported_note = (beat * notes_per_measure) - 1
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	report_beat()


func _on_MainMenu_input_pressed(input):
	time_after_note()
	


func _on_Global_sig_hit_input(input):
	emit_signal("sig_time_off_beat",time_after_note(), input);
	pass # Replace with function body.
