
// Original shader by RavenWorks
// https://www.shadertoy.com/view/Xs23zW

// Adapted for Processing by Raphaël de Courville <@sableRaph>

uniform vec2 sketchSize;
uniform float interpolationValue;
uniform vec2 rando;

uniform sampler2D texture;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}
uint xorshift32(uint state) {
    state ^= (state << 13);
    state ^= (state >> 17);
    state ^= (state << 5);
    return state;
}

vec3 generateRandomColor(uint seed) {
    // Use xorshift to generate a random number based on the seed
    uint randomValue = xorshift32(seed);

    // Normalize the random value to a range between 0 and 1
    float normalizedRandom = float(randomValue) / float(uint(0xFFFFFFFF));

    // Use the normalized random value to create a random color
    vec3 randomColor = vec3(normalizedRandom, fract(normalizedRandom + 0.33), fract(normalizedRandom + 0.67));

    return randomColor;
}
void main(void) {

    vec2 uv = gl_FragCoord.xy / sketchSize.xy;
    uv.y = uv.y;

    vec3 sourcePixel = texture2D(texture, uv).rgb;

    vec2 coordRand = rando * uv.xy;

    float random = rand(coordRand);

    gl_FragColor = vec4(mix(random, sourcePixel.x, interpolationValue), mix(random, sourcePixel.y, interpolationValue), mix(random, sourcePixel.z, interpolationValue), 1);
}

/*

// Original version with pseudo menu-bar

void main(void) {
	
	int topGapY = int(sketchSize.y - gl_FragCoord.y);
	
	int cornerGapX = int((gl_FragCoord.x < 10.0) ? gl_FragCoord.x : sketchSize.x - gl_FragCoord.x);
	int cornerGapY = int((gl_FragCoord.y < 10.0) ? gl_FragCoord.y : sketchSize.y - gl_FragCoord.y);
	int cornerThreshhold = ((cornerGapX == 0) || (topGapY == 0)) ? 5 : 4;
	
	if (cornerGapX+cornerGapY < cornerThreshhold) {
				
		gl_FragColor = vec4(0,0,0,1);
		
	} else if (topGapY < 20) {
			
			if (topGapY == 19) {
				
				gl_FragColor = vec4(0,0,0,1);
				
			} else {
		
				gl_FragColor = vec4(1,1,1,1);
				
			}
		
	} else {
		
		vec2 uv = gl_FragCoord.xy / sketchSize.xy;
		uv.y = uv.y;
		
		vec3 sourcePixel = texture2D(texture, uv).rgb;
		float grayscale = length(sourcePixel*vec3(0.2126,0.7152,0.0722));
		
		vec3 ditherPixel = texture2D(noiseTexture, vec2(mod(gl_FragCoord.xy/vec2(8.0,8.0),1.0))).xyz;
		float ditherGrayscale = (ditherPixel.x + ditherPixel.y + ditherPixel.z) / 3.0;
		ditherGrayscale -= 0.5;
		
		float ditheredResult = grayscale + ditherGrayscale;
		
		float bit = ditheredResult >= 0.5 ? 1.0 : 0.0;
		gl_FragColor = vec4(bit,bit,bit,1);
			
	}
	
}
*/