extends CanvasLayer

signal delete_level

@onready var console_log: Control = $Debug/ConsoleLog
@onready var title_screen: Control = $TitleScreen
@onready var pause_screen: Control = $PauseScreen
@onready var game_over_screen: Control = $GameOverScreen
@onready var score_label: Label = $GameOverScreen/Box/ScoreLabel
@onready var high_score_label: Label = $GameOverScreen/Box/HighScoreLabel

var current_screen = null

signal start_game

func _ready() -> void:
	console_log.visible = false
	
	register_buttons()
	
	change_screen(title_screen)


func _process(_delta: float) -> void:
	pass


#region Buttons

var button_counter: = 0

func register_buttons() -> void:
	var buttons: = get_tree().get_nodes_in_group("buttons")
	if !buttons.is_empty():
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)


func _on_texture_button_toggled(toggled_on: bool) -> void:
	console_log.visible = toggled_on


func _on_button_pressed(button: BaseButton) -> void:
	SoundFx.play("click")
	match button.name:
		"PlayButton":
			MyUtility.add_log_message("play button was pressed")
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
		"PauseRetry":
			MyUtility.add_log_message("pause retry button was pressed")
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			get_tree().paused = false
			start_game.emit()
		"PauseBack":
			MyUtility.add_log_message("pause back button was pressed")
			get_tree().paused = false
			delete_level.emit()
		"PauseClose":
			MyUtility.add_log_message("pause close button was pressed")
			change_screen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().paused = false
		"GameOverRetry":
			MyUtility.add_log_message("game over retry button was pressed")
			change_screen(null)
			await get_tree().create_timer(0.5).timeout
			start_game.emit()
		"GameOverBack":
			MyUtility.add_log_message("game over back button was pressed")
			change_screen(title_screen)
			delete_level.emit()
	print(button.name)

#endregion Buttons


func change_screen(new_screen) -> void:
	if current_screen:
		var disapear_tween = current_screen.disappear()
		await disapear_tween.finished
	current_screen = new_screen
	if current_screen:
		var appear_tween = current_screen.appear()
		await appear_tween.finished
		get_tree().call_group("buttons", "set_disabled", false)


func game_over(score: int, highscore: int):
	score_label.text = "Score: " + str(score)
	high_score_label.text = "Highscore: " + str(highscore)
	change_screen(game_over_screen)


func pause_game() -> void:
	change_screen(pause_screen)
