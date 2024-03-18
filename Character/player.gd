extends CharacterBody2D

@export var move_speed:float = 100.0
@export var starting_direction: Vector2 = Vector2(0,1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
const bulletPath = preload('res://fireball.tscn')


func _ready():
	update_animation_parameters(starting_direction)
	
func _process(delta):
	if Input.is_action_just_pressed("click"):
		breathe()
	
	if Input.is_action_pressed("space"):
		boost()
	else:
		move_speed = 100.0
	
	$Node2D.look_at(get_global_mouse_position())

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	
	
	pick_new_state()
	move_and_slide()

func update_animation_parameters(move_input:Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
		

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


func _on_area_2d_area_entered(area):
	print("out")
	
	pass # Replace with function body.
	
func breathe():
	var count = 0
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Marker2D.global_position 
	
	bullet.vel = get_global_mouse_position() - bullet.position
	count = count +1
	
func boost():
	move_speed = 250.0
	
