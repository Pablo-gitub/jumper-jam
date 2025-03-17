extends Node2D

@onready var platform_parent = $PlatformParent
@onready var player = $Player
var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")
var camera = null

# Level gen variables
var start_platform_y
var y_distance_between_platforms = 200
var level_size = 50
var generate_platform_count
var viewport_size

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	viewport_size = get_viewport_rect().size
	generate_platform_count = 0
	start_platform_y = - y_distance_between_platforms
	generate_level(start_platform_y, true)
	 
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if player: 
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generate_platform_count * y_distance_between_platforms)
		var threshold = end_of_level_pos + (y_distance_between_platforms * 6)
		if py <= threshold:
			generate_level(end_of_level_pos, false)

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform

func generate_level(start_y: float, generate_ground: bool):
	var ground_layer_y_offset = 62
	var platform_with = 136
	if generate_ground:
		#Generate the ground
		var ground_layer_platform_count = ( viewport_size.x / platform_with ) + 1
		for i in range(ground_layer_platform_count):
			var ground_location = Vector2(i * platform_with, 0)
			create_platform(ground_location)
	
	#Generate the rest of the level
	for i in range(level_size):
		var location: Vector2
		var max_x_position = viewport_size.x-platform_with
		location.x = randf_range( 0.0, max_x_position )
		location.y = start_y - (i * y_distance_between_platforms)
		create_platform(location)
		generate_platform_count += 1
	
