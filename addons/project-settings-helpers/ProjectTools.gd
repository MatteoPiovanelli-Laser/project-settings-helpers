tool
class_name ProjectTools
extends Reference
# author: willnationsdev & jeremi360
# license: MIT
# description: A utility for any features useful in the context of a Godot Project.

const conf_path := "res://addons.cfg"

static func set_setting(p_name: String, p_default_value, p_pinfo: PropertyInfo) -> void:
	p_pinfo.name = p_name
	if not ProjectSettings.has_setting(p_name):
		ProjectSettings.set_setting(p_name, p_default_value)

	ProjectSettings.add_property_info(p_pinfo.to_dict())
	ProjectSettings.set_initial_value(p_name, p_default_value)
	save_to_config(p_name[1], p_default_value)

static func set_settings_dict(settings_dict:Dictionary) -> void:
	for property_key in settings_dict.keys():
		var property_value = settings_dict[property_key]
		set_setting(property_key, property_value[0], property_value[1])

static func set_settings_order(properties: Array, p_order: int) -> void:
	for p in properties:
		ProjectSettings.set_order(p, p_order)
		p_order += 1

static func get_addon_setting(p_name: String):
	if Engine.editor_hint:
		var setting = ProjectSettings.get_setting(p_name)
		save_to_config(p_name, setting)
		return setting
	else:
		return load_from_config(p_name)

static func save_to_config(setting_path:String, value:String) -> void:
	var config = ConfigFile.new()
	var f = File.new()
	if f.file_exists(conf_path):
		config.load(conf_path)
	
	var p_conf = setting_path.split("/")
	if len(p_conf) == 2:
		config.set_value(p_conf[1], p_conf[2], value)
	else:
		config.set_value("", setting_path, value)
	config.save(conf_path)

static func load_from_config(setting_path:String) -> String:
	var config = ConfigFile.new()
	config.load(conf_path)
	var p_conf = setting_path.split("/")
	if len(p_conf) == 2:
		return config.get_value(p_conf[1], p_conf[2])
	else:
		return config.get_value("", setting_path)