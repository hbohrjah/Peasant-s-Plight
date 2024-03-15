extends CharacterBody2D
@onready var tilemap = $"../TileMap"

var current_path: Array[Vector2i]
@onready var dragon = $"../Player"

func _process(delta):
	if current_path.is_empty():
		return
		
	var target_pos = tilemap.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, 1)
	
	if global_position == target_pos:
		current_path.pop_front()
	
	pass

func _unhandled_input(event):
	var dragon_position = dragon.global_position
	#position.x
	#position.y
	
	if tilemap.is_point_walkable(dragon_position):
		current_path = tilemap.astar.get_id_path(
			tilemap.local_to_map(global_position),
			tilemap.local_to_map(dragon_position)
		).slice(1)


func _on_area_2d_area_entered(area):
	queue_free()
	pass # Replace with function body.
