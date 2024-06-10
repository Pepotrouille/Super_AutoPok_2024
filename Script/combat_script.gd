extends Node

class_name CombatScript

var base_player_team : Array;

@export_group("Player Team")
@export var player_pokemon_team : Array[CombatPokemon]
@export var player_pokemon_1 : CombatPokemon; 
@export var player_pokemon_2 : CombatPokemon; 
@export var player_pokemon_3 : CombatPokemon; 
@export var player_pokemon_4 : CombatPokemon; 
@export var player_pokemon_5 : CombatPokemon; 
@export var player_pokemon_6 : CombatPokemon; 

var base_adv_team : Array;
@export_group("Adversary Team")
@export var adversary_pokemon_team : Array[CombatPokemon]
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
	set_places()
	set_player_pokemon(GameStats.get_instance().pokemon_team)
	set_adv_pokemon(GameStats.get_instance().get_ennemy_team())
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
	for i in range(1,6):
		player_pokemon_team[i].set_next_place(player_pokemon_team[i-1])
		adversary_pokemon_team[i].set_next_place(adversary_pokemon_team[i-1])
	for i in range(0,6):
		player_pokemon_team[i].set_is_from_player(true)
		adversary_pokemon_team[i].set_is_from_player(false)

func set_player_pokemon(team_pok : Array):
	#base_adv_team = team_pok #Permet d'utiliser la team dans la fonction evaluate. Peut être remplacé par passage d'argument.
	base_player_team = team_pok
	for i in range(0,6):
		player_pokemon_team[i].set_combat_pokemon(base_player_team[i])

func set_adv_pokemon(team_pok : Array):
	#base_adv_team = team_pok #Permet d'utiliser la team dans la fonction evaluate. Peut être remplacé par passage d'argument.
	var i : int = 0
	for pok in team_pok:
		adversary_pokemon_team[i].set_combat_pokemon(pok)
		i += 1

func new_combat_turn():
	for i in range(0,6):
		player_pokemon_team[i].make_action()
		adversary_pokemon_team[i].make_action()
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
		for i in range(0,6):
			adversary_pokemon_team[i].move()
			player_pokemon_team[i].move()

func get_first_non_null_player():
	for i in range(0,6):
		if player_pokemon_team[i].local_pokemon:
			return player_pokemon_team[i]

func get_first_non_null_adversary():
	for i in range(0,6):
		if adversary_pokemon_team[i].local_pokemon != null:
			return adversary_pokemon_team[i]

func check_remaining_pokemon_player():
	if (player_pokemon_team[0].local_pokemon == null and
		player_pokemon_team[1].local_pokemon == null and
		player_pokemon_team[2].local_pokemon == null and
		player_pokemon_team[3].local_pokemon == null and
		player_pokemon_team[4].local_pokemon == null and
		player_pokemon_team[5].local_pokemon == null):
			player_lost=true

func check_remaining_pokemon_adv():
	if (adversary_pokemon_team[0].local_pokemon == null and
		adversary_pokemon_team[1].local_pokemon == null and
		adversary_pokemon_team[2].local_pokemon == null and
		adversary_pokemon_team[3].local_pokemon == null and
		adversary_pokemon_team[4].local_pokemon == null and
		adversary_pokemon_team[5].local_pokemon == null):
			adv_lost=true

func set_money_to_win():
	for i in range(0,6):
		if adversary_pokemon_team[i].local_pokemon:
			add_money_to_win(adversary_pokemon_team[i].local_pokemon.price * 0.75)

func add_money_to_win(money_amount : int):
	money_to_win += money_amount

func ends_in_victory():
	game_ended = true
	var game_stats = GameStats.get_instance()
	var winning_screen = load("res://Scene/UI/winning_screen.tscn").instantiate()
	
	#Gère les crédits gagnés
	winning_screen.set_winning_screen(game_stats.score, money_to_win)
	GameStats.get_instance().change_money(money_to_win)
	
	for i in range (0,6):#GameStats.get_instance()
		game_stats.set_pokemon(i+1, player_pokemon_team[i].local_pokemon)
	for i in range (0,6):
		player_pokemon_team[i].reparent(game_stats)
	##Penser à mettre un Canvas nommé CanvasLayer dans la scène
	get_parent().find_child("CanvasLayer").add_child(winning_screen)

func ends_in_defeat():
	game_ended = true
	var losing_screen = load("res://Scene/UI/losing_screen.tscn").instantiate()
	losing_screen.set_losing_screen(GameStats.get_instance().score)
	get_parent().find_child("CanvasLayer").add_child(losing_screen)
	
## -- TEST -- ##

func set_adv_pokemon_test():
	var new_adv_team = GameStats.get_instance().csv_pokemon_database.get_random_pokemon_team_depending_difficulty()
	for i in range(0, new_adv_team.size()):
		adversary_pokemon_team[i].set_combat_pokemon(new_adv_team[i])
## ---------- ##


