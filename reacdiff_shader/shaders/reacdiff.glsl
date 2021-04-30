#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif


#define PROCESSING_COLOR_SHADER

#define PI 3.141592653589793
#define TWOPI 2.0 * PI


uniform vec2 u_resolution;
uniform vec2 mouse;
uniform bool spawn;
uniform float u_feedA;
uniform float u_killB;
uniform float u_diffA;
uniform float u_diffB;
uniform sampler2D scene;
uniform int u_mode;
uniform int u_npoint;
uniform float u_size;


void main() {
    vec2 position = gl_FragCoord.xy / u_resolution.xy;

    vec2 pixel = 1.0/u_resolution;
    

    float A = texture2D(scene, position).b;
    float B = texture2D(scene, position).r;
    
    float neighbourA = 0.;
    neighbourA += 0.05 * texture2D(scene, position + pixel * vec2(-1., -1.)).b;
	neighbourA += 0.2 * texture2D(scene, position + pixel * vec2(-1., 0.)).b;
	neighbourA += 0.05 * texture2D(scene, position + pixel * vec2(-1., 1.)).b;
	neighbourA += 0.05 * texture2D(scene, position + pixel * vec2(1., -1.)).b;
	neighbourA += 0.2 * texture2D(scene, position + pixel * vec2(1., 0.)).b;
	neighbourA += 0.05 * texture2D(scene, position + pixel * vec2(1., 1.)).b;
	neighbourA += 0.2 * texture2D(scene, position + pixel * vec2(0., -1.)).b;
	neighbourA += 0.2 * texture2D(scene, position + pixel * vec2(0., 1.)).b;
	
	float nextA = A + u_diffA * (neighbourA - A) + u_feedA * (1. - A) - A * B * B;
	    
	float neighbourB = 0.;
	neighbourB += 0.05 * texture2D(scene, position + pixel * vec2(-1., -1.)).r;
	neighbourB += 0.2 * texture2D(scene, position + pixel * vec2(-1., 0.)).r;
	neighbourB += 0.05 * texture2D(scene, position + pixel * vec2(-1., 1.)).r;
	neighbourB += 0.05 * texture2D(scene, position + pixel * vec2(1., -1.)).r;
	neighbourB += 0.2 * texture2D(scene, position + pixel * vec2(1., 0.)).r;
	neighbourB += 0.05 * texture2D(scene, position + pixel * vec2(1., 1.)).r;
	neighbourB += 0.2 * texture2D(scene, position + pixel * vec2(0., -1.)).r;
	neighbourB += 0.2 * texture2D(scene, position + pixel * vec2(0., 1.)).r;
	
	float nextB = B + u_diffB * (neighbourB - B) - B * (u_killB + u_feedA) + A * B * B;
	
	
	if (spawn) {
	    float ratio = u_resolution.x / u_resolution.y;
	    
	    switch(u_mode) {
	        case 0: // Unique point
                vec2 pToM = position - mouse;
                pToM.x *= ratio;
	            if (length(pToM) < u_size) nextB = 1.;
	            break;
	        case 1: // Vertical axe symmetry
	            pToM = position - mouse;
                pToM.x *= ratio;
                vec2 pToM2 = vec2(1 - position.x, position.y) - mouse;
                pToM2.x *= ratio;
	            if (length(pToM) < u_size || length(pToM2) < u_size)
	                nextB = 1.;
	            break;
	        case 2:
	            float mDistToCenter = length(vec2((mouse.x - 0.5) * ratio, mouse.y - 0.5));
	            float angle = atan(mouse.y - 0.5, (mouse.x - 0.5) * ratio);
	            for (int i=0; i<u_npoint; i++) {
	                vec2 point = vec2(cos(angle) / ratio, sin(angle)) * mDistToCenter + 0.5;
                    vec2 pToM = position - point;
                    pToM.x *= ratio;
	                if (length(pToM) < u_size) {
		                nextB = 1.;
	                }
	                angle += TWOPI / u_npoint;
	            }
	            break;
	    }
	}
	
	gl_FragColor = vec4(nextB, 0., nextA, 1.);
}
