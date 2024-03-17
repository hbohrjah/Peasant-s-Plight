extends CharacterBody2D

@export var speed = 50
@export var navAgent: NavigationAgent2D

var targetNode = null

func _ready():
	
	navAgent.path_desired_distance = 4
	navAgent.target_desired_distance = 4
	

func _physics_process(_delta):

		
	var axis = to_local(navAgent.get_next_path_position()).normalized() #gets the direction this villager will be heading
	var intendedVelocity = axis * speed
	navAgent.set_velocity(intendedVelocity)
	
	
func recalc_path():
	if targetNode:
		navAgent.target_position = targetNode

	print(navAgent.target_position)

func _on_recalculator_timeout():
	recalc_path()

func _on_fear_range_area_entered(area):
	targetNode = Vector2(575, 575)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("dragon"):
		queue_free()
	if area.is_in_group("fireball"):
		queue_free()
