extends Node2D

@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite

var player_scene = preload("res://scenes/player.tscn")
var player: Player = null
var player_spam_pos: Vector2 = Vector2()

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	var player_spam_pos_y_offset = 35
	player_spam_pos.x = 0  
	player_spam_pos.y = 0 + player_spam_pos_y_offset
	ground_sprite.global_position.x = viewport_size.x/2
	ground_sprite.global_position.y = viewport_size.y
	new_game()
	 
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func new_game():
	player = player_scene.instantiate()
	player.global_position = player_spam_pos
	add_child(player)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	if player:
		level_generator.setup(player)
	
