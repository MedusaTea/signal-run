extends Label


@export var PointsPaused = true
@export var Points = 0

var pointsTimeMultiplier = 100
var deltaDivider = 10

func Start() -> void:
	Points = 0
	PointsPaused = false

func Stop() -> void:
	PointsPaused = true
	
func _process(delta: float) -> void:
	if PointsPaused:
		return

	Points += delta / deltaDivider
	set_text("Points: %d" % (Points * pointsTimeMultiplier))
