extends Node


signal lives_updated
signal coins_updated
signal score_updated
signal health_updated


var lives: = 3 setget set_lives
var health: = 3 setget set_health
var coins: = 0 setget set_coins
var score: = 0 setget set_score
var stomping: = false setget set_stomping


func reset() -> void:
	lives = 3
	health = 3
	coins = 0
	score = 0
	stomping = false


func set_lives(value: int) -> void:
	lives = value
	emit_signal("lives_updated")

func set_health(value: int) -> void:
	health = value
	emit_signal("health_updated")

func set_coins(value: int) -> void:
	coins = value
	emit_signal("coins_updated")

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")


func set_stomping(value: bool) -> void:
	stomping = value
