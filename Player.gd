extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const HOUSE_SENSITIVITY = 0.001
const HOUSE_RANGE = 1.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	# if the mouse has moved 
	if event is InputEventMouseMotion:
		#up-down motion, apply to the $Pivot
		$Pivot.rotate_x(-event.relative.y * HOUSE_SENSITIVITY)
		#make sure we can't look inside ourselves :0
		$Pivot.rotation.x = clamp($Pivot.rotation.x, - HOUSE_RANGE, HOUSE_RANGE)
		#left-right motion, applied to the player 
		rotate_y(-event.relative.x * HOUSE_SENSITIVITY)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
