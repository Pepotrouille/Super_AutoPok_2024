extends MovablePokemon

class_name PossessedPokemon

@export var index: int = 1;

###--------------------------------------------------------------------
###-                              METHODS                             -
###--------------------------------------------------------------------

##========================Ititialization====================
#Pour initialiser un PossessedPokemon avec un Pokemon existant
func set_possessed_pokemon(pokemon : Pokemon):
	if pokemon != null:
		local_pokemon = pokemon
		if(local_pokemon.get_parent() != null):
			local_pokemon.reparent(self)
		else:
			add_child(local_pokemon)
		print("first: " + str(self))
		print("Ste possessed pokemons: " + get_children()[0].pok_name)
		position=Vector2.ZERO
		local_pokemon.position=Vector2.ZERO
		local_pokemon.position.y = position.y
		local_pokemon.set_size(2.5)
		local_pokemon.mouse_entered.connect(_on_pokemon_mouse_entered)
		local_pokemon.mouse_exited.connect(_on_pokemon_mouse_exited)
		local_pokemon.show_info(false)

##========================Actions====================
#Permet de changer de place au sein de la team avec un autre pokemon. Met à jour les deux
func change_position_in_team_with(other_possessed_pokemon: PossessedPokemon):
	var temp_pos = base_position
	base_position = other_possessed_pokemon.base_position
	other_possessed_pokemon.base_position = temp_pos
	GameStats.get_instance().change_position_in_team(index, other_possessed_pokemon.index)
	is_moving = true
	is_dropped = true
	#print("Change pos with: ",other_possessed_pokemon.local_pokemon.name)

#Permet de changer de place au sein de la team avec une place vide. Met à jour les deux
func change_position_in_team_with_empty(empty_place: TeamEmptyPlace ):
	var temp_pos = base_position
	base_position = empty_place.position
	empty_place.position = temp_pos
	GameStats.get_instance().change_position_in_team(index, empty_place.index)
	is_moving = true
	is_dropped = true

func _dropped_on_areas():
	var closest_zone = null
	var closest_position = 1000000
	for area in local_pokemon.get_overlapping_areas():
		if area is Pokemon:
			if area.get_parent() is PossessedPokemon:
				print(position.distance_squared_to(area.position))
				if position.distance_squared_to(area.position) < closest_position:
					closest_zone = area
					closest_position = position.distance_squared_to(area.position)
		elif area is TeamEmptyPlace || area is SellPlace:
			if position.distance_squared_to(area.position) < closest_position:
				closest_zone = area
				closest_position = position.distance_squared_to(area.position)
		
	
	if closest_zone is Pokemon:
		closest_zone.get_parent().change_position_in_team_with(self)
	elif closest_zone is TeamEmptyPlace:
		change_position_in_team_with_empty(closest_zone)
	elif closest_zone is SellPlace:
		GameStats.get_instance().change_money(ceil(local_pokemon.price * closest_zone.sell_coef))
		back_to_empty_place()

func back_to_empty_place():
	var empty_place = load("res://Scene/team_empty_place.tscn").instantiate();
	empty_place.index = index
	GameStats.get_instance().set_pokemon(index, null)
	empty_place.position=base_position
	get_tree().root.get_child(0).add_child(empty_place)
	_pokemon_is_not_moving.emit()
	queue_free();

