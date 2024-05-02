extends Node

class_name CSVPokemonDatabase

var pokemon_database_path = "res://Assets/database/pokemon_database.csv"
var pok_bdd
var pok_ids : Array
var pok_total_rarity : int
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_variables()

func instantiate_variables():
	#Instantiate pok_bdd
	pok_bdd = FileAccess.open(pokemon_database_path, FileAccess.READ)
	#Instantiate pok_index and pok_total_rarity
	pok_total_rarity = 0
	pok_ids = []
	pok_bdd.get_csv_line()
	while !pok_bdd.eof_reached():
		var pokemon_stat = pok_bdd.get_csv_line()
		if pokemon_stat.size()>=7:
			pok_ids.append(pokemon_stat[2])
			pok_total_rarity += int(pokemon_stat[7])

func get_list_pokemon():
	var pokemon_list = []
	pok_bdd.get_csv_line()
	while !pok_bdd.eof_reached():
		var pokemon_stat = pok_bdd.get_csv_line()
		if pokemon_stat.size()>=7:
			pokemon_list.append(pokemon_stat[2])
	return pokemon_list

func get_pokemon_stat_from_index(index : int):
	pok_bdd = FileAccess.open(pokemon_database_path, FileAccess.READ)
	pok_bdd.get_csv_line()
	for i in range(0, index):
		pok_bdd.get_csv_line()
	var pokemon_stat = pok_bdd.get_csv_line()
	if pokemon_stat.size()>=7:
		return pokemon_stat
	return null

func get_pokemon_stat(pokemon_id : String) :
	pok_bdd.get_csv_line()
	var i = 0
	for pok_id in pok_ids:
		if pok_id == pokemon_id:
			return get_pokemon_stat_from_index(i)
		i += 1
	return null

func get_pokemon(pokemon_id : String) -> Pokemon:
	var pokemon = Pokemon.create_pokemon(pokemon_id, self)
	return pokemon

func get_type_from_pokemon_stats(pokemon_stat : Array) -> String:
	return pokemon_stat[0]

func get_fr_name_from_pokemon_stats(pokemon_stat : Array) -> String:
	return pokemon_stat[1]

func get_en_name_from_pokemon_stats(pokemon_stat : Array) -> String:
	return pokemon_stat[8]

func get_atk_from_pokemon_stats(pokemon_stat : Array) -> int:
	return int(pokemon_stat[4])

func get_freq_atk_from_pokemon_stats(pokemon_stat : Array) -> int:
	return int(pokemon_stat[5])

func get_life_from_pokemon_stats(pokemon_stat : Array) -> int:
	return int(pokemon_stat[3])

func get_rarity_from_pokemon_stats(pokemon_stat : Array) -> int:
	return int(pokemon_stat[7])

func get_price_from_pokemon_stats(pokemon_stat : Array) -> int:
	return int(pokemon_stat[6])

func get_random_pokemon() -> Pokemon:
	var random_rarity_index = rng.randi_range(1, pok_total_rarity)
	print("Rarity: ", random_rarity_index)
	var current_rarity_index = 0
	pok_bdd = FileAccess.open(pokemon_database_path, FileAccess.READ)
	pok_bdd.get_csv_line()
	while !pok_bdd.eof_reached():
		var pokemon_stat = pok_bdd.get_csv_line()
		if pokemon_stat.size()>=7:
			current_rarity_index += get_rarity_from_pokemon_stats(pokemon_stat)
			if current_rarity_index > random_rarity_index:
				print("Pokémon: ", pokemon_stat[1])
				return get_pokemon(pokemon_stat[2])
	#In case of an error, return Fuecoco
	return get_pokemon("Chochodile")
