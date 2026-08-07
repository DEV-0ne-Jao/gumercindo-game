#Soli Deo Gloria

class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dano:int = 1
var vidaMax:int = 10
var vida:int = vidaMax
var atacando:bool = false

@onready var bullet: RayCast2D = $Bullet
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var lbl_vida: Label = $lblVida
@onready var attack_time: Timer = $AttackTime

func printVida() -> void :
	lbl_vida.text = "Vida: " + str(vida)

func tomarDano(dano:int)->void:
	vida -= dano
	printVida()
	if vida <= 0:
		get_tree().change_scene_to_file("res://scenes/rio_grande_do_sul.tscn")

func _ready() -> void:
	printVida()
	vida = vidaMax

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Atacar"):
		atacando = true
		attack_time.start()
		if bullet.is_colliding():
			var alvo = bullet.get_collider()
			if alvo is Enemy:
				alvo.tomarDano(dano)
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 0 and not atacando:
		animated_sprite.play("Idle")
	elif direction !=0 and not atacando:
		animated_sprite.play("Walking")
	elif atacando:
		animated_sprite.play("Atacking")
	move_and_slide()


func _on_attack_time_timeout() -> void:
	atacando = false
