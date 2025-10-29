extends Node3D
@onready var collision_shape_3d: CollisionShape3D = $pookie/CollisionShape3D
@onready var guide: Label3D = $guide

@export var on_ground: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if self.visible and on_ground:
		body.inventory.append("plushie")
		self.visible = false

func _on_guidearea_body_entered(_body: Node3D) -> void:
	guide.text = "v"

func _on_guidearea_body_exited(_body: Node3D) -> void:
	guide.text = ""
