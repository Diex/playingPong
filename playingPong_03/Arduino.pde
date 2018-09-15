import processing.serial.*;
 
Serial port;                      // Create object from Serial class
Serial port2;

void setupArduino() {  
  // Open the port that the board is connected to and use the same speed (9600 bps) 
  port = new Serial(this, "/dev/ttyUSB1", 115200); 
  port2 = new Serial(this, "/dev/ttyUSB0", 115200); 
  
}

void updateServo(String pad, float val) {
  int angle = int(map(val, 0.0, 1.0, 0, 180));  // Scale the value to the range 0-180
  if(pad.equals("B")) port2.write(pad+":"+angle+'\n');                        // Write the angle to the serial port
  if(pad.equals("A")) port.write(pad+":"+angle+'\n');                        // 
}
