extends Area2D

const SINGLE_TILE_ALIVE = preload("uid://c6keppd8pj74n")
const SINGLE_TILE_DEAD = preload("uid://glgjfsi5qxr5")
const SINGLE_TILE_HOVER = preload("uid://djljdu5ck3nkp")

const MIN_NEIGHBORS_TO_SURVIVE = 2
const MAX_NEIGHBORS_TO_SURVIVE = 3
const NEIGHBORS_TO_REPRODUCE = 3

@export var dead_sprite: Texture2D = SINGLE_TILE_DEAD
@export var alive_sprite: Texture2D = SINGLE_TILE_ALIVE

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var tile_sprite: Sprite2D = $"../tileSprite"
@onready var hover_over_sprite: Sprite2D = $hoverOverSprite
@onready var tile_area_2d: Area2D = $".."
@onready var tile_controller_area: Area2D = $"."

enum State {DEAD, ALIVE}

var editable := false
var current_state: State = State.DEAD
var next_state: State = State.DEAD
var living_neighbors: int = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if editable:
			DragState.dragging = true
			DragState.paint_state = State.DEAD if current_state == State.ALIVE else State.ALIVE
			_paint()

	if Input.is_action_just_released("left_click"):
		DragState.dragging = false
		DragState.paint_state = -1

	if editable and DragState.dragging and current_state != DragState.paint_state:
		_paint()


func _paint() -> void:
	if DragState.paint_state == State.ALIVE and current_state != State.ALIVE:
		toggle_sprite()
	elif DragState.paint_state == State.DEAD and current_state != State.DEAD:
		toggle_sprite()


func compute_next_state() -> void:
	living_neighbors = _count_living_neighbors()
	match current_state:
		State.DEAD:
			next_state = State.ALIVE if living_neighbors == NEIGHBORS_TO_REPRODUCE else State.DEAD
		State.ALIVE:
			next_state = State.DEAD if living_neighbors < MIN_NEIGHBORS_TO_SURVIVE or living_neighbors > MAX_NEIGHBORS_TO_SURVIVE else State.ALIVE


func apply_next_state() -> void:
	if next_state != current_state:
		toggle_sprite()


func clear_tile() -> void:
	if current_state == State.DEAD:
		return
	toggle_sprite()


func _count_living_neighbors():
	var n := 0
	for tile in tile_area_2d.get_overlapping_areas():
		if 'Controller' in tile.name and tile != self:
			n += tile.current_state
	return n


func _on_mouse_entered() -> void:
	hover_over_sprite.visible = true
	tile_sprite.z_as_relative = false
	tile_sprite.z_index = 3
	hover_over_sprite.z_as_relative = false
	hover_over_sprite.z_index = 4
	editable = true

func _on_mouse_exited() -> void:
	hover_over_sprite.visible = false
	tile_sprite.z_as_relative = false
	tile_sprite.z_index = 1
	hover_over_sprite.z_as_relative = false
	hover_over_sprite.z_index = 2
	editable = false


func toggle_noise(dir: String):
	var pitch = null
	match dir:
		'Up':
			pitch = randf_range(0.9, 1.2)
		'Down':
			pitch = randf_range(0.4, 0.7)
		_:
			pitch = 1.0
		
	audio_stream_player_2d.pitch_scale = pitch
	audio_stream_player_2d.play()


func toggle_sprite() -> void:
	var current_texture = tile_sprite.texture
	if current_texture == dead_sprite:
		toggle_noise('Up')
		tile_sprite.texture = alive_sprite
		current_state = State.ALIVE
		tile_sprite.z_as_relative = false
		tile_sprite.z_index = 3
		bounce_animation(tile_sprite, 0.19, 0.16, 0.12, 0.1)
		bounce_animation(hover_over_sprite, 0.19, 0.16, 0.12, 0.1)
	else:
		toggle_noise('Down')
		current_state = State.DEAD
		tile_sprite.texture = dead_sprite
		tile_sprite.z_as_relative = false
		tile_sprite.z_index = 1


func bounce_animation(tile, start_scale: float, end_scale: float, grow_time: float, shrink_time: float) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(tile, "scale", Vector2(start_scale, start_scale), grow_time)
	tween.tween_property(tile, "scale", Vector2(end_scale, end_scale), shrink_time)
