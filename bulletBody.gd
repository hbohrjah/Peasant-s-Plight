extends CharacterBody2D

var vel = Vector2(1,0)
var speed = 200
@onready var tilemap = $"../TileMap"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(vel.normalized() * delta * speed)
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("villager"):
		queue_free()
