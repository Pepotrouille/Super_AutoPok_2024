extends Node2D

class_name MovablePokemon

var local_pokemon : Pokemon;

static var current_selected : Pokemon = null;

var is_hovered : bool = false;

var is_moving : bool = false;

var is_dropped : bool = true;

var base_position : Vector2;

signal _pokemon_is_moving();
signal _pokemon_is_not_moving();

func _ready():
	base_position = position
	for empty_place in TeamEmptyPlace.empty_places_in_scene:
		if empty_place != null:
			empty_place.new_movable_in_scene(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_mouse_button_pressed( MOUSE_BUTTON_LEFT ): # Click Gauche
		if is_moving: #Déplacemenyt avec la souris si sélectionné
			position = get_global_mouse_position()
		elif is_hovered and current_selected == null: #Sélectionne pokémon si aucun sélectionné
			#print("second: " + str(self))
			#print("local_parent : " + str(local_pokemon.get_parent()))
			#print("Will move pokemon " + str(get_child_count()))
			#print("Will move pokemon " + get_children()[0].pok_name)
			if local_pokemon != null:
				_pokemon_is_moving.emit()
				current_selected = local_pokemon;
				current_selected.z_index=5;
				is_moving = true;
				is_dropped = false;
				print(is_moving)
	elif is_moving: #Click souris laché, mais pas immobile (position initiale non-atteinte)
		if position.distance_squared_to(base_position)<50:
			_pokemon_is_not_moving.emit()
			is_moving = false;
			position = base_position;
			if current_selected:
				current_selected.z_index=0;
				current_selected = null
		else:
			if is_dropped:
				position = (position - base_position)/2 + base_position
			else:
				_dropped_on_areas()
				is_dropped = true;

func _on_pokemon_mouse_entered():
	if local_pokemon:
		if current_selected == null:
			is_hovered = true;
		local_pokemon.show_info(true)

func _on_pokemon_mouse_exited():
	if local_pokemon:
		is_hovered = false
		local_pokemon.show_info(false)

#Virtual : permet aux classes héritante de redéfinir la fonction appelée au lâché
func _dropped_on_areas():
	pass

#Virtual : permet aux classes héritante de redéfinir la fonction appelée au lâché
func _delete_place():
	pass
