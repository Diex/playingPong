#ifdef GL_ES
precision mediump float;  // no hace falta en desktop
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
varying vec4 vertTexCoord;

uniform sampler2D previo;


uniform float gain;
uniform float diffMinValue;
uniform float diffMaxValue;

void main(void){

  vec4 prevColor = texture2D(previo, vec2(vertTexCoord.s, 1.0 - vertTexCoord.t));  // invierte Y y samplea el color para este vertex
  vec4 actualColor = texture2D(texture, vertTexCoord.st);
  vec4 diff = actualColor - prevColor;
  diff.r = smoothstep(diffMinValue, diffMaxValue, diff.r) * gain;
  diff.g = smoothstep(diffMinValue, diffMaxValue, diff.g) * gain;
  diff.b = smoothstep(diffMinValue, diffMaxValue, diff.b) * gain;  
  gl_FragColor = vec4(diff.rgb, 1.0);
}