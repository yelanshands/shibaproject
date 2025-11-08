extends Control

@onready var pp: Label = $ColorRect/VBoxContainer/MarginContainer/VBoxContainer/pp
@onready var crosshairs: CanvasLayer = $Crosshair
@onready var crosshair_margin: MarginContainer = $Crosshair/MarginContainer
@onready var hitcrosshair_cont: Control = $Crosshair/HitContainer

var player_name: String = ""
var hitting: bool = false
signal ok

func _process(_delta) -> void:
	if self.visible:
		crosshairs.visible = true
	else:
		crosshairs.visible = false
	crosshairs.transform.origin = crosshairs.transform.origin.lerp(get_viewport().get_mouse_position() - crosshair_margin.size/2.0, 0.3)
	
	if hitting:
		hitcrosshair_cont.scale = Vector2(lerp(hitcrosshair_cont.scale.x, 0.8, 0.4), lerp(hitcrosshair_cont.scale.y, 0.8, 0.4))
		
	if hitcrosshair_cont.scale.x > 0.77:
		hitcrosshair_cont.scale = Vector2(0.0, 0.0)
		hitting = false
	
func key_pressed(key: String) -> void:
	if key.length() == 1:
		player_name += key
	elif key == "back":
		player_name = player_name.left(player_name.length() - 1)
	elif key == "ok":
		emit_signal("ok")
	pp.text = player_name
