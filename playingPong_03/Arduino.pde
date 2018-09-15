import processing.serial.*;
 
Serial port;                      // Create object from Serial class
Serial port2;

void setupArduino() {  
  // Open the port that the board is connected to and use the same speed (9600 bps) 
  println(Serial.list());
  port = new Serial(this, "/dev/ttyUSB2", 115200); 
  println(port);
  port.write("A:50");
  
  //port2 = new Serial(this, "/dev/ttyUSB0", 115200);
  //println(port2);
  //port2.write("B:50");
  
  
}

void updateServo(String pad, float val) {
  int angle = int(map(val, 0.0, 1.0, 0, 180));  // Scale the value to the range 0-180
  if(port2 pad.equals("B")) port2.write(pad+":"+angle+'\n');                        // Write the angle to the serial port
  if(pad.equals("A")) port.write(pad+":"+angle+'\n');                        // 
}
