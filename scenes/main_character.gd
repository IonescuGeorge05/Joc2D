extends CharacterBody2D

@export var speed: float = 200.0
@onready var animated_sprite_2d = $AnimatedSprite2D

# Ultima direcție de mers:
# "right", "left", "down", "up"
var last_direction = "down"

func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			# Mers dreapta/stânga
			if input_vector.x > 0:
				last_direction = "right"
				animated_sprite_2d.flip_h = false
			else:
				last_direction = "left"
				animated_sprite_2d.flip_h = true

			if animated_sprite_2d.animation != "running":
				animated_sprite_2d.play("running")

		else:
			# Mers sus/jos
			animated_sprite_2d.flip_h = false  # la sus/jos nu se inversează
			if input_vector.y > 0:
				last_direction = "down"
				if animated_sprite_2d.animation != "running down":
					animated_sprite_2d.play("running down")
			else:
				last_direction = "up"
				if animated_sprite_2d.animation != "running up":
					animated_sprite_2d.play("running up")
	else:
		# Idle pe ultima direcție
		match last_direction:
			"right", "left":
				animated_sprite_2d.flip_h = (last_direction == "left")
				if animated_sprite_2d.animation != "default 2":
					animated_sprite_2d.play("default 2")
			"down":
				if animated_sprite_2d.animation != "default":
					animated_sprite_2d.play("default")
			"up":
				if animated_sprite_2d.animation != "default 3":
					animated_sprite_2d.play("default 3")
