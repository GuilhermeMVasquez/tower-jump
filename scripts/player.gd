extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -350.0

const MIN_POWER: float = 0.75
const MAX_POWER: float = 2.0

const HORIZONTAL_MULTIPLIER: float = 1.25

@onready var animated_sprite = $AnimatedSprite2D

enum State {READY, CHARGE, JUMP, FALL}
var state: State = get_starter_state()

var jump_power: float


func _physics_process(delta: float) -> void:
	var direction := get_direction()
	flip_sprite(direction)	

	if state == State.READY:
		process_ready(delta, direction)

	if state == State.CHARGE:
		process_charge(delta, direction)
	
	if state == State.JUMP or state == State.FALL:
		process_jump(delta)
	
	move_and_slide()


func process_ready(delta, direction: float) -> void:
	if not is_on_floor():
		state = State.FALL
	else:
		if animated_sprite.animation == "jump":
			animated_sprite.play("land")
					
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
		
		if Input.is_action_pressed("jump"):
			context_charge()


func process_charge(delta, direction: float) -> void:
	animated_sprite.play("charge")
	jump_power += 2 * delta
	
	if Input.is_action_just_released("jump") or jump_power >= MAX_POWER:
		context_jump(direction)


func process_jump(delta: float) -> void:
	animated_sprite.play("jump")
	use_gravity(delta)
	
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
	if not state in [State.JUMP, State.FALL]:
		if direction > 0:
			animated_sprite.flip_h = true
		elif direction < 0:
			animated_sprite.flip_h = false

func use_gravity(delta: float) -> void:
	velocity += get_gravity() * delta

func context_charge() -> void:
	velocity = Vector2.ZERO
	jump_power = 0
	state = State.CHARGE

func context_jump(direction: float) -> void:
	velocity.y = clamp(jump_power, MIN_POWER, MAX_POWER) * JUMP_VELOCITY
	velocity.x = direction * SPEED * HORIZONTAL_MULTIPLIER
	state = State.JUMP
