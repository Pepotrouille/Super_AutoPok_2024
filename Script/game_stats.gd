extends Node

class_name GameStats

static var money : int = 50;

static var instance : GameStats;

signal _change_money(amount : int)

signal _money_has_changed(total_amount : int)

var pokemon_team : Array

var size_team : int

var score : int = 0

@export var csv_pokemon_database : CSVPokemonDatabase
# Called when the node enters the scene tree for the first time.

static func get_instance() -> GameStats:
	return instance

func _ready():
	instance = self
	money = 80 #temp;
	_change_money.connect(change_money)
	for i in range(0,6):
		pokemon_team.append(null)

func add_score(amount : int):
	score += amount

func change_money(amount : int):
	money += amount
	_money_has_changed.emit(money)

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
		if pokemon_team != null:
			count_temp += 1
	size_team = count_temp

func change_position_in_team(index1 : int, index2 : int):
	var temp = pokemon_team[index1-1];
	pokemon_team[index1-1] = pokemon_team[index2-1];
	pokemon_team[index2-1] = temp

func end_game():
	#Envoyer score à l'exterieur
	for pok in pokemon_team:
		if(pok):
			pok.queue_free()
	get_tree().change_scene_to_file("res://Scene/UI/main_menu.tscn")
	queue_free()
