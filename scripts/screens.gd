extends CanvasLayer

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen

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
	match button.name:
		"TitlePlay":
			print("TitleButton is pressed")
			change_screen(pause_screen)
		"PauseRetry":
			print("Pause Retry")
			change_screen(game_over_screen)
		"PauseBack":
			print("Pause Back")
		"PauseClose":
			print("Pause Close")
		"GameOverRetry":
			print("Game Over Retry")
			change_screen(title_screen)
		"GameOverBack":
			print("Game Over Back")

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
	
	
