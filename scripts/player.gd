extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -375.0

const MIN_POWER: float = 0.6
const MAX_POWER: float = 2

const HORIZONTAL_MULTIPLIER: float = 1.15
const BOUNCE_MULTIPLIER: float = 0.75

const STEPS: int = 15
const MAX_POINTS: int = 300

@onready var animated_sprite = $AnimatedSprite2D
@onready var line = $Line2D
@onready var jump_sound = $JumpSound
@onready var punch_sound = $PunchSound
@onready var wall_jump_sound = $WallJumpSound
@onready var timer = $Timer
@onready var line_timer = $Line2D/Timer

signal open_portal_1()
signal open_portal_2()

enum State {READY, CHARGE, JUMP, FALL}
var state: State = get_starter_state()

var jump_power: float
var sound_playing: bool = false

func _physics_process(delta: float) -> void:		
	var direction: float = 0
	if not state in [State.JUMP, State.FALL]:
		direction = get_direction()
	
	flip_sprite(direction)	

	if state == State.READY:
		process_ready(direction)

	if state == State.CHARGE:
		process_charge(delta, direction)
	
	if state in [State.JUMP, State.FALL]:
		process_jump(delta)

	move_and_slide()


func process_ready(direction: float) -> void:
	if not is_on_floor():
		state = State.FALL
	else:
		if animated_sprite.animation == "jump":
			animated_sprite.play("land")
			punch_sound.play()
				
		var is_land_animation: bool = animated_sprite.animation == "land"
		if !is_land_animation or (is_land_animation and !animated_sprite.is_playing()):
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("move")
				
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		handle_aim_line()
		
		if Input.is_action_pressed("jump"):
			context_charge()


func process_charge(delta, direction: float) -> void:
	animated_sprite.play("charge")
	jump_power += 2 * delta
	
	if Input.is_action_just_released("jump") or jump_power >= MAX_POWER:
		context_jump(direction)


func process_jump(delta: float) -> void:			
	animated_sprite.play("jump")
	velocity += get_gravity() * delta
	
	if is_on_wall():
		handle_bounce()
	
	if state == State.JUMP:
		if velocity.y > 0:
			state = State.FALL
	else:
		if is_on_floor():
			state = State.READY


func get_starter_state() -> State:
	if is_on_floor():
		return State.READY
	else:
		return State.FALL


func get_direction() -> float:
	return Input.get_axis("move_left", "move_right")


func flip_sprite(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false


func handle_bounce() -> void:
	var new_direction: float
	if animated_sprite.flip_h:
		new_direction = -1
	else:
		new_direction = 1
		
	flip_sprite(new_direction)
	velocity.x = new_direction * SPEED * BOUNCE_MULTIPLIER
	wall_jump_sound.play()


func context_charge() -> void:
	velocity = Vector2.ZERO
	jump_power = 0
	line.visible = false
	state = State.CHARGE


func context_jump(direction: float) -> void:
	velocity.y = clamp(jump_power, MIN_POWER, MAX_POWER) * JUMP_VELOCITY
	velocity.x = direction * SPEED * HORIZONTAL_MULTIPLIER
	state = State.JUMP
	jump_sound.play()


func handle_aim_line() -> void:
	var pos = Vector2.ZERO
	var mouse_now = get_local_mouse_position()
	var rad = abs(pos.angle_to_point(mouse_now))
	line.clear_points()
	line.visible = false
	if rad <= PI / 6 or (rad >= 5*PI/6 and rad <= 7*PI/6):
		line.add_point(pos)
		line.add_point(mouse_now)
		line.visible = true
		if Input.is_action_pressed("left_click"):
			open_portal_1.emit()
		elif Input.is_action_pressed("right_click"):
			open_portal_2.emit()
