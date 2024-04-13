extends Node

class_name GameStats

static var money : int;

signal _change_money(amount : int)

signal _money_has_changed(total_amount : int)

static var pokemon_team : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	money = 80 #temp;
	_change_money.connect(change_money)
	for i in range(0,6):
		pokemon_team.append(null)

func change_money(amount : int):
	money += amount
	print('money change. New amount: ', money)
	_money_has_changed.emit(money)

func set_pokemon(index : int, pokemon : Pokemon):
	print(pokemon)
	if pokemon == null:
		pokemon_team[index-1] = null;
		print("Reinitialisation dans l'équipe, en position " , index)
	else:
		pokemon_team[index-1] = pokemon;
		print("Ajout de ", pokemon.name, " à l'équipe, en position " , index)

func get_pokemon(index : int):
	return pokemon_team[index-1];
	
func get_team():
	return pokemon_team;

func change_position_in_team(index1 : int, index2 : int):
	var temp = pokemon_team[index1-1];
	pokemon_team[index1-1] = pokemon_team[index2-1];
	pokemon_team[index2-1] = temp
