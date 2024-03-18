extends CharacterBody2D

@export var speed = 50
@export var navAgent: NavigationAgent2D

var targetNode = null
var player = null
var shouldRun = false
var hasSeenDragon = false

var townSquare = false

var killme = false 

func _ready():
	
	navAgent.path_desired_distance = 4
	navAgent.target_desired_distance = 4
	

func _physics_process(_delta):
	var axis = to_local(navAgent.get_next_path_position()).normalized() #gets the direction this villager will be heading
	var intendedVelocity = axis * speed
	navAgent.set_velocity(intendedVelocity)
	$Sprite2D.rotation = intendedVelocity.angle()
	

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
		


func timer_start():
	$Recalculator.start()
	shouldRun = true
	if townSquare: #if this villager has not yet been to the town square
		targetNode = Vector2(575, 575) #then target the town square

#every time the timer (named recalculator) times out, we recalculate the path
func _on_recalculator_timeout():
	recalc_path()

#This function works with the avoidance behaviors to prevent villagers from overlapping
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

#if the dragon enters a radius around the villager, then the villager should start running
func _on_fear_range_area_entered(area): 
	timer_start()
	hasSeenDragon = true
	

#if the dragon is no longer in line of sight, the villager should not change the direction it runs
func _on_fear_range_area_exited(area): 
	shouldRun = false  

#this signal exists solely to get the player node so we can work with its coordinates
func _on_other_range_area_entered(area): #the radius is huge
	player = area.owner 


#function to make villagers "tell each other" to run as they encounter each other
func _on_vilager_range_area_entered(area):
	if hasSeenDragon && !area.owner.hasSeenDragon: #so that they don't start running just because they spawn next to each other
		print("run")
		area.owner.timer_start()
		area.owner.player = player
		area.owner.hasSeenDragon = true
		area.owner.shouldRun = false
		area.owner.targetNode = targetNode
	
	

#if a villager is touched by the dragon's fireball, we free both the villager and the fireball
func _on_death_range_area_entered(area):
	if area.owner.killme:
		area.owner.queue_free()
		queue_free()
