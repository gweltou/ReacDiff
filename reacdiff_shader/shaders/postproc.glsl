#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif


#define PROCESSING_COLOR_SHADER


uniform vec2 u_resolution;
uniform vec2 u_smooth;
uniform sampler2D scene;
//uniform sampler2D gradient;


void main() {
    vec2 position = gl_FragCoord.xy / u_resolution.xy;
    float b = texture2D(scene, position).b;
	vec3 color = vec3(smoothstep(u_smooth.x, u_smooth.y, b));
	gl_FragColor = vec4(color, 1.);
}
