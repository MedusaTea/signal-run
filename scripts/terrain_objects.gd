extends Node3D

@export var minSpawnDistance = 150

@onready var GlobalRoot = get_node('/root/Root')

@onready var obstacles = [
	preload("res://scenes/obstacles/log.tscn"),
	preload("res://scenes/obstacles/terrain_test.tscn")
]

func SpawnNewObstacle() -> void:
	var index = randi() % obstacles.size()
	var newNode = obstacles[index].instantiate()
	
	newNode.position += Vector3(0,0, -minSpawnDistance)
	newNode.get_child(0).linear_velocity = Vector3(0,0,GlobalRoot.terrainSpeed)
	add_child(newNode)

func _on_test_spawn_timer_timeout() -> void:
	SpawnNewObstacle()
