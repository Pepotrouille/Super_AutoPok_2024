extends Area2D

class_name TeamEmptyPlace

var is_highlighted : bool = false;
var light_is_decreasing : bool = true;

var game_stats :GameStats;

signal _new_movable(new_movable : MovablePokemon);

@export var index : int = 1;

func _ready():
	modulate.a = 0
	for node in get_tree().root.get_child(0).get_children():
		if node is MovablePokemon:
			node._pokemon_is_moving.connect(pokemon_selected)
			node._pokemon_is_not_moving.connect(pokemon_unselected)
		if node is GameStats:
			game_stats = node
		if node is TeamEmptyPlace:
			node._new_movable.connect(new_movable_in_scene)
			


func _process(delta):
	if is_highlighted:
		if light_is_decreasing:
			if modulate.a > 0.3:
				modulate.a -= 0.005
			else:
				light_is_decreasing = false
		else:
			if modulate.a < 0.8:
				modulate.a += 0.005
			else:
				light_is_decreasing = true
	
				

func new_movable_in_scene(new_movable : MovablePokemon):
	new_movable._pokemon_is_moving.connect(pokemon_selected)
	new_movable._pokemon_is_not_moving.connect(pokemon_unselected)

func pokemon_selected():
	is_highlighted = true
	modulate.a = 0.3
	
func pokemon_unselected():
	is_highlighted = false
	modulate.a = 0

func fill_place(pokemon : Pokemon):
	var filled_place = load("res://Scene/possessed_pokemon.tscn").instantiate();
	filled_place.index = index
	filled_place.set_possessed_pokemon(pokemon);
	game_stats.set_pokemon(index, pokemon)
	filled_place.position=position
	get_tree().root.get_child(0).add_child(filled_place)
	_new_movable.emit(filled_place)
	queue_free();
