extends CharacterBody2D

const wzombierun = 300

var gravity = 200


func _ready() -> void:
	$AnimatedSprite2D.play("run")
	velocity.x = wzombierun
	
func _physics_process(delta: float) -> void:
	pared()
	gravedad(delta)
	move_and_slide()

func gravedad(delta):
	velocity.y += gravity * delta

func pared():
	if is_on_wall():
		if !$AnimatedSprite2D.flip_h:
			velocity.x = -wzombierun
		else:
			velocity.x = wzombierun
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		
