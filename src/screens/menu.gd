extends Node2D

export(String, FILE) var next_scene_path: = ""

func _ready() -> void:
	GameData.reset()

func _on_Button_button_up() -> void:
	get_tree().change_scene(next_scene_path)
