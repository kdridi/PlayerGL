// https://www.shadertoy.com/view/4dl3zn

#ifdef GL_ES
precision highp float;
#endif

#define PRECALCULATE 0

uniform float time;
uniform vec2 resolution;
uniform int size;

uniform vec3 colors[100];
uniform vec4 bubbles[100];

void main(void) {
	vec2 uv = 2. * gl_FragCoord.xy / resolution.xy - 1.;
	uv.x *= resolution.x / resolution.y;
    
	// background
	vec3 color = vec3(0.8 + 0.2 * uv.y);
    
	// bubbles
	for (int i = 0; i < 3; i++) {
#if PRECALCULATE
        float pha = bubbles[i][0];
        float siz = bubbles[i][1];
        float pox = bubbles[i][2];
        float rad = bubbles[i][3];
        
        vec3 col = colors[i];
#else
        float pha =     sin(float(i) * 548.13 + 1.0) * 0.5 + 0.5;
        float siz =     sin(float(i) * 851.15 + 5.0) * 0.5 + 0.5;
        float pox =     sin(float(i) * 322.55 + 4.1) * resolution.x / resolution.y;
        float rad = 0.05 + 0.25 * siz;
        
        vec3 col = mix(vec3(0.94, 0.3, 0.0), vec3(0.1, 0.4, 0.8), 0.5 + 0.5 * sin(float(i) * 1.2 + 1.9));
#endif
        
        float v1 =  -1.0 - rad;
        float v2 =  2.0 + 2.0 * rad;
        float v3 =  0.1 + 0.9 * siz;
        float v4 = rad * 0.95;
		// bubble seeds
        
		// buble size, position and color
		vec2 pos = vec2(pox, v1 + v2 * mod(pha + 0.1 * time * v3, 1.0));
		float dis = length(uv - pos);
		col += 8.0 * smoothstep(v4, rad, dis);
        
		// render
		float f = length(uv - pos) / rad;
		f = sqrt(clamp(1.0 - f * f, 0.0, 1.0));
		color -= col.zyx * (1.0 - smoothstep(rad * 0.95, rad, dis)) * f;
	}
    
	// vigneting
	color *= sqrt(1.5 - 0.5 * length(uv));
    
	gl_FragColor = vec4(color, 1.0);
}