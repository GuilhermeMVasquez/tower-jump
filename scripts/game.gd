extends Node2D

@onready var hud = $HUD
@onready var player = $Player
@onready var level = $Level
@onready var portal_1 = $Portals/Portal1
@onready var portal_2 = $Portals/Portal2

signal set_time(ftime)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var camera = get_viewport().get_camera_2d()
		if event.button_index == MOUSE_BUTTON_LEFT:
			portal_1.open_portal(camera.get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			portal_2.open_portal(camera.get_global_mouse_position())


func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.name == "Player" and portal_1.portal_on and portal_2.portal_on:
		portal_1.recharge()
		portal_2.recharge()
		body.position = portal_2.position


func _on_portal_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and portal_1.portal_on and portal_2.portal_on:
		portal_1.recharge()
		portal_2.recharge()
		body.position = portal_1.position
