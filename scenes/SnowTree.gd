extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	translate_object_local(Vector3(0,0,delta*-40))

func initialize(tree_spawn_location):
	look_at_from_position(tree_spawn_location, Vector3(0,1,0), Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))
