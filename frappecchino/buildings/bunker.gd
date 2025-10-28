extends Node3D

@onready var closingdoor: StaticBody3D = $closingdoor
@onready var closingentrance: StaticBody3D = $closingentrance
@onready var openingdoor: StaticBody3D = $openingdoor
@onready var snow: MeshInstance3D = get_parent().get_node("snow")

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	var openingscale := openingdoor.scale.x
	if openingscale - 0.01 > 0.01:
		closingdoor.position.y = lerp(closingdoor.position.y, 14.0, 0.15)
		closingentrance.position.y = lerp(closingentrance.position.y, 14.0, 0.15)
		openingdoor.scale.x = lerp(openingscale, 0.01, 0.05)
		snow.position.y = lerp(snow.position.y, -2.0, 0.05)
	else:
		closingdoor.position.y = 14.0
		closingentrance.position.y = 14.0
		openingdoor.scale.x = 0.01
		snow.visible = false
		set_process(false)
