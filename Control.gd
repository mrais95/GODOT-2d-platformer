extends Control

onready var scene_tree: = get_tree()
onready var health: Label = get_node("HBoxContainer/Label")
onready var coins: Label = get_node("HBoxContainer2/Label2")
onready var score: Label = get_node("HBoxContainer3/Label3")

func _ready() -> void:
	GameData.connect("health_updated", self, "update_health_interface")
	GameData.connect("coins_updated", self, "update_coins_interface")
	GameData.connect("score_updated", self, "update_score_interface")
	update_health_interface()
	update_coins_interface()
	update_score_interface()

func update_health_interface() -> void:
	health.text = "Health : %s" % GameData.health

func update_coins_interface() -> void:
	coins.text = "Coins : %s  " % GameData.coins

func update_score_interface() -> void:
	score.text = "Score : %s" % GameData.score
