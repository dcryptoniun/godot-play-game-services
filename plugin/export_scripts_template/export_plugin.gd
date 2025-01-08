@tool
extends EditorPlugin

const PLUGIN_AUTOLOAD := &"GodotPlayGameServices"

const SIGN_IN_CLIENT_CUSTOM_TYPE := &"PlayGamesSignInClient"
const ACHIEVEMENTS_CLIENT_CUSTOM_TYPE := &"PlayGamesAchievementsClient"
const LEADERBOARDS_CLIENT_CUSTOM_TYPE := &"PlayGamesLeaderboardsClient"
const PLAYERS_CLIENT_CUSTOM_TYPE := &"PlayGamesPlayersClient"
const SNAPSHOTS_CLIENT_CUSTOM_TYPE := &"PlayGamesSnapshotsClient"
const EVENTS_CLIENT_CUSTOM_TYPE := &"PlayGamesEventsClient"

var _export_plugin : AndroidExportPlugin
var _dock : Node

func _enter_tree() -> void:
	_add_custom_types()
	_add_plugin()
	_add_docks()
	_add_autoloads()

func _exit_tree() -> void:
	_remove_plugin()
	_remove_docks()
	_remove_autoloads()
	_remove_custom_types()

func _add_custom_types() -> void:
	add_custom_type(SIGN_IN_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/sign_in/sign_in_client.gd"), null)
	add_custom_type(ACHIEVEMENTS_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/achievements/achievements_client.gd"), null)
	add_custom_type(LEADERBOARDS_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/leaderboards/leaderboards_client.gd"), null)
	add_custom_type(PLAYERS_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/players/players_client.gd"), null)
	add_custom_type(SNAPSHOTS_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/snapshots/snapshots_client.gd"), null)
	add_custom_type(EVENTS_CLIENT_CUSTOM_TYPE, "Node", preload("res://addons/GodotPlayGameServices/scripts/events/events_client.gd"), null)

func _remove_custom_types() -> void:
	remove_custom_type(EVENTS_CLIENT_CUSTOM_TYPE)
	remove_custom_type(SNAPSHOTS_CLIENT_CUSTOM_TYPE)
	remove_custom_type(PLAYERS_CLIENT_CUSTOM_TYPE)
	remove_custom_type(LEADERBOARDS_CLIENT_CUSTOM_TYPE)
	remove_custom_type(ACHIEVEMENTS_CLIENT_CUSTOM_TYPE)
	remove_custom_type(SIGN_IN_CLIENT_CUSTOM_TYPE)

func _add_plugin() -> void:
	_export_plugin = AndroidExportPlugin.new()
	add_export_plugin(_export_plugin)

func _remove_plugin() -> void:
	remove_export_plugin(_export_plugin)
	_export_plugin = null

func _add_docks() -> void:
	var dock_name := &"Godot Play Game Services"
	_dock = preload("res://addons/GodotPlayGameServices/godot_play_game_services_dock.tscn").instantiate()
	add_control_to_bottom_panel(_dock, dock_name)

func _remove_docks() -> void:
	remove_control_from_bottom_panel(_dock)
	_dock.free()

func _add_autoloads() -> void:
	add_autoload_singleton(PLUGIN_AUTOLOAD, "res://addons/GodotPlayGameServices/scripts/autoloads/godot_play_game_services.gd")

func _remove_autoloads() -> void:
	remove_autoload_singleton(PLUGIN_AUTOLOAD)

class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = &"GodotPlayGameServices"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray([_plugin_name + "/bin/debug/" + _plugin_name + "-debug.aar"])
		else:
			return PackedStringArray([_plugin_name + "/bin/release/" + _plugin_name + "-release.aar"])
	
	func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		if not _supports_platform(platform):
			return PackedStringArray()
		
		return PackedStringArray([
			"com.google.code.gson:gson:2.11.0", 
			"com.google.android.gms:play-services-games-v2:20.1.2"
			])
	
	func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
		if not _supports_platform(platform):
			return ""
		
		return "<meta-data android:name=\"com.google.android.gms.games.APP_ID\" android:value=\"@string/game_services_project_id\"/>"

	func _get_name():
		return _plugin_name
