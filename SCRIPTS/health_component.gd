extends Area2D
class_name HealthComponent

signal onDead
signal onDamageTook


@export var max_health: int = 100
var current_health: int = 0

func _ready() -> void:
	current_health = max_health
	
func take_heal(value: int):
	set_health(value)
	
	
func take_damage(damage: int):
	var value = abs(damage)
	set_health(-value)
	

func set_health(value: int):
	current_health += value
	current_health = clamp(current_health, 0, max_health)
	
	if current_health <= 0:
		dead()
		
func dead():
	emit_signal("onDead")
	get_parent().queue_free()
	
