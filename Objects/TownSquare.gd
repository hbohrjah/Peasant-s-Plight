extends Node2D

var theBells = false

func _on_villager_entered_area_entered(area):
	print("entered")
	theBells = true
