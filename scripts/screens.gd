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
			change_screen(null)
		"PauseRetry":
			print("Pause Retry")
		"PauseBack":
			print("Pause Back")
		"PauseClose":
			print("Pause Close")
		"GameOverRetry":
			print("Game Over Retry")
		"GameOverBack":
			print("Game Over Back")

func _process(delta: float) -> void:
	pass


func _on_toggle_console_pressed() -> void:
	console.visible = !console.visible
	
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
	current_screen = new_screen
	if current_screen:
		current_screen.appear()
	
	
