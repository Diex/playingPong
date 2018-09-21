// Write data to the serial port according to the mouseX value

import processing.serial.*;
 
Serial port;                      // Create object from Serial class
Serial port1;

float mx = 0.0;

void setup() { 
  size(800, 200); 
  noStroke(); 
  frameRate(60); 
  // Open the port that the board is connected to and use the same speed (9600 bps) 
  port = new Serial(this, "/dev/ttyUSB0", 115200); 
  //port1 = new Serial(this, "/dev/ttyUSB1", 115200); 
} 

void draw() {   
  background(0);  // Clear background
  rectMode(CENTER);
  fill(204);    // Set fill color 
  rect(width/2, height/2, width * .80, 25);      // Draw square

  mx = map(mouseX, 0, width, -width * .8 /2, width * .8 /2);                // Keeps marker on the screen
  
  noStroke();
  fill(255);
  rect(width/2, (height/2), width * .8 , 5);  
  fill(204, 102, 0);
  
  rect((width/2) + mx, height/2, 4, 5);               // Draw the position marker
  int angle = int(map(mx, -width * .8 /2, width * .8 /2, 0, 180));  // Scale the value to the range 0-180

  port.write("B:"+angle+'\n');                        // Write the angle to the serial port
  print("B:"+angle+'\n');
   //port.write(angle);                        // Write the angle to the serial port
}



void SerialEvent(Serial port){
  println("serial: " + port.readString());

}
