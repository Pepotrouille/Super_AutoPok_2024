extends MovablePokemon

class_name PossessedPokemon

@export var index: int = 1;

#Pour initialiser un PossessedPokemon avec un type de Pokemon
func set_possessed_pokemon_kind(pokemon_kind : Pokemon.PokemonKind):
	set_possessed_pokemon(Pokemon.create_pokemon(pokemon_kind))

#Pour initialiser un PossessedPokemon avec un Pokemon existant
func set_possessed_pokemon(pokemon : Pokemon):
	local_pokemon = pokemon
	if(local_pokemon.get_parent() != null):
		local_pokemon.reparent(self)
	else:
		add_child(local_pokemon)
	position=Vector2.ZERO
	local_pokemon.position=Vector2.ZERO
	local_pokemon.position.y -= 50
	local_pokemon.mouse_entered.connect(_on_pokemon_mouse_entered)
	local_pokemon.mouse_exited.connect(_on_pokemon_mouse_exited)

#Permet de changer de place au sein de la team avec un autre pokemon. Met à jour les deux
func change_position_in_team_with(other_possessed_pokemon: PossessedPokemon):
	var temp_pos = base_position
	base_position = other_possessed_pokemon.base_position
	other_possessed_pokemon.base_position = temp_pos
	game_stats.change_position_in_team(index, other_possessed_pokemon.index)
	is_moving = true
	is_dropped = true
	print(other_possessed_pokemon.local_pokemon.name)

#Permet de changer de place au sein de la team avec une place vide. Met à jour les deux
func change_position_in_team_with_empty(empty_place: TeamEmptyPlace ):
	var temp_pos = base_position
	base_position = empty_place.position
	empty_place.position = temp_pos
	game_stats.change_position_in_team(index, empty_place.index)
	is_moving = true
	is_dropped = true

func _dropped_on_areas():
	#for body in local_pokemon.get_overlapping_bodies():
		#print("body : ",body.name)
	for area in local_pokemon.get_overlapping_areas():
		#print("area : ",area.name)
		if area is Pokemon:
			if area.get_parent() is PossessedPokemon:
				area.get_parent().change_position_in_team_with(self)
		if area is TeamEmptyPlace:
			change_position_in_team_with_empty(area)
		if area is SellPlace:
			game_stats.change_money(ceil(local_pokemon.price * area.sell_coef))
			back_to_empty_place()

func back_to_empty_place():
	var empty_place = load("res://Scene/team_empty_place.tscn").instantiate();
	empty_place.index = index
	game_stats.set_pokemon(index, null)
	empty_place.position=base_position
	get_tree().root.get_child(0).add_child(empty_place)
	_pokemon_is_not_moving.emit()
	queue_free();

