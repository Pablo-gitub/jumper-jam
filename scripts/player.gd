extends CharacterBody2D
class_name Player

var speed = 300.0

var gravity = 15.0
var max_fall_velocity = 1000.0

var viewport_size 

func _ready() -> void:
	viewport_size = get_viewport_rect().size

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity
	
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed/20)
		
	move_and_slide()
	
	var margin = 30
	if global_position.x > viewport_size.x/2 + margin:
		global_position.x = -viewport_size.x/2 - margin
	if global_position.x < -viewport_size.x/2 - margin:
		global_position.x = viewport_size.x/2 + margin
		
	if global_position.y > viewport_size.y/2 + margin:
		global_position.y = -viewport_size.y + margin*10
	if global_position.y < -viewport_size.y - margin:
		global_position.y = viewport_size.y/2 + margin
	
