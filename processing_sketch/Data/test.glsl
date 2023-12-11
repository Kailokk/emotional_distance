uniform sampler2D texture;
uniform float interpolationValue;
uniform vec2 sketchSize;

float redShift = 10.0;
float greenShift = 5.0;
float blueShift = 15.0;
float aberrationStrength = 1.0;

float bx2(float x) {
    return x * 2.0 - 1.0;
}

void main(void) {
    vec2 texelSize = vec2(1.0, 1.0) / sketchSize.xy;
    vec2 uv = gl_FragCoord.xy * texelSize;
    vec2 mouse = vec2(interpolationValue, interpolationValue).xy * texelSize;

    float uvXOffset = bx2(uv.x);
    float mouseXOffset = (interpolationValue > 0.0) ? bx2(mouse.x) : 0.0;

    float uvXFromCenter = uvXOffset - mouseXOffset;
    float finalUVX = uvXFromCenter * abs(uvXFromCenter) * aberrationStrength;

    float redChannel = texture(texture, vec2(uv.x + (finalUVX * (redShift * texelSize.x)), uv.y)).r;
    float greenChannel = texture(texture, vec2(uv.x + (finalUVX * (greenShift * texelSize.x)), uv.y)).g;
    float blueChannel = texture(texture, vec2(uv.x + (finalUVX * (blueShift * texelSize.x)), uv.y)).b;

    gl_FragColor = vec4(redChannel, greenChannel, blueChannel, 1.0);
}