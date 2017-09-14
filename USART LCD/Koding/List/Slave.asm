
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Tiny
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _string=R3
	.DEF _col=R2
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x47,0x61,0x6B,0x20,0x6E,0x67,0x61,0x72
	.DB  0x75,0x68,0x20,0x63,0x75,0x6B,0x21,0x0
	.DB  0x25,0x63,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/30/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;
;#define EN PIND.1
;
;char *string, col;
;
;
;void main(void)
; 0000 0022 {

	.CSEG
_main:
; 0000 0023 // Declare your local variables here
; 0000 0024 
; 0000 0025 // Crystal Oscillator division factor: 1
; 0000 0026 #pragma optsize-
; 0000 0027 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0028 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0029 #ifdef _OPTIMIZE_SIZE_
; 0000 002A #pragma optsize+
; 0000 002B #endif
; 0000 002C 
; 0000 002D // Input/Output Ports initialization
; 0000 002E // Port A initialization
; 0000 002F // Func2=In Func1=In Func0=In
; 0000 0030 // State2=T State1=T State0=T
; 0000 0031 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0032 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0033 
; 0000 0034 // Port B initialization
; 0000 0035 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0036 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0037 PORTB=0x00;
	OUT  0x18,R30
; 0000 0038 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0039 
; 0000 003A // Port D initialization
; 0000 003B // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 003C // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 003D PORTD=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 003E DDRD=0x00;
	OUT  0x11,R30
; 0000 003F 
; 0000 0040 // Timer/Counter 0 initialization
; 0000 0041 // Clock source: System Clock
; 0000 0042 // Clock value: Timer 0 Stopped
; 0000 0043 // Mode: Normal top=0xFF
; 0000 0044 // OC0A output: Disconnected
; 0000 0045 // OC0B output: Disconnected
; 0000 0046 TCCR0A=0x00;
	OUT  0x30,R30
; 0000 0047 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 0048 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0049 OCR0A=0x00;
	OUT  0x36,R30
; 0000 004A OCR0B=0x00;
	OUT  0x3C,R30
; 0000 004B 
; 0000 004C // Timer/Counter 1 initialization
; 0000 004D // Clock source: System Clock
; 0000 004E // Clock value: Timer1 Stopped
; 0000 004F // Mode: Normal top=0xFFFF
; 0000 0050 // OC1A output: Discon.
; 0000 0051 // OC1B output: Discon.
; 0000 0052 // Noise Canceler: Off
; 0000 0053 // Input Capture on Falling Edge
; 0000 0054 // Timer1 Overflow Interrupt: Off
; 0000 0055 // Input Capture Interrupt: Off
; 0000 0056 // Compare A Match Interrupt: Off
; 0000 0057 // Compare B Match Interrupt: Off
; 0000 0058 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0059 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 005A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 005B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 005C ICR1H=0x00;
	OUT  0x25,R30
; 0000 005D ICR1L=0x00;
	OUT  0x24,R30
; 0000 005E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 005F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0060 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0061 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0062 
; 0000 0063 // External Interrupt(s) initialization
; 0000 0064 // INT0: Off
; 0000 0065 // INT1: Off
; 0000 0066 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0067 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0068 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0069 
; 0000 006A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 006B TIMSK=0x00;
	OUT  0x39,R30
; 0000 006C 
; 0000 006D // Universal Serial Interface initialization
; 0000 006E // Mode: Disabled
; 0000 006F // Clock source: Register & Counter=no clk.
; 0000 0070 // USI Counter Overflow Interrupt: Off
; 0000 0071 USICR=0x00;
	OUT  0xD,R30
; 0000 0072 
; 0000 0073 // USART initialization
; 0000 0074 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0075 // USART Receiver: Off
; 0000 0076 // USART Transmitter: On
; 0000 0077 // USART Mode: Asynchronous
; 0000 0078 // USART Baud Rate: 9600
; 0000 0079 UCSRA=0x00;
	OUT  0xB,R30
; 0000 007A UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 007B UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 007C UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 007D UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 007E 
; 0000 007F // Analog Comparator initialization
; 0000 0080 // Analog Comparator: Off
; 0000 0081 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0082 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0083 DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0084 
; 0000 0085 // Alphanumeric LCD initialization
; 0000 0086 // Connections specified in the
; 0000 0087 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0088 // RS - PORTB Bit 0
; 0000 0089 // RD - PORTB Bit 1
; 0000 008A // EN - PORTB Bit 2
; 0000 008B // D4 - PORTB Bit 4
; 0000 008C // D5 - PORTB Bit 5
; 0000 008D // D6 - PORTB Bit 6
; 0000 008E // D7 - PORTB Bit 7
; 0000 008F // Characters/line: 16
; 0000 0090 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0091 
; 0000 0092 while (1)
_0x3:
; 0000 0093 {
; 0000 0094   lcd_clear();
	RCALL _lcd_clear
; 0000 0095   lcd_putsf("Gak ngaruh cuk!");
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 0096   scanf("%c",&col);
	__POINTW1FN _0x0,16
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x2
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _scanf
	ADIW R28,6
; 0000 0097 
; 0000 0098   if (col == '+')
	LDI  R30,LOW(43)
	CP   R30,R2
	BRNE _0x6
; 0000 0099   {
; 0000 009A     gets(string,16);
	ST   -Y,R3
	LDI  R26,LOW(16)
	RCALL _gets
; 0000 009B     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 009C     lcd_puts(string);
	MOV  R26,R3
	RCALL _lcd_puts
; 0000 009D     delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
; 0000 009E   }
; 0000 009F 
; 0000 00A0   if (col == '-')
_0x6:
	LDI  R30,LOW(45)
	CP   R30,R2
	BRNE _0x7
; 0000 00A1   {
; 0000 00A2     gets(string,16);
	ST   -Y,R3
	LDI  R26,LOW(16)
	RCALL _gets
; 0000 00A3     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00A4     lcd_puts(string);
	MOV  R26,R3
	RCALL _lcd_puts
; 0000 00A5     delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00A6   }
; 0000 00A7 
; 0000 00A8   delay_ms(200);
_0x7:
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00A9 }
	RJMP _0x3
; 0000 00AA }
_0x8:
	RJMP _0x8
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	RJMP _0x2080004
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2080004
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	SUBI R30,-LOW(__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	RJMP _0x2080005
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080004
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080004
_lcd_puts:
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LD   R30,X+
	STD  Y+1,R26
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
_0x2080005:
	ADIW R28,2
	RET
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
	RJMP _0x2080003
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080004:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
_gets:
	ST   -Y,R26
	RCALL __SAVELOCR4
	LDD  R17,Y+4
	LDD  R16,Y+5
_0x2020009:
	CPI  R17,0
	BREQ _0x202000B
_0x202000C:
	RCALL _getchar
	MOV  R19,R30
	CPI  R19,8
	BRNE _0x202000D
	LDD  R26,Y+4
	CP   R17,R26
	BRSH _0x202000E
	SUBI R16,LOW(1)
	SUBI R17,-LOW(1)
_0x202000E:
	RJMP _0x202000C
_0x202000D:
	CPI  R19,10
	BREQ _0x202000B
	PUSH R16
	SUBI R16,-1
	MOV  R30,R19
	POP  R26
	ST   X,R30
	SUBI R17,LOW(1)
	RJMP _0x2020009
_0x202000B:
	MOV  R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+5
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
_get_usart_G101:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020078
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x2020079
_0x2020078:
	RCALL _getchar
	MOV  R17,R30
_0x2020079:
	MOV  R30,R17
_0x2080003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__scanf_G101:
	ST   -Y,R26
	SBIW R28,4
	RCALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R21,R30
_0x202007F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R16,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020081
	MOV  R26,R16
	RCALL _isspace
	CPI  R30,0
	BREQ _0x2020082
_0x2020083:
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x2020086
	MOV  R26,R16
	RCALL _isspace
	CPI  R30,0
	BRNE _0x2020087
_0x2020086:
	RJMP _0x2020085
_0x2020087:
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x2020088
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020088:
	RJMP _0x2020083
_0x2020085:
	MOV  R21,R16
	RJMP _0x2020089
_0x2020082:
	CPI  R16,37
	BREQ PC+2
	RJMP _0x202008A
	LDI  R18,LOW(0)
_0x202008B:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R16,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	CPI  R16,48
	BRLO _0x202008F
	CPI  R16,58
	BRLO _0x202008E
_0x202008F:
	RJMP _0x202008D
_0x202008E:
	MOV  R30,R18
	LDI  R26,LOW(10)
	RCALL __MULB12U
	MOV  R18,R30
	MOV  R30,R16
	SUBI R30,LOW(48)
	ADD  R18,R30
	RJMP _0x202008B
_0x202008D:
	CPI  R16,0
	BRNE _0x2020091
	RJMP _0x2020081
_0x2020091:
_0x2020092:
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	MOV  R19,R30
	MOV  R26,R30
	RCALL _isspace
	CPI  R30,0
	BREQ _0x2020094
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x2020095
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020095:
	RJMP _0x2020092
_0x2020094:
	CPI  R19,0
	BRNE _0x2020096
	RJMP _0x2020097
_0x2020096:
	MOV  R21,R19
	CPI  R18,0
	BRNE _0x2020098
	LDI  R18,LOW(255)
_0x2020098:
	MOV  R30,R16
	CPI  R30,LOW(0x63)
	BRNE _0x202009C
	LDD  R30,Y+13
	SUBI R30,LOW(4)
	STD  Y+13,R30
	LDD  R17,Z+4
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	MOV  R26,R17
	ST   X,R30
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x202009D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x202009D:
	RJMP _0x202009B
_0x202009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20200A6
	LDD  R30,Y+13
	SUBI R30,LOW(4)
	STD  Y+13,R30
	LDD  R17,Z+4
_0x202009F:
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BREQ _0x20200A1
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x20200A3
	MOV  R26,R16
	RCALL _isspace
	CPI  R30,0
	BREQ _0x20200A2
_0x20200A3:
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x20200A5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x20200A5:
	RJMP _0x20200A1
_0x20200A2:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	ST   X,R30
	RJMP _0x202009F
_0x20200A1:
	MOV  R26,R17
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x202009B
_0x20200A6:
	LDI  R20,LOW(1)
	MOV  R30,R16
	CPI  R30,LOW(0x64)
	BREQ _0x20200AB
	CPI  R30,LOW(0x69)
	BRNE _0x20200AC
_0x20200AB:
	LDI  R20,LOW(0)
	RJMP _0x20200AD
_0x20200AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20200AE
_0x20200AD:
	LDI  R19,LOW(10)
	RJMP _0x20200A9
_0x20200AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20200AF
	LDI  R19,LOW(16)
	RJMP _0x20200A9
_0x20200AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20200B2
	RJMP _0x20200B1
_0x20200B2:
	RJMP _0x2080002
_0x20200A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x20200B3:
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200B5
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	MOV  R16,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20200B6
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x20200B7:
	RJMP _0x20200B8
_0x20200B6:
	CPI  R20,0
	BRNE _0x20200B9
	CPI  R16,45
	BRNE _0x20200BA
	LDI  R20,LOW(255)
	RJMP _0x20200B3
_0x20200BA:
	LDI  R20,LOW(1)
_0x20200B9:
	CPI  R19,16
	BRNE _0x20200BC
	MOV  R26,R16
	RCALL _isxdigit
	CPI  R30,0
	BREQ _0x20200B8
	RJMP _0x20200BE
_0x20200BC:
	MOV  R26,R16
	RCALL _isdigit
	CPI  R30,0
	BRNE _0x20200BF
_0x20200B8:
	MOV  R21,R16
	RJMP _0x20200B5
_0x20200BF:
_0x20200BE:
	CPI  R16,97
	BRLO _0x20200C0
	SUBI R16,LOW(87)
	RJMP _0x20200C1
_0x20200C0:
	CPI  R16,65
	BRLO _0x20200C2
	SUBI R16,LOW(55)
	RJMP _0x20200C3
_0x20200C2:
	SUBI R16,LOW(48)
_0x20200C3:
_0x20200C1:
	MOV  R30,R19
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	RCALL __MULW12U
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x20200B3
_0x20200B5:
	LDD  R30,Y+13
	SUBI R30,LOW(4)
	STD  Y+13,R30
	LDD  R17,Z+4
	MOV  R30,R20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL __MULW12U
	MOV  R26,R17
	ST   X+,R30
	ST   X,R31
_0x202009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20200C4
_0x202008A:
_0x20200B1:
	IN   R30,SPL
	ST   -Y,R30
	PUSH R21
	LDD  R26,Y+11
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ICALL
	POP  R21
	CP   R30,R16
	BREQ _0x20200C5
	LDD  R26,Y+10
	LD   R26,X
	CPI  R26,0
	BRGE _0x20200C6
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x20200C6:
_0x2020097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20200C7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x20200C7:
	RJMP _0x2020081
_0x20200C5:
_0x20200C4:
_0x2020089:
	RJMP _0x202007F
_0x2020081:
_0x2080002:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x2080001:
	RCALL __LOADLOCR6
	ADIW R28,16
	RET
_scanf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	MOV  R26,R28
	SUBI R26,LOW(1)
	ADD  R26,R15
	MOV  R17,R26
	LDI  R30,LOW(0)
	STD  Y+2,R30
	MOV  R26,R28
	SUBI R26,-(3)
	ADD  R26,R15
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	LDI  R30,LOW(_get_usart_G101)
	LDI  R31,HIGH(_get_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R28
	SUBI R26,-(6)
	RCALL __scanf_G101
	LDD  R17,Y+0
	ADIW R28,3
	POP  R15
	RET

	.CSEG
_isdigit:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
_isxdigit:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULB12U:
	MOV  R0,R26
	SUB  R26,R26
	LDI  R27,9
	RJMP __MULB12U1
__MULB12U3:
	BRCC __MULB12U2
	ADD  R26,R0
__MULB12U2:
	LSR  R26
__MULB12U1:
	ROR  R30
	DEC  R27
	BRNE __MULB12U3
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
