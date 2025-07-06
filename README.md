# ZOMBIE ESCAPE

![](https://github.com/user-attachments/assets/01f3b25c-4b5e-4d3d-9c25-8aad5357cc27)


### integrantes
DIEGO EDUARDO VELASCO BASULTO\
CARLOS ANTONIO ANDRADE VALLES

## Descripción del juego
Plataformero con enemigos.\
El unico objetivo es salir del castillo evitando todas las trampas y matando todo lo que se te cruze en tu camino


## Recursos usados
* Musica: se agrego musica en el menú del juego, por cuestiones tecnicas y falta de tiempo no pudimos agregar más música dentro del juego
* Assets: Se utilizo los siguientes assets para crear los niveles [PERSONAJES](https://github.com/DVelasco9/game/tree/master/free-vampire-pixel-art-sprite-sheets) dentro de personajes vienen los ataques, [Mapa](https://github.com/DVelasco9/game/tree/master/Tile%20set) aqui vienen las trampas y cosas que aparecen en el nivel 2, el nivel uno fue creado con [Nivel 1](https://github.com/DVelasco9/game/blob/master/castle_tileset_part1.png)

En general estos fueron los assets que más se utilizaron



## Descripción de las escenas


### Niveles
El primer nivel solo contiene zombies y una puerta de salida, el segundo nivel contiene un zombies y esta creado en un estilo más plataformero.
![NIVEL 1](https://github.com/user-attachments/assets/c23a189c-7bd8-4754-b3da-c65104f4ba6a)

![NIVEL 2](https://github.com/user-attachments/assets/805c340b-71d3-486e-acb6-4f1cbf022a0b)


### Plataformas 
Las plataformas utilizadas fueron las mismas que en proyectos anteriores con la diferencia que se agregó una nueva que provoca daño.
![PLATAFORMA](https://github.com/user-attachments/assets/4c3e03d5-9697-4301-92f5-00f9576103b0)


### Personaje 
El personaje utilizado no puede golpear solo disparar, sin embargo cumple con todos los criterios basicos de un personaje de videojuegos

![PERSONAJE](https://github.com/user-attachments/assets/38026e07-fcd2-466a-a9ac-45f53d224d82)


### Zombies
Solamente se incluyo un tipo de zombie que fue el salvaje, de ahi su gran velocidad e increible daño, debido a ciertas complicaciones no se pudo agregar a más enemigos o mejorar su codigo

![FERAL](https://github.com/user-attachments/assets/d4ee4b23-4ec7-4240-81dd-5a2488d59a2f)

### HEALTH COMPONENT 
como se puede apreciar en las escenas tenemos 2 cuadros de diferente color, uno verde y uno rojo, el verde es el componente de vida y el rojo el componente de daño, en los codigos vendra mejor explicado

## Descripción de los codigos
### Menú

```
extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer 

var musica_menu = preload("res://GameMusic_ForestTheme_24.mp3") #para cargar la musica 

func _ready() -> void:
	audio_stream_player.stream = musica_menu #para reproducir la musica
	audio_stream_player.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/nivel_0.tscn") #Las funciones basicas de un menú

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

```

### Personaje

```
extends CharacterBody2D

class_name player

@export var move_speed: float
@export var jump: float
@export var run_speed: float


@onready var animated_sprite = $Sprite2D



const arrblood1 = preload("res://SCENES/carga_sangre_1.tscn") #La flecha

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #Para que las fisicas funcionen como irl
var is_facing_right = true
var running = false
var ataque_1 = false

func _ready():
	add_to_group("player")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	

func _physics_process(delta: float) -> void:  #Para que todo se reproduzca al momento en que se corra el juego
	disparo()
	attack_1()
	estado()
	ajump(delta)
	flip()
	move_x()
	update_animations()
	move_and_slide()

func move_x():  #Movimiento en eje horizontal
	if ataque_1:
		velocity.x = 0
		return

	var input_axis = Input.get_axis("move_left", "move_right")

	if running:
		velocity.x = input_axis * (move_speed * run_speed)
	else:
		velocity.x = input_axis * move_speed

func estado():                                      #Para saber si esta corriendo o no
	if Input.is_action_just_pressed("run"):
		running = true
	if Input.is_action_just_released("run"):
		running = false

func ajump(delta):                
	if Input.is_action_just_pressed("jump") and is_on_floor() and not ataque_1:
		velocity.y = -jump
	if not is_on_floor():
		velocity.y += gravity * delta
#Función de salto


func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

#Función que permite voltear a los lados

func attack_1():
	if Input.is_action_just_pressed("ataque1") and is_on_floor() and not ataque_1:
		ataque_1 = true
		animated_sprite.play("attack_1")
		velocity.x = 0

#La función de la animación del ataque 

func disparo():
	var shoot = arrblood1.instantiate()
	if Input.is_action_just_pressed("ataque1"):
		get_parent().add_child(shoot)
		shoot.position = $Marker2D.global_position
		if not is_facing_right:
			shoot.scale.x *= -1
			shoot.arr1_speed *= -1

#La función del disparo


func _on_animation_finished():
	if animated_sprite.animation == "attack_1":
		ataque_1 = false

#Función para que el personaje no se quede atacando infinitamente 

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

#función para cargar y reproducir animaciones

```

### healt component

```
extends Area2D
class_name HealthComponent

signal onDead
signal onDamageTook
#SEÑALES PARA CONECTAR AL PERSONAJE Y QUE PUEDA MORIR O RECIBIR DAÑO

@export var max_health: int = 100
var current_health: int = 0

func _ready() -> void:
	current_health = max_health
	
func take_heal(value: int):
	set_health(value)

	
func take_damage(damage: int):
	var value = abs(damage)
	set_health(-value)
#FUNCIÓN QUE PERMITE QUE HAYA DAÑO

func set_health(value: int):
	current_health += value
	current_health = clamp(current_health, 0, max_health)
	
	if current_health <= 0:
		dead()
#DEFINIMOS QUE PASA SI LA VIDA LLEGA A 0
		
func dead():
	emit_signal("onDead")
	get_parent().queue_free()
#FUNCIÓN QUE EMITE UNA SEÑAL Y AUTOMATICAMENTE SE QUITA LA ESCENA DEL PERSONAJE INDICANDO QUE ESTE MURIÓ

```
### hitbox
```
extends Area2D
class_name hitbox

@export var damage: int = 10

func _ready() -> void:
	area_entered.connect(hit)
	
func hit(area):
	if area is HealthComponent:
		area.take_damage(damage)
		print("Daño hecho:", damage, "a", area)

#SE DEFINE EL AREA DEL DAÑO DE LOS ENEMIGOS Y SE EXPORTA LA VARIABLE "damage" PARA QUE ASI ESTE CONECTADO A LA VIDA 

```
### Plataforma 
```
extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE}
@export var tipo: TipoPlataforma = TipoPlataforma.FIJA;
@export var fuerza_rebote := 2.0

func _ready():
	actualizar_plataforma()
	monitorable = true
	monitoring = true

#LA FUNC _ready SIRVE PARA CARGAR LAS COSAS AL COMIENZO DEL JUEGO

func actualizar_plataforma():
	match tipo:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color.GREEN
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.BLUE
			osiclar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.RED
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color.YELLOW

#SE COLOREAN PARA PODER DIFERENCIAR QUE PLATAFORMA HACE CADA COSA 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		match tipo:
			TipoPlataforma.FRAGIL:
				await get_tree().create_timer(1.0).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else:
					body.velocity.y = body.brinco * fuerza_rebote

#LO QUE PASA A LAS PLATAFORMAS CUANDO EL PERSONAJE ENTRA 
	pass # Replace with function body.

func osiclar():
	var twin = create_tween()
	twin.tween_property(self,"position:x",position.x + 100,2)
	twin.tween_property(self,"position:x",position.x - 100,2)
	twin.set_loops()
#SE CREA LA FUNC OSCILAR Y CON AYUDA DE TWIN PODEMOS MOVER LA PLATAFORMA


#ESTE CODIGO YA FUE DOCUMENTADO POR EL PROFE

```
### Reset area 
```
extends Area2D

func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			print("Jugador tocó la zona")
			get_tree().reload_current_scene()

#SI EL JUGADOR ENTRA EN LA ZONA DESIGNADA SE REINICIA 

```
### zombie 
```
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

#PARA QUE EL ENEMIGO TENGA GRAVEDAD 

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

#SI EL ENEMIGO CHOCA CON UNA PARED, AUTOMATICAMENTE DA LA VUELTA Y CORRERA INFINITAMENTE HASTA QUE CHOQUE CON UNA PARED O EL JUGADOR 
```


## SCENES 
TODAS LAS ESCENAS DEL JUEGO
[Ir a escenas](https://github.com/DVelasco9/game/tree/master/SCENES)

## SCRIPTS 
TODOS LOS CODIGOS DEL JUEGO
[Ir a scripts](https://github.com/DVelasco9/game/tree/master/SCRIPTS)

## DIFICULTADES
### Diego
Por mi parte, las dificultades  fue que no sabia usar terminal y fue un problemon intentar subir commits, hacer merges o rebase, fue asi de complicado que tuve que borrar el primer proyecto porque estaba hecho un desastre y para rematar cierta persona casi me tumba el nuevo proyecto, en conclusión, vean tutoriales en youtube o preguntenle a alguien que si sabe @NIZ

### Carlos

## CONCLUSIÓN
Es de suma importancia el saber usar estas herramientas colaborativas, puesto que te permitira trabajar de manera más eficiente y casi en tiempo real junto con tus compañeros, para no hacer el tipico "En la casa lo hacemos y en la escuela lo juntamos", ademas, muchas veces en al ambito laboral nos vamos a topar con problemas que requieran más de un colaborador y el hecho de no saber usar herramientas como github, o incluso más importante, herramientas como la terminal pues va a entorpecer el trabajo de la empresa e incluso puede provocar tu despido, ademas de un claro estancamiento en tu desarrollo profesional.
