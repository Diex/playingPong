#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
#define PROCESSING_TEXTURE_SHADER

uniform float Brightness;
uniform float Contrast;

uniform sampler2D texture;
varying vec4 vertTexCoord;

void main(void){

  vec4 pixelColor = texture2D(texture, vertTexCoord.st).rgba;
  pixelColor.rgb /= pixelColor.a;
  // Apply contrast.
  pixelColor.rgb = ((pixelColor.rgb - 0.5) * max(Contrast, 0.0)) + 0.5;
  // Apply brightness.
  pixelColor.rgb += Brightness;
  // Return final pixel color.
  pixelColor.rgb *= pixelColor.a;
  gl_FragColor = pixelColor;
 
}