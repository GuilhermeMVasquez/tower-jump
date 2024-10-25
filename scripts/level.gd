extends Node

@onready var camera = $Camera2D
@onready var upper_limit = $UpperSceneLimit
@onready var lower_limit = $LowerSceneLimit

const SCREEN_MIDDLE = {x = 0, y = -360}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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
		
