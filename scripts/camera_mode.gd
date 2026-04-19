extends Camera3D

@export var move_speed = 2
@export var horizontal_rotate_speed = 0.05
@export var vertical_rotate_speed = 0.05

func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		position -= get_global_transform().basis.z * move_speed
	if Input.is_action_pressed("ui_down"):
		position += get_global_transform().basis.z * move_speed

	if Input.is_action_pressed("ui_left"):
		position -= get_global_transform().basis.x * move_speed
	if Input.is_action_pressed("ui_right"):
		position += get_global_transform().basis.x * move_speed

	#if Input.is_action_pressed("ui_left"):
	#	rotation.y += horizontal_rotate_speed
