uniform vec2 sketchSize;
uniform float interpolationValue;
uniform vec2 rando;

uniform sampler2D texture;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(void) {

    vec2 uv = gl_FragCoord.xy / sketchSize.xy;
    uv.y = uv.y;

    vec3 sourcePixel = texture2D(texture, uv).rgb;

    vec2 coordRand = rando * uv.xy;

    float random = rand(coordRand);

    gl_FragColor = vec4(
		mix(random, sourcePixel.x, interpolationValue), 
		mix(random, sourcePixel.y, interpolationValue), 
		mix(random, sourcePixel.z, interpolationValue), 
		1);
}
