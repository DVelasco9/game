extends CharacterBody2D

var direction: float = 0.0
var speed: float = 100

func _ready() -> void:
	rotation = direction
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(speed,0).rotated(direction)
	move_and_slide()
