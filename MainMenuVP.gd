extends Spatial

var cameraMove = 1
var cameraSpeed = 0.05
var colors=["000000","151c35","664731","ec6f15",
			"c8a57e","ecf911","6de735","20b55e",
			"2c4554","562169","ef1543","2b2bdf",
			"2b8adf","c9ebff","847c84","3d847a"]
var cubeMaterial



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	cubeMaterial = $cube.get_surface_material(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Camera.rotate_y(delta * cameraSpeed * cameraMove)
	if($Camera.rotation_degrees.y > 50 and cameraMove > 0):
		cameraMove = cameraMove * -1
	if($Camera.rotation_degrees.y < 40 and cameraMove < 0):
		cameraMove = cameraMove * -1

func _on_BeatPlayer_measure(position):
	pass # Replace with function body.

func camera_pulse(position):
	if(position == 1):
		$Camera.fov = 26;
	else:
		$Camera.fov = 25;

func _on_Pulse_timeout():
	$Camera.fov = 25;
	pass # Replace with function body.


func _on_BeatPlayer_note(position):
	cubeMaterial.albedo_color = Color(colors[randi() % 16])
	pass # Replace with function body.
