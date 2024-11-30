extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var open_sound = $OpenSound
@onready var teleport_sound = $TeleportSound
@onready var close_sound = $CloseSound

@export var portal_on: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_portal(pos: Vector2, player_pos: Vector2) -> void:
	if portal_on:
		portal_on = false
		close_sound.play()
		animated_sprite.play("close")
		await animated_sprite.animation_finished
	animated_sprite.flip_h = (player_pos.x - pos.x) > 0
	position = pos
	open_sound.play()
	animated_sprite.play("open")
	await animated_sprite.animation_finished
	portal_on = true
	animated_sprite.play("idle")


func recharge() -> void:
	teleport_sound.play()
	portal_on = false
	timer.start()
	

func _on_timer_timeout() -> void:
	portal_on = true
