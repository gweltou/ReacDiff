#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif


#define PROCESSING_COLOR_SHADER


uniform vec2 u_resolution;
uniform vec2 u_smooth;
uniform sampler2D scene;


void main() {
    vec2 position = gl_FragCoord.xy / u_resolution.xy;
	vec3 color = vec3(smoothstep(u_smooth.x, u_smooth.y, texture2D(scene, position).b));
	gl_FragColor = vec4(color, 1.);
}
