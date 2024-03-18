extends CharacterBody2D

var vel = Vector2(1,0)
var speed = 200
@onready var tilemap = $"../TileMap"

var killme = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(vel.normalized() * delta * speed)
	




func _on_area_2d_body_entered(body):
	if body is TileMap:
		queue_free()
