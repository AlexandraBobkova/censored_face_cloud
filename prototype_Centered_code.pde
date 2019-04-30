P s;
P end;
crystal[] N;

//timer
float lasttimecheck;
float timeinterval;
int start;

//cloud
int crystalNum=12;
int maxbranch=3;
int remainder;

import org.openkinect.processing.*;

Kinect2 kinect2;



PGraphics pg;

float minThresh = 0;
float maxThresh = 1000;
PImage img;



import processing.sound.*;

AudioIn in;
Reverb reverb;
PinkNoise noise;

//colour change audio code
Amplitude amp;
float ampt;
AudioIn in2;


// effect
int scale = 1;

void setup() {
  //size(512, 424);
  fullScreen(P3D);
  //frameRate(60);
 
  //timer
  lasttimecheck = millis();
  timeinterval = 1;
  
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initVideo();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);


  pg = createGraphics(500, 500);
  N= new crystal[crystalNum];
  s= new P(mouseX, mouseY);

  for (int i=0; i<crystalNum; i++) {
    N[i]= new crystal(s);
  }

  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  // in = new AudioIn(this, 0);

  reverb = new Reverb(this);


  in.play();



  reverb.process(in);
  in.amp(0.09);
  reverb.room(2);


  noise = new PinkNoise(this);
  noise.play();
  noise.amp(0.09);
  
  //effect
   frames = new PImage[frame_count];
  for(int i = 0; i < frame_count; i++)
  {
      frames[i] = createImage(0, 0, 0);
  }
}

//effect
int frame_count = 10;
PImage[] frames;
boolean feedback = false;

int index = 0;


void TimerTime(){
 if (ampt>0.004) { 
    start = millis();
  } 
}


void draw() {
  background(0);

  ampt = amp.analyze();
  println(ampt);

  img.loadPixels();

  PImage VImg = kinect2.getVideoImage();
  //image(VImg, 0, 0, 512, 424);



  int[] depth = kinect2.getRawDepth();

  int record = kinect2.depthHeight;
  int rx = 0;
  int ry = 0;

  //float sumX = 0;
  //float sumY = 0;
  //float totalPixels = 0;

  for (int x=0; x<kinect2.depthWidth; x++) {
    for (int y=0; y<kinect2.depthHeight; y++) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh && x >100) {
        img.pixels[offset] = color(255, 0, 150);

        if (y < record) {
          record = y;
          rx = x;
          ry = y;
        }
      } else {
        img.pixels[offset] = VImg.pixels[offset];
      }
    }
  }

  img.updatePixels();

  image(VImg, 560, 320, 512, 424);

  noStroke();
  color c2;
  if (ampt>0.009) {
    c2 = color(random(0, 255), 0, 0, 18); //red tint flashing slightly
  } else {
    c2 = color(random(0, 255), 20); //white/black flashing
  }

  fill(c2);
  rect(560, 320, 512, 424);

  //fill(255);
  //ellipse(rx, ry, 32, 32);

  s= new P(rx+610, ry+370); //+50 to move the graphics to the right as the RGB camera isnt on the same level as IR camera
  //  if(frameCount<200){
  remainder=frameCount % crystalNum;
  N[crystalNum-remainder-1]= new crystal(s);

  pg.beginDraw(); 
  pg.endDraw();
  image(pg, 0, 0);
  for (int i=0; i<crystalNum; i++) {
    N[i].display();
    N[i].branch();
  }

  noise.pan(map(rx, 0, width, -1.0, 1.0)); //make it -rx for a disorienting feel
  in.pan(map(rx, 0, width, -1.0, 1.0));
}
