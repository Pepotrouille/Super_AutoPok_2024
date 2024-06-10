extends Node

class_name LoadingName

static var pokemons_dictionary : Dictionary;
# Called when the node enters the scene tree for the first time.
func _ready():
	load_pokemons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func load_pokemons():
	pokemons_dictionary = {}
	for file_name in DirAccess.get_files_at("res://Assets/Images/Pokemons/"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
			var pokemon_name = file_name.substr(0,len(file_name)-4)
			print(pokemon_name)
			if pokemon_name:
				pokemons_dictionary[pokemon_name] = ResourceLoader.load("res://Assets/Images/Pokemons/"+file_name)
