extends Spatial

export (PackedScene) var tree_scene


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_tree():
	var tree1 = tree_scene.instance()
	#var tree_spawn1 = get_node("TreeSpawn/PathFollow")
	#tree_spawn1.unit_offset = randf() 
	
	tree1.initialize(Vector3(20,2,-20))#tree_spawn1.translation)
	
	add_child(tree1)


func _on_BeatPlayer_note(song_position_in_beats, song_position_in_notes):
	spawn_tree()
