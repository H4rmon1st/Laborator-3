extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

# physics constants for player movement
const MAX_SPEED = 80
const ACCELERATION = 300
const FRICTION = 500

# animation related variables and types
enum {IDLE, WALK}
var state = IDLE

var blend_position = Vector2.ZERO
var blend_position_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/walk/walk_bs2d/blend_position"
]
var animation_tree_conditions = [
	"parameters/conditions/is_idle",
	"parameters/conditions/is_walking"
]

func move(delta):
	# getting movement input from the player
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	# applying physics movement onto player
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(FRICTION * delta)
	else:
		state = WALK
		apply_movement(ACCELERATION * input_vector * delta)
		blend_position = input_vector
	
	# flipping character sprite towards the movement of the player
	if input_vector.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif input_vector.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()

# function that applies friction on character when it stops moving
func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

# function that applies movement on character
func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)

func _physics_process(delta):
	move(delta)
	animate()

func _ready():
	animation_tree.active = true

# function that controls the character animation
func animate():
	if state == IDLE:
		animation_tree[animation_tree_conditions[IDLE]] = true
		animation_tree[animation_tree_conditions[WALK]] = false
	else:
		animation_tree[animation_tree_conditions[IDLE]] = false
		animation_tree[animation_tree_conditions[WALK]] = true
	
	animation_tree.set(blend_position_paths[state], blend_position)
