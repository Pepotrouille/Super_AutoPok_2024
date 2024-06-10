extends Node2D

class_name PreviewPokemon

var local_pokemon : Pokemon;

@export var view_size : float;

###--------------------------------------------------------------------
###-                              METHODS                             -
###--------------------------------------------------------------------

##========================Ititialization====================
#Pour initialiser un PossessedPokemon avec un Pokemon existant
func set_preview_pokemon(pokemon : Pokemon):
	if pokemon != null:
		local_pokemon = pokemon
		if(local_pokemon.get_parent() != null):
			local_pokemon.reparent(self)
		else:
			add_child(local_pokemon)
		local_pokemon.position=Vector2.ZERO
		local_pokemon.scale = Vector2.ONE * view_size
		local_pokemon.position.y += 20
		local_pokemon.mouse_entered.connect(_on_pokemon_mouse_entered)
		local_pokemon.mouse_exited.connect(_on_pokemon_mouse_exited)
		local_pokemon.show_info(false)
		local_pokemon.face_right(false)

##========================Signals====================
func _on_pokemon_mouse_entered():
	if local_pokemon:
		local_pokemon.show_top_info(true)

func _on_pokemon_mouse_exited():
	if local_pokemon:
		local_pokemon.show_top_info(false)
