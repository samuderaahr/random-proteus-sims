/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/26/2012
Author  : 
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>

#define ROWCLK    PORTB.0
#define ROWLATCH  PORTB.1
#define ROWDATA   PORTB.2
#define IN1       PINB.3
#define IN2       PINB.4
#define COLCLK    PORTB.5
#define COLLATCH  PORTB.6
#define COLDATA   PORTB.7

unsigned char count = 1;

void col(void)  // progress column. max time per column = 2.5ms to get 50Hz
{ 
  if (count > 1) 
  {             
    if (count == 9) // open latch, data = 1, tick the clock, close latch, data = 0, count 2 (as if it's 1st count)
    { 
      COLLATCH = 0;
       
      COLDATA  = 1;
      
      COLCLK   = 1;
      delay_us(10);
      COLCLK   = 0;
      
      COLLATCH = 1;
      
      COLDATA  = 0;
      
      count = 2;
    }
    
    else // open latch, data = 0, tick the clock, close latch, count
    {      
      COLLATCH = 0;
       
      COLDATA  = 0;
      
      COLCLK   = 1;
      delay_us(10);
      COLCLK   = 0;
      
      COLLATCH = 1;
      
      count++;
    } 
  }
  
  if (count == 1)  // open latch, data = 1, tick the clock, close latch, data = 0, count
  {
    COLLATCH = 0;
     
    COLDATA  = 1;
    
    COLCLK   = 1;
    delay_us(10);
    COLCLK   = 0;
    
    COLLATCH = 1;
    
    COLDATA  = 0;
    
    count++;
  }       
}

void row(unsigned char data) // open latch, get n-th bit, tick clock.... , close latch
{
  signed char temp, n = 7, m;      
  col();  //progress column  
  ROWLATCH = 0;                     
  
  for (m = 0; m < 8 ; m++)
  {                  
    temp = data;
    temp = temp << n; 
    ROWDATA = temp >> (n + m); // process to get n-th bit of the char
    
    ROWCLK  = 1;
    delay_us(10);
    ROWCLK  = 0;  
    
    n--;
  }  
  
  ROWLATCH = 1;
}

void show_o(void)
{
  row(126);
  row(126);
  row(195);
  row(195);
  row(195);
  row(195);
  row(126);
  row(126);
}

void show_f(void)
{
  row(255);
  row(255);
  row(216);
  row(216);
  row(216);
  row(0);
  row(251);
  row(251);
}

void show_uright(void)
{
  row(255);
  row(255);
  row(216);
  row(216);
  row(216);
  row(0);
  row(251);
  row(251);
}

void show_uleft(void)
{
  row(255);
  row(255);
  row(216);
  row(216);
  row(216);
  row(0);
  row(251);
  row(251); 
}
void show_fuck(void)
{
  row(15);
  row(15);
  row(31);
  row(255);
  row(255);
  row(31);
  row(15);
  row(15);
}

void main(void)
{


// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1 
PORTB=0b00011000;
DDRB=0b11100111;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

while (1)
      { 
        while (IN1 == 0)
        {
          show_o();
        }    
        
        while (IN2 == 0)
        {
          show_f();
        }
      }
}
