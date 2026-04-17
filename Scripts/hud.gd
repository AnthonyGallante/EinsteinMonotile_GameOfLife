extends Control

@onready var h_slider: HSlider = $CanvasLayer/Panel/MarginContainer/HSplitContainer/HSlider
@onready var freq_label: Label = $CanvasLayer/Panel/MarginContainer/HSplitContainer/FreqLabel
@onready var tile_manager: Node2D = $"../TileManager"
@onready var gen_count_label: Label = $CanvasLayer/Panel/MarginContainer/HSplitContainer/VBoxContainer/GenCountLabel
@onready var play_button: Button = $CanvasLayer/Panel/MarginContainer/HSplitContainer/HBoxContainer/PlayButton
@onready var info_panel: Panel = $CanvasLayer2/InfoPanel

const PAUSE = preload("uid://c8lrrydk3jb73")
const RIGHT = preload("uid://obltg050p4w4")


func _process(_delta: float) -> void:
	freq_label.text = str(int(h_slider.value))


func _ready() -> void:
	info_panel.visible = false


func _on_play_button_pressed() -> void:
	if PlayState.is_playing:
		PlayState.is_playing = false
		play_button.icon = RIGHT
		play_button.text = 'Play'
	else:
		PlayState.is_playing = true
		play_button.icon = PAUSE
		play_button.text = 'Pause'


func _on_step_button_pressed() -> void:
	tile_manager._step()


func _on_h_slider_changed() -> void:
	PlayState.speed = float(h_slider.value)


func _on_clear_button_pressed() -> void:
	tile_manager._clear_all()
	tile_manager.reset_gen_count()


func _on_info_button_pressed() -> void:
	info_panel.visible = not info_panel.visible
