import com.hamoid.*;
VideoExport videoExport;
PImage bg;
PImage fox31;
void setup()
{
  size(828, 618);
  bg = loadImage("graph.jpg");
  fox31 = loadImage("fox31.jpg");
  textFont(createFont("Arial Bold", 18));
    videoExport = new VideoExport(this);
    videoExport.setFrameRate(60);
    videoExport.startMovie();
}

void draw()
{
  background(0);
  
  // Show original image
  if(frameCount < 120)
  {
    image(bg,0,0);
    videoExport.saveFrame();
    return;
  }
  
  // Fade to lying graph
  if(frameCount >= 120 && frameCount < 180)
  {
    float fc = frameCount-120;
    int alpha = int(255 * (fc/60.0));
    pushStyle();
      tint(255,255,255,255-alpha);
      image(bg,0,0);
    popStyle();
    
    drawGraph(0, alpha);
    videoExport.saveFrame();
    return;
  }
  
  // Show lying graph for a few seconds
  if(frameCount >= 180 && frameCount < 210)
  {
    drawGraph(0,255);
    videoExport.saveFrame();
    return;
  }
  
  // Morph to correct graph
  if(frameCount >= 210 && frameCount < 330)
  {
    float fc = frameCount-210;
    float lerp = fc / 120.0;
    drawGraph(lerp, 255);
    videoExport.saveFrame();
    return;
  }
  
  // Show correct graph for a few seconds.
  if(frameCount >= 330 && frameCount < 900)
  {
    drawGraph(1,255);
    videoExport.saveFrame();
    return;
  }
  
  videoExport.endMovie();
  
  exit();
  
}

int[] foxY = new int[]{30,60,90,100,130,160,190,240,250,300,350,400};
int[] newCases = new   int[]{33,61,86,112,116,129,192,174,344,304,327,246,320,339,376};
int[] fakeValues = new int[]{33,61,86,122,126,149,210,184,320,304,315,246,310,317,355};

// lerp is a value between 0 and 1 for morphing the graph - "lerp" is short for "linear interpolation"
// alpha is a value between 0 and 255 for doing the fade in.
void drawGraph(float lerp, int alpha)
{
  pushStyle();
    tint(255,255,255,alpha/3);
    image(fox31,0,164,828,289);
    
    fill(255,255,255,alpha);
    stroke(255,255,255,alpha);
    
    text("@KevPluck", width-200,height-20);
    
    textAlign(CENTER);
    textSize(17);
    text("TOTAL CASES", width-100,60);
    textSize(30);
    text("3,342", width-100,90);
    strokeWeight(3);
    
    textSize(40);
    text("New Cases Per Day", width/2, 80);
    
    
    textAlign(RIGHT);
    textSize(20);
    
    // Horizontal lines
    stroke(127,127,127, alpha);
    for(int i = 0; i<12; i++)
    {
      float y = lerp((i+1)*30, foxY[i], lerp);
      line(100, height-y-100, 800, height-y-100);
      text(foxY[i], 90, height-y-95); 
    }
    
    // Value lines
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(15);
    for(int i = 0;i<15;i++)
    {
      float y = lerp(fakeValues[i], newCases[i], lerp);
      
      pushStyle();
        stroke(255,255,255,alpha);
        strokeWeight(5);
        if(i>=1)
        {
          float lasty = lerp(fakeValues[i-1], newCases[i-1], lerp);
          line(120 + (i-1)*45, height-lasty-100, 120 + i*45, height-y-100);
        }
      popStyle();
    }
    
    // Value circles
    for(int i = 0;i<15;i++)
    {
      float y = lerp(fakeValues[i], newCases[i], lerp);
      
      ellipse(120 + i*45, height-y-100, 30,30);
      
      
      pushStyle();
        fill(0,0,0,alpha);
        text(newCases[i], 120 + i*45, height-y-101);
      popStyle();
      
      pushStyle();
        textSize(12);
        if(i<14)
          text("March\n" + (i+18), 120 + i*45, height - 90);
        else
          text("April\n1", 120 + i*45, height - 90);
      popStyle();
    }
  popStyle();
}
