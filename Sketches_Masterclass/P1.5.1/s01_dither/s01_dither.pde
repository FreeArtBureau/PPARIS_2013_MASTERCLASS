import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

GLGraphicsOffScreen offscreen;
GLSLShader shaderDither;

void setup()
{
  size(800, 600, GLConstants.GLGRAPHICS);
  offscreen = new GLGraphicsOffScreen(this, width, height);
  shaderDither = new GLSLShader(this, "dither_vert.glsl", "dither_frag.glsl");
}


void draw()
{
  offscreen.beginDraw();
  offscreen.lights();
  offscreen.background(0);
  offscreen.translate(offscreen.width/2, offscreen.height/2);
  float r = radians(frameCount)/2;
  offscreen.rotateX(r);
  offscreen.rotateY(r);
  offscreen.noStroke();
  offscreen.fill(255);
  //offscreen.box(160);
  offscreen.sphereDetail(6);
  offscreen.sphere(160);
  
/*
  offscreen.rotateX(1.3*r);
  offscreen.rotateY(1.3*r);
  offscreen.box(400);
*/

  offscreen.endDraw();
  GLGraphics renderer = (GLGraphics)g;
  renderer.beginGL();
  shaderDither.start(); // Enabling shader.
  shaderDither.setFloatUniform("scale", 1.0);
  shaderDither.setTexUniform("texture", offscreen.getTexture());
  

  beginShape(QUADS);
  textureMode(NORMALIZED);
  texture(offscreen.getTexture());
  vertex(0, 0, 0, 0);
  vertex(2*width, 0, 1, 0); // why 2 ????
  vertex(2*width, 2*height, 1, 1); 
  vertex(0, 2*height, 0, 1);  
  endShape();
  
  shaderDither.stop();
  renderer.endGL();
  

}
