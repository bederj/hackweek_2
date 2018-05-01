
// 2036mapa
// justin mark beder
// midi_keyboard (added lerp function)


import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
FFT fft;
AudioDevice device;

AudioIn input;
Amplitude rms;

// Declare a scaling factor
int scale=15;

// Define how many FFT bands we want
int bands = 16;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;


import themidibus.*;

MidiBus myBus; // The MidiBus

float bg=0;

int[] keys = new int[85];
int[] grid = new int[85];

//note posiiton data
float nx;
float ny;
float noteX= -10; //pitch x of the key notes
float noteY= 500; //pitch y of the key notes

//note posiiton data
float kx;
float ky;
float keyX= -10; //pitch x of the key notes
float keyY= 500; //pitch y of the key notes

// this is how fast the main bar takes to mvoe to its new positions
float speed = 0.05; // between 0.00 and 1.00

void setup() {
  size(1000, 600);
  noStroke();  

  MidiBus.list();
  myBus = new MidiBus(this, 0, "MPKmini2"); //change this for your device.

  device = new AudioDevice(this, 44000, bands);

  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);
  // start the Audio Input
  input.start();
  // create a new Amplitude analyzer
  rms = new Amplitude(this);
  // Patch the input to an volume analyzer
  rms.input(input);


  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);

  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  // sample = new SoundFile(this, "beat.aiff");
  //sample.loop();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(input);



  int n=1;
  for (int i =60; i < 85; i++) {
    keys[i] = 40*n;
    n++;
  }
  int nn=1;
  for (int j = 40; j < 59; j++) {
    grid[j] = 50*nn;
    nn+=1;
  }

  background(0);

  rectMode(CENTER);
  createNotes();
}

void draw() { 

  //clever fade command
  fill(bg, 30);
  rect(0, 0, width*2, height*2);

  //draw a large bar and move it based on the pitch
  nx = lerp(nx, noteX, speed); // this animates the bar
  ny = lerp(ny, noteY, speed); // this animates the bar
  noFill();
  stroke(255-bg);
  // rect(nx, ny, 10, 1000);
  bezier(width/2, 0, nx, ny, nx, ny, width/2, height);

  //draw a large bar and move it based on the pitch
  kx = lerp(kx, keyX, speed); // this animates the bar
  ky = lerp(ky, keyY, speed); // this animates the bar

  noFill();
  stroke(255-bg);
  bezier(0, height/2, kx, ky, kx, ky, width, height/2);

  vol(); //draws the eq from the volume
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  //println("--------");
  //println("Channel:"+channel);
  println("Pitch:"+pitch);
  //println("Velocity:"+velocity);

  //for (int k = 60; k < 85; k++) {
  if (pitch >60 && pitch <85) {
    notes[pitch].drawNote();
  }
  // }
  //move the main bar about due to the pitch
  noteX = keys[pitch]-40;
  noteY = height - velocity*5;

  keyX = keys[pitch]-40;
  keyY = height - velocity*5;



  if (pitch <48) {
    // must be the square buttons and not keys
    fill(255, 0, 255);
    rect(grid[pitch], height/3, velocity*5, velocity*5);
  } else {
    //must be the keys
    fill(255);
    rect(keys[pitch]-40, height, 40, -velocity*5);
  }
}  

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff=
  println();
  println("Note Off:");
  // println("--------");
  // println("Channel:"+channel);
  println("Pitch:"+pitch);
  // println("Velocity:"+velocity);

  // for (int k = 60; k < 85; k++) {
  if (pitch >60 && pitch <85) {
    notes[pitch].removeNote();
  }
  //}
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  bg = value*2;
}


void vol() {

  stroke(255, 0, 0);

  fft.analyze();

  for (int i = 0; i < bands; i++) {

    // smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;

    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*height*scale );
  }
}