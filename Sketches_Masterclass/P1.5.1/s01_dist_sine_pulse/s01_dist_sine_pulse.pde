import processing.opengl.*;
import javax.media.opengl.*;
import codeanticode.glgraphics.*;

GLSLShader theShader;
float timeReload = 0;

void setup() 
{
  size(800, 600, GLConstants.GLGRAPHICS);
  noStroke();
  reloadShader();
  timeReload = millis();
}

void draw()
{
  // Timing
  float now = millis();
  if (now-timeReload>=500)
  {
    timeReload = now;
    reloadShader();
  }

  // Shader
  //GLGraphics renderer = (GLGraphics)g;
  //renderer.beginGL();
  theShader.start();
  theShader.setFloatUniform("t", millis()/1000.0);
  theShader.setVecUniform("resolution", float(width), float(height));
  rect(0, 0, width, height);
  theShader.stop();

//  renderer.endGL();
}


void reloadShader()
{
  theShader = new GLSLShader(this, "dist_sine_pulse_vert.glsl", "dist_sine_pulse_frag.glsl");
}

