extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer
export var level: String

func _on_door_body_entered(_body: Node) -> void:
	anim_player.play("teleport")
	yield(anim_player, "animation_finished")
	get_tree().change_scene(level)
