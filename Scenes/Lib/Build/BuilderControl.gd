extends Control


onready var map_parent: Node2D = get_tree().current_scene.get_node("DefaultMap").get_node("Floor")
onready var buildable_areas: Array = get_tree().get_nodes_in_group(Constants.Groups.BUILD_AREA_GROUP)
onready var object_ysort: Node2D = get_tree().current_scene.get_node("ObjectYSort")


var build_mode: bool
var tower_preview: TowerPreview
var tower_type: String


func _unhandled_input(event):
	if build_mode:
		if event.is_action_released("ui_cancel"):
			cancel_build_mode()
		elif event.is_action_released("ui_accept"):
			verify_and_build()
			cancel_build_mode()


func on_build_button_pressed(tower_id: int):
	if build_mode:
		cancel_build_mode()
	build_mode = true

	var tower_instance = TowerManager.get_tower(tower_id)
	tower_instance.set_name("Tower")
	tower_preview = TowerPreview.new(tower_id)
	tower_preview.set_name("TowerPreview")
	tower_preview.add_child(tower_instance, true)
	var game_scene = get_node(@"/root/GameScene")
	game_scene.add_child(tower_preview, true)


func verify_and_build():
	if build_mode and tower_preview.is_buildable():
		var new_tower = TowerManager.get_tower(tower_preview.tower_id)
		new_tower.position = tower_preview.get_current_pos()
		object_ysort.add_child(new_tower, true)

		tower_preview.queue_free()


func cancel_build_mode():
	build_mode = false

	tower_preview.queue_free()
