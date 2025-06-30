extends Area2D

func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			print("Jugador tocó la zona")
			get_tree().reload_current_scene()
