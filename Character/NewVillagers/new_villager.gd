extends CharacterBody2D

@export var speed = 50
@export var navAgent: NavigationAgent2D

var targetNode = null
var player = null
var shouldRun = false

var townSquare = false

var killme = false

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
		
	
	if !townSquare && player && shouldRun: #if we have been to the town square and we have encountered the player
		if ((15 + player.global_position.x) >= (15 + self.global_position.x)) && ((25 + player.global_position.y) >= (25 + self.global_position.y)):
			targetNode = Vector2(15, 25)
		elif ((15 + player.global_position.x) >= (15 + self.global_position.x)) && ((1045 - player.global_position.y) >= (1045 - self.global_position.y)):
			targetNode = Vector2(15, 1045)
		elif ((1600 - player.global_position.x) >= (1600 - self.global_position.x)) && ((25 + player.global_position.y) >= (25 + self.global_position.y)):
			targetNode = Vector2(1600, 25)
		elif ((1600 - player.global_position.x) >= (1600 - self.global_position.x)) && ((1045 - player.global_position.y) >= (1045 - self.global_position.y)):
			targetNode = Vector2(1600, 1045)
		
	if player:
		print(player.global_position)

func timer_start():
	$Recalculator.start()
	shouldRun = true
	if townSquare: #if this villager has not yet been to the town square
		targetNode = Vector2(575, 575) #then target the town square

func _on_recalculator_timeout():
	recalc_path()
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func _on_fear_range_area_entered(area): #placeholder for line of sight of the dragon
	timer_start()
	

func _on_fear_range_area_exited(area): 
	shouldRun = false  #if the dragon is no longer in line of sight, the villager should not change the direction it runs
	
func _on_other_range_area_entered(area): #this signal exists solely to get the player node so we can work with its coordinates
	player = area.owner 


func _on_vilager_range_area_entered(area):
	print("test")
	area.owner.timer_start()
	area.owner.player = player
	
	


func _on_death_range_area_entered(area):
	if area.owner.killme:
		queue_free()
