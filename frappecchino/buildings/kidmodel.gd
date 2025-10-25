extends Node3D
@onready var missing_billboard: Label3D = $missing
@onready var face: Label3D = $face
@onready var dialogue: Label3D = $dialogue
@onready var dialogue_timer: Timer = $dialogueTimer
@onready var plushie: Node3D = $plushie
@onready var plushie_collision: CollisionShape3D = plushie.get_node("pookie/CollisionShape3D")

@export var text_speed: float = 0.015

var happy: bool = false
var dialogue_text: String = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not happy:
		if body.inventory.any(func(b): return b.name == "plushie"):
			for b in body.inventory:
				if b.name == "plushie":
					body.inventory.erase(b)
					break
			happy = true
			missing_billboard.visible = false
			face.text = "^ ^"
			plushie_collision.disabled = false
			plushie.visible = true
			dialogue_text = "thank you ! do you want to see something ?"
			dialogue.text = ""
			for letter in dialogue_text:
				dialogue_timer.start(text_speed)
				dialogue.text += letter
				await dialogue_timer.timeout
