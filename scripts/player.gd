extends CharacterBody2D

enum State { IDLE, RUN, JUMP, FALL }

const SPEED = 200
const JUMP_VELOCITY = -400
const GRAVITY = 1200

var state = State.IDLE

func _physics_process(delta):
	handle_state()
	apply_gravity(delta)
	move_and_slide()
	update_animation()  # Optional

func handle_state():
	match state:
		State.IDLE:
			velocity.x = 0
			if !is_on_floor():
				state = State.FALL
			elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				state = State.RUN
			elif Input.is_action_just_pressed("jump"):
				jump()

		State.RUN:
			var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
			velocity.x = direction * SPEED

			if direction == 0:
				state = State.IDLE
			elif Input.is_action_just_pressed("jump"):
				jump()
			elif !is_on_floor():
				state = State.FALL

		State.JUMP:
			var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
			velocity.x = direction * SPEED
			if velocity.y > 0:
				state = State.FALL

		State.FALL:
			var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
			velocity.x = direction * SPEED
			if is_on_floor():
				state = State.IDLE

func jump():
	velocity.y = JUMP_VELOCITY
	state = State.JUMP

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func update_animation():
	match state:
		State.IDLE:
			$AnimationPlayer.play("idle")
		State.RUN:
			$AnimationPlayer.play("run")
		State.JUMP:
			$AnimationPlayer.play("jump")
		State.FALL:
			$AnimationPlayer.play("fall")
