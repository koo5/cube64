#include <SPI.h>
const int latchPin = 10;
byte outs[9][3];
byte indata[4];
int w = 8*3;
int h = 9;

void setall(byte wut)
{
    memset(&outs, wut?255:0, 9*3);
}


void setup(void) {
  Serial.begin(38400);
  setall(0);
  pinMode(latchPin, OUTPUT);
//  SPI.setDataMode(SPI_MODE0);
//  SPI.setBitOrder(MSBFIRST);  
  SPI.setClockDivider(128);
  SPI.begin();
}

void sup_serial()
{
      if (Serial.available()>0) 
      {
        byte in = Serial.read();
        byte data = (in&0b11111100)>>2;
        byte meaning = in&0b00000011;
        indata[meaning] = data;
        if (meaning == 3)
        {
    	    int x= min(w-1,indata[1]);
    	    int y= min(h-1,indata[2]);
    	    byte bit= 1<<(x%8);
    	    if (indata[3])
                outs[y][x/8] = outs[y][x/8] | bit;
	    else
                outs[y][x/8] = outs[y][x/8] & ~bit;
        }
        if(meaning == 0)
          setall(indata[0]);
      }
}

int cubelayers[4] = {0,2,3,1};

void loop() {
  static unsigned int layer;
  static int animator;
  
  digitalWrite(latchPin,0);

  int i;
  for(i=0;i<=2;i++)
      SPI.transfer(outs[layer][i]);

  /*
  randomSeed((millis())/100+layer);
  SPI.transfer(1<<random(8));

  randomSeed((millis())/150+layer*100);
  SPI.transfer(random(255)&random(255)&random(255));
  SPI.transfer(random(255)&random(255)&random(255));
*/
  SPI.transfer(layer==8?1:0);
  SPI.transfer((1<<layer)&0b0000000011111111);

  digitalWrite(latchPin,1);

  delay(1);
  
  if (layer++ == 8)
  {
    layer = 0;

    if(animator++ == 7)
    {
      animator  =  0;
//      leds[random(w)][random(h)]=random(7);
      
    }
sup_serial();
  }
}

