#Soli Deo Gloria

class_name Enemy
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dano:int = 1
var vida:int = 10
var vidaMax:int = 10
var velocidade:int = 180
var atacou:bool = false
var esperando:bool = false

var estado:String = "Posicionando"

@onready var lbl_vida: Label = $lblVida
@onready var player: Player = $"../Player"
@onready var bullet: RayCast2D = $Bullet

signal inimigoMorreu

func printVida() -> void :
	lbl_vida.text = "Vida: " + str(vida)
	

func tomarDano(dano:int)->void:
	vida -= dano
	printVida()
	if vida <= 0:
		inimigoMorreu.emit()
		queue_free()
		


func _ready() -> void:
	printVida()
	vida = vidaMax
	
var direction:int = 0
func _physics_process(delta: float) -> void:
		
	if not is_on_floor():
		velocity.y += 9.8
	if player:
		if self.position.x > player.position.x + 500:
			direction = -1
			estado = "Posicionando"
		elif self.position.x <= player.position.x + 500 and self.position.x > player.position.x + 460:
			direction = 0
			estado = "Atirando"
		else:
			direction = +1 
			estado = "Posicionando"
	if(estado == "Atirando"):
		if bullet.is_colliding():
			var alvo = bullet.get_collider()
			if alvo is Player:
				if not atacou:
					print("Atacou")
					alvo.tomarDano(dano)
					atacou = true
					esperando = true
					if get_tree():
						await get_tree().create_timer(0.5).timeout
					atacou = false
				if atacou and not esperando:
					esperando = true
					if get_tree():
						await get_tree().create_timer(0.5).timeout
					
	
	velocity.x = velocidade * direction

	move_and_slide()
