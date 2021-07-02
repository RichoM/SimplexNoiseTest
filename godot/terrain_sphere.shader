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
		disp = (noise.r - beach_threshold) * 1.7;
	} else if (noise.r > mountain_threshold) {
		disp = (noise.r - beach_threshold) * 1.25;
	} else if (noise.r > forest_threshold) {
		disp = (noise.r - beach_threshold) * 1.15;
	} else if (noise.r > beach_threshold) {
		disp = (noise.r - beach_threshold) * 1.05;
	}
	
	if (UV.y < noise.x / 5.0 || UV.y > 1.0 - noise.x / 5.0) {
		//disp = 0.015 * UV.y + 0.055;
		disp += .075;
		disp = min(disp, 0.15);
	}
	
	VERTEX = move(VERTEX, disp - 1.0);
}


void fragment() {
	vec4 noise = texture(noise_sampler, UV);
	if (UV.y < noise.x/5.0 || UV.y > 1.0 - noise.x/5.0) {// Poles
		
		ALBEDO = snow.rgb * 0.9;
		if (UV.y > 0.5) {
			NORMALMAP_DEPTH = 11.0 * smoothstep(0.25, 0.75, (UV.y*0.450));
		} else {
			NORMALMAP_DEPTH = 11.0 * smoothstep(0.25, 0.75, ((1.0-UV.y)*0.450));
		}
		NORMALMAP = texture(noise_normal, UV).rgb;
		METALLIC = 0.0;
		ROUGHNESS = 0.0;
		EMISSION = vec3(.01);
		
	} else {
		vec4 color = vec4(1.0);
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
