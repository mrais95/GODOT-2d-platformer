extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP
export var speed: = Vector2(200.0, 1250.0)
var gravity: = 4000.0
var _velocity: = Vector2.ZERO
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
var facing_right = false
var death = false

func _ready() -> void:
	_velocity.x = -speed.x
	play_anim("walk")

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	if facing_right and _velocity.x > 0:
		flip()
	if !facing_right and _velocity.x < 0:
		flip()
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	anim_player.play(anim_name)

func _on_Area2D_area_entered(_area: Area2D) -> void:
	if GameData.stomping:
		call_deferred("dead_called")
		play_anim("dead")
		yield(get_node("AnimationPlayer"),"animation_finished")
		queue_free()
	

func dead_called() -> void:
	_velocity.x = 0
	GameData.score += 50
	get_node("Sprite").position.y = 20
	get_node("Sprite").position.x = 65
	get_node("Area2D/CollisionShape2D").disabled = true
	get_node("Area2D2/CollisionShape2D").disabled = true
	get_node("Area2D3/CollisionShape2D").disabled = true


func _on_Area2D4_area_shape_entered(_area_id: int, _area: Area2D, _area_shape: int, self_shape: int) -> void:
	_velocity.x *= -1.0
