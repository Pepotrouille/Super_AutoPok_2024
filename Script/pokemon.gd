extends Area2D

class_name Pokemon



enum PokemonKind {SALAMECHE, HERICENDRE};
static var pokemon_dic = {
				PokemonKind.SALAMECHE : "res://Scene/Pokemon/salameche.tscn",
				PokemonKind.HERICENDRE : "res://Scene/Pokemon/hericendre.tscn"
				}

static func create_pokemon(pokemon_kind : PokemonKind):
	return load(pokemon_dic[pokemon_kind]).instantiate()


@export var max_life : int = 20;
var life : int;
@export var attack : int = 20;
@export var price : int = 20;
var alive : bool = true;



# Called when the node enters the scene tree for the first time.
func _ready():
	life = max_life;
	create_pokemon_info_if_none()
	$PokemonInfo.set_max_life(max_life)
	$PokemonInfo.set_current_life(life)
	$PokemonInfo.set_attack(attack)

func set_current_life(current_life:int):
	create_pokemon_info_if_none()
	$PokemonInfo.set_current_life(current_life)

func show_life(is_visible:bool):
	create_pokemon_info_if_none()
	$PokemonInfo.show_life(is_visible)

func show_info(is_visible:bool):
	create_pokemon_info_if_none()
	$PokemonInfo.show_info(is_visible)

func change_current_life(delta_life:int):
	create_pokemon_info_if_none()
	$PokemonInfo.change_current_life(delta_life)

func create_pokemon_info_if_none():
	if $PokemonInfo == null:
		var pokemon_info =load("res://Scene/pokemon_info.tscn").instantiate()
		print(pokemon_info.name)
		add_child(pokemon_info)
		pokemon_info.position = Vector2.ZERO
		pokemon_info.scale = Vector2.ONE * 0.7
		pokemon_info.z_index = -1

func face_right(will_face_right : bool):
	$Sprite2D.flip_h = will_face_right
	#Mettre le sprite de dos
