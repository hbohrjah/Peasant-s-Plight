extends CharacterBody2D

@export var speed = 50
@export var navAgent: NavigationAgent2D

var targetNode = null
var player = null
var townSquare = null
var heirloom = null
var shouldRun = false
var hasSeenDragon = false
var hiding = false
var grabbing = false
var theBells = false
var heirloomCollected = false

var killme = false 
var isHeirloom = false

func _ready():
	
	navAgent.path_desired_distance = 4
	navAgent.target_desired_distance = 4
	
	$AnimationPlayer.play("run")

func _physics_process(_delta):
	var axis = to_local(navAgent.get_next_path_position()).normalized() #gets the direction this villager will be heading
	var intendedVelocity = axis * speed
	navAgent.set_velocity(intendedVelocity)
	$Sprite2D.rotation = intendedVelocity.angle()
	if heirloom && heirloomCollected:
		heirloom.global_position.x = self.global_position.x + 5
		heirloom.global_position.y = self.global_position.y + 5
		

func recalc_path(): 
	if !theBells && !grabbing: #if the bells have not rung
		targetNode = Vector2(800, 530) #go to the town square to ring the bells
		
	elif theBells && !hasSeenDragon && !grabbing: #if the bells have been rung but we haven't encountered the player
		targetNode = Vector2(1600, 25) #run to the top right of the map
		
	elif theBells && player && shouldRun && !hiding && !grabbing: #if the dragon is chasing and we are not hiding
		if ((15 + player.global_position.x) >= (15 + self.global_position.x)) && ((25 + player.global_position.y) >= (25 + self.global_position.y)):
			targetNode = Vector2(15, 25)
		elif ((15 + player.global_position.x) >= (15 + self.global_position.x)) && ((1045 - player.global_position.y) >= (1045 - self.global_position.y)):
			targetNode = Vector2(15, 1045)
		elif ((1600 - player.global_position.x) >= (1600 - self.global_position.x)) && ((25 + player.global_position.y) >= (25 + self.global_position.y)):
			targetNode = Vector2(1600, 25)
		elif ((1600 - player.global_position.x) >= (1600 - self.global_position.x)) && ((1045 - player.global_position.y) >= (1045 - self.global_position.y)):
			targetNode = Vector2(1600, 1045)
	
	if targetNode:
		navAgent.target_position = targetNode
		


func timer_start():
	$Recalculator.start()

func timer_stop():
	$Recalculator.stop()

#every time the timer (named recalculator) times out, we recalculate the path
func _on_recalculator_timeout():
	if !theBells: #if the bells have not rung
		theBells = townSquare.theBells
	recalc_path()

#This function works with the avoidance behaviors to prevent villagers from overlapping
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

#if the dragon enters a radius around the villager, then the villager should start running
func _on_fear_range_area_entered(area): 
	timer_start()
	if !player:
		player = area.owner
	shouldRun = true
	hasSeenDragon = true
	if (randi() % 10) < 2: #chance that the villager trips and falls upon seeing the dragon
		timer_stop()
		navAgent.target_position = self.global_position
		$tripTimer.start()
		
	

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
	
	

#if a villager is touched by the dragon's fireball, we free both the villager and the fireball
func _on_death_range_area_entered(area):
	if area.owner.killme:
		area.owner.queue_free()
		queue_free()
		if heirloom && heirloomCollected:
			heirloom.queue_free()


func _on_the_bells_area_entered(area):
	townSquare = area.owner


func _on_bell_chimes_timeout():
	if townSquare:
		if townSquare.theBells:
			theBells = townSquare.theBells
			timer_start()
			$bellChimes.stop()
			


func _on_trip_timer_timeout():
	timer_start()


func _on_heirlooms_area_entered(area):
	if !heirloomCollected  && !grabbing && area.owner.isHeirloom && (randi() % 20) < 2:
		if area.owner.collected == false:
			heirloom = area.owner
			grabbing = true
			targetNode = heirloom.global_position


func _on_heirlooms_grabbed_area_entered(area):
	if heirloom && grabbing:
		if area.owner == heirloom:
			print("grabbed")
			heirloom.collected = true
			heirloomCollected = true
			grabbing = false
		
		
		
		
