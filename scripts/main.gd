extends Node

@onready var game: Node2D = $Game
@onready var screens: CanvasLayer = $Screens
@onready var iap_manager: Node = $IAPManager

var game_in_progress: = false


func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)
	screens.delete_level.connect(_on_screens_delete_level)
	
	game.player_died.connect(_on_game_player_died)
	game.pause_game.connect(_on_game_pause_game)
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	#IAP signals
	iap_manager.unlock_new_skin.connect(_on_iap_managger_unlock_new_skin)
	screens.purchase_skin.connect(_on_screens_purchase_skin)


func _process(_delta: float) -> void:
	pass


func _on_window_event(event: int) -> void:
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			MyUtility.add_log_message("window focus in")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			MyUtility.add_log_message("window focus out")
			if game_in_progress == true and !get_tree().paused:
				MyUtility.add_log_message("window miniumized pausing the game!")
				_on_game_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()
		DisplayServer.WINDOW_EVENT_GO_BACK_REQUEST:
			get_tree().quit()
	
	print("window event: " + str(event))


func _on_screens_start_game() -> void:
	game.new_game()
	game_in_progress = true


func _on_screens_delete_level() -> void:
	game_in_progress = false
	game.reset_game()


func _on_game_player_died(score: int, highscore: int) -> void:
	
	await get_tree().create_timer(0.75).timeout
	screens.game_over(score, highscore)
	game_in_progress = false


func _on_game_pause_game()-> void:
	get_tree().paused = true#!get_tree().paused
	screens.pause_game()

#region IAP section signals

func _on_screens_purchase_skin() -> void:
	iap_manager.purchase_skin()


func _on_iap_managger_unlock_new_skin() -> void:
	if game.new_skin_unlocked == false:
		game.new_skin_unlocked = true


#endregion IAP section signals
