import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

GLSLShader theShader;

void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);
  theShader = new GLSLShader(this, "uniforms_vert.glsl", "uniforms_frag.glsl");
  noStroke();
}

void draw()
{
  theShader.start();
  theShader.setVecUniform("mouse", float(mouseX), height-float(mouseY)); // hmmm reverse mouseY pos ?
  theShader.setVecUniform("resolution", float(width), float(height));
  rect(0,0,width,height);
  theShader.stop();
}
