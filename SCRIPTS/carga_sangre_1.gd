extends Area2D

var arr1_speed = 200

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	position.x += arr1_speed * delta
	$AnimatedSprite2D.play("blood_arrow1")
