extends CharacterBody2D

# animation related variables
@onready var animation_tree = $AnimationTree
@onready var animated_sprite = $AnimatedSprite2D
var animation_tree_conditions = [
	"parameters/conditions/is_idle",
	"parameters/conditions/is_walking"
]

# state related variables
enum {IDLE, CHASE}
var prey : PhysicsBody2D = null
var state = IDLE

# physics related variables
var ACCELERATION = 10
var MAX_SPEED = 50
var FRICTION = 1000

func _ready():
	animation_tree.active = true

func _on_area_2d_body_entered(body):
	prey = body
	state = CHASE

func _on_area_2d_body_exited(_body):
	prey = null
	state = IDLE

func _physics_process(delta):
	if state == CHASE:
		# get direction of the player
		var direction = prey.position - position
		direction.limit_length(0.7)
		
		# flipping animation sprite towards direction of the character
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true
		
		# applying physics on movement of the character
		var move_speed = ACCELERATION * delta * direction
		apply_movement(move_speed)
		move_and_slide()
	elif state == IDLE:
		# apply friction when player character stops moving
		apply_friction(FRICTION * delta)
	
	animate()

func apply_movement(amount : Vector2) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)

func apply_friction(amount : int) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func animate() -> void:
	if state == IDLE:
		animation_tree[animation_tree_conditions[IDLE]] = true
		animation_tree[animation_tree_conditions[CHASE]] = false
	else:
		animation_tree[animation_tree_conditions[IDLE]] = false
		animation_tree[animation_tree_conditions[CHASE]] = true
