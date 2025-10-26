extends Node3D
@onready var missing_billboard: Label3D = $missing
@onready var face: Label3D = $face
@onready var dialogue: Label3D = $dialogue
@onready var dialogue_timer: Timer = $dialogueTimer
@onready var plushie: Node3D = $plushie

@export var text_speed: float = 0.015

var happy: bool = false
var dialogue_text: String = ""

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not happy:
		if "plushie" in body.inventory:
			body.inventory.erase("plushie")
			happy = true
			missing_billboard.visible = false
			face.text = "^ ^"
			plushie.visible = true
			dialogue_text = "thank you !"
			dialogue.text = ""
			for letter in dialogue_text:
				dialogue_timer.start(text_speed)
				dialogue.text += letter
				await dialogue_timer.timeout
