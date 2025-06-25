extends CharacterBody2D

@export var move_speed: float
@export var jump: float
@export var run_speed: float


@onready var animated_sprite = $Sprite2D

const arrblood1 = preload("res://SCENES/carga_sangre_1.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_facing_right = true
var running = false
var ataque_1 = false

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:

	attack_1()
	estado()
	ajump(delta)
	flip()
	move_x()
	update_animations()
	move_and_slide()

func move_x():
	if ataque_1:
		velocity.x = 0
		return

	var input_axis = Input.get_axis("move_left", "move_right")

	if running:
		velocity.x = input_axis * (move_speed * run_speed)
	else:
		velocity.x = input_axis * move_speed

func estado():
	if Input.is_action_just_pressed("run"):
		running = true
	if Input.is_action_just_released("run"):
		running = false

func ajump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor() and not ataque_1:
		velocity.y = -jump
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	
	
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func attack_1():
	if Input.is_action_just_pressed("ataque1") and is_on_floor() and not ataque_1:
		ataque_1 = true
		animated_sprite.play("attack_1")
		velocity.x = 0




func _on_animation_finished():
	if animated_sprite.animation == "attack_1":
		ataque_1 = false

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		return

	if ataque_1:
		return  

	if running:
		animated_sprite.play("run")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
