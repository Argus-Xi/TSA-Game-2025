extends CharacterBody2D

const WALK_FORCE = 800
const WALK_MAX_SPEED = 300
const STOP_FORCE = 2000
const JUMP_SPEED = 300
var coyoteTime: float = 0.2
var jumpBuffering: float = 0.2
var onGround: bool = true

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _updateData():
	if jumps > 1:
		jumpBuffering = 0
		coyoteTime = 0
		
		coyoteTime = abs(coyoteTime)
		jumpBuffering = abs(jumpBuffering)

func _bufferJump():
	await get_tree().create_timer(jumpBuffering).timeout
	jumpWasPressed = false

func _coyoteTime():
	await get_tree().create_timer(coyoteTime).timeout
	coyoteActive = false
	jumpCount += -1

func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	# TODO: This information should be set to the CharacterBody properties instead of arguments: snap, Vector2.DOWN, Vector2.UP
	# TODO: Rename velocity to linear_velocity in the rest of the script.
	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = -JUMP_SPEED
