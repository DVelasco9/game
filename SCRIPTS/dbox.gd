extends Area2D
class_name dbox

@export var damage: int = 10

func _ready() -> void:
	area_entered.connect(hita)
	
func hita(area):
	if area is HealthComponent:
		area.take_damage(damage)
