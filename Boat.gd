extends CharacterBody3D

# Boat settings
var max_speed = 15.0
var acceleration = 2.0
var deceleration = 1.5
var max_turn_speed = 2.0
var min_turn_speed = 0.3

# Current speed
var current_speed = 0.0

# Bobbing motion (always active)
var bob_time = 0.0
var bob_amount = 0.2
var bob_speed = 1.2

func _physics_process(delta):
	# Get input
	var move_input = Input.get_axis("ui_down", "ui_up")
	var turn_input = Input.get_axis("ui_right", "ui_left")
	
	# Smoothly change speed
	if move_input != 0:
		current_speed = move_toward(current_speed, move_input * max_speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)
	
	# Calculate turn speed based on current speed (smooth blend)
	var speed_ratio = abs(current_speed) / max_speed
	var turn_speed = lerp(min_turn_speed, max_turn_speed, speed_ratio)
	
	# Turn the boat smoothly
	rotation.y += turn_input * turn_speed * delta
	
	# Always remain at water level
	position.y = 0.0
	
	# Move the boat
	velocity = -transform.basis.z * current_speed
	
	# Always bobbing (just less when moving fast)
	bob_time += delta * bob_speed
	var bob_intensity = lerp(bob_amount, bob_amount * 0.3, speed_ratio)
	get_node("Root Scene").rotation.z = sin(bob_time) * bob_intensity
	
	move_and_slide()
