extends Node3D
@onready var collision_shape_3d: CollisionShape3D = $pookie/CollisionShape3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.inventory.append(self)
	self.visible = false
	#collision_shape_3d.set_deferred("disabled", true)
	print(body.inventory)
