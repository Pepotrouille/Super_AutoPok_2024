extends Area2D

class_name Pokemon

enum PokemonType {FIRE, WATER, GRASS, ELECTRIC, POISON, ROCK, FLYING, FIGHTING, NORMAL, NULL}

static var pokemon_image_path = "res://Assets/Images/Pokemons/"
static var pokemon_image_path_sub = "res://Assets/Images/Pokemons/SubstituteDoll.png"

static func create_pokemon(new_pokemon_id : String, csv_pokemon_database : CSVPokemonDatabase):
	var pokemon = load("res://Scene/pokemon.tscn").instantiate()
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


var pok_type : PokemonType;
var pok_name : String = "Salamèche";
var pokemon_id : String;
var max_life : int = 20;
var attack : int = 20;
var freq_attack : int = 1;
var price : int = 20;

var alive : bool = true;
var life : int;

@export var pokemon_info : PokemonInfo 


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
	$PokemonInfo.set_info(pok_name, max_life, life, attack, price, pok_type, freq_attack)
	
	#Set the image
	var new_path = pokemon_image_path + pokemon_id + ".png"
	if FileAccess.file_exists(new_path):
		$Sprite2D.texture = load(new_path)
	else :
		$Sprite2D.texture = load(pokemon_image_path_sub)
		
	#Fix the position
	$Sprite2D.scale = Vector2.ONE*3
		

func set_current_life(current_life:int):
	life = current_life
	pokemon_info.set_current_life(current_life)

func show_life(is_now_visible:bool):
	$PokemonInfo.show_life(is_now_visible)

func show_info(is_now_visible:bool):
	pokemon_info.show_info(is_now_visible)

func change_current_life(delta_life:int):
	life += delta_life
	pokemon_info.change_current_life(delta_life)

func face_right(will_face_right : bool):
	$Sprite2D.flip_h = !will_face_right
	#Mettre le sprite de dos

func set_size(new_size :float):
	$Sprite2D.scale = Vector2.ONE*new_size
	$Sprite2D.position.y = position.y - 15 * new_size
