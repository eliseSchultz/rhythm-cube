extends Node2D

export (PackedScene) var nextScene 

func _ready():
	pass
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to(nextScene)
