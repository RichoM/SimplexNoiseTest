extends Control

# TODO(Richo): All this code sucks, I should build the GUI dynamically...
export var planet : NodePath
export var seed_input : NodePath
export var octaves_input : NodePath
export var period_input : NodePath
export var persistence_input : NodePath
export var lacunarity_input : NodePath
export var elevation_slider : NodePath
export var base_color : NodePath
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
export var poles_threshold : NodePath
export var poles_color : NodePath

var initial_values = {}

var planet_material : Material
var noise : OpenSimplexNoise

func _ready():
	planet_material = get_node(planet).get_surface_material(0)
	noise = planet_material.get("shader_param/noise_sampler").get("noise")
	collect_initial_values()
	update()
	
func collect_initial_values():
	initial_values["seed"] = get_noise_param("seed")
	initial_values["octaves"] = get_noise_param("octaves")
	initial_values["period"] = get_noise_param("period")
	initial_values["persistence"] = get_noise_param("persistence")
	initial_values["lacunarity"] = get_noise_param("lacunarity")
	initial_values["elevation"] = get_elevation()
	
	initial_values["water.threshold"] = get_terrain_threshold("water")
	initial_values["beach.threshold"] = get_terrain_threshold("beach")
	initial_values["forest.threshold"] = get_terrain_threshold("forest")
	initial_values["mountain.threshold"] = get_terrain_threshold("mountain")
	initial_values["snow.threshold"] = get_terrain_threshold("snow")
	initial_values["poles.threshold"] = get_terrain_threshold("poles")
	
	initial_values["base.color"] = get_terrain_color("base")
	initial_values["water.color"] = get_terrain_color("water")
	initial_values["beach.color"] = get_terrain_color("beach")
	initial_values["forest.color"] = get_terrain_color("forest")
	initial_values["mountain.color"] = get_terrain_color("mountain")
	initial_values["snow.color"] = get_terrain_color("snow")
	initial_values["poles.color"] = get_terrain_color("poles")
	
func update():
	(get_node(seed_input) as LineEdit).text = str(get_noise_param("seed"))
	(get_node(octaves_input) as LineEdit).text = str(get_noise_param("octaves"))
	(get_node(period_input) as LineEdit).text = str(get_noise_param("period"))
	(get_node(persistence_input) as LineEdit).text = str(get_noise_param("persistence"))
	(get_node(lacunarity_input) as LineEdit).text = str(get_noise_param("lacunarity"))
	(get_node(elevation_slider) as HSlider).value = get_elevation()
	
	(get_node(water_threshold) as HSlider).value = get_terrain_threshold("water")
	(get_node(beach_threshold) as HSlider).value = get_terrain_threshold("beach")
	(get_node(forest_threshold) as HSlider).value = get_terrain_threshold("forest")
	(get_node(mountain_threshold) as HSlider).value = get_terrain_threshold("mountain")
	(get_node(snow_threshold) as HSlider).value = get_terrain_threshold("snow")
	(get_node(poles_threshold) as HSlider).value = get_terrain_threshold("poles")
	
	(get_node(base_color) as ColorPickerButton).color = get_terrain_color("base")
	(get_node(water_color) as ColorPickerButton).color = get_terrain_color("water")
	(get_node(beach_color) as ColorPickerButton).color = get_terrain_color("beach")
	(get_node(forest_color) as ColorPickerButton).color = get_terrain_color("forest")
	(get_node(mountain_color) as ColorPickerButton).color = get_terrain_color("mountain")
	(get_node(snow_color) as ColorPickerButton).color = get_terrain_color("snow")
	(get_node(poles_color) as ColorPickerButton).color = get_terrain_color("poles")

func get_noise_param(name : String):
	return noise.get(name)
	
func set_noise_param(name : String, value):
	if value != noise.get(name):
		noise.set(name, value)
	
	
func get_elevation():
	return planet_material.get("shader_param/elevation")

func set_elevation(value):
	planet_material.set("shader_param/elevation", value)

