extends Node

class_name CombatScript

@export var player_pokemon_1 : CombatPokemon; 
@export var player_pokemon_2 : CombatPokemon; 
@export var player_pokemon_3 : CombatPokemon; 
@export var player_pokemon_4 : CombatPokemon; 
@export var player_pokemon_5 : CombatPokemon; 
@export var player_pokemon_6 : CombatPokemon; 

@export var adv_pokemon_1 : CombatPokemon; 
@export var adv_pokemon_2 : CombatPokemon; 
@export var adv_pokemon_3 : CombatPokemon; 
@export var adv_pokemon_4 : CombatPokemon; 
@export var adv_pokemon_5 : CombatPokemon; 
@export var adv_pokemon_6 : CombatPokemon; 

var player_lost : bool = false;
var adv_lost : bool = false;
var game_ended : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_places()
	set_player_pokemon_test()
	set_adv_pokemon_test()

var max_time_turn : float = 1

var current_time : float = 0

var is_moving_turn : bool = false;

func _process(delta):
	current_time += delta
	if current_time>max_time_turn:
		
		current_time = 0
		if !game_ended:
			if is_moving_turn:
				print("Tour Déplacement")
				new_moving_turn()
				is_moving_turn = false
			else:
				print("Tour Combat")
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
	for i in range(1,7):
		evaluate("player_pokemon_"+ str(i) +".set_combat_pokemon(team_pok["+str(i-1) +"])")

func set_adv_pokemon(team_pok : Array):
	for i in range(1,7):
		evaluate("adv_pokemon_"+ str(i) +".set_combat_pokemon(team_pok["+str(i-1) +"])")
	#adv_pokemon_1.set_combat_pokemon(team_pok[0])
	#adv_pokemon_2.set_combat_pokemon(team_pok[1])
	#adv_pokemon_3.set_combat_pokemon(team_pok[2])
	#adv_pokemon_4.set_combat_pokemon(team_pok[3])
	#adv_pokemon_5.set_combat_pokemon(team_pok[4])
	#adv_pokemon_6.set_combat_pokemon(team_pok[5])

func new_combat_turn():
	for i in range(1,7):
		evaluate("adv_pokemon_"+ str(i) +".make_action()")
		evaluate("player_pokemon_"+ str(i) +".make_action()")
	player_pokemon_1.check_dying()
	adv_pokemon_1.check_dying()

func new_moving_turn():
	if player_lost and adv_lost:
		print("Egalité")
		game_ended = true
	elif player_lost:
		print("Victoire : Adversaire")
		game_ended = true
	elif adv_lost:
		print("Victoire : Joueur")
		game_ended = true
		var winning_screen = load("res://Scene/UI/winning_screen.tscn").instantiate()
		##Penser à mettre un Canvas nommé CanvasLayer dans la scène
		get_tree().root.get_child(0).find_child("CanvasLayer").add_child(winning_screen)
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
			print("player_lost=true")

func check_remaining_pokemon_adv():
	if (adv_pokemon_1.local_pokemon == null and
		adv_pokemon_2.local_pokemon == null and
		adv_pokemon_3.local_pokemon == null and
		adv_pokemon_4.local_pokemon == null and
		adv_pokemon_5.local_pokemon == null and
		adv_pokemon_6.local_pokemon == null):
			adv_lost=true
			print("adv_lost=true")

## -- TEST -- ##

func set_player_pokemon_test():
	player_pokemon_1.set_combat_pokemon_kind(Pokemon.PokemonKind.HERICENDRE)
	player_pokemon_2.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)

func set_adv_pokemon_test():
	adv_pokemon_2.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)

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

	var result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		pass#print(str(result))

