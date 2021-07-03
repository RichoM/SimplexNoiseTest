extends Control

export var planet : NodePath
export var seed_input : NodePath
export var water_threshold : NodePath
export var water_color : NodePath
export var beach_threshold : NodePath
export var beach_color : NodePath
export var forest_threshold : NodePath
export var forest_color : NodePath
export var mountain_threshold : NodePath
export var mountain_color : NodePath
export var snow_threshold : NodePath
export var snow_color : NodePath

var initial_values = {}


var planet_material : Material

func _ready():
	planet_material = get_node(planet).get_surface_material(0)
	collect_initial_values()
	update()
	
func collect_initial_values():
	initial_values["seed"] = get_seed()
	
	initial_values["water.threshold"] = get_terrain_threshold("water")
	initial_values["beach.threshold"] = get_terrain_threshold("beach")
	initial_values["forest.threshold"] = get_terrain_threshold("forest")
	initial_values["mountain.threshold"] = get_terrain_threshold("mountain")
	initial_values["snow.threshold"] = get_terrain_threshold("snow")
	
	initial_values["water.color"] = get_terrain_color("water")
	initial_values["beach.color"] = get_terrain_color("beach")
	initial_values["forest.color"] = get_terrain_color("forest")
	initial_values["mountain.color"] = get_terrain_color("mountain")
	initial_values["snow.color"] = get_terrain_color("snow")
	
func update():
	(get_node(seed_input) as LineEdit).text = str(get_seed())
	
	(get_node(water_threshold) as HSlider).value = get_terrain_threshold("water")
	(get_node(beach_threshold) as HSlider).value = get_terrain_threshold("beach")
	(get_node(forest_threshold) as HSlider).value = get_terrain_threshold("forest")
	(get_node(mountain_threshold) as HSlider).value = get_terrain_threshold("mountain")
	(get_node(snow_threshold) as HSlider).value = get_terrain_threshold("snow")
	
	(get_node(water_color) as ColorPickerButton).color = get_terrain_color("water")
	(get_node(beach_color) as ColorPickerButton).color = get_terrain_color("beach")
	(get_node(forest_color) as ColorPickerButton).color = get_terrain_color("forest")
	(get_node(mountain_color) as ColorPickerButton).color = get_terrain_color("mountain")
	(get_node(snow_color) as ColorPickerButton).color = get_terrain_color("snow")

func get_seed():
	var noise_sampler = planet_material.get("shader_param/noise_sampler")
	var noise = noise_sampler.get("noise")
	return noise.get("seed")
	
func set_seed(value):	
	var noise_sampler = planet_material.get("shader_param/noise_sampler")
	var noise = noise_sampler.get("noise")
	noise.set("seed", value)
	

func get_terrain_threshold(terrain : String):
	return planet_material.get("shader_param/" + terrain + "_threshold")

func set_terrain_threshold(terrain : String, value):
	planet_material.set("shader_param/" + terrain + "_threshold", value)


func get_terrain_color(terrain : String):
	return planet_material.get("shader_param/" + terrain)

func set_terrain_color(terrain : String, value):
	planet_material.set("shader_param/" + terrain, value)
	
	
func _on_seed_text_entered(new_text):
	print(new_text as int)
	var value = new_text as int
	set_seed(value)
	(get_node(seed_input) as LineEdit).text = str(value)


func _on_seed_focus_exited():
	var value = (get_node(seed_input) as LineEdit).text as int
	if value != get_seed():
		set_seed(value)
	(get_node(seed_input) as LineEdit).text = str(value)
	

func _on_water_threshold_value_changed(value):
	set_terrain_threshold("water", value)

func _on_water_color_changed(color):
	set_terrain_color("water", color)


func _on_beach_threshold_value_changed(value):
	set_terrain_threshold("beach", value)

func _on_beach_color_changed(color):
	set_terrain_color("beach", color)


func _on_forest_threshold_value_changed(value):
	set_terrain_threshold("forest", value)

func _on_forest_color_changed(color):
	set_terrain_color("forest", color)


func _on_mountain_threshold_value_changed(value):
	set_terrain_threshold("mountain", value)

func _on_mountain_color_changed(color):
	set_terrain_color("mountain", color)


func _on_snow_threshold_value_changed(value):
	set_terrain_threshold("snow", value)

func _on_snow_color_changed(color):
	set_terrain_color("snow", color)


func _on_reset_button_pressed():
	set_seed(initial_values["seed"])
	
	set_terrain_threshold("water", initial_values["water.threshold"])
	set_terrain_threshold("beach", initial_values["beach.threshold"])
	set_terrain_threshold("forest", initial_values["forest.threshold"])
	set_terrain_threshold("mountain", initial_values["mountain.threshold"])
	set_terrain_threshold("snow", initial_values["snow.threshold"])
	
	set_terrain_color("water", initial_values["water.color"])
	set_terrain_color("beach", initial_values["beach.color"])
	set_terrain_color("forest", initial_values["forest.color"])
	set_terrain_color("mountain", initial_values["mountain.color"])
	set_terrain_color("snow", initial_values["snow.color"])

