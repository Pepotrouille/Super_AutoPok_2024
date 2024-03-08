extends Area2D


@export var max_life : int = 20;
var life : int;
@export var attack : int = 20;
@export var price : int = 20;
var alive : bool = true;

var is_hovered : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	life = max_life;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed( 1 ): # Left click
		if is_hovered:
				position = get_global_mouse_position()


func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false

#func _unhandled_input(event):
	#if event is InputEventMouseButton:
	#	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
	#		if is_hovered:
	#			position = get_global_mouse_position()
