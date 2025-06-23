class_name blood_arrow extends CharacterBody2D

var direccion_blood_arr : Vector2

var velocidad_blood_arrow = 500

func _physics_process(delta: float) -> void:
	velocity = direccion_blood_arr.normalized()*velocidad_blood_arrow
	
	move_and_slide() 

func _on_timereliminar_flecha_timeout() -> void:
	queue_free()
