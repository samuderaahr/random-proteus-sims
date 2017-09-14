/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 5/30/2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>
#include <twi.h>
#include <stdio.h>

#define SET(x,y) (x|=(1<<y))
#define CLR(x,y) (x&=(~(1<<y)))
#define CHK(x,y) (x&(1<<y)) 
#define TOG(x,y) (x^=(1<<y))

#define TWACK (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA))   //I2C ACK for next transmission
#define TWNACK (TWCR=(1<<TWINT)|(1<<TWEN))            //I2C NACK for next transmission
#define TWRESET (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWSTO)|(1<<TWEA)) //I2C reset, duh!
#define TWSTART (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWSTA))					 //Send a start signal on the I2C bus

#define I2C_SLAVE_ADDRESS 0x01
#define SLA_W ((I2C_SLAVE_ADDRESS<<1) | 0)
#define SLA_R ((I2C_SLAVE_ADDRESS<<1) | 1)

#define RXBUF 3
#define TXBUF 12

unsigned char r_index = 0;
char recv[RXBUF]; //buffer to store received bytes

unsigned char t_index=0;
char tran[TXBUF]= {1,2,3,4,5,6,7,8,9,10,11,12};

char kirim[2] = {0x20, 0x00};
char terima[10];
char txtemp[3] = "";
char rxtemp[3] = "";

flash char ovf[9] = "OVERFLOW";
flash char dbg[6] = "HERE!";

unsigned long millis = 0;
static bool overflow = false;

static void smartdelay(unsigned long ms);
static void ov7670seq(void);
static void i2c_delay(char cycles);
static void kirim2_ov(char byte1, char byte2);
char fetch_ov(char reg_add);


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{  
  TCNT0=0x06;  // Reinitialize Timer 0 value
  
  if (millis != 0xFFFF)
  {
  	millis++;
  } 
  
  else
  {                 
  	millis = 0;
    overflow = true;       
    putsf(ovf);
    #asm("cli");
  }              
}

void main(void)
{
  // Declare your local variables here

  // Crystal Oscillator division factor: 1
  #pragma optsize-
  CLKPR=(1<<CLKPCE);
  CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
  #ifdef _OPTIMIZE_SIZE_
  #pragma optsize+
  #endif

  // Input/Output Ports initialization
  // Port B initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
  DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T 
  PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

  // Port C initialization
  // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
  // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

  // Port D initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: 250.000 kHz
  // Mode: Normal top=0xFF
  // OC0A output: Disconnected
  // OC0B output: Disconnected
  // Timer Period: 1 ms
  TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
  TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
  TCNT0=0x06;
  OCR0A=0x00;
  OCR0B=0x00;

  // Timer/Counter 1 initialization
  // Clock source: System Clock
  // Clock value: Timer1 Stopped
  // Mode: Normal top=0xFFFF
  // OC1A output: Disconnected
  // OC1B output: Disconnected
  // Noise Canceler: Off
  // Input Capture on Falling Edge
  // Timer1 Overflow Interrupt: Off
  // Input Capture Interrupt: Off
  // Compare A Match Interrupt: Off
  // Compare B Match Interrupt: Off
  TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
  TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
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
  // Clock value: 16000.000 kHz
  // Mode: CTC top=OCR2A
  // OC2A output: Toggle on compare match
  // OC2B output: Disconnected
  // Timer Period: 0.5 us
  // Output Pulse(s):
  // OC2A Period: 1 us Width: 0.5 us
  ASSR=(0<<EXCLK) | (0<<AS2);
  TCCR2A=(0<<COM2A1) | (1<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (0<<WGM20);
  TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
  TCNT2=0x00;
  OCR2B=0x00;   
  OCR2A=0x0F;		//500kHz
  //OCR2A=0x07;		//1MHz
  //OCR2A=0x00; 	//8 MHz

  // Timer/Counter 0 Interrupt(s) initialization
  TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

  // Timer/Counter 1 Interrupt(s) initialization
  TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

  // Timer/Counter 2 Interrupt(s) initialization
  TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  // Interrupt on any change on pins PCINT0-7: Off
  // Interrupt on any change on pins PCINT8-14: Off
  // Interrupt on any change on pins PCINT16-23: Off
  EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
  EIMSK=(0<<INT1) | (0<<INT0);
  PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

  // USART initialization
  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART Receiver: Off
  // USART Transmitter: On
  // USART0 Mode: Asynchronous
  // USART Baud Rate: 38400
  UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
  UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
  UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
  UBRR0H=0x00;
  UBRR0L=0x19;   
  
  // Analog Comparator initialization
  // Analog Comparator: Off
  // The Analog Comparator's positive input is
  // connected to the AIN0 pin
  // The Analog Comparator's negative input is
  // connected to the AIN1 pin
  ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
  ADCSRB=(0<<ACME);
  // Digital input buffer on AIN0: On
  // Digital input buffer on AIN1: On
  DIDR1=(0<<AIN0D) | (0<<AIN1D);

  // ADC initialization
  // ADC disabled
  ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

  // SPI initialization
  // SPI disabled
  SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

  // TWI initialization
  // Mode: TWI Master
  // Bit Rate: 50 kHz
  twi_master_init(50);

  // Global enable interrupts
  #asm("sei")

	while (1)
  {                         
  	PORTC = 0x00; 
    UDR0 = fetch_ov(0x0A);
                       
    smartdelay(100);
  }
}

static void smartdelay(unsigned long ms)
{
  unsigned long start = millis;
  do 
  {
     //putsf(dbg);	//debug echo
  }  while (millis - start < ms || overflow);
  
  if (overflow)
  {
  	overflow = false;         
  }
}

/*
#define SET(x,y) (x|=(1<<y))
#define CLR(x,y) (x&=(~(1<<y)))
#define CHK(x,y) (x&(1<<y)) 
#define TOG(x,y) (x^=(1<<y))

#define TWACK (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA))   //I2C ACK for next transmission
#define TWNACK (TWCR=(1<<TWINT)|(1<<TWEN))            //I2C NACK for next transmission
#define TWRESET (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWSTO)|(1<<TWEA)) //I2C reset, duh!
#define TWSTART (TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWSTA))					 //Send a start signal on the I2C bus

#define I2C_SLAVE_ADDRESS 0x01
#define SLA_W ((I2C_SLAVE_ADDRESS<<1) | 0)
#define SLA_R ((I2C_SLAVE_ADDRESS<<1) | 1)

#define RXBUF 3
#define TXBUF 12
*/

static void ov7670seq(void)
{
	TWRESET;
	TWSTART;
  
	TWACK;
}

static void i2c_delay(char cycles)
{
	char count;
  for (count = 0; count < cycles; count++)
  {	}	//empty loop	
}

void kirim2_ov(char byte1, char byte2)
{
  //txtemp = "";
  //rxtemp = "";
  
  txtemp[0] = 0x21;
}

char fetch_ov(char reg_add)
{
	char temp = 0;                
  char alamat = reg_add;
  twi_master_trans(0x21, (char *) alamat, 1, (char *)temp, 1);
  i2c_delay(100);
  return temp;
}



//	//send start condition
//	twiStart();
//	twiAddr(camAddr_WR,TW_MT_SLA_ACK);
//	twiWriteByte(reg,TW_MT_DATA_ACK);
//	twiWriteByte(dat,TW_MT_DATA_ACK);
//	TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO);//send stop
//	_delay_ms(1);