const int dataPin = 11;
const int latchPin = 12;
const int shiftPin = 13;
const unsigned char w = 8*3;
const unsigned char h = 8*2;
byte leds[w][h];

void setup() {
  Serial.begin(9600);
  pinMode(dataPin, OUTPUT);
  pinMode(latchPin, OUTPUT);
  pinMode(shiftPin, OUTPUT);
  int a;
  for(int i = 0;i<w;i++)
  {
    for(int j = 0;j<h;j++)
      leds[i][j]=0;
  }
}

void boing(byte boing)
{
  digitalWrite(shiftPin,LOW);
  digitalWrite(dataPin, boing);
  digitalWrite(shiftPin,1);
}

float b;

byte indata[4];

void loop() {
  if (Serial.available()>0) 
  {
    byte in = Serial.read();
    byte data = (in&0b11111100)>>2;
    byte meaning = in&0b00000011;
    indata[meaning] = data;
    if (meaning = 2)        
      leds[min(w,indata[1])][min(h,indata[2])] = indata[3];
  }

  static int layer=0;

  for (int x = 0; x < w; x++)
    boing(leds[x][layer]);

  for(int y=0;y<h;y++)
    boing(y==layer);

  digitalWrite(latchPin,0);
  digitalWrite(latchPin,1);

  if (++layer == h)
  {
    layer = 7;
  }

  //    leds[random(w)][random(h)]=random(2);


  /*
  if (Serial.available() > 0) {
   digitalWrite(dataPin, Serial.read());
   digitalWrite(shiftPin,LOW);
   digitalWrite(latchPin,LOW);
   delay(4);
   digitalWrite(shiftPin,1);
   digitalWrite(latchPin,1);
   delay(4);
   }*/
}




