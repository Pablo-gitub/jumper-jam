extends Control

@onready var topbar = $TopBar
@onready var topbar_bg = $TopBarBG
@onready var score_label = $TopBar/ScoreLabel

func _ready() -> void:
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top = (safe_area_top / screen_scale)
			MyUtility.add_log_msg("screen scale: " + str(screen_scale))
		else:
			safe_area_top = (safe_area_top / 4)
			MyUtility.add_log_msg("screen scale: " + str(safe_area_top))
		
		topbar.position.y += safe_area_top
		var margin = 10
		topbar_bg.size.y += safe_area_top + margin
		
		MyUtility.add_log_msg("safe area: " + str(safe_area))
		MyUtility.add_log_msg("window size: " + str(DisplayServer.window_get_size()))
		MyUtility.add_log_msg("safe_area_top: " + str(safe_area_top))
		MyUtility.add_log_msg("top bar position: " + str(topbar.position))
		

func _on_pause_button_pressed() -> void:
	pass # Replace with function body.

func set_score(new_score):
	score_label.text = str(new_score)
