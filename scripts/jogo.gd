#Soli Deo Gloria
class_name Jogo
extends Node2D

@export var enemy:Enemy
@export var cidade:String

signal update_data(cidade:String, destruida:bool)

func _ready() -> void:
	self.add_child(enemy)
	enemy.position = $Enemy.position
	$Enemy.queue_free()
	enemy.inimigoMorreu.connect(_on_enemy_inimigo_morreu)
	pass


func _on_enemy_inimigo_morreu() -> void:
	update_data.emit(cidade, true)
	queue_free()
	get_tree().change_scene_to_file("res://scenes/rio_grande_do_sul.tscn")
