extends Control

@export var personajes: Array[CharacterData]

@onready var spr = $Sprite2D

var cont: int = 0 

func _ready() -> void:
	spr.texture = personajes[0].imagen
	

func sig() -> void:
	if cont < personajes.size() -1:
		cont += 1
		spr.texture = personajes[cont].imagen

func ant()-> void:
	if cont >= 0:
		cont -= 1
		spr.texture = personajes[cont].imagen

func select() -> void:
	Global.currentPlayer = personajes[cont].Scene

func _on_anterior_pressed() -> void:
	ant()



func _on_siguiente_pressed() -> void:
	sig()



func _on_select_pressed() -> void:
	select()
	get_tree().change_scene_to_file("res://SCENES/nivel_0.tscn")
