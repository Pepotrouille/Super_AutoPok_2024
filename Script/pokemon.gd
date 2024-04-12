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
