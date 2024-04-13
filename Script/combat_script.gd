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




# Called when the node enters the scene tree for the first time.
func _ready():
	set_places()
	set_player_pokemon_test()
	set_adv_pokemon_test()

var max_time_turn : float = 1.5

var current_time : float = 0

var is_moving_turn : bool = false;

func _process(delta):
	current_time += delta
	if current_time>max_time_turn:
		
		current_time = 0
		if is_moving_turn:
			print("Tour Déplacement")
			new_moving_turn()
			is_moving_turn = false
		else:
			print("Tour Combat")
			new_combat_turn()
			is_moving_turn = true
		

func set_places():
	player_pokemon_1.next_place = null
	player_pokemon_2.next_place = player_pokemon_1
	player_pokemon_3.next_place = player_pokemon_2
	player_pokemon_4.next_place = player_pokemon_3
	player_pokemon_5.next_place = player_pokemon_4
	player_pokemon_6.next_place = player_pokemon_5
	player_pokemon_1.is_from_player = true
	player_pokemon_2.is_from_player = true
	player_pokemon_3.is_from_player = true
	player_pokemon_4.is_from_player = true
	player_pokemon_5.is_from_player = true
	player_pokemon_6.is_from_player = true
	adv_pokemon_1.next_place = null
	adv_pokemon_2.next_place = adv_pokemon_1
	adv_pokemon_3.next_place = adv_pokemon_2
	adv_pokemon_4.next_place = adv_pokemon_3
	adv_pokemon_5.next_place = adv_pokemon_4
	adv_pokemon_6.next_place = adv_pokemon_5
	adv_pokemon_1.is_from_player = false
	adv_pokemon_2.is_from_player = false
	adv_pokemon_3.is_from_player = false
	adv_pokemon_4.is_from_player = false
	adv_pokemon_5.is_from_player = false
	adv_pokemon_6.is_from_player = false

func new_combat_turn():
	player_pokemon_1.make_action();
	player_pokemon_2.make_action();
	player_pokemon_3.make_action();
	player_pokemon_4.make_action();
	player_pokemon_5.make_action();
	player_pokemon_6.make_action();
	adv_pokemon_1.make_action();
	adv_pokemon_2.make_action();
	adv_pokemon_3.make_action();
	adv_pokemon_4.make_action();
	adv_pokemon_5.make_action();
	adv_pokemon_6.make_action();

func new_moving_turn():
	player_pokemon_1.move();
	player_pokemon_2.move();
	player_pokemon_3.move();
	player_pokemon_4.move();
	player_pokemon_5.move();
	player_pokemon_6.move();
	adv_pokemon_1.move();
	adv_pokemon_2.move();
	adv_pokemon_3.move();
	adv_pokemon_4.move();
	adv_pokemon_5.move();
	adv_pokemon_6.move();
	
func set_player_pokemon(team_pok : Array):
	player_pokemon_1.set_combat_pokemon(team_pok[0])
	player_pokemon_2.set_combat_pokemon(team_pok[1])
	player_pokemon_3.set_combat_pokemon(team_pok[2])
	player_pokemon_4.set_combat_pokemon(team_pok[3])
	player_pokemon_5.set_combat_pokemon(team_pok[4])
	player_pokemon_6.set_combat_pokemon(team_pok[5])

func set_adv_pokemon(team_pok : Array):
	adv_pokemon_1.set_combat_pokemon(team_pok[0])
	adv_pokemon_2.set_combat_pokemon(team_pok[1])
	adv_pokemon_3.set_combat_pokemon(team_pok[2])
	adv_pokemon_4.set_combat_pokemon(team_pok[3])
	adv_pokemon_5.set_combat_pokemon(team_pok[4])
	adv_pokemon_6.set_combat_pokemon(team_pok[5])

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


## -- TEST -- ##

func set_player_pokemon_test():
	player_pokemon_1.set_combat_pokemon_kind(Pokemon.PokemonKind.HERICENDRE)
	player_pokemon_2.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)
	player_pokemon_5.set_combat_pokemon_kind(Pokemon.PokemonKind.HERICENDRE)

func set_adv_pokemon_test():
	adv_pokemon_2.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)
	adv_pokemon_3.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)
	adv_pokemon_4.set_combat_pokemon_kind(Pokemon.PokemonKind.SALAMECHE)

## ---------- ##
