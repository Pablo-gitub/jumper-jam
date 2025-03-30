extends Node2D

@onready var platform_parent = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")
# Level gen variables
var start_platform_y
var y_distance_between_platforms = 200
var level_size = 50
var generate_platform_count
var viewport_size

var player: Player = null

func setup(_player: Player):
	if _player:
		player = _player

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	generate_platform_count = 0
	start_platform_y = - y_distance_between_platforms
	
func start_generation():
	generate_level(start_platform_y, true)
	
func _process(_delta: float) -> void:
	if player: 
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generate_platform_count * y_distance_between_platforms)
		var threshold = end_of_level_pos + (y_distance_between_platforms * 6)
		if py <= threshold:
			generate_level(end_of_level_pos, false)
	
func generate_level(start_y: float, generate_ground: bool):
	var _ground_layer_y_offset = 62
	var platform_with = 136
	if generate_ground:
		#Generate the ground
		var ground_layer_platform_count = ( viewport_size.x / platform_with ) + 1
		for i in range(ground_layer_platform_count):
			var ground_location = Vector2(i * platform_with, 0)
			create_platform(ground_location)
	
	#Generate the rest of the level
	for i in range(level_size):
		var location: Vector2 = Vector2.ZERO
		var max_x_position = viewport_size.x-platform_with
		var random_x = randf_range( 0.0, max_x_position )
		location.x = random_x
		location.y = start_y - (i * y_distance_between_platforms)
		create_platform(location)
		generate_platform_count += 1
	
func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform

func reset_level():
	generate_platform_count = 0
	for platform in platform_parent.get_children():
		platform.queue_free()
		
