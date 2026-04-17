extends Node2D

@onready var hud: Control = $"../Control"

var tile_controllers: Array = []
var _elapsed := 0.0
var gen: int = 0
var _thread := Thread.new()
var _computing := false

func register(controller: Area2D) -> void:
	tile_controllers.append(controller)


func reset_gen_count() -> void:
	gen = 0
	hud.gen_count_label.text = str(gen)


func _ready() -> void:
	reset_gen_count()
	PlayState.speed = float(hud.h_slider.value)
	get_tree().auto_accept_quit = false


func _process(delta: float) -> void:
	PlayState.speed = float(hud.h_slider.value)
	
	if not PlayState.is_playing:
		return
		
	_elapsed += delta
	if _elapsed >= 1.0 / PlayState.speed:
		_elapsed = 0.0
		_step()


func _step() -> void:
	if _computing:
		return
	_computing = true
	if _thread.is_started():
		_thread.wait_to_finish()
	_thread.start(_compute_all)


func _apply_all() -> void:
	for tile in tile_controllers:
		tile.apply_next_state()
	gen += 1
	hud.gen_count_label.text = str(format_with_commas(gen))
	_thread.wait_to_finish()
	_computing = false


func _compute_all() -> void:
	for tile in tile_controllers:
		tile.compute_next_state()
	call_deferred("_apply_all")


func _clear_all() -> void:
	for tile in tile_controllers:
		tile.clear_tile()


func format_with_commas(number: int) -> String:
	var n_str: String = str(abs(number))
	var res: String = ""
	
	for i in range(n_str.length()):
		if i > 0 and (n_str.length() - i) % 3 == 0:
			res += ","
		res += n_str[i]
		
	return ("-" if number < 0 else "") + res


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_begin_cleanup()
		get_tree().quit()


func _begin_cleanup() -> void:
	for child in get_children():
		child.queue_free()
