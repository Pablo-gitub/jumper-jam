extends Control

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	get_tree().call_group("buttons", "set_disabled", true)

var fade_duration = 0.5

func appear():
	visible = true
	return tween_animation(1.0)
	
func disappear():
	get_tree().call_group("buttons", "set_disabled", true)
	return tween_animation(0.0)

func tween_animation(alpha):
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", alpha, fade_duration)
	return tween
