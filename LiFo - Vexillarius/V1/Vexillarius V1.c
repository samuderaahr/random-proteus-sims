/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/22/2012
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512

*****************************************************/

/********************** Includes ********************/

#include <stdlib.h>
#include <mega32.h>
#include <delay.h>
#include <string.h>
#include <lcd.h>

/********************** ASM Init ********************/

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

/******************** Definitions *******************/

// dibawah ini semuanya macro, sat

#define SERVO OCR1B
#define SPEED OCR2
#define AXIA PIND.0
#define DIR1 PORTD.5
#define DIR2 PORTD.6
#define BTN1 PINB.0
#define BTN2 PINB.1
#define BTN3 PINB.2
#define EXECUTE PINB.3

/********************* Variables ********************/

long enc = 0;
char *strenc;
char menu = 1;
char flash *name = "Vexillarius V1.0";
unsigned int cnt;                                                                            

/********************* Interrupt ********************/

interrupt [EXT_INT0] void ext_int0_isr(void)  //implementasi Encoder, belum dipakai
{
  if (AXIA == 1)
  {
    enc++;
  }
  
  if (AXIA == 0)
  {
    enc--;
  }
}

/********************* Functions ********************/

void write(char flash *string1, char flash *string2)  //untuk nulis ke LCD, kalo line 1 dan 2 dari flash (kode)
{ 
  lcd_clear(); 
  lcd_gotoxy(0,0);
  lcd_putsf(string1);
  lcd_gotoxy(0,1);
  lcd_putsf(string2);   
}
                                                        
void write2(char *string1, char flash *string2)       //sama tapi line 1 dari variabel program
{ 
  lcd_clear(); 
  lcd_gotoxy(0,0);
  lcd_puts(string1);
  lcd_gotoxy(0,1);
  lcd_putsf(string2);   
}

void clear(int delay) //buat clear LCD setelah n milisekon
{
  delay_ms(delay);
  lcd_clear();
}

void degtopwm(unsigned int deg)  //untuk konversi derajat ke PWM servo
{
  SERVO = ((((deg*100)/180)*10)+1000); //1000 => 0deg (kiri max); 2000 => 180deg (kanan max); 1500 => 90deg (center);
}

void spdtopwm(unsigned char spd) //untuk kecepatan motor, n % , 0 <= n <= 100. jangan lebih karena bakal error (OF)
{
  float spit;
  spit = ((spd/10.0 * 255)); //kalo nemu algoritma yg lebih bagus, ganti aja
  SPEED = (char) spit; 
}

void direction(unsigned char dir) //arah motor. 1 = maju, 2 = mundur, 3 = brake
{
  if (dir == 1)
  {
    DIR1 = 1;
    DIR2 = 0;
  }
   
  if (dir == 0)
  {
    DIR1 = 0;
    DIR2 = 1;
  }       
  
  if (dir == 2)
  {
    DIR1 = 1;
    DIR2 = 1;
  }  
  
  //DIR1 = 0;
  //DIR2 = 0;
}

void step(unsigned int s, unsigned char m, unsigned char d,unsigned int t,char flash *l)
//buat bikin gerakan terprogram, masih prototipe
{
  for (cnt=0;cnt<t;cnt++)
  {
    degtopwm(s);
    spdtopwm(m);
    direction(d);
    //ltoa(enc,strenc);
    write2(strenc,l);
    delay_ms(1);
  }
}

void checkbutton(void) //fungsi pushbutton, ga dipake karena kita cuma punya 2 tombol instead of 4
{
  if (BTN1 == 0)
  {
    menu = 1;
  }
        
  if (BTN2 == 0)
  {
    menu = 2;
  }
        
  if (BTN3 == 0)
  {
    menu = 3;
  } 
  delay_ms(10); 
}

void showmenu(void) //fungsi menu
{
  if (menu == 1)
  {
    write("Main Menu :","1. Follow Line");
  }
  
  if (menu == 2)
  {
    write("Main Menu :","2. Follow Path");
  }   
  
  if (menu == 3)
  {
    write("Main Menu :","3. Check Swing");
  }
     
  delay_ms(10);
}

void splash(void) //splash screen awal
{
  write(name,"Conquer 'em All!");
  clear(500);
}

/******************** Main Block ********************/

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P 
PORTB=0x0F;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: Ph. correct PWM top=ICR1
// OC1A output: Discon.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x22;
TCCR1B=0x12;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=027;
ICR1L=0x10;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Phase correct PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x67;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("cli")

splash();

while (1)
      {
        checkbutton();
        showmenu();                 
        while (EXECUTE == 0 && menu == 2)
        { 
        step(90,0,2,200,"Align Me!");
        step(45,50,1,200,"Step One");
        step(180,50,1,200,"Step Two");
        step(0,50,1,200,"Step Three");
        step(135,50,1,200,"Step Four");
        step(90,100,2,1000,"Finish!");
        }
      }
}

//P.S coba2 dulu aja sat masing2 fungsi gimana kerjanya, kalo ga paham tanyain aja
//    servo mungkin masih kacau itungannya/simulasiny, ntar coba gw benerin
//    buat line following belom ada kodenya hehehe