extends CharacterBody2D

@export var move_speed: float = 200
@export var jump_velocity: float = -275
@export var gravity: float = 900.0
@export var jump_cut_multiplier: float = 0.3

@export var roll_speed: float = 400
@export var roll_duration: float = 0.2

@export var wall_jump_velocity_x: float = 750
@export var wall_jump_velocity_y: float = -300

@export var coyote_time_threshold: float = 0.10
@export var jump_buffer_time_threshold: float = 0.15

@onready var animsprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var is_rolling: bool = false
var roll_timer: float = 0.0
var facing_direction: int = 1
var was_on_wall: bool = false

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _ready():
	anim.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	update_animation()

func update_animation():
	if is_rolling:
		animsprite.play("sinatra_slide")
		animsprite.flip_h = facing_direction < 0
		return

	if is_touching_wall() and not is_on_floor():
		animsprite.play("sinatra_wall")
		animsprite.flip_h = $WallRay.target_position.x > 0
	elif not is_on_floor():
		animsprite.play("sinatra_fall")
		animsprite.flip_h = facing_direction < 0
	elif abs(velocity.x) > 10:
		animsprite.play("sinatra_run")
		animsprite.flip_h = facing_direction < 0
	else:
		animsprite.play("sinatra_idle")
		animsprite.flip_h = facing_direction < 0

func _physics_process(delta):
	# Update timers
	if is_on_floor():
		coyote_timer = coyote_time_threshold
	else:
		coyote_timer -= delta

	jump_buffer_timer -= delta

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

		# Variable jump height (early jump cut)
		if velocity.y < 0 and Input.is_action_just_released("jump"):
			velocity.y *= jump_cut_multiplier
	else:
		velocity.y = 0

	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
			anim.play("RESET")
		velocity.x = facing_direction * roll_speed
	else:
		var input_direction = 0
		if Input.is_action_pressed("left"):
			input_direction -= 1
		if Input.is_action_pressed("right"):
			input_direction += 1
		velocity.x = input_direction * move_speed

		if input_direction != 0:
			facing_direction = input_direction

		$WallRay.target_position = Vector2(10 * facing_direction, 0)

		# Buffer jump input
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer = jump_buffer_time_threshold

		# Handle jump using coyote time and input buffer
		if jump_buffer_timer > 0:
			if coyote_timer > 0:
				velocity.y = jump_velocity
				jump_buffer_timer = 0
			elif is_touching_wall() and not is_on_floor():
				wall_jump()
				jump_buffer_timer = 0

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
	animsprite.play("sinatra_slide")
	anim.play("sin_slide")

func _on_animation_finished(anim_name: String):
	if anim_name == "sin_slide":
		anim.stop()