func get_terrain_threshold(terrain : String):
	return planet_material.get("shader_param/" + terrain + "_threshold")

func set_terrain_threshold(terrain : String, value):
	planet_material.set("shader_param/" + terrain + "_threshold", value)


func get_terrain_color(terrain : String):
	return planet_material.get("shader_param/" + terrain)

func set_terrain_color(terrain : String, value):
	planet_material.set("shader_param/" + terrain, value)


func _on_reset_button_pressed():
	set_noise_param("seed", initial_values["seed"])
	set_noise_param("octaves", initial_values["octaves"])
	set_noise_param("period", initial_values["period"])
	set_noise_param("persistence", initial_values["persistence"])
	set_noise_param("lacunarity", initial_values["lacunarity"])
	set_elevation(initial_values["elevation"])
	
	set_terrain_threshold("water", initial_values["water.threshold"])
	set_terrain_threshold("beach", initial_values["beach.threshold"])
	set_terrain_threshold("forest", initial_values["forest.threshold"])
	set_terrain_threshold("mountain", initial_values["mountain.threshold"])
	set_terrain_threshold("snow", initial_values["snow.threshold"])
	set_terrain_threshold("poles", initial_values["poles.threshold"])
	
	set_terrain_color("base", initial_values["base.color"])
	set_terrain_color("water", initial_values["water.color"])
	set_terrain_color("beach", initial_values["beach.color"])
	set_terrain_color("forest", initial_values["forest.color"])
	set_terrain_color("mountain", initial_values["mountain.color"])
	set_terrain_color("snow", initial_values["snow.color"])
	set_terrain_color("poles", initial_values["poles.color"])
	update()
	
func _on_seed_text_entered(new_text):
	var value = new_text as int
	set_noise_param("seed", value)
	(get_node(seed_input) as LineEdit).text = str(value)


func _on_seed_focus_exited():
	var value = (get_node(seed_input) as LineEdit).text as int
	set_noise_param("seed", value)
	(get_node(seed_input) as LineEdit).text = str(value)
	
	

func _on_elevation_slider_value_changed(value):
	set_elevation(value)
	


func _on_base_color_color_changed(color):
	set_terrain_color("base", color)
	

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
	

func _on_poles_threshold_value_changed(value):
	set_terrain_threshold("poles", value)

func _on_poles_color_changed(color):
	set_terrain_color("poles", color)


func _on_octaves_text_entered(new_text):
	var value = new_text as int
	if value < 1: value = 1
	elif value > 8: value = 8
	set_noise_param("octaves", value)
	(get_node(octaves_input) as LineEdit).text = str(value)

func _on_octaves_focus_exited():
	var value = (get_node(octaves_input) as LineEdit).text as int
	if value < 1: value = 1
	elif value > 8: value = 8
	set_noise_param("octaves", value)
	(get_node(octaves_input) as LineEdit).text = str(value)

func _on_period_text_entered(new_text):
	var value = new_text as float
	set_noise_param("period", value)
	(get_node(period_input) as LineEdit).text = str(value)

func _on_period_focus_exited():
	var value = (get_node(period_input) as LineEdit).text as float
	set_noise_param("period", value)
	(get_node(period_input) as LineEdit).text = str(value)


func _on_persistence_text_entered(new_text):
	var value = new_text as float
	set_noise_param("persistence", value)
	(get_node(persistence_input) as LineEdit).text = str(value)

func _on_persistence_focus_exited():
	var value = (get_node(persistence_input) as LineEdit).text as float
	set_noise_param("persistence", value)
	(get_node(persistence_input) as LineEdit).text = str(value)


func _on_lacunarity_text_entered(new_text):
	var value = new_text as float
	set_noise_param("lacunarity", value)
	(get_node(lacunarity_input) as LineEdit).text = str(value)

func _on_lacunarity_focus_exited():
	var value = (get_node(lacunarity_input) as LineEdit).text as float
	set_noise_param("lacunarity", value)
	(get_node(lacunarity_input) as LineEdit).text = str(value)

