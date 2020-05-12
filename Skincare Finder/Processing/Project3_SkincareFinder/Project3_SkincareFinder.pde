/*
  The Skincare Finder
  by Kara Ngamsopee
  
  This machine can read the moisture level of the skin
  and recommmend skincare products based on skin goals
*/

//----------------------------------------------------------------------------------------------------------------------------

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;

String[] data;

int switchValue = 0;
int potValue = 0;
int ldrValue = 0;

//getLDRValue()
int currentSkinValue = 0;
String skinType = "";

int serialIndex = 2;

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;


//----------------------------------------------------------------------------------------------------------------------------

int state;
int stateLandingPage = 1;
int stateSkinGoals = 2;
int stateDryGlow = 3;
int stateDryDark = 4;
int stateDryRedness = 5;
int stateDrySmooth = 6;
int stateDryPores = 7;
int stateNormalGlow = 8;
int stateNormalDark = 9;
int stateNormalRedness = 10;
int stateNormalSmooth = 11;
int stateNormalPores = 12;
int stateOilyGlow = 13;
int stateOilyDark = 14;
int stateOilyRedness = 15;
int stateOilySmooth = 16;
int stateOilyPores = 17;
int stateDrySkin = 18;
int stateNormalSkin = 19;
int stateOilySkin = 20;

PImage menu;
PImage goals;
PImage dryGlow;
PImage dryDark;
PImage dryRedness;
PImage drySmooth;
PImage dryPores;
PImage normalGlow;
PImage normalDark;
PImage normalRedness;
PImage normalSmooth;
PImage normalPores;
PImage oilyGlow;
PImage oilyDark;
PImage oilyRedness;
PImage oilySmooth;
PImage oilyPores;
PImage drySkin;
PImage normalSkin;
PImage oilySkin;

void setup() {
  //----------------------------------------------------------------------------------------------------------------------------
  printArray(Serial.list());

  myPort  =  new Serial (this, Serial.list()[serialIndex], 115200); 
  //----------------------------------------------------------------------------------------------------------------------------
  imageMode(CORNER);
  rectMode(CORNER);
  size(800, 580);
  background(255);
  state = stateLandingPage;
  menu = loadImage("assets/landing-page.jpg");
  goals = loadImage("assets/skingoals.jpg");
  dryGlow = loadImage("assets/dry-glow.png");
  dryDark = loadImage("assets/dry-dark.png");
  dryRedness = loadImage("assets/dry-redness.png");
  drySmooth = loadImage("assets/dry-smooth.png");
  dryPores = loadImage("assets/dry-pores.png");
  normalGlow = loadImage("assets/normal-glow.png");
  normalDark = loadImage("assets/normal-dark.png");
  normalRedness = loadImage("assets/normal-redness.png");
  normalSmooth = loadImage("assets/normal-smooth.png");
  normalPores = loadImage("assets/normal-pores.png");
  oilyGlow = loadImage("assets/oily-glow.png");
  oilyDark = loadImage("assets/oily-dark.png");
  oilyRedness = loadImage("assets/oily-redness.png");
  oilySmooth = loadImage("assets/oily-smooth.png");
  oilyPores = loadImage("assets/oily-pores.png");
  drySkin = loadImage("assets/dry-skin.png");
  normalSkin = loadImage("assets/normal-skin.png");
  oilySkin = loadImage("assets/oily-skin.png");
}


void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();
    
    
    print(inBuffer);

    // This removes the end-of-line from the string
    inBuffer = (trim(inBuffer));
    
    println("Switch, Pot Value, LDR Value");

    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
    
    if ( data.length >= 3 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value

      
    }

    
  }
} 


