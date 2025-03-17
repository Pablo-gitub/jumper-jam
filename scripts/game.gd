extends Node2D

@onready var platform_parent = $PlatformParent
var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")
var camera = null

# Level gen variables
var start_platform_y
var y_distance_between_platforms = 200
var level_size = 50

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	#Generate the ground
	var viewport_size = get_viewport_rect().size
	var platform_with = 136
	var ground_layer_platform_count = ( viewport_size.x / platform_with ) + 1
	var ground_layer_y_offset = 62
	for i in range(ground_layer_platform_count):
		var ground_location = Vector2(i * platform_with, 0)
		create_platform(ground_location)
	#Generate the rest of the level
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 6)
	for i in range(level_size):
		var location: Vector2
		var max_x_position = viewport_size.x-platform_with
		location.x = randf_range( 0.0, max_x_position )
		location.y = start_platform_y - (i * y_distance_between_platforms)
		create_platform(location)
	 
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform
