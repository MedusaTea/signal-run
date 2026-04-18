extends Node

@onready var RootNode = get_node('/root/Root')
@onready var OrbsControl = get_node('/root/Root/Control/QueueBar/Orbs')

@onready var orbScene = preload("res://scenes/orb.tscn")

@export var orbOffset = 115
@export var orbTopOffset = 20

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var orbCount = OrbsControl.get_child_count()
	
	var orb = orbScene.instantiate()
	OrbsControl.add_child(orb)
	orb.position = Vector2(100 + orbCount * orbOffset, orbTopOffset)
