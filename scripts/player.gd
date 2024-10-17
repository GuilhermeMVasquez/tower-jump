extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -600.0

@onready var animated_sprite := $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if animated_sprite.animation == "jump":
			animated_sprite.play("land")

		var is_land_animation = animated_sprite.animation == "land"
		if not is_land_animation or (is_land_animation and not animated_sprite.is_playing()):
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("move")

		if direction > 0:
			animated_sprite.flip_h = true
		elif direction < 0:
			animated_sprite.flip_h = false
	
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		animated_sprite.play("jump")

	move_and_slide()