void draw() {
  
  getLDRValue();
  
  // every loop, look for serial information
  checkSerial();
  
  if(state == stateLandingPage) {
    drawLandingPage();
  }
 //skin type descriptions
    else if (state == stateDrySkin) {
    drawDrySkin();
  }
    else if (state == stateNormalSkin) {
    drawNormalSkin();
  }
    else if (state == stateOilySkin) {
    drawOilySkin();
  }
 //skin goal page
    else if (state == stateSkinGoals) {
    drawSkinGoals();
    drawRects();
  }
 //product pages
  else if (state == stateDryGlow) {
    drawDryGlow();
    startOver();
  }
  else if (state == stateDryDark) {
    drawDryDark();
    startOver();
  }
  else if (state == stateDryRedness) {
    drawDryRedness();
    startOver();
  }
  else if (state == stateDrySmooth) {
    drawDrySmooth();
    startOver();
  }
  else if (state == stateDryPores) {
    drawDryPores();
    startOver();
  }
  else if (state == stateNormalGlow) {
    drawNormalGlow();
    startOver();
  }
  else if (state == stateNormalDark) {
    drawNormalDark();
    startOver();
  }
  else if (state == stateNormalRedness) {
    drawNormalRedness();
    startOver();
  }
  else if (state == stateNormalSmooth) {
    drawNormalSmooth();
    startOver();
  }
  else if (state == stateNormalPores) {
    drawNormalPores();
    startOver();
  }
  else if (state == stateOilyGlow) {
    drawOilyGlow();
    startOver();
  }
  else if (state == stateOilyDark) {
    drawOilyDark();
    startOver();
  }
  else if (state == stateOilyRedness) {
    drawOilyRedness();
    startOver();
  }
  else if (state == stateOilySmooth) {
    drawOilySmooth();
    startOver();
  }
  else if (state == stateOilyPores) {
    drawOilyPores();
    startOver();
  }
}

void getLDRValue() {

  //get LDR value when button is pressed
  if((switchValue == 1) && (ldrValue <= 500)) {
    currentSkinValue = ldrValue;
    state = stateDrySkin;
  } else if((switchValue == 1) && ((ldrValue > 500) && (ldrValue < 1300))) {
    currentSkinValue = ldrValue;
    state = stateNormalSkin;
  } else if((switchValue == 1) && (ldrValue >= 1300)) {
    currentSkinValue = ldrValue;
    state = stateOilySkin;
  }
  
  //assigning skin types to LDR values
  if(currentSkinValue <= 500) {
    skinType = "dry";
  } else if ((currentSkinValue > 500) && (currentSkinValue < 1300)) {
    skinType = "normal";
  } else if (currentSkinValue >= 1300) {
    skinType = "oily";
  } 
}

//draw functions for all states

void startOver() {
  if ( (mousePressed) && (isMouseInRect(homeLeft, homeTop, homeWidth, homeHeight))) {
  state = stateLandingPage;
}
}

void drawLandingPage() {  
  state = 0;
  image(menu, 0, 0, 800, 580);
}

void drawDrySkin() {
  image(drySkin, 0, 0, 800, 580);
  if (mousePressed) {
    state = stateSkinGoals;
  }
}

void drawNormalSkin() {
  image(normalSkin, 0, 0, 800, 580);
  if (mousePressed) {
    state = stateSkinGoals;
  }
}

void drawOilySkin() {
  image(oilySkin, 0, 0, 800, 580);
  if (mousePressed) {
    state = stateSkinGoals;
  }
}

void drawSkinGoals() {
  image(goals, 0, 0, 800, 580);
}

void drawDryGlow() {
  image(dryGlow, 0, 0, 800, 580);
}

void drawDryDark() {
  image(dryDark, 0, 0, 800, 580);
}

void drawDryRedness() {
  image(dryRedness, 0, 0, 800, 580);
}

void drawDrySmooth() {
  image(drySmooth, 0, 0, 800, 580);
}

void drawDryPores() {
  image(dryPores, 0, 0, 800, 580);
}

void drawNormalGlow() {
  image(normalGlow, 0, 0, 800, 580);
}

void drawNormalDark() {
  image(normalDark, 0, 0, 800, 580);
}

void drawNormalRedness() {
  image(normalRedness, 0, 0, 800, 580);
}

void drawNormalSmooth() {
  image(normalSmooth, 0, 0, 800, 580);
}

void drawNormalPores() {
  image(normalPores, 0, 0, 800, 580);
}

void drawOilyGlow() {
  image(oilyGlow, 0, 0, 800, 580);
}

void drawOilyDark() {
  image(oilyDark, 0, 0, 800, 580);
}

void drawOilyRedness() {
  image(oilyRedness, 0, 0, 800, 580);
}

void drawOilySmooth() {
  image(oilySmooth, 0, 0, 800, 580);
}

void drawOilyPores() {
  image(oilyPores, 0, 0, 800, 580);
}

//another way to go back to landing page for coding purposes
void keyPressed() {
  if(key == ' '){
    state = stateLandingPage;
  }
}

