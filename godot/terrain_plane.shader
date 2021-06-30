shader_type spatial;

uniform vec2 offset;
uniform vec4 water : hint_color;
uniform vec4 beach : hint_color;
uniform vec4 forest : hint_color;
uniform vec4 mountain : hint_color;
uniform vec4 snow : hint_color;
uniform sampler2D noise_sampler;

uniform float water_threshold = 0.0;
uniform float beach_threshold = 0.5;
uniform float forest_threshold = 0.53;
uniform float mountain_threshold = 0.6;
uniform float snow_threshold = 0.65;

void vertex() {
	UV += offset;
	vec4 noise = texture(noise_sampler, UV);
	
	if (noise.r > snow_threshold) {
		VERTEX.y += (noise.r - beach_threshold) * 3.0;
	} else if (noise.r > mountain_threshold) {
		VERTEX.y += (noise.r - beach_threshold) * 2.0;
	} else if (noise.r > forest_threshold) {
		VERTEX.y += (noise.r - beach_threshold) * 1.15;
	} else if (noise.r > beach_threshold) {
		VERTEX.y += (noise.r - beach_threshold) * 1.05;
	}
}

void fragment() {
	vec4 noise = texture(noise_sampler, UV);
	vec4 color = vec4(1.0);
	if (noise.x > snow_threshold) {
		color = snow;
	} else if (noise.x > mountain_threshold) {
		color = mountain;
	} else if (noise.x > forest_threshold) {
		color = forest;
	} else if (noise.x > beach_threshold) {
		color = beach;
	} else if (noise.x > water_threshold) {
		color = water;
	}
	ALBEDO = noise.rgb * color.rgb;
}
