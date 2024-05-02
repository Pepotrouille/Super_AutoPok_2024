extends Node

class_name CombatScript

var game_stats : GameStats

var base_player_team : Array;
@export var player_pokemon_1 : CombatPokemon; 
@export var player_pokemon_2 : CombatPokemon; 
@export var player_pokemon_3 : CombatPokemon; 
@export var player_pokemon_4 : CombatPokemon; 
@export var player_pokemon_5 : CombatPokemon; 
@export var player_pokemon_6 : CombatPokemon; 

var base_adv_team : Array;
@export var adv_pokemon_1 : CombatPokemon; 
@export var adv_pokemon_2 : CombatPokemon; 
@export var adv_pokemon_3 : CombatPokemon; 
@export var adv_pokemon_4 : CombatPokemon; 
@export var adv_pokemon_5 : CombatPokemon; 
@export var adv_pokemon_6 : CombatPokemon; 

var player_lost : bool = false;
var adv_lost : bool = false;
var game_ended : bool = false

var max_time_turn : float = 1

var current_time : float = 0

var is_moving_turn : bool = false;

var money_to_win : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().root.get_children())
	for node in get_tree().root.get_children():
		if node is GameStats:
			game_stats = node
	set_places()
	set_player_pokemon(game_stats.pokemon_team)
	set_adv_pokemon_test()
	set_money_to_win()

func _process(delta):
	current_time += delta
	if current_time>max_time_turn:
		current_time = 0
		if !game_ended:
			if is_moving_turn: #Tour Déplacement
				
				new_moving_turn()
				is_moving_turn = false
			else: #Tour Combat
				new_combat_turn()
				is_moving_turn = true

func set_places():
	player_pokemon_1.has_died.connect(check_remaining_pokemon_player);
	adv_pokemon_1.has_died.connect(check_remaining_pokemon_adv);
	
	player_pokemon_1.next_place = null
	adv_pokemon_1.next_place = null
	for i in range(2,7):
		evaluate("player_pokemon_"+ str(i) +".set_next_place(player_pokemon_"+str(i-1) +")")
		evaluate("adv_pokemon_"+ str(i) +".set_next_place(adv_pokemon_"+str(i-1) +")")
	adv_pokemon_2.next_place = adv_pokemon_1

	for i in range(1,7):
		evaluate("player_pokemon_"+ str(i) +".set_is_from_player(true)")
		evaluate("adv_pokemon_"+ str(i) +".set_is_from_player(false)")

func set_player_pokemon(team_pok : Array):
	base_adv_team = team_pok #Permet d'utiliser la team dans la fonction evaluate. Peut être remplacé par passage d'argument.
	base_player_team = team_pok
	for i in range(1,7):
		evaluate("player_pokemon_"+ str(i) +".set_combat_pokemon(base_player_team["+str(i-1) +"])")

func set_adv_pokemon(team_pok : Array):
	base_adv_team = team_pok #Permet d'utiliser la team dans la fonction evaluate. Peut être remplacé par passage d'argument.
	for i in range(1,7):
		evaluate("adv_pokemon_"+ str(i) +".set_combat_pokemon(base_adv_team["+str(i-1) +"])")

func new_combat_turn():
	for i in range(1,7):
		evaluate("adv_pokemon_"+ str(i) +".make_action()")
		evaluate("player_pokemon_"+ str(i) +".make_action()")
	player_pokemon_1.check_dying()
	adv_pokemon_1.check_dying()

func new_moving_turn():
	if player_lost and adv_lost:
		ends_in_defeat()
	elif player_lost:
		ends_in_defeat()
	elif adv_lost:
		ends_in_victory()
	else:
		for i in range(1,7):
			evaluate("adv_pokemon_"+ str(i) +".move()")
			evaluate("player_pokemon_"+ str(i) +".move()")

func get_first_non_null_player():
	if player_pokemon_1.local_pokemon != null:
		return player_pokemon_1
	if player_pokemon_2.local_pokemon != null:
		return player_pokemon_2
	if player_pokemon_3.local_pokemon != null:
		return player_pokemon_3
	if player_pokemon_4.local_pokemon != null:
		return player_pokemon_4
	if player_pokemon_5.local_pokemon != null:
		return player_pokemon_5
	if player_pokemon_6.local_pokemon != null:
		return player_pokemon_6

func get_first_non_null_adversary():
	if adv_pokemon_1.local_pokemon != null:
		return adv_pokemon_1
	if adv_pokemon_2.local_pokemon != null:
		return adv_pokemon_2
	if adv_pokemon_3.local_pokemon != null:
		return adv_pokemon_3
	if adv_pokemon_4.local_pokemon != null:
		return adv_pokemon_4
	if adv_pokemon_5.local_pokemon != null:
		return adv_pokemon_5
	if adv_pokemon_6.local_pokemon != null:
		return adv_pokemon_6

func check_remaining_pokemon_player():
	if (player_pokemon_1.local_pokemon == null and
		player_pokemon_2.local_pokemon == null and
		player_pokemon_3.local_pokemon == null and
		player_pokemon_4.local_pokemon == null and
		player_pokemon_5.local_pokemon == null and
		player_pokemon_6.local_pokemon == null):
			player_lost=true

func check_remaining_pokemon_adv():
	if (adv_pokemon_1.local_pokemon == null and
		adv_pokemon_2.local_pokemon == null and
		adv_pokemon_3.local_pokemon == null and
		adv_pokemon_4.local_pokemon == null and
		adv_pokemon_5.local_pokemon == null and
		adv_pokemon_6.local_pokemon == null):
			adv_lost=true

func set_money_to_win():
	for i in range (0,6):
		evaluate("add_money_to_win(adv_pokemon_" + str(i) + ".local_pokemon.price / 2)")

func add_money_to_win(money_amount : int):
	money_to_win += money_amount

func ends_in_victory():
	print("Victoire : Joueur")
	game_ended = true
	var winning_screen = load("res://Scene/UI/winning_screen.tscn").instantiate()
	
	#Gère les crédits gagnés
	winning_screen.set_winning_screen(money_to_win)
	game_stats.change_money(money_to_win)
	
	for i in range (1,7):
		evaluate("game_stats.set_pokemon(" + str(i) + ", player_pokemon_" + str(i) + ".local_pokemon)")
	for i in range (0,6):
		evaluate("player_pokemon_" + str(i) + ".reparent(game_stats)")
	#game_stats.set_team([	player_pokemon_1.local_pokemon, player_pokemon_2.local_pokemon, 
	#						player_pokemon_3.local_pokemon, player_pokemon_4.local_pokemon, 
	#						player_pokemon_5.local_pokemon, player_pokemon_6.local_pokemon])
	##Penser à mettre un Canvas nommé CanvasLayer dans la scène
	get_parent().find_child("CanvasLayer").add_child(winning_screen)

func ends_in_defeat():
	print("Perdu")
	game_ended = true
	var losing_screen = load("res://Scene/UI/losing_screen.tscn").instantiate()
	losing_screen.set_losing_screen(game_stats.score)
	get_parent().find_child("CanvasLayer").add_child(losing_screen)
	
## -- TEST -- ##

func set_adv_pokemon_test():
	adv_pokemon_2.set_combat_pokemon(Pokemon.create_pokemon("Boumata",game_stats.csv_pokemon_database ))
## ---------- ##

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

