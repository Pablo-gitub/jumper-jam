extends Node

@onready var game = $Game
@onready var screens = $Screens
@onready var iap_manager = $IAPManager

var game_in_progress = false

func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)
	screens.start_game.connect(_on_screens_start_game)
	screens.delete_level.connect(_on_screens_delete_level)
	game.player_died.connect(_on_game_player_died)
	game.pause_game.connect(_on_game_pause_game)
	
	#IAP signals
	iap_manager.unlock_new_skin.connect(_iap_manager_unlock_new_skin)
	screens.purchase_skin.connect(_on_screens_purchase_skin)
	
func _on_window_event(event):
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			MyUtility.add_log_msg("Focus In")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			MyUtility.add_log_msg("Focus Out")
			if game_in_progress && !get_tree().paused:
				_on_game_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()
	
#func _process(delta: float) -> void:
	#print(game_in_progress)

func _on_screens_start_game():
	game_in_progress = true
	game.new_game()

func _on_screens_delete_level():
	game_in_progress = false
	game.reset_game()

func _on_game_player_died(score, high_score):
	game_in_progress = false
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, high_score)

func _on_game_pause_game():
	get_tree().paused = true
	screens.pause_game()

#IAP Signal

func _iap_manager_unlock_new_skin():
	if !game.new_skin_unlocked:
		game.new_skin_unlocked = true
		print("Unlocking the new skin...")
	
func _on_screens_purchase_skin():
	iap_manager.purchase_skin()
		
