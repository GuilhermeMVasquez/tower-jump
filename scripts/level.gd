extends Node

@onready var camera = $Camera2D
@onready var upper_limit = $UpperSceneLimit
@onready var lower_limit = $LowerSceneLimit
@onready var objective = $Objective

signal objective_reached

const SCREEN_MIDDLE = {x = 0, y = -360}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objective.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func move_view(direction: int) -> void:
	if direction > 0:
		camera.offset.y += SCREEN_MIDDLE.y * 2
		upper_limit.position.y += SCREEN_MIDDLE.y * 2
		lower_limit.position.y += SCREEN_MIDDLE.y * 2
	else:
		camera.offset.y -= SCREEN_MIDDLE.y * 2
		upper_limit.position.y -= SCREEN_MIDDLE.y * 2
		lower_limit.position.y -= SCREEN_MIDDLE.y * 2
		
		
func _on_body_entered(body: Node2D) -> void:
	objective_reached.emit()
	
