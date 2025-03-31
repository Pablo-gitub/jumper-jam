extends CharacterBody2D
class_name Player

signal died

@onready var animator = $AnimationPlayer
@onready var cshape = $CollisionShape2D
@onready var sprite = $Sprite2D

var speed = 300.0
var accelerometer_speed = 130.0

var gravity = 15.0
var max_fall_velocity = 1000.0
var jump_velocity = -800

var viewport_size 
var use_accelerometer = false

var dead = false

var fall_animation_name = "fall"
var jump_animation_name = "jump"

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true

func _process(_delta: float) -> void:
	if velocity.y > 0:
		if animator.current_animation != fall_animation_name:
			animator.play(fall_animation_name)
	if velocity.y < 0:
		if animator.current_animation != jump_animation_name:
			animator.play(jump_animation_name)

func _physics_process(_delta: float) -> void:
	velocity.y += gravity
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity
	
	if !dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
		else:
			var direction = Input.get_axis("move_left","move_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var margin = 30
	if global_position.x > viewport_size.x/2 + margin:
		global_position.x = -viewport_size.x/2 - margin
	if global_position.x < -viewport_size.x/2 - margin:
		global_position.x = viewport_size.x/2 + margin
		
	
func jump():
	velocity.y = jump_velocity
	SoundFX.play("Jump")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

func die():
	if !dead:
		dead = true
		cshape.set_deferred("disabled", true)
		died.emit()
		SoundFX.play("Fall")
		
func use_new_skin():
	fall_animation_name = "fall_red"
	jump_animation_name = "jump_red"
	
	if sprite:
		sprite.texture = preload("res://assets/textures/character/Skin2Idle.png")
