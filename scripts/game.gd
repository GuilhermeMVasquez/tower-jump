extends Node2D

var level = null
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_child(0)
	level = get_child(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lower_limit = level.get_node("LowerSceneLimit")
	var upper_limit = level.get_node("UpperSceneLimit")
	
	if player.position.y < upper_limit.position.y:
		level.move_view(1)
	elif player.position.y > lower_limit.position.y:
		level.move_view(-1)
