extends Node2D

@onready var hud = $HUD
@onready var player = $Player
@onready var portal_1 = $Portals/Portal1
@onready var portal_2 = $Portals/Portal2
@onready var level = $Level

signal set_time(ftime)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level.objective_reached.connect(_on_objective_reached)
	player.open_portal_1.connect(_on_portal_1_open)
	player.open_portal_2.connect(_on_portal_2_open)

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
	

func _on_portal_1_open() -> void:
	portal_1.open_portal(get_local_mouse_position(), player.position)
 

func _on_portal_2_open() -> void:
	portal_2.open_portal(get_local_mouse_position(), player.position)
	

func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.name == "Player" and portal_1.portal_on and portal_2.portal_on:
		portal_2.recharge()
		body.position = portal_2.position


func _on_portal_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and portal_1.portal_on and portal_2.portal_on:
		portal_1.recharge()
		body.position = portal_1.position
