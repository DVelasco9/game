extends CharacterBody2D

@export var move_speed: float
@export var jump: float
@export var run: float
@onready var animated_sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_right = true

func _physics_process(delta: float) -> void:
	ajump(delta)
	flip()
	update_animations()
	move_x()	
	move_and_slide()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		return
	
	if velocity.x:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("move_left","move_right")
	velocity.x = input_axis * move_speed
	

func rrun():
	var input_axis = Input.get_axis("ui_left","ui_right")
	
	

func ajump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -400
	
	if not is_on_floor():
		velocity.y += gravity * delta	
