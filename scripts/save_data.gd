#Soli Deo Gloria
extends Node

@onready var dom_pedrito: Cidade = $"../Cidades/Dom Pedrito"
@onready var curitiba: Cidade = $"../Cidades/Curitiba"
@onready var ponta_grossa: Cidade = $"../Cidades/Ponta Grossa"

var data = {
	"ponta_grossa": false,
	"curitiba": false,
	"dom_pedrito": false
}

func save_data()->void:
	var file = FileAccess.open("user://dados.txt", FileAccess.WRITE)
	file.store_var(data)
	print("Salvou a data")
	
	file = FileAccess.open("user://dados.txt", FileAccess.READ)
	var save = file.get_var()
	
	print("dom pedrito " + str(save["dom_pedrito"]))
	print("curitiba " + str(save["curitiba"]))
	print("ponta grossa " + str(save["ponta_grossa"]))
	print("   ")

func load_data()->void:
	if FileAccess.file_exists("user://dados.txt"):
		var file = FileAccess.open("user://dados.txt", FileAccess.READ)
		
		var save = file.get_var()
		print("Carregando data...")
		
		data["dom_pedrito"] = save["dom_pedrito"]
		if dom_pedrito:
			dom_pedrito.attacked = data["dom_pedrito"]
			dom_pedrito.atualizar()
		print("dom pedrito " + str(save["dom_pedrito"]))
		
		data["curitiba"] = save["curitiba"]
		if curitiba:
			curitiba.attacked = data["curitiba"]
			curitiba.atualizar()
		print("curitiba " + str(save["curitiba"]))
		
		data["ponta_grossa"] = save["ponta_grossa"]
		if ponta_grossa:
			ponta_grossa.attacked = data["ponta_grossa"]
			ponta_grossa.atualizar()
		print("ponta grossa " + str(save["ponta_grossa"]))
		
		print("  ")
	else:
		var file = FileAccess.open("user://dados.txt", FileAccess.WRITE)
		file.store_var(data)

func _ready() -> void:
	load_data()


func _on_jogo_update_data(cidade: String, destruida: bool) -> void:
	load_data()
	if cidade == "Curitiba":
		cidade = "curitiba"
	if cidade == "Dom Pedrito" or cidade == "dom pedrito":
		cidade = "dom_pedrito"
	if cidade == "Ponta Grossa" or cidade == "ponta grossa":
		cidade = "ponta_grossa"
	data[cidade] = destruida
	print("\n data[" + str(cidade) + "] = " + str(destruida))
	save_data()
	print("Salvou a data da cidade: " + str(cidade) + " como " + str(destruida) + " mas na realidade ela está como " + str(data[cidade]) )
	load_data()


func _on_btn_del_data_pressed() -> void:
	data["ponta_grossa"] = false
	data["curitiba"] = false
	data["dom_pedrito"] = false
	save_data()
	load_data()
