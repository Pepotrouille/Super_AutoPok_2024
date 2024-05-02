extends Node2D

var game_stats = GameStats

@export var team_place_1 : TeamEmptyPlace; 
@export var team_place_2 : TeamEmptyPlace; 
@export var team_place_3 : TeamEmptyPlace; 
@export var team_place_4 : TeamEmptyPlace; 
@export var team_place_5 : TeamEmptyPlace; 
@export var team_place_6 : TeamEmptyPlace; 
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().root.get_children():
		if node is GameStats:
			game_stats = node
			game_stats._money_has_changed.connect(update_amount_money)
			update_amount_money(game_stats.money)
			print("Game stat : ", game_stats)
			print("Game csv bdd : ", game_stats.csv_pokemon_database)
	#Met les pokémons présents dans game stats à l'initialisation
	$BuyablePokemon1.set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	$BuyablePokemon2.set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	$BuyablePokemon3.set_pokemon_to_buy(game_stats.csv_pokemon_database.get_random_pokemon())
	for i in range(0,6): 
		evaluate("team_place_" + str(i+1) + ".fill_place(game_stats.pokemon_team[" + str(i) +"])")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_amount_money(total_amount:int):#Will be changed to hud scene after
	$Amount.text = ("Credits: " + str(total_amount))

func _on_button_pressed():
	if game_stats.size_team >0:
		for i in range(1,7):
			evaluate("team_place_" + str(i) + "")
		get_tree().change_scene_to_file("res://Scene/niveau_test.tscn")
	else:
		#for i in range(1,7):
			#evaluate("team_place_" + str(i) + ".local_pokemon.reparent(get_tree().root)")
		#Afficher
		print("Veuillez prendre au moins un pokémon dans votre équipe")



#Tiré de la doc Godot :
#https://docs.godotengine.org/fr/4.x/tutorials/scripting/evaluating_expressions.html
#Permet de factoriser des fonctions en transformants des strings en fonctions
#Permettant par exemple une itération dans des variables.
#ATTENTION : ne marche que sur des fonctions, par sur des sets directs (machin = chose)
func evaluate(command, variable_names = [], variable_values = []) -> void:
	#print(command)
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return

	var _result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		pass#print(str(result))
