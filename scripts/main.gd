extends Node

@onready var game = $Game
@onready var screens = $Screens

func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)
	
	game.player_died.connect(_on_game_player_died)
	
func _on_screens_start_game():
	game.new_game()

func _on_game_player_died(score, high_score):
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, high_score)
