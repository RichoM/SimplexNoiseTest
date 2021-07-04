shader_type spatial;

uniform vec2 offset;

uniform float elevation;

uniform vec4 base : hint_color;
uniform vec4 water : hint_color;
uniform vec4 beach : hint_color;
uniform vec4 forest : hint_color;
uniform vec4 mountain : hint_color;
uniform vec4 snow : hint_color;
uniform vec4 poles : hint_color;
uniform sampler2D noise_sampler : hint_albedo;
uniform sampler2D noise_normal : hint_normal;

uniform float water_threshold = 0.0;
uniform float beach_threshold = 0.5;
uniform float forest_threshold = 0.53;
uniform float mountain_threshold = 0.6;
uniform float snow_threshold = 0.65;
uniform float poles_threshold = 0.2;

vec3 move(vec3 pt, float disp) {
	float x = pt.x;
	float y = pt.y;
	float z = pt.z;
	
	float r = sqrt(x*x + y*y + z*z);
	float i = acos(z/r);
	float a = atan(y, x);
	
	r += disp;
	pt.x = r * cos(a) * sin(i);
	pt.y = r * sin(a) * sin(i);
	pt.z = r * cos(i);
	return pt;
}

void vertex() {
	UV += offset;
	vec4 noise = texture(noise_sampler, UV);
	
	float disp = 0.0;
	if (noise.r > snow_threshold) {
		disp = noise.r * 0.3;
	} else if (noise.r > mountain_threshold) {
		disp = noise.r * 0.2;
	} else if (noise.r > forest_threshold) {
		disp = noise.r * 0.1;
	} else if (noise.r > beach_threshold) {
		disp = noise.r * 0.05;
	} else if (noise.r > water_threshold) {
		disp = noise.r * 0.0;
	} else {
		disp = noise.r * -0.1;
	}
	
	
	if (UV.y < noise.x * poles_threshold || UV.y > 1.0 - noise.x * poles_threshold) {
		//disp = 0.015 * UV.y + 0.055;
		disp += .075;
		disp = min(disp, 0.15);
	}
	
	disp *= elevation;
	VERTEX = move(VERTEX, disp);
}


void fragment() {
	vec4 noise = texture(noise_sampler, UV);
	if (UV.y < noise.x * poles_threshold || UV.y > 1.0 - noise.x * poles_threshold) {// Poles
		NORMALMAP = texture(noise_normal, UV).rgb;
		NORMALMAP_DEPTH = 5.5;
		ROUGHNESS = 0.75;
		EMISSION = vec3(0.2);
		ALBEDO = noise.rgb * poles.rgb ;
	} else {
		vec4 color = base;
		if (noise.x > water_threshold && noise.x < beach_threshold) { // Water
			color = water;
			ROUGHNESS = 0.001;
			EMISSION = vec3(0.01, 0.01, 0.1);
			METALLIC = 1.0;
			
			NORMALMAP = texture(noise_sampler, UV + (TIME * .01)).rgb;
			NORMALMAP_DEPTH = .5;
		} else { // Land
			
			NORMALMAP = texture(noise_normal, UV).rgb;
			NORMALMAP_DEPTH = 11.5;
			ROUGHNESS = 0.75;
			if (noise.x > snow_threshold) {
				color = snow;
				NORMALMAP_DEPTH = 5.5;
				EMISSION = vec3(0.2);
			} else if (noise.x > mountain_threshold) {
				color = mountain;
				METALLIC = 0.5;
			} else if (noise.x > forest_threshold) {
				color = forest;
			} else if (noise.x > beach_threshold) {
				color = beach;
				NORMALMAP_DEPTH = 2.5;
			}
			
		}
		
		ALBEDO = noise.rgb * color.rgb;
	}
}
