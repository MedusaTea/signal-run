extends Node3D

@export var minSpawnDistance = 75

@onready var GlobalRoot = get_node('/root/Root')

@onready var obstacles = [
	preload("res://scenes/obstacles/log.tscn"),
	preload("res://scenes/obstacles/terrain_test.tscn")
]

func SpawnNewObstacle(spawnOffset=0) -> void:
	var index = randi() % obstacles.size()
	var newNode = obstacles[index].instantiate()
	
	var leftOrRight = randi() % 2
	var modifier = Vector3(0,0,0)
	
	if leftOrRight == 0:
		if index == 0:
			modifier.y = 1
			
		if index == 1:
			modifier.x = 20
		
	newNode.position += Vector3(0,0, -minSpawnDistance - spawnOffset) + modifier
	newNode.get_child(0).linear_velocity = Vector3(0,0,GlobalRoot.terrainSpeed)
	add_child(newNode)

func _on_test_spawn_timer_timeout() -> void:
	SpawnNewObstacle()
	SpawnNewObstacle(30)
