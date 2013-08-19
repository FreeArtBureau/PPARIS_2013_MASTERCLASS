import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

GLSLShader theShader;
GLTexture tex;

void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);
  theShader = new GLSLShader(this, "texture_vert.glsl", "texture_frag.glsl");
  tex = new GLTexture(this, "export.png");
}

void draw()
{
  theShader.start();
  theShader.setVecUniform("mouse", float(mouseX), height-float(mouseY)); // hmmm reverse mouseY pos ?
  theShader.setVecUniform("resolution", float(width), float(height));
  theShader.setTexUniform("texture", tex);

  //rect(0,0,width,height);  
  beginShape(QUADS);
  texture(tex);
  textureMode(NORMALIZED);
  vertex(0,0, 0,0);
  vertex(width,0, 1,0);
  vertex(width,height, 1,1);
  vertex(0,height, 0,1);
  endShape();
  
  theShader.stop();
}
