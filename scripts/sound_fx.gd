extends Node

@onready var sound_players = get_children()

var sounds = {
	"click" : load("res://assets/sound/Click.wav"),
	"fall" : load("res://assets/sound/Fall.wav"),
	"jump" : load("res://assets/sound/Jump.wav")
}


func play(sound_name: String) -> void:
	var sound_to_play = sounds[sound_name]
	for sound_player: AudioStreamPlayer in sound_players:
		if !sound_player.playing:
			sound_player.stream = sound_to_play
			sound_player.play()
			return
	MyUtility.add_log_message("too many sounds playing at the same time!")
