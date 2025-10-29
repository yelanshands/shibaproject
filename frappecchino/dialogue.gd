extends CanvasLayer

@onready var dialogue_name: Label = $DialogueBorder/DialogueBox/HBoxContainer/VBoxContainer/Name
@onready var dialogue_text: Label = $DialogueBorder/DialogueBox/HBoxContainer/VBoxContainer/Dialogue
@onready var dialogue_animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@export var text_speed: float = 0.015
@export var popup: bool = false

var current_dialogue_id = 0

func _ready() -> void:
	if popup:
		dialogue_animation = $popup

func streamDialogue(texty: String, namey: String = "FRAPPIE"):
	if not visible:
		visible = true
	
	if namey != dialogue_name.text:
		dialogue_animation.play("slide_in")
		
	current_dialogue_id += 1
	var this_id = current_dialogue_id
	dialogue_name.text = namey
	dialogue_text.text = ""
	
	for letter in texty:
		if current_dialogue_id != this_id: return
		timer.start(text_speed)
		dialogue_text.text += letter
		await timer.timeout
			
func endDialogue(idy: int = -1) -> void:
	if idy == current_dialogue_id or idy < 0:
		dialogue_animation.play_backwards("slide_in")
		await dialogue_animation.animation_finished
		visible = false
