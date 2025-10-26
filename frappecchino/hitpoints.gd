extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hitpointy: Label3D = $hitpointy

func _ready() -> void:
	animation.play("fadeinandout")
