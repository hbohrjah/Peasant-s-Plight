extends Node2D

func _on_area_2d_area_entered(area):
	if (randi() % 20) < 2:
		area.owner.targetNode = self.global_position
		area.owner.hiding = true
		
