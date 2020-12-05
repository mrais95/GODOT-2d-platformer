extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP

var speed: = Vector2(250.0, 1250.0)
var gravity: = 4000.0
var dead: = false
var _velocity: = Vector2.ZERO


var jump_counts: = 0
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
var facing_right = false
onready var camera_player = $Camera2D
var sliding = false
var invulnurable = false

func _ready() -> void:
	get_node("stomper/stomper-collision").disabled = false
	get_node("stomper2/stomper-collision").disabled = false

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and jump_counts > 0
	var is_double_jumping: = Input.is_action_just_pressed("jump") and is_jump_interrupted
	var direction: = get_direction() 
	if Input.is_action_just_pressed("jump"):
		jump_counts += 1
	check_anim()
	if facing_right and direction.x > 0:
		flip()
	if !facing_right and direction.x < 0:
		flip()
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted, is_double_jumping)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	if is_on_floor():
		jump_counts = 0
	if get_node(".").position.y > 1200:
		dead = true

	if GameData.coins >= 100:
		GameData.coins -= 100
		GameData.lives += 1
	
	if _velocity.y > 0:
		GameData.stomping = true
	else:
		GameData.stomping = false

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and jump_counts < 2 else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		cspeed: Vector2,
		is_jump_interrupted: bool,
		is_double_jumping: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = cspeed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = cspeed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	if is_double_jumping:
		out.y = -1500
	if sliding:
		if facing_right:
			out.x = speed.x * -1
		else:
			out.x = speed.x
	return out 
	

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h


func check_anim() -> void:
	var direction = get_direction()
	if is_on_floor() and direction.x == 0 and sliding == false and dead == false:
		speed.x = 0.0
		play_anim("idle")
	if jump_counts != 0 and sliding == false:
		play_anim("jump")
		if speed.x == 0:
			speed.x = 250
	if is_on_floor() and direction.x != 0 and Input.is_action_pressed("run") == false and sliding == false and dead == false:
		speed.x = 250.0
		play_anim("walk")
	if is_on_floor() and direction.x != 0 and Input.is_action_pressed("run") and sliding == false and dead == false:
		speed.x = 350.0
		play_anim("run")
	if Input.is_action_just_pressed("slide") and sliding == false and dead == false:
		sliding = true
		get_node("Sprite").position.y = 10
		play_anim("slide")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("Sprite").position.y = 0
		sliding = false
	if invulnurable:
		get_node("vulnurable-spot/vulnurable-collision").disabled = true
		call_deferred("got_hurt")
		get_node("vulnurable-spot/vulnurable-collision").disabled = false
		invulnurable = false
	if dead:
		get_node("stomper/stomper-collision").disabled = true
		get_node("stomper2/stomper-collision").disabled = true
		get_node("Sprite").position.x = 10
		play_anim("dead")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("Sprite").position.x = 10
		dead = false
		get_tree().change_scene("res://src/screens/game-over.tscn")


func _on_vulnurablespot_area_shape_entered(_area_id: int, _area: Area2D, _area_shape: int, self_shape: int) -> void:
	if invulnurable == false:
		GameData.health -= 1
		if GameData.health != 0:
			invulnurable = true
		else:
			dead = true


func _on_stomper_area_shape_entered(_area_id: int, _area: Area2D, _area_shape: int, self_shape: int) -> void:
	if GameData.stomping:
		_velocity.y = -1000


func got_hurt() -> void:
	get_node("Sprite").modulate = Color(1,0,0)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,1,1)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,0,0)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,1,1)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,0,0)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,1,1)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,0,0)
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Sprite").modulate = Color(1,1,1)
