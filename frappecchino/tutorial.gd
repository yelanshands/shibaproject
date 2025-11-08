extends Node3D

const PlayerScene = preload("res://player.tscn")
const Npc = preload("res://npc.tscn")

@onready var barrier1 = $building/innerwalls/barrier1
@onready var barrier2 = $building/innerwalls/barrier2
@onready var finalbarrier = $building/innerwalls/finalbarrier
@onready var n1 = $n1
@onready var n2 = $n2
@onready var dialogue: CanvasLayer = $Dialogue
@onready var player: CharacterBody3D = $Player
@onready var fade_animation: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var skip_animation: AnimationPlayer = $CanvasLayer/SkipAnimation
@onready var skip_label: Label = $CanvasLayer/Label

var skipped: bool = false

var slide1
var slide2
var finalnpc

var player_respawn: Vector3

var range_enemies: Array
var slide_enemies: Array
var final_enemies: Array

var area0text = "Hurry, before the explosion goes off. Use the left joystick to move. Look around with the right joystick. Jump by moving forward and pressing the white button."
var area1text = "Shoot the targets with the big red button. Notice how headshots deal more damage than body shots? And body shots deal more than leg shots?"
var area2text = "Slide under by moving forward and pressing the blue button."
var area3text = "Eliminate the targets and slide again with the blue button."
var area4text = "Now slide and jump at the same time to get through the gap."
var area5text = "Shoot the target across the room."
var area6text = "Slide and jump to break the glass and escape."

var area0text_jp = "「爆発が起こる前に急げ。左ジョイスティックで移動。右ジョイスティックで周囲を見渡せ。前進しながら白ボタンでジャンプ。」"
var area1text_jp = "「大きな赤ボタンで標的を撃て。ヘッドショットは胴体よりも大きなダメージを与えるぞ。脚よりも胴体の方が強いダメージだ。」"
var area2text_jp = "「前進しながら青ボタンでスライディング。」"
var area3text_jp = "「標的を排除して、もう一度青ボタンでスライディング。」"
var area4text_jp = "「スライディングしながらジャンプして、隙間を通り抜けろ。」"
var area5text_jp = "「部屋の向こう側の標的を撃て。」"
var area6text_jp = "「スライディングとジャンプでガラスを破り、脱出しろ。」"

#var area0text = "Hurry, before the explosion goes off. Use WASD to move. Jump moving forward and pressing SPACE."
#var area1text = "Shoot the targets with LEFT CLICK. Notice how headshots deal more damage than body shots? And body shots deal more than leg shots?"
#var area2text = "Slide under by moving forward and pressing SHIFT."
#var area3text = "Eliminate the targets and slide again with SHIFT."
#var area4text = "Now slide and jump at the same time to get through the gap."
#var area5text = "Press C to aim. Aiming zooms in, decreases sensitivity, and decreases recoil, allowing for better accuracy. Shoot the target."
#var area6text = "Slide and jump to break the glass and escape."
#
#var area0text_jp = "「爆発が起こる前に急げ。WASDで移動。前進しながらSPACEでジャンプ。」"
#var area1text_jp = "「LEFT CLICKで標的を撃て。ヘッドショットは胴体よりも大きなダメージを与えるぞ。脚よりも胴体の方が強いダメージだ。」"
#var area2text_jp = "「前進しながらSHIFTでスライディング。」"
#var area3text_jp = "「標的を排除して、もう一度SHIFTでスライディング。」"
#var area4text_jp = "「スライディングしながらジャンプして、隙間を通り抜けろ。」"
#var area5text_jp = "「Cを押してエイム。エイム中はズームインし、感度と反動が減少し、命中精度が上がる。標的を撃て。」"
#var area6text_jp = "「スライディングとジャンプでガラスを破り、脱出しろ。」"

var checkpoint: Vector3
var checkpoint_rot: Vector3

func _ready() -> void:
	if globals.settings_data.language: 
		skip_label.text = "「ENTERキーでチュートリアルをスキップ。」"
		skip_label.position.x = 600
	
	range_enemies = [n1, n2]
	
	player_respawn = player.global_position
	fade_animation.play_backwards("fade_out")
	
	player.bullet_speed = 2000.0
	skip_animation.play("skip_fade_out")
	
	dialogue.streamDialogue(area0text)
	
	checkpoint = player.global_position
	checkpoint_rot = Vector3(0.0, -PI, 0.0)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip") and not skipped:
		skipped = true
		if skip_animation.current_animation_position < 3.25:
			skip_animation.seek(3.25, true)
			skip_animation.play_section()
		player.fade_and_change_scene("res://game.tscn")
	
	if player.hp <= 0: 
		if player.animation.assigned_animation == "dying":
			if not player.animation.current_animation:
				fade_animation.play_backwards("fade_out")
				player.free()
				player = PlayerScene.instantiate()
				add_child(player)
				player.bullet_speed = 2000.0
				player.max_hp = 500.0
				player.hp = 500.0
				player.global_position = checkpoint
				player.global_rotation = checkpoint_rot
		else:
			player.emit_signal("on_ground")
	
	if barrier1 and not enemiesAlive(range_enemies):
		barrier1.free()
		slide1 = Npc.instantiate()
		add_child(slide1)
		slide1.global_position = Vector3(157.0, 0.0, -154.0)
		slide2 = Npc.instantiate()
		add_child(slide2)
		slide2.global_position = Vector3(213.0, 0.0, -73.0)
		slide2.global_rotation = Vector3(0.0, -90.0, 0.0)
		slide_enemies = [slide1, slide2]
		checkpoint = Vector3(93.0, 0.0, -25.0)
	if not barrier1 and barrier2 and not enemiesAlive(slide_enemies):
		barrier2.free()
		finalnpc = Npc.instantiate()
		finalnpc.enemy_type = "sharpshooter"
		add_child(finalnpc)
		finalnpc.global_position = Vector3(-14.0, 0.0, 197.0)
		finalnpc.global_rotation = Vector3(0.0, 180.0, 0.0)
		final_enemies = [finalnpc]
		checkpoint = Vector3(90.0, 0.0, -222.0)
		checkpoint_rot = Vector3(0.0, -PI/2, 0.0)
	if not barrier2 and finalbarrier and not enemiesAlive(final_enemies):
		finalbarrier.free()
			
func enemiesAlive(enemies: Array) -> int:
	var count: int = 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			if enemy.alive:
				count += 1
	return count
			
func _on_area_1_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area1text_jp if globals.settings_data.language else area1text)

func _on_area_2_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area2text_jp if globals.settings_data.language else area2text)

func _on_area_3_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area3text_jp if globals.settings_data.language else area3text)

func _on_area_4_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area4text_jp if globals.settings_data.language else area4text)

func _on_area_5_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area5text_jp if globals.settings_data.language else area5text)

func _on_area_6_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue.streamDialogue(area6text_jp if globals.settings_data.language else area6text)
