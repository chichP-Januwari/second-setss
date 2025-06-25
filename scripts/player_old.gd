extends CharacterBody2D

@export var move_speed: float = 200
@export var jump_velocity: float = -275
@export var gravity: float = 900.0

@export var roll_speed: float = 300
@export var roll_duration: float = .2

@export var wall_jump_velocity_x: float = 500
@export var wall_jump_velocity_y: float = -275

var is_rolling: bool = false
var roll_timer: float = 0.0
var facing_direction: int = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta # Apply gravity
	else:
		velocity.y = 0 # Don't apply on ground

	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false # Stop rolling when timer stops
		velocity.x = facing_direction * roll_speed # Roll the character
	else:
		var input_direction = 0
		if Input.is_action_pressed("left"):
			input_direction -= 1
		if Input.is_action_pressed("right"):
			input_direction += 1 
		velocity.x = input_direction * move_speed
		
		if input_direction != 0:
			facing_direction = input_direction # Set facing dir. to input dir.
		# Flip RayCast2D direction based on facing
		$WallRay.target_position = Vector2(10 * facing_direction, 0)
		
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = jump_velocity
			elif not is_on_floor() and is_touching_wall():
				wall_jump()
			
		if Input.is_action_just_pressed("roll") and is_on_floor():
			start_roll()
	move_and_slide()

func is_touching_wall() -> bool:
	return $WallRay.is_colliding()

func wall_jump():
	velocity.y = wall_jump_velocity_y
	velocity.x = -facing_direction * wall_jump_velocity_x
	facing_direction = -facing_direction

func start_roll():
	is_rolling = true
	roll_timer = roll_duration
	velocity.x = facing_direction * roll_speed
