extends Area2D

class_name Pokemon

###--------------------------------------------------------------------
###-                   DEFINITIONS AND CREATION                       -
###--------------------------------------------------------------------


enum PokemonType {FIRE, WATER, GRASS, ELECTRIC, POISON, ROCK, FLYING, FIGHTING, NORMAL}

static var type_vs = [
	[0.5, 0.5, 2, 1, 1, 0.5, 1, 1, 1], 
	[2, 0.5,0.5, 1, 1, 2, 1, 1, 1],
	[0.5, 2, 0.5, 1, 0.5,2, 0.5, 1, 1],
	[1, 1, 0.5, 0.5, 1, 1, 2, 1, 1],
	[1, 1, 2, 1, 1, 0.5, 1, 1, 1],
	[2, 1, 1, 1, 1, 1, 2, 0.5, 1],
	[1, 1, 2, 0.5, 1, 0.5, 1, 2, 1],
	[1, 1, 1, 1, 0.5, 2, 0.5, 1, 2],
	[1, 1, 1, 1, 1 ,1, 0.5, 1, 1]
]


static var pokemon_image_path = "res://Assets/Images/Pokemons/"
static var pokemon_image_path_sub = "res://Assets/Images/Pokemons/SubstituteDoll.png"

static func create_pokemon(new_pokemon_id : String, csv_pokemon_database : CSVPokemonDatabase):
	var pokemon = load("res://Scene/Pokemon/pokemon.tscn").instantiate()
	var pok_stat = csv_pokemon_database.get_pokemon_stat(new_pokemon_id)
	if pok_stat != null:
		pokemon.set_stats(
			PokemonType[csv_pokemon_database.get_type_from_pokemon_stats(pok_stat)],
			csv_pokemon_database.get_fr_name_from_pokemon_stats(pok_stat),
			new_pokemon_id,
			csv_pokemon_database.get_life_from_pokemon_stats(pok_stat),
			csv_pokemon_database.get_atk_from_pokemon_stats(pok_stat),
			csv_pokemon_database.get_freq_atk_from_pokemon_stats(pok_stat),
			csv_pokemon_database.get_price_from_pokemon_stats(pok_stat)
		);
		return pokemon
	return null

static func coef_from_types(offensive_type: PokemonType, defensive_type: PokemonType) -> float:
	return type_vs[offensive_type][defensive_type]

###--------------------------------------------------------------------
###-                            ATTRIBUTS                             -
###--------------------------------------------------------------------

##========================Pokemon kind Dependent====================
var pok_type : PokemonType;
var pok_name : String = "Salamèche";
var pokemon_id : String;
var max_life : int = 20;
var attack : int = 20;
var freq_attack : int = 1;
var price : int = 20;

##========================Current====================
var life : int;

##========================Display objects====================
@export var pokemon_info : PokemonInfo 
@export var pokemon_top_info : PokemonInfo 

###--------------------------------------------------------------------
###-                              METHODS                             -
###--------------------------------------------------------------------

##========================Ititialization====================
func set_stats(new_type : PokemonType, new_pokemon_name : String, new_pokemon_id : String, new_max_life : int, new_atk : int, new_freq_atk : int, new_price : int):
	#Set attributes
	pok_type = new_type
	pok_name = new_pokemon_name
	pokemon_id = new_pokemon_id
	max_life = new_max_life
	life = new_max_life
	price = new_price
	freq_attack = new_freq_atk
	attack = new_atk
	pokemon_info.set_info(pok_name, max_life, life, attack, price, pok_type, freq_attack)
	pokemon_top_info.set_info(pok_name, max_life, life, attack, price, pok_type, freq_attack)
	pokemon_info.show_info(false)
	pokemon_top_info.show_info(false)
	#Set the image
	print(LoadingName.pokemons_dictionary)
	var new_path = LoadingName.pokemons_dictionary[pokemon_id]
	if new_path:
		$SpritePokemon.texture = new_path
	else :
		$SpritePokemon.texture = pokemon_image_path_sub
		
	#Fix the position
	$SpritePokemon.scale = Vector2.ONE*3


##========================Set infos====================
func set_current_life(current_life:int):
	life = current_life
	pokemon_info.set_current_life(current_life)

func change_current_life(delta_life:int):
	life += delta_life
	pokemon_info.change_current_life(delta_life)

##========================Set display info====================

func show_life(is_now_visible:bool):
	pokemon_info.show_life(is_now_visible)

func show_info(is_now_visible:bool):
	pokemon_info.show_info(is_now_visible)

func show_top_info(is_now_visible:bool):
	pokemon_top_info.show_info(is_now_visible)

func face_right(will_face_right : bool):
	$SpritePokemon.flip_h = !will_face_right
	#Mettre le sprite de dos

func set_size(new_size :float):
	$SpritePokemon.scale = Vector2.ONE*new_size
	$Shadow.scale = Vector2.ONE*new_size
	$SpritePokemon.position.y = position.y - 15 * new_size
	$Shadow.position.y = position.y + 10 * new_size
