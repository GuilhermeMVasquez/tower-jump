extends Node2D

var hud: CanvasLayer
var player: CharacterBody2D
var level = null

signal set_time(ftime)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud = get_child(0)
	player = get_child(1)
	level = get_child(2)
	level.objective_reached.connect(_on_objective_reached)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	var lower_limit = level.get_node("LowerSceneLimit")
	var upper_limit = level.get_node("UpperSceneLimit")
	
	if player.position.y < upper_limit.position.y:
		level.move_view(1)
	elif player.position.y > lower_limit.position.y:
		level.move_view(-1)


func _on_objective_reached() -> void:
	hud.stop()
	var packed = load("res://scenes/credits.tscn")
	var scene = packed.instantiate()
	scene.connect_signal(set_time)
	set_time.emit(hud.get_time_formatted())
	var p2 = PackedScene.new()
	p2.pack(scene)
	get_tree().change_scene_to_packed(p2)
