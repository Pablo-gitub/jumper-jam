extends Camera2D

var player: Player = null
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x

func _process(delta: float) -> void:
	if player:
		var limit_distance = 500
		if limit_bottom > get_camera_target_to_player(player, limit_distance):
			limit_bottom = get_camera_target_to_player(player, limit_distance)
	
func setup_camera(_player: Player):
	if _player:
		player = _player
		
func _physics_process(delta: float) -> void:
	if player:
		global_position.y = get_camera_target_to_player(player)
		
func get_camera_target_to_player(player: Player, limit_distance: float = 0) -> float:
	return player.global_position.y + viewport_size.y / 2 + limit_distance
