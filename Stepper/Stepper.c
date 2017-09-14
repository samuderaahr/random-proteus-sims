/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/16/2013
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 4.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

int n;
// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0b00000000;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTC=0b00010000;
DDRC=0b00001111;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0b00000111;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

n = 200;

while (1)
  { 
    if (PIND.1 == 0)
    {
      n = n + 100;
    }             
    
    if (PIND.2 == 0)
    {
      n = n - 100;
    }
        
    if (PIND.0 == 0)
    {
    PORTC.0 = 1;
    PORTC.1 = 0;
    PORTC.2 = 1;
    PORTC.3 = 0;
    delay_ms(n);
    
    PORTC.0 = 1;
    PORTC.1 = 0;
    PORTC.2 = 0;
    PORTC.3 = 0;
    delay_ms(n);
    
    PORTC.0 = 1;
    PORTC.1 = 0;
    PORTC.2 = 0;
    PORTC.3 = 1;
    delay_ms(n);
    
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 0;
    PORTC.3 = 1;
    delay_ms(n);
    
    PORTC.0 = 0;
    PORTC.1 = 1;
    PORTC.2 = 0;
    PORTC.3 = 1;
    delay_ms(n);
    
    PORTC.0 = 0;
    PORTC.1 = 1;
    PORTC.2 = 0;
    PORTC.3 = 0;
    delay_ms(n);
    
    PORTC.0 = 0;
    PORTC.1 = 1;
    PORTC.2 = 1;
    PORTC.3 = 0;
    delay_ms(n);
    
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 1;
    PORTC.3 = 0;
    delay_ms(n);
    }    
  }
}
