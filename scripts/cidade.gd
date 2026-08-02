#Soli Deo Gloria
class_name Cidade
extends Button

@export var cityName:String
@export var attacked:bool

@export var enemy_maxLife:int
@export var enemy_damage:int

@onready var label: Label = $Label

func _ready() -> void:
	atualizar()

func atualizar() -> void:
	label.text = cityName
	if attacked:
		self.icon = load("res://assets/sprites/CasaDestruida.png")
	else:
		self.icon = load("res://assets/sprites/CasaNormal.png")



func _on_pressed() -> void:
	if attacked:
		var textoAntigo = label.text
		label.text = "Você já atacou esta cidade"
		await get_tree().create_timer(0.5).timeout
		label.text = textoAntigo
	else:
		var jogo:Jogo = load("res://scenes/jogo.tscn").instantiate()
		var enemy:Enemy = load("res://scenes/enemy.tscn").instantiate()
	
		enemy.dano = enemy_damage
		enemy.vidaMax = enemy_maxLife
	
		jogo.enemy = enemy
		jogo.cidade = cityName
		get_tree().change_scene_to_node(jogo)
