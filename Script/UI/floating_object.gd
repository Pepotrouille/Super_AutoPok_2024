extends Node2D

var y_direction : int = 1
@export  var speed : float = 10
@export var max_offset : float = 5

var offset_y_plus : float
var offset_y_minus : float
# Called when the node enters the scene tree for the first time.
func _ready():
	offset_y_plus = self.position.y + max_offset
	offset_y_minus = self.position.y - max_offset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.y = self.position.y + speed * delta * y_direction
	if self.position.y < offset_y_minus:
		y_direction = 1
	elif self.position.y > offset_y_plus:
		y_direction = -1
		
