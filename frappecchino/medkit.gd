extends Node3D

@onready var guide: Label3D = $guide
@onready var game: Node3D = get_tree().current_scene
@onready var timer: Timer = $popup

@export var value: int = 50
var dialogue_id: int

func _on_area_3d_body_entered(body: Node3D) -> void:
	if self.visible:
		body.apply_damage((-value) if body.hp + value <= body.max_hp else (-(body.max_hp - body.hp)))
		self.visible = false
		dialogue_id = game.dialogue.current_dialogue_id + 1
		game.dialogue.streamDialogue("150 HP 回復。" if globals.settings_data.language else "Healed 150 HP.", "「回復キットを入手！」" if globals.settings_data.language else "Medkit obtained!")
		timer.start(5.0)
		await timer.timeout
		game.dialogue.endDialogue(dialogue_id)

func _on_guidearea_body_entered(_body: Node3D) -> void:
	guide.text = "v"

func _on_guidearea_body_exited(_body: Node3D) -> void:
	guide.text = ""
