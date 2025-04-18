extends CanvasLayer

signal start_game
signal delete_level
signal purchase_skin

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var game_over_score_label = $GameOverScreen/Box/ScoreLabel
@onready var game_over_high_score_label = $GameOverScreen/Box/HighScoreLabel
@onready var shop_screen = $ShopScreen

var current_screen = null

func _ready() -> void:
	console.visible = false
	
	register_button()
	change_screen(title_screen)
	
func register_button():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button):
	SoundFX.play("Click")
	match button.name:
		"TitlePlay":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"TitleShop":
			change_screen(shop_screen)
		"PauseRetry":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseBack":
			change_screen(title_screen)
			get_tree().paused = false
			delete_level.emit()
		"PauseClose":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
		"GameOverRetry":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"GameOverBack":
			change_screen(title_screen)
			delete_level.emit()
		"ShopBack":
			change_screen(title_screen)
		"ShopPurchaseSkin":
			purchase_skin.emit()

func _process(delta: float) -> void:
	pass


func _on_toggle_console_pressed() -> void:
	console.visible = !console.visible
	
func change_screen(new_screen):
	if current_screen:
		var disappear_tween = current_screen.disappear()
		await(disappear_tween.finished)
		current_screen.visible = false
	current_screen = new_screen
	if current_screen:
		var appear_tween = current_screen.appear()
		await(appear_tween.finished)
		get_tree().call_group("buttons", "set_disabled", false)
	
func game_over(score, high_score):
	game_over_score_label.text = "Score: " + str(score)
	game_over_high_score_label.text = "Best: " + str(high_score)
	change_screen(game_over_screen)

func pause_game():
	change_screen(pause_screen)
