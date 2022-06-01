extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(soda_spawn_location, camera_position):
	look_at_from_position(soda_spawn_location, Vector3(0,1,0), Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))
