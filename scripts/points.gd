extends Label

var points = 0
var pointsTimeMultiplier = 100
var deltaDivider = 10

func _process(delta: float) -> void:
	points += delta / deltaDivider
	set_text("Points: %d" % (points * pointsTimeMultiplier))
