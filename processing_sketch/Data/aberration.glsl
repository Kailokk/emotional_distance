
// Original shader by RavenWorks
// https://www.shadertoy.com/view/Xs23zW

// Adapted for Processing by Raphaël de Courville <@sableRaph>

uniform vec2 sketchSize;

uniform sampler2D texture;

vec2 barrelDistortion(vec2 coord, float amt) {
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * dist * amt;
}

float sat( float t )
{
	return clamp( t, 0.0, 1.0 );
}

float linterp( float t ) {
	return sat( 1.0 - abs( 2.0*t - 1.0 ) );
}

float remap( float t, float a, float b ) {
	return sat( (t - a) / (b - a) );
}

vec4 spectrum_offset( float t ) {
	vec4 ret;
	float lo = step(t,0.5);
	float hi = 1.0-lo;
	float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
	ret = vec4(lo,1.0,hi, 1.) * vec4(1.0-w, w, 1.0-w, 1.);

	return pow( ret, vec4(1.0/2.2) );
}

const float max_distort = 2.2;
const int num_iter = 12;
const float reci_num_iter_f = 1.0 / float(num_iter);

uniform float redOffset;
uniform float greenOffset;
uniform float blueOffset;

in vec2 TexCoords;
void main()
{	
   // Offset the texture coordinates horizontally
    vec2 offsetCoords = TexCoords + vec2(redOffset, 0.0);

    // Sample the original pixel value
    vec4 originalColor = texture(texture, offsetCoords);

    // Set the output color to the original pixel value
    gl_FragColor = originalColor;
}