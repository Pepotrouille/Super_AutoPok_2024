extends Node

class_name GameStats

###--------------------------------------------------------------------
###-                             ATTRIBUTES                           -
###--------------------------------------------------------------------

static var money : int = 50;

static var instance : GameStats;

signal _change_money(amount : int)

signal _money_has_changed(total_amount : int)

var pokemon_team : Array

var pokemon_ennemy_team : Array

var size_team : int = 0
var size_ennemy_team : int = 0

var game_paused : bool = false

var score : int = 0

var difficulty : int = 0

@export var csv_pokemon_database : CSVPokemonDatabase
# Called when the node enters the scene tree for the first time.

###--------------------------------------------------------------------
###-                                METHODS                           -
###--------------------------------------------------------------------

##========================Singleton====================

static func get_instance() -> GameStats:
	return instance

##========================Game Methods====================

func _ready():
	instance = self
	money = 30 #temp;
	_change_money.connect(change_money)
	for i in range(0,6):
		pokemon_team.append(null)
		pokemon_ennemy_team.append(null)

func end_game():
	##Envoyer score à l'exterieur
	get_tree().change_scene_to_file("res://Scene/UI/main_menu.tscn")
	queue_free()

func increase_difficulty():
	difficulty += 3

##========================Player stats====================

func add_score(amount : int):
	score += amount

func change_money(amount : int):
	money += amount
	_money_has_changed.emit(money)

##========================Player Team Management====================

func set_pokemon(index : int, pokemon : Pokemon):
	if pokemon == null:
		pokemon_team[index-1] = null;
	else:
		pokemon_team[index-1] = pokemon;
	count_team_member()

func get_pokemon(index : int):
	return pokemon_team[index-1];

func get_team():
	return pokemon_team;

func set_team(new_pokemon_team):
	pokemon_team = new_pokemon_team
	count_team_member()

func count_team_member():
	var count_temp = 0
	for pokemon in pokemon_team:
		if pokemon != null:
			count_temp += 1
	size_team = count_temp

func change_position_in_team(index1 : int, index2 : int):
	var temp = pokemon_team[index1-1];
	pokemon_team[index1-1] = pokemon_team[index2-1];
	pokemon_team[index2-1] = temp

##========================Ennemy Team Management====================

func set_ennemy_pokemon(index : int, pokemon : Pokemon):
	if pokemon == null:
		pokemon_ennemy_team[index-1] = null;
	else:
		pokemon_ennemy_team[index-1] = pokemon;
	count_team_member()

func get_ennemy_pokemon(index : int):
	return pokemon_ennemy_team[index-1];

func get_ennemy_team():
	return pokemon_ennemy_team;

func set_ennemy_team(new_pokemon_team):
	pokemon_ennemy_team = new_pokemon_team
	count_ennemy_team_member()

func count_ennemy_team_member():
	var count_temp = 0
	for pokemon in pokemon_ennemy_team:
		if pokemon != null:
			count_temp += 1
	size_ennemy_team = count_temp
