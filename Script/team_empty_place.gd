extends Area2D

class_name TeamEmptyPlace

var is_highlighted : bool = false;
var light_is_decreasing : bool = true;

signal _new_movable(new_movable : MovablePokemon);

@export var index : int = 1;

static var empty_places_in_scene : Array;

func _ready():
	modulate.a = 0
	empty_places_in_scene.append(self)
	for node in get_tree().root.get_child(0).get_children():
		if node is MovablePokemon:
			node._pokemon_is_moving.connect(pokemon_selected)
			node._pokemon_is_not_moving.connect(pokemon_unselected)


func _process(_delta):
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
	if pokemon != null :
		var filled_place = load("res://Scene/possessed_pokemon.tscn").instantiate();
		filled_place.index = index
		filled_place.set_possessed_pokemon(pokemon);
		GameStats.get_instance().set_pokemon(index, pokemon)
		pokemon.scale = Vector2.ONE *1.5
		pokemon.z_index = 1
		pokemon.face_right(false)
		filled_place.position=position
		get_tree().root.get_child(0).add_child(filled_place)
		_new_movable.emit(filled_place)
		empty_places_in_scene.remove_at(empty_places_in_scene.find(self))
		queue_free();
