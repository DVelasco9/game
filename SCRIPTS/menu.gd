extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var musica_menu = preload("res://GameMusic_ForestTheme_24.mp3")

func _ready() -> void:
	audio_stream_player.stream = musica_menu
	audio_stream_player.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://nivel_0.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