//boxes for skin goals page
//boost glow
int glowLeft = 210;
int glowWidth = 380;
int glowTop = 190;
int glowHeight = 55;

//dark spots
int darkLeft = 210;
int darkWidth = 380;
int darkTop = 260;
int darkHeight = 55;

//calm redness
int rednessLeft = 210;
int rednessWidth = 380;
int rednessTop = 332;
int rednessHeight = 55;

//smooth fine lines
int smoothLeft = 210;
int smoothWidth = 380;
int smoothTop = 403;
int smoothHeight = 55;

//minimize pores
int poresLeft = 210;
int poresWidth = 380;
int poresTop = 475;
int poresHeight = 55;

//start over
int homeLeft = 614;
int homeWidth = 111;
int homeTop =  513;
int homeHeight = 57;

//see if the buttons are in the right positions
void drawRects() {
  noFill();
  noStroke();
  rect(glowLeft, glowTop, glowWidth, glowHeight);
  rect(darkLeft, darkTop, darkWidth, darkHeight);
  rect(rednessLeft, rednessTop, rednessWidth, rednessHeight);
  rect(smoothLeft, smoothTop, smoothWidth, smoothHeight);
  rect(poresLeft, poresTop, poresWidth, poresHeight);
}

//go to product page
void mousePressed() {
  if( isMouseInRect(glowLeft, glowTop, glowWidth, glowHeight) && state == stateSkinGoals && skinType == "dry" )
    state = stateDryGlow;
  else if( isMouseInRect(glowLeft, glowTop, glowWidth, glowHeight) && state == stateSkinGoals && skinType == "normal" )
    state = stateNormalGlow;
  else if( isMouseInRect(glowLeft, glowTop, glowWidth, glowHeight) && state == stateSkinGoals && skinType == "oily" )
    state = stateOilyGlow;
  else if( isMouseInRect(darkLeft, darkTop, darkWidth, darkHeight) && state == stateSkinGoals && skinType == "dry" )
    state = stateDryDark;
  else if( isMouseInRect(darkLeft, darkTop, darkWidth, darkHeight) && state == stateSkinGoals && skinType == "normal" )
    state = stateNormalDark;
  else if( isMouseInRect(darkLeft, darkTop, darkWidth, darkHeight) && state == stateSkinGoals && skinType == "oily" )
    state = stateOilyDark;
  else if( isMouseInRect(rednessLeft, rednessTop, rednessWidth, rednessHeight) && state == stateSkinGoals && skinType == "dry" )
    state = stateDryRedness;
  else if( isMouseInRect(rednessLeft, rednessTop, rednessWidth, rednessHeight) && state == stateSkinGoals && skinType == "normal" )
    state = stateNormalRedness;
  else if( isMouseInRect(rednessLeft, rednessTop, rednessWidth, rednessHeight) && state == stateSkinGoals && skinType == "oily" )
    state = stateOilyRedness;
  else if( isMouseInRect(smoothLeft, smoothTop, smoothWidth, smoothHeight) && state == stateSkinGoals && skinType == "dry" )
    state = stateDrySmooth;
  else if( isMouseInRect(smoothLeft, smoothTop, smoothWidth, smoothHeight) && state == stateSkinGoals && skinType == "normal" )
    state = stateNormalSmooth;
  else if( isMouseInRect(smoothLeft, smoothTop, smoothWidth, smoothHeight) && state == stateSkinGoals && skinType == "oily" )
    state = stateOilySmooth;
  else if( isMouseInRect(poresLeft, poresTop, poresWidth, poresHeight) && state == stateSkinGoals && skinType == "dry" )
    state = stateDryPores;
  else if( isMouseInRect(poresLeft, poresTop, poresWidth, poresHeight) && state == stateSkinGoals && skinType == "normal" )
    state = stateNormalPores;
  else if( isMouseInRect(poresLeft, poresTop, poresWidth, poresHeight) && state == stateSkinGoals && skinType == "oily" )
    state = stateOilyPores;
}

boolean isMouseInRect(int rectL, int rectT, int rectW, int rectH) {
  // check X first
  if( mouseX >= rectL && mouseX <= rectL + rectW ) {
    if( mouseY >= rectT && mouseY <= rectT + rectH ) {
      // must satisfy *both* conditions
      return true;
    }
  }

  return false;
}
