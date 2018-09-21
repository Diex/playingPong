#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
#define PROCESSING_TEXTURE_SHADER
 
uniform sampler2D texCurve;
varying vec4 inColor;


//uniform sampler2D previo;
//uniform float gain;
 
void main(void){
  
//  vec4 prevColor 	= texture2D(previo, vec2(vertTexCoord.s, 1.0 - vertTexCoord.t));
//  vec4 actualColor 	= texture2D(texture, vertTexCoord.st);
//  vec4 diferencia 	= abs(actualColor - prevColor) * gain;

  
 gl_FragColor = vec4(texture2D(texCurve, vec2(inColor.r, 0.5)).r, texture2D(texCurve, vec2(inColor.g, 0.5)).g, texture2D(texCurve, vec2(inColor.b, 0.5)).b, inColor.a); //vec4(diferencia.rgb, 1.0);
}


