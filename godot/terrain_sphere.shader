shader_type spatial;

uniform vec2 offset;
uniform vec4 water : hint_color;
uniform vec4 beach : hint_color;
uniform vec4 forest : hint_color;
uniform vec4 mountain : hint_color;
uniform vec4 snow : hint_color;
uniform sampler2D noise_sampler;
uniform sampler2D noise_normal;

uniform float water_threshold = 0.0;
uniform float beach_threshold = 0.5;
uniform float forest_threshold = 0.53;
uniform float mountain_threshold = 0.6;
uniform float snow_threshold = 0.65;

void vertex() {
	UV += offset;
	vec4 noise = texture(noise_sampler, UV);
	
	float disp = 0.0;
	if (noise.r > snow_threshold) {
		disp = (noise.r - beach_threshold) * 1.7;
	} else if (noise.r > mountain_threshold) {
		disp = (noise.r - beach_threshold) * 1.25;
	} else if (noise.r > forest_threshold) {
		disp = (noise.r - beach_threshold) * 1.15;
	} else if (noise.r > beach_threshold) {
		disp = (noise.r - beach_threshold) * 1.05;
	}
	
	if (UV.y < noise.x / 5.0 || UV.y > 1.0 - noise.x / 5.0) {
		// Estamos en los polos
		disp = 0.015 * UV.y + 0.055;
	}
	float x = VERTEX.x;
	float y = VERTEX.y;
	float z = VERTEX.z;
	
	float r = sqrt(x*x + y*y + z*z);
	float i = acos(z/r);
	float a = atan(y, x);
	
	r += disp - 1.0;
	VERTEX.x = r * cos(a) * sin(i);
	VERTEX.y = r * sin(a) * sin(i);
	VERTEX.z = r * cos(i);
	
}


void fragment() {
	
	vec4 noise = texture(noise_sampler, UV);
	
	NORMALMAP = texture(noise_normal, UV).rgb;
	NORMALMAP_DEPTH = 11.5;
	ROUGHNESS = 0.75;
	
	vec4 color = vec4(1.0);
	if (noise.x > snow_threshold) {
		color = snow;
		NORMALMAP_DEPTH = 5.5;
	} else if (noise.x > mountain_threshold) {
		color = mountain;
		METALLIC = 0.5;
	} else if (noise.x > forest_threshold) {
		color = forest;
	} else if (noise.x > beach_threshold) {
		color = beach;
		NORMALMAP_DEPTH = 2.5;
	} else if (noise.x > water_threshold) {
		color = water;
		ROUGHNESS = 0.001;
		EMISSION = vec3(0.01, 0.01, 0.1);
		METALLIC = 1.0;
		
		NORMALMAP = texture(noise_sampler, UV + (TIME * .01)).rgb;
		NORMALMAP_DEPTH = .5;
	}
	ALBEDO = noise.rgb * color.rgb;
	
	noise /= 5.0;
	if (UV.y < noise.x || UV.y > 1.0 - noise.x) 
	{
		ALBEDO = snow.rgb * 0.9;
		NORMALMAP_DEPTH = 11.0;
		NORMALMAP = texture(noise_normal, UV).rgb;
		METALLIC = 0.0;
	}
}
