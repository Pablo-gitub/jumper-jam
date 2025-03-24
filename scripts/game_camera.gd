extends Camera2D

@onready var destroyer = $Destroyer
@onready var destroyer_shape = $Destroyer/CollisionShape2D

var player: Player = null
var viewport_size

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	#Definition of camera limits
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x
	
	destroyer.position.y  = viewport_size.y
	var rect_shape = RectangleShape2D.new()
	var rect_shape_size = Vector2(viewport_size.x, 200)
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape

func _process(_delta: float) -> void:
	if player:
		var limit_distance = 500
		if limit_bottom > get_camera_target_to_player(player, limit_distance):
			limit_bottom = int(get_camera_target_to_player(player, limit_distance))
			
	var overlapping_areas = destroyer.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area is Platform:
				area.queue_free()
	
func setup_camera(_player: Player):
	if _player:
		player = _player
		
func _physics_process(_delta: float) -> void:
	if player:
		global_position.y = get_camera_target_to_player(player)
		
func get_camera_target_to_player(_player: Player, limit_distance: float = 0) -> float:
	return player.global_position.y + viewport_size.y / 2 + limit_distance
