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
var pontoPosTiro

var estado:String = "Posicionando"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
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
		if self.position.x > player.position.x:
			if self.position.x > player.position.x + 510:
				direction = -1
				estado = "Posicionando"
			elif self.position.x <= player.position.x + 510 and self.position.x > player.position.x + 450:
				direction = 0
				estado = "Atirando"
			else:
				direction = +1 
				estado = "Posicionando"
		else:
			if self.position.x > player.position.x - 500:
				direction = 1
				estado = "Posicionando"
			elif self.position.x <= player.position.x - 500 and self.position.x > player.position.x - 460:
				direction = 0
				estado = "Atirando"
			else:
				direction = -1 
				estado = "Posicionando"
		
	if(estado == "Atirando"):
		if bullet.is_colliding():
			var alvo = bullet.get_collider()
			if alvo is Player:
				if not atacou:
					alvo.tomarDano(dano)
					animated_sprite.play("Attacking")
					atacou = true
					move_and_slide()
					$CoolDawn.start()
	
	velocity.x = velocidade * direction
	if atacou and !pontoPosTiro:
		if self.position.x > player.position.x + 460:
			pontoPosTiro = self.position.x + 20
		elif self.position.x < player.position.x + 500:
			pontoPosTiro = self.position.x - 20
	if atacou and pontoPosTiro:
		if pontoPosTiro > self.position.x:
			direction = +1
		else:
			direction = -1
		if abs(self.position.x - pontoPosTiro) < 5:
			pontoPosTiro = null
		velocity.x = velocidade * direction
	if not atacou:
		pontoPosTiro = null
	
	if velocity.x > 0 :
		animated_sprite.play("Walking")
	
	move_and_slide()

func _on_timer_timeout() -> void:
	atacou = false
