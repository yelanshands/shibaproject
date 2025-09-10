extends RayCast3D

@export var speed := 50.0
@onready var remote_transform := RemoteTransform3D.new()

func _physics_process(delta: float) -> void:
	position -= global_basis * Vector3.BACK * speed * delta
	target_position = -(Vector3.BACK * speed * delta)
	force_raycast_update()
	var collided = get_collider()
	if is_colliding():
		global_position = get_collision_point()
		set_physics_process(false)
		collided.add_child(remote_transform)
		remote_transform.global_transform = global_transform
		remote_transform.remote_path = remote_transform.get_path_to(self)
		remote_transform.tree_exited.connect(cleanup)
		
func cleanup() -> void:
	queue_free()
