extends Area2D

var hit = false

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")


func _on_coins_body_entered(_body: Node) -> void:
	if hit == false:
		hit = true
		GameData.coins += 1
		GameData.score += 10
		anim_player.play("vanished")
		yield(get_node("AnimationPlayer"), "animation_finished")
		queue_free()
