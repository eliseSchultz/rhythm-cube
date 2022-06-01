extends Spatial

export (PackedScene) var soda_can_scene

var cameraMove = 1
var cameraSpeed = 0.05
var colors=["000000","151c35","664731","ec6f15",
			"c8a57e","ecf911","6de735","20b55e",
			"2c4554","562169","ef1543","2b2bdf",
			"2b8adf","c9ebff","847c84","3d847a"]
var cubeMaterial
var before_start = true
var is_end_camera = false

signal camera_turn(strHexColor)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Camera.translation = Vector3(-2.7, 2, -2.7)
	$Camera.rotation_degrees = Vector3(-25,45,0)
	$Camera.make_current()
	cubeMaterial = $cube.get_surface_material(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(before_start):
		$Camera.rotate_y(delta * cameraSpeed * cameraMove)
		if($Camera.rotation_degrees.y > 50 and cameraMove > 0):
			cameraMove = cameraMove * -1
			emit_signal("camera_turn", colors[randi() % 16])
		if($Camera.rotation_degrees.y < 40 and cameraMove < 0):
			cameraMove = cameraMove * -1
			emit_signal("camera_turn", colors[randi() % 16])
	else:
		$Camera.rotation_degrees.y = 45
	if(is_end_camera):
		camera_end_pan(delta)
		
		
func camera_end_pan(delta):
	if($Camera2.translation.z < 0):
		$Camera2.translate(Vector3(0, 0, delta*0.08))
		$Camera2.fov += delta * 1.7

func start_playing():
	before_start = false
	$Camera.rotation_degrees.y = 45

func camera_pulse(song_position_in_beats, song_position_in_notes):
	if(song_position_in_notes % 8 == 0):
		$Camera.fov += 5;
	else:
		$Camera.fov -= 5;

func spawn_sodacan():
	var sodacan = soda_can_scene.instance()
	
	var soda_spawn_location = get_node("SodaCanSpawn/SpawnLocation")
	soda_spawn_location.unit_offset = randf()
	var camera_position = $Camera.transform.origin
	var spawn_location = soda_spawn_location.translation
	spawn_location.y = 1
	sodacan.initialize(spawn_location, camera_position)
	
	add_child(sodacan)
	

func _on_Pulse_timeout():
	$Camera.fov = 25;
	pass # Replace with function body.


func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	if(song_position_in_beats == 40):
		is_end_camera = true
		$Camera2.current = true
		$BackWall.scale = Vector3(20,15,1)
		$LeftWall.scale = Vector3(1,15,10)
		$Floor.scale = Vector3 (30,1,10)
	elif(song_position_in_beats < 40):
		camera_pulse(song_position_in_beats, song_position_in_notes)
	if(song_position_in_notes % 4 == 0):
		cubeMaterial.albedo_color = Color(colors[song_position_in_notes % 16])

