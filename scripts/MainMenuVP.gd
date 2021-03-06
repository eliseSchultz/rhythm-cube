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
var move_camera2 = true

signal camera_turn(strHexColor)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Camera.make_current()
	$Camera/AnimationPlayer.play("start_anim")
	cubeMaterial = $cube.get_surface_material(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_end_camera):
		camera_end_pan(delta)
		

func camera_end_pan(delta):
	if($Camera2.translation.z < 0 && move_camera2):
		$Camera2.translate(Vector3(0, 0, delta*0.13))
		$Camera2.fov += delta * 2.1

func start_playing():
	before_start = false
	$Camera4/AnimationPlayer.play("beginning_angle")
	$Camera4/AnimationPlayer.playback_speed = 0.3
	$Camera/AnimationPlayer.playback_speed = 0.3
	$Camera4.make_current()

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
	
	var child = add_child(sodacan)
	


func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	if(song_position_in_beats == 40):
		is_end_camera = true
		$Camera2.current = true
		$StaticBody/BackWall.scale = Vector3(20,15,1)
		$StaticBody/LeftWall.scale = Vector3(1,15,10)
		$StaticBody/Floor.scale = Vector3 (30,1,10)
	#elif(song_position_in_beats < 40):
		#camera_pulse(song_position_in_beats, song_position_in_notes)
	if(song_position_in_notes % 4 == 0):
		cubeMaterial.albedo_color = Color(colors[song_position_in_notes % 16])
	if(song_position_in_notes % 16 == 0 && !is_end_camera && song_position_in_notes > 8):
		if($Camera.current):
			$Camera3.make_current()
		else:
			$Camera.make_current()
			$Camera/AnimationPlayer.play("New Anim")
	if(song_position_in_notes == 302):
		move_camera2 = false



func _on_SodaCan_input_event(camera, event, position, normal, shape_idx):
	pass # Replace with function body.
