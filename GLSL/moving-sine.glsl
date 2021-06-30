#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14

vec3 bgColorDown = vec3(0.2, 0.1, 0.1);
vec3 bgColorUp = vec3(0.1, 0.1, 0.2);

vec3 P1ColorIn = vec3(1.0, 0.5, 0.0);
vec3 P1ColorOut = vec3(1.0, 0.0, 0.0);

vec3 P2ColorIn = vec3(0.0, 0.5, 1.0);  //vec3(1.0, 1.0, 1.0);
vec3 P2ColorOut = vec3(0.0, 0.0, 1.0); //vec3(0.0, 0.5, 1.0);

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;

  float curve = 0.1 * sin((9.25 * uv.x) + (2.0 * u_time));

  float lineAShape = smoothstep(1.0 - clamp(distance(curve + uv.y, 0.5) * 1.0, 0.0, 1.0), 1.0, 0.99);
  vec3  lineACol = (1.0 - lineAShape) * vec3(mix(P1ColorIn, P1ColorOut, lineAShape));

  gl_FragColor = vec4(lineACol, 1.0);
}
