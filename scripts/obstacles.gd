extends Node3D

@export var minSpawnDistance = 300
@export var terrainSpeed = 50

@onready var GlobalRoot = get_node('/root/Root')

var logIndex = 0
var wallIndex = 1
var breakableIndex = 2
@onready var obstacles = [
	preload("res://scenes/obstacles/log.tscn"),
	preload("res://scenes/obstacles/terrain_test.tscn"),
	preload("res://scenes/obstacles/breakable_wall.tscn"),
]

var obstacleNameCounter = 0

func SpawnNewObstacle(spawnOffset=0) -> void:
	var index = randi() % obstacles.size()
	var newNode = obstacles[index].instantiate()
	
	newNode.name = '%s %d' % [newNode.name, obstacleNameCounter]
	obstacleNameCounter += 1
	
	var modifier = Vector3(0,0,0)
	var leftOrRight = randi() % 2
	if leftOrRight == 0:
		if index == logIndex:
			modifier.y = 2
			var mesh = newNode.get_child(0).get_child(0).get_child(0).mesh
			mesh.material.albedo_color = '#fff'
						
		if index == wallIndex:
			var mesh = newNode.get_child(0).get_child(0).get_child(0).mesh
			mesh.material.albedo_color = '#000'
			modifier.x = 20
	else:
		if index == logIndex:
			modifier.y = -1
			var mesh = newNode.get_child(0).get_child(0).get_child(0).mesh
			mesh.material.albedo_color = '#f00'
		if index == wallIndex:
			var mesh = newNode.get_child(0).get_child(0).get_child(0).mesh
			mesh.material.albedo_color = '#f00'
		
		
	newNode.position += Vector3(0,0, -minSpawnDistance - spawnOffset) + modifier
	newNode.get_child(0).linear_velocity = Vector3(0,0,terrainSpeed)
	add_child(newNode)

func _on_test_spawn_timer_timeout() -> void:
	SpawnNewObstacle()
	SpawnNewObstacle(30)
