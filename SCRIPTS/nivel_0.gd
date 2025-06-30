extends Node2D

var player = null

func _ready() -> void:
	if Global.currentPlayer != null:
		player = Global.currentPlayer.instantiate()
		get_parent().add_child(player)
		player.global_position = $spawn.global_position
