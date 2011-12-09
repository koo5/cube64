#include <SPI.h>

//int cubelayers[4] = {0,2,3,1};
const int latchPin = 10;
int random_blinker=1;
byte outs[9][3];
byte x=0,y=0;
int w = 8*3;
int h = 9;

void setall(byte wut)
{
    memset(&outs, wut?255:0, 9*3);
}

void setup(void) {
    setall(0);
    Serial.begin(38400);
    pinMode(latchPin, OUTPUT);
//  SPI.setDataMode(SPI_MODE0);
//  SPI.setBitOrder(MSBFIRST);
    SPI.setClockDivider(8);
    SPI.begin();
}

void toggle(byte x, byte y, byte data)
{
    byte bit= 1<<(x%8);
    if (data)
        outs[y][x/8] = outs[y][x/8] | bit;
    else
        outs[y][x/8] = outs[y][x/8] & ~bit;
}


void sup_serial()
{
    if (!Serial.available()) return;
    byte in = Serial.read();
    byte data = (in&0b11111100)>>2;
    byte meaning = in&0b00000011;
    switch(meaning)
    {
    case 0:
        switch (data)
        {
        case 0:
        case 1:
            setall(data);
            break;
        case 2:
        case 3:
            random_blinker=data-2;
            break;
        }
        break;
    case 1:
        x = min(w-1,data);
        break;
    case 2:
        y = min(h-1,data);
        break;
    case 3:
        toggle(x,y,data);
        break;
    }
}

void loop() {
    static int animator;
    static unsigned int layer;

    digitalWrite(latchPin,0);

    int i;
    for(i=0; i<=2; i++)
        SPI.transfer(outs[layer][i]);

    SPI.transfer(layer==8);
    SPI.transfer(1<<layer);

    digitalWrite(latchPin,1);

    delay(1);

    if (layer++ == 8)
    {
        layer = 0;
        if(animator++ == 7)
        {
            animator  =  0;
            if(random_blinker) toggle(random(w),random(h),random(7));
        }
        sup_serial();
    }
}

