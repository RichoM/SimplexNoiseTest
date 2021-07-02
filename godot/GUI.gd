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


var planet_material : Material

func _ready():
	planet_material = get_node(planet).get_surface_material(0)
	update()
	
func update():
	var noise_sampler = planet_material.get("shader_param/noise_sampler")
	var noise = noise_sampler.get("noise")
	get_node(seed_input).text = str(noise.get("seed"))
	
	(get_node(water_threshold) as HSlider).value = planet_material.get("shader_param/water_threshold")
	(get_node(water_color) as ColorPickerButton).color = planet_material.get("shader_param/water")
	(get_node(beach_threshold) as HSlider).value = planet_material.get("shader_param/beach_threshold")
	(get_node(beach_color) as ColorPickerButton).color = planet_material.get("shader_param/beach")
	(get_node(forest_threshold) as HSlider).value = planet_material.get("shader_param/forest_threshold")
	(get_node(forest_color) as ColorPickerButton).color = planet_material.get("shader_param/forest")
	(get_node(mountain_threshold) as HSlider).value = planet_material.get("shader_param/mountain_threshold")
	(get_node(mountain_color) as ColorPickerButton).color = planet_material.get("shader_param/mountain")
	(get_node(snow_threshold) as HSlider).value = planet_material.get("shader_param/snow_threshold")
	(get_node(snow_color) as ColorPickerButton).color = planet_material.get("shader_param/snow")
	
	
func _on_seed_text_entered(new_text):
	print(new_text as int)
	var value = new_text as int
	
	var noise_sampler = planet_material.get("shader_param/noise_sampler")
	var noise = noise_sampler.get("noise")
	noise.set("seed", value)


func _on_water_threshold_value_changed(value):
	planet_material.set("shader_param/water_threshold", value)


func _on_water_color_changed(color):
	planet_material.set("shader_param/water", color)


func _on_beach_threshold_value_changed(value):
	planet_material.set("shader_param/beach_threshold", value)


func _on_beach_color_changed(color):
	planet_material.set("shader_param/beach", color)


func _on_forest_threshold_value_changed(value):
	planet_material.set("shader_param/forest_threshold", value)


func _on_forest_color_changed(color):
	planet_material.set("shader_param/forest", color)


func _on_mountain_threshold_value_changed(value):
	planet_material.set("shader_param/mountain_threshold", value)


func _on_mountain_color_changed(color):
	planet_material.set("shader_param/mountain", color)


func _on_snow_threshold_value_changed(value):
	planet_material.set("shader_param/snow_threshold", value)


func _on_show_color_changed(color):
	planet_material.set("shader_param/snow", color)
