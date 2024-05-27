
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Delay=R4
	.DEF _Delay_msb=R5
	.DEF _Xanh1=R7
	.DEF _Vang1=R6
	.DEF _Do1=R9
	.DEF _Xanh2=R8
	.DEF _Vang2=R11
	.DEF _Do2=R10
	.DEF _DemXanh1=R13
	.DEF _DemVang1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1E,0x0,0x3,0xF
	.DB  0xA,0x0,0x0,0x3

_0x8:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _MaLed
	.DW  _0x8*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <Timer.h>

	.CSEG
__KhoiTaoTimer0:
; .FSTART __KhoiTaoTimer0
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(56)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	LDI  R30,LOW(1)
	OUT  0x39,R30
	sei
	RET
; .FEND
__NgatToanCuc:
; .FSTART __NgatToanCuc
	ST   -Y,R26
;	TrangThai -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,0
	BRNE _0x6
	BCLR 7
	RJMP _0x5
_0x6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5
	BSET 7
_0x5:
	RJMP _0x2000003
; .FEND
;#include <INT0.h>
__KhoiTaoNgatINT0:
; .FSTART __KhoiTaoNgatINT0
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
	LDI  R30,LOW(2)
	OUT  0x35,R30
	LDI  R30,LOW(0)
	OUT  0x34,R30
	LDI  R30,LOW(64)
	OUT  0x3A,R30
	RET
; .FEND
;
;#define DenXanh11   PORTA.0
;#define DenXanh12   PORTA.6
;#define DenVang11   PORTA.1
;#define DenVang12   PORTA.7
;#define DenDo11     PORTA.2
;#define DenDo12     PORTB.0
;
;#define DenXanh21   PORTA.3
;#define DenXanh22   PORTB.3
;#define DenVang21   PORTA.4
;#define DenVang22   PORTB.2
;#define DenDo21     PORTA.5
;#define DenDo22     PORTB.1
;
;#define MENU        PIND.2
;#define TANG        PIND.5
;#define GIAM        PIND.6
;
;#define COT1        PORTB.4
;#define COT2        PORTB.5
;#define COT3        PORTB.6
;#define COT4        PORTB.7
;#define COT5        PORTD.0
;#define COT6        PORTD.1
;#define COT7        PORTD.3
;#define COT8        PORTD.4
;
;unsigned int Delay = 30;
;signed  char MaLed[]={0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90}; // Anode chung

	.DSEG
;//signed  char MaLed[]={0x3F, 0x06, 0x5B, 0X4F, 0x66, 0x6D, 0x7C, 0x07, 0x7F, 0x6F}; // Cathode chung
;signed char Xanh1 =15,Vang1 =3,Do1;
;signed char Xanh2 =10,Vang2 =3,Do2;
;
;signed char DemXanh1,DemVang1,DemDo1;
;signed char DemXanh2,DemVang2,DemDo2;
;signed char TenDuong=0;
;char CheDo =0,Flag=0;
;signed char CacSo[8];
;unsigned int Dem=0;
;
;//-----------------------CHUONG TRINH CON-----------------------------
;void _TachSo(signed char Dem, signed char *Chuc, signed char *DonVi);
;void _QuetCot(char TenCot);
;void _HienThiLed(signed char CacSo[]);
;void _DenXanh11(void);
;void _DenVang11(void);
;void _DenDo11(void);
;void _DenXanh21(void);
;void _DenVang21(void);
;void _DenDo21(void);
;
;//NGAT INT0
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 003B {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 003C   if((PIND & (1<<PIND2))== 0)
	SBIC 0x10,2
	RJMP _0x9
; 0000 003D   {
; 0000 003E         while((PIND & (1<<PIND2))== 0);
_0xA:
	SBIS 0x10,2
	RJMP _0xA
; 0000 003F         CheDo = CheDo + 1;
	LDS  R30,_CheDo
	SUBI R30,-LOW(1)
	STS  _CheDo,R30
; 0000 0040         if(CheDo > 1)
	LDS  R26,_CheDo
	CPI  R26,LOW(0x2)
	BRLO _0xD
; 0000 0041         {
; 0000 0042             CheDo = 0;
	LDI  R30,LOW(0)
	STS  _CheDo,R30
; 0000 0043         }
; 0000 0044         Flag = 0;
_0xD:
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0000 0045   }
; 0000 0046 }
_0x9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;//NGAT TIMER0
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004A {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004B 
; 0000 004C    Dem++;
	LDI  R26,LOW(_Dem)
	LDI  R27,HIGH(_Dem)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 004D    if(Dem>=5000)
	LDS  R26,_Dem
	LDS  R27,_Dem+1
	CPI  R26,LOW(0x1388)
	LDI  R30,HIGH(0x1388)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0xE
; 0000 004E    {
; 0000 004F      if(CheDo==0)
	LDS  R30,_CheDo
	CPI  R30,0
	BREQ PC+2
	RJMP _0xF
; 0000 0050      {
; 0000 0051         if(Flag==0)
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x10
; 0000 0052         {
; 0000 0053            Do1 = Xanh2 + Vang2;
	MOV  R30,R11
	ADD  R30,R8
	MOV  R9,R30
; 0000 0054            DemDo1 = Do1;
	STS  _DemDo1,R9
; 0000 0055            DemXanh2 = Xanh2+1;
	MOV  R30,R8
	SUBI R30,-LOW(1)
	STS  _DemXanh2,R30
; 0000 0056            DemVang2 = Vang2+1;
	MOV  R30,R11
	SUBI R30,-LOW(1)
	STS  _DemVang2,R30
; 0000 0057            Do2 = Xanh1 + Vang1;
	MOV  R30,R6
	ADD  R30,R7
	MOV  R10,R30
; 0000 0058            DemDo2 = Do2;
	STS  _DemDo2,R10
; 0000 0059            DemXanh1 = Xanh1+1;
	MOV  R30,R7
	SUBI R30,-LOW(1)
	MOV  R13,R30
; 0000 005A            DemVang1 = Vang1+1;
	MOV  R30,R6
	SUBI R30,-LOW(1)
	MOV  R12,R30
; 0000 005B            Flag =1;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0000 005C         }
; 0000 005D         if(TenDuong==0)
_0x10:
	LDS  R30,_TenDuong
	CPI  R30,0
	BRNE _0x11
; 0000 005E         {
; 0000 005F            _DenDo11();
	RCALL __DenDo11
; 0000 0060            if(DemDo1>=0)
	LDS  R26,_DemDo1
	CPI  R26,0
	BRLT _0x12
; 0000 0061            {
; 0000 0062               _TachSo(DemDo1,&CacSo[1],&CacSo[0]);
	LDS  R30,_DemDo1
	ST   -Y,R30
	RCALL SUBOPT_0x0
; 0000 0063               _TachSo(DemDo1,&CacSo[5],&CacSo[4]);
	LDS  R30,_DemDo1
	ST   -Y,R30
	RCALL SUBOPT_0x1
; 0000 0064              DemDo1--;
	LDS  R30,_DemDo1
	SUBI R30,LOW(1)
	STS  _DemDo1,R30
; 0000 0065              if(DemXanh2>=1)
	LDS  R26,_DemXanh2
	CPI  R26,LOW(0x1)
	BRLT _0x13
; 0000 0066              {
; 0000 0067                 DemXanh2--;
	LDS  R30,_DemXanh2
	SUBI R30,LOW(1)
	STS  _DemXanh2,R30
; 0000 0068                 _DenXanh21();
	RCALL __DenXanh21
; 0000 0069                 _TachSo(DemXanh2,&CacSo[3],&CacSo[2]);
	LDS  R30,_DemXanh2
	RCALL SUBOPT_0x2
; 0000 006A                 _TachSo(DemXanh2,&CacSo[7],&CacSo[6]);
	LDS  R30,_DemXanh2
	RCALL SUBOPT_0x3
; 0000 006B              }
; 0000 006C              if(DemXanh2==0)
_0x13:
	LDS  R30,_DemXanh2
	CPI  R30,0
	BRNE _0x14
; 0000 006D              {
; 0000 006E                 if(DemVang2>=1)
	LDS  R26,_DemVang2
	CPI  R26,LOW(0x1)
	BRLT _0x15
; 0000 006F                 {
; 0000 0070                     DemVang2--;
	LDS  R30,_DemVang2
	SUBI R30,LOW(1)
	STS  _DemVang2,R30
; 0000 0071                     _DenVang21();
	RCALL __DenVang21
; 0000 0072                     if(DemVang2==0)
	LDS  R30,_DemVang2
	CPI  R30,0
	BRNE _0x16
; 0000 0073                     {
; 0000 0074                         TenDuong=1;
	LDI  R30,LOW(1)
	STS  _TenDuong,R30
; 0000 0075 
; 0000 0076                     }
; 0000 0077                     _TachSo(DemVang2,&CacSo[3],&CacSo[2]);
_0x16:
	LDS  R30,_DemVang2
	RCALL SUBOPT_0x2
; 0000 0078                     _TachSo(DemVang2,&CacSo[7],&CacSo[6]);
	LDS  R30,_DemVang2
	RCALL SUBOPT_0x3
; 0000 0079                 }
; 0000 007A              }
_0x15:
; 0000 007B 
; 0000 007C            }
_0x14:
; 0000 007D             _HienThiLed(CacSo);
_0x12:
	RJMP _0x155
; 0000 007E         }
; 0000 007F 
; 0000 0080 
; 0000 0081        else if(TenDuong==1)
_0x11:
	LDS  R26,_TenDuong
	CPI  R26,LOW(0x1)
	BRNE _0x18
; 0000 0082         {
; 0000 0083            _DenDo21();
	RCALL __DenDo21
; 0000 0084            if(DemDo2>=0)
	LDS  R26,_DemDo2
	CPI  R26,0
	BRLT _0x19
; 0000 0085            {
; 0000 0086              _TachSo(DemDo2,&CacSo[3],&CacSo[2]);
	LDS  R30,_DemDo2
	RCALL SUBOPT_0x2
; 0000 0087              _TachSo(DemDo2,&CacSo[7],&CacSo[6]);
	LDS  R30,_DemDo2
	RCALL SUBOPT_0x3
; 0000 0088              DemDo2--;
	LDS  R30,_DemDo2
	SUBI R30,LOW(1)
	STS  _DemDo2,R30
; 0000 0089 
; 0000 008A              if(DemXanh1>=1)
	LDI  R30,LOW(1)
	CP   R13,R30
	BRLT _0x1A
; 0000 008B              {
; 0000 008C                 DemXanh1--;
	DEC  R13
; 0000 008D                 _DenXanh11();
	RCALL __DenXanh11
; 0000 008E                 _TachSo(DemXanh1,&CacSo[1],&CacSo[0]);
	ST   -Y,R13
	RCALL SUBOPT_0x0
; 0000 008F                 _TachSo(DemXanh1,&CacSo[5],&CacSo[4]);
	ST   -Y,R13
	RCALL SUBOPT_0x1
; 0000 0090              }
; 0000 0091              if(DemXanh1==0)
_0x1A:
	TST  R13
	BRNE _0x1B
; 0000 0092              {
; 0000 0093                 if(DemVang1>=1)
	LDI  R30,LOW(1)
	CP   R12,R30
	BRLT _0x1C
; 0000 0094                 {
; 0000 0095                     DemVang1--;
	DEC  R12
; 0000 0096                     _DenVang11();
	RCALL __DenVang11
; 0000 0097                     if(DemVang1==0)
	TST  R12
	BRNE _0x1D
; 0000 0098                     {
; 0000 0099                         TenDuong=0;
	LDI  R30,LOW(0)
	STS  _TenDuong,R30
; 0000 009A                         Flag =0;
	STS  _Flag,R30
; 0000 009B                     }
; 0000 009C                     _TachSo(DemVang1,&CacSo[1],&CacSo[0]);
_0x1D:
	ST   -Y,R12
	RCALL SUBOPT_0x0
; 0000 009D                     _TachSo(DemVang1,&CacSo[5],&CacSo[4]);
	ST   -Y,R12
	RCALL SUBOPT_0x1
; 0000 009E                 }
; 0000 009F              }
_0x1C:
; 0000 00A0            }
_0x1B:
; 0000 00A1            _HienThiLed(CacSo);
_0x19:
_0x155:
	LDI  R26,LOW(_CacSo)
	LDI  R27,HIGH(_CacSo)
	RCALL __HienThiLed
; 0000 00A2         }
; 0000 00A3      }
_0x18:
; 0000 00A4      Dem=0;
_0xF:
	LDI  R30,LOW(0)
	STS  _Dem,R30
	STS  _Dem+1,R30
; 0000 00A5    }
; 0000 00A6 
; 0000 00A7    TCNT0 =56;
_0xE:
	LDI  R30,LOW(56)
	OUT  0x32,R30
; 0000 00A8 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;//--------------------------CHUONG TRINH CHINH--------------------------
;void main(void)
; 0000 00AC {
_main:
; .FSTART _main
; 0000 00AD     char i;
; 0000 00AE     //signed char a[8];
; 0000 00AF 
; 0000 00B0     DDRA = 0xFF;
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00B1     DDRB = 0xFF;
	OUT  0x17,R30
; 0000 00B2     DDRC = 0xFF;
	OUT  0x14,R30
; 0000 00B3     DDRD.0 = 1;
	SBI  0x11,0
; 0000 00B4     DDRD.1 = 1;
	SBI  0x11,1
; 0000 00B5     DDRD.3 = 1;
	SBI  0x11,3
; 0000 00B6     DDRD.4 = 1;
	SBI  0x11,4
; 0000 00B7 
; 0000 00B8     DDRD.2 = 0;
	CBI  0x11,2
; 0000 00B9     DDRD.5 = 0;
	CBI  0x11,5
; 0000 00BA     DDRD.6 = 0;
	CBI  0x11,6
; 0000 00BB 
; 0000 00BC     PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00BD     PORTC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00BE     PORTB.0 = 0;
	CBI  0x18,0
; 0000 00BF     PORTB.1 = 0;
	CBI  0x18,1
; 0000 00C0     PORTB.2 = 0;
	CBI  0x18,2
; 0000 00C1     PORTB.3 = 0;
	CBI  0x18,3
; 0000 00C2 
; 0000 00C3     PORTB.4 = 1;
	RCALL SUBOPT_0x4
; 0000 00C4     PORTB.5 = 1;
; 0000 00C5     PORTB.6 = 1;
; 0000 00C6     PORTB.7 = 1;
; 0000 00C7     PORTD.0 = 1;
; 0000 00C8     PORTD.1 = 1;
; 0000 00C9     PORTD.3 = 1;
; 0000 00CA     PORTD.4 = 1;
; 0000 00CB 
; 0000 00CC _KhoiTaoNgatINT0();
	RCALL __KhoiTaoNgatINT0
; 0000 00CD _KhoiTaoTimer0();
	RCALL __KhoiTaoTimer0
; 0000 00CE _NgatToanCuc(1);
	LDI  R26,LOW(1)
	RCALL __NgatToanCuc
; 0000 00CF 
; 0000 00D0 while (1)
_0x44:
; 0000 00D1       {
; 0000 00D2          _HienThiLed(CacSo);
	LDI  R26,LOW(_CacSo)
	LDI  R27,HIGH(_CacSo)
	RCALL __HienThiLed
; 0000 00D3          while(CheDo==1)
_0x47:
	LDS  R26,_CheDo
	CPI  R26,LOW(0x1)
	BRNE _0x49
; 0000 00D4          {
; 0000 00D5                 DenXanh11 =0;
	CBI  0x1B,0
; 0000 00D6                 DenXanh12 = 0;
	CBI  0x1B,6
; 0000 00D7                 DenDo11 = 0;
	CBI  0x1B,2
; 0000 00D8                 DenDo12 = 0;
	CBI  0x18,0
; 0000 00D9                 DenXanh21 = 0;
	CBI  0x1B,3
; 0000 00DA                 DenXanh22 = 0;
	CBI  0x18,3
; 0000 00DB                 DenDo21 = 0;
	CBI  0x1B,5
; 0000 00DC                 DenDo22 = 0;
	CBI  0x18,1
; 0000 00DD 
; 0000 00DE                 DenVang11 = 1;
	SBI  0x1B,1
; 0000 00DF                 DenVang12 = 1;
	SBI  0x1B,7
; 0000 00E0                 DenVang21 = 1;
	SBI  0x1B,4
; 0000 00E1                 DenVang22 = 1;
	SBI  0x18,2
; 0000 00E2                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00E3                 DenVang11 = 0;
	CBI  0x1B,1
; 0000 00E4                 DenVang12 = 0;
	CBI  0x1B,7
; 0000 00E5                 DenVang21 = 0;
	CBI  0x1B,4
; 0000 00E6                 DenVang22 = 0;
	CBI  0x18,2
; 0000 00E7                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00E8          }
	RJMP _0x47
_0x49:
; 0000 00E9       }
	RJMP _0x44
; 0000 00EA }
_0x6A:
	RJMP _0x6A
; .FEND
;
;//-------------------CHUONG TRINH CON-----------------------------
;void _TachSo(signed char Dem, signed char *Chuc, signed char *DonVi)
; 0000 00EE {
__TachSo:
; .FSTART __TachSo
; 0000 00EF     *Chuc = Dem/10;
	ST   -Y,R27
	ST   -Y,R26
;	Dem -> Y+4
;	*Chuc -> Y+2
;	*DonVi -> Y+0
	RCALL SUBOPT_0x5
	CALL __DIVW21
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
; 0000 00F0     *DonVi =Dem%10;
	RCALL SUBOPT_0x5
	CALL __MODW21
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
; 0000 00F1 }
	ADIW R28,5
	RET
; .FEND
;
;void _QuetCot(char TenCot)
; 0000 00F4 {
__QuetCot:
; .FSTART __QuetCot
; 0000 00F5     switch(TenCot)
	ST   -Y,R26
;	TenCot -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00F6     {
; 0000 00F7         case 0:
	SBIW R30,0
	BRNE _0x6E
; 0000 00F8         {
; 0000 00F9             COT1 =1;
	RCALL SUBOPT_0x4
; 0000 00FA             COT2 =1;
; 0000 00FB             COT3 =1;
; 0000 00FC             COT4 =1;
; 0000 00FD             COT5 =1;
; 0000 00FE             COT6 =1;
; 0000 00FF             COT7 =1;
; 0000 0100             COT8 =1;
; 0000 0101             break;
	RJMP _0x6D
; 0000 0102         }
; 0000 0103          case 1:
_0x6E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x7F
; 0000 0104         {
; 0000 0105             COT1 =0;
	CBI  0x18,4
; 0000 0106             COT2 =1;
	RCALL SUBOPT_0x6
; 0000 0107             COT3 =1;
; 0000 0108             COT4 =1;
; 0000 0109             COT5 =1;
; 0000 010A             COT6 =1;
	SBI  0x12,1
; 0000 010B             COT7 =1;
	SBI  0x12,3
; 0000 010C             COT8 =1;
	SBI  0x12,4
; 0000 010D             break;
	RJMP _0x6D
; 0000 010E         }
; 0000 010F          case 2:
_0x7F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x90
; 0000 0110         {
; 0000 0111             COT1 =1;
	SBI  0x18,4
; 0000 0112             COT2 =0;
	CBI  0x18,5
; 0000 0113             COT3 =1;
	SBI  0x18,6
; 0000 0114             COT4 =1;
	SBI  0x18,7
; 0000 0115             COT5 =1;
	RCALL SUBOPT_0x7
; 0000 0116             COT6 =1;
; 0000 0117             COT7 =1;
; 0000 0118             COT8 =1;
; 0000 0119             break;
	RJMP _0x6D
; 0000 011A         }
; 0000 011B          case 3:
_0x90:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA1
; 0000 011C         {
; 0000 011D             COT1 =1;
	SBI  0x18,4
; 0000 011E             COT2 =1;
	SBI  0x18,5
; 0000 011F             COT3 =0;
	CBI  0x18,6
; 0000 0120             COT4 =1;
	SBI  0x18,7
; 0000 0121             COT5 =1;
	RCALL SUBOPT_0x7
; 0000 0122             COT6 =1;
; 0000 0123             COT7 =1;
; 0000 0124             COT8 =1;
; 0000 0125             break;
	RJMP _0x6D
; 0000 0126         }
; 0000 0127          case 4:
_0xA1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB2
; 0000 0128         {
; 0000 0129             COT1 =1;
	SBI  0x18,4
; 0000 012A             COT2 =1;
	SBI  0x18,5
; 0000 012B             COT3 =1;
	SBI  0x18,6
; 0000 012C             COT4 =0;
	CBI  0x18,7
; 0000 012D             COT5 =1;
	RCALL SUBOPT_0x7
; 0000 012E             COT6 =1;
; 0000 012F             COT7 =1;
; 0000 0130             COT8 =1;
; 0000 0131             break;
	RJMP _0x6D
; 0000 0132         }
; 0000 0133          case 5:
_0xB2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0134         {
; 0000 0135             COT1 =1;
	SBI  0x18,4
; 0000 0136             COT2 =1;
	SBI  0x18,5
; 0000 0137             COT3 =1;
	SBI  0x18,6
; 0000 0138             COT4 =1;
	SBI  0x18,7
; 0000 0139             COT5 =0;
	CBI  0x12,0
; 0000 013A             COT6 =1;
	SBI  0x12,1
; 0000 013B             COT7 =1;
	SBI  0x12,3
; 0000 013C             COT8 =1;
	SBI  0x12,4
; 0000 013D             break;
	RJMP _0x6D
; 0000 013E         }
; 0000 013F          case 6:
_0xC3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0140         {
; 0000 0141             COT1 =1;
	SBI  0x18,4
; 0000 0142             COT2 =1;
	RCALL SUBOPT_0x6
; 0000 0143             COT3 =1;
; 0000 0144             COT4 =1;
; 0000 0145             COT5 =1;
; 0000 0146             COT6 =0;
	CBI  0x12,1
; 0000 0147             COT7 =1;
	SBI  0x12,3
; 0000 0148             COT8 =1;
	SBI  0x12,4
; 0000 0149             break;
	RJMP _0x6D
; 0000 014A         }
; 0000 014B          case 7:
_0xD4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xE5
; 0000 014C         {
; 0000 014D             COT1 =1;
	SBI  0x18,4
; 0000 014E             COT2 =1;
	RCALL SUBOPT_0x6
; 0000 014F             COT3 =1;
; 0000 0150             COT4 =1;
; 0000 0151             COT5 =1;
; 0000 0152             COT6 =1;
	SBI  0x12,1
; 0000 0153             COT7 =0;
	CBI  0x12,3
; 0000 0154             COT8 =1;
	SBI  0x12,4
; 0000 0155             break;
	RJMP _0x6D
; 0000 0156         }
; 0000 0157          case 8:
_0xE5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x6D
; 0000 0158         {
; 0000 0159             COT1 =1;
	SBI  0x18,4
; 0000 015A             COT2 =1;
	RCALL SUBOPT_0x6
; 0000 015B             COT3 =1;
; 0000 015C             COT4 =1;
; 0000 015D             COT5 =1;
; 0000 015E             COT6 =1;
	SBI  0x12,1
; 0000 015F             COT7 =1;
	SBI  0x12,3
; 0000 0160             COT8 =0;
	CBI  0x12,4
; 0000 0161             break;
; 0000 0162         }
; 0000 0163     }
_0x6D:
; 0000 0164 }
_0x2000003:
	ADIW R28,1
	RET
; .FEND
;
;void _HienThiLed(signed char CacSo[])
; 0000 0167 {
__HienThiLed:
; .FSTART __HienThiLed
; 0000 0168     signed char a[8];
; 0000 0169     char i;
; 0000 016A 
; 0000 016B     for(i=0;i<=7;i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	ST   -Y,R17
;	CacSo -> Y+9
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x108:
	CPI  R17,8
	BRSH _0x109
; 0000 016C     {
; 0000 016D         a[i] =MaLed[CacSo[i]];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_MaLed)
	SBCI R31,HIGH(-_MaLed)
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 016E     }
	SUBI R17,-1
	RJMP _0x108
_0x109:
; 0000 016F 
; 0000 0170     for(i=0;i<=7;i++)
	LDI  R17,LOW(0)
_0x10B:
	CPI  R17,8
	BRSH _0x10C
; 0000 0171     {
; 0000 0172         PORTC =a[i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
; 0000 0173         _QuetCot(i+1);
	MOV  R26,R17
	SUBI R26,-LOW(1)
	RCALL __QuetCot
; 0000 0174         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0175         _QuetCot(0);
	LDI  R26,LOW(0)
	RCALL __QuetCot
; 0000 0176     }
	SUBI R17,-1
	RJMP _0x10B
_0x10C:
; 0000 0177 }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND
;
;void _DenXanh11(void)
; 0000 017A {
__DenXanh11:
; .FSTART __DenXanh11
; 0000 017B    DenXanh11 =1;
	SBI  0x1B,0
; 0000 017C    DenXanh12 =1;
	SBI  0x1B,6
; 0000 017D    DenVang11 =0;
	CBI  0x1B,1
; 0000 017E    DenVang12 =0;
	CBI  0x1B,7
; 0000 017F    DenDo11 =0;
	RJMP _0x2000002
; 0000 0180    DenDo12 =0;
; 0000 0181 }
; .FEND
;void _DenVang11(void)
; 0000 0183 {
__DenVang11:
; .FSTART __DenVang11
; 0000 0184    DenXanh11 =0;
	CBI  0x1B,0
; 0000 0185    DenXanh12 =0;
	CBI  0x1B,6
; 0000 0186    DenVang11 =1;
	SBI  0x1B,1
; 0000 0187    DenVang12 =1;
	SBI  0x1B,7
; 0000 0188    DenDo11 =0;
_0x2000002:
	CBI  0x1B,2
; 0000 0189    DenDo12 =0;
	CBI  0x18,0
; 0000 018A }
	RET
; .FEND
;void _DenDo11(void)
; 0000 018C {
__DenDo11:
; .FSTART __DenDo11
; 0000 018D    DenXanh11 =0;
	CBI  0x1B,0
; 0000 018E    DenXanh12 =0;
	CBI  0x1B,6
; 0000 018F    DenVang11 =0;
	CBI  0x1B,1
; 0000 0190    DenVang12 =0;
	CBI  0x1B,7
; 0000 0191    DenDo11 =1;
	SBI  0x1B,2
; 0000 0192    DenDo12 =1;
	SBI  0x18,0
; 0000 0193 }
	RET
; .FEND
;void _DenXanh21(void)
; 0000 0195 {
__DenXanh21:
; .FSTART __DenXanh21
; 0000 0196     DenXanh21 =1;
	SBI  0x1B,3
; 0000 0197     DenXanh22 =1;
	SBI  0x18,3
; 0000 0198     DenVang21 =0;
	CBI  0x1B,4
; 0000 0199     DenVang22 =0;
	CBI  0x18,2
; 0000 019A     DenDo21 =0;
	RJMP _0x2000001
; 0000 019B     DenDo22 =0;
; 0000 019C }
; .FEND
;void _DenVang21(void)
; 0000 019E {
__DenVang21:
; .FSTART __DenVang21
; 0000 019F     DenXanh21 =0;
	CBI  0x1B,3
; 0000 01A0     DenXanh22 =0;
	CBI  0x18,3
; 0000 01A1     DenVang21 =1;
	SBI  0x1B,4
; 0000 01A2     DenVang22 =1;
	SBI  0x18,2
; 0000 01A3     DenDo21 =0;
_0x2000001:
	CBI  0x1B,5
; 0000 01A4     DenDo22 =0;
	CBI  0x18,1
; 0000 01A5 }
	RET
; .FEND
;void _DenDo21(void)
; 0000 01A7 {
__DenDo21:
; .FSTART __DenDo21
; 0000 01A8     DenXanh21 =0;
	CBI  0x1B,3
; 0000 01A9     DenXanh22 =0;
	CBI  0x18,3
; 0000 01AA     DenVang21 =0;
	CBI  0x1B,4
; 0000 01AB     DenVang22 =0;
	CBI  0x18,2
; 0000 01AC     DenDo21 =1;
	SBI  0x1B,5
; 0000 01AD     DenDo22 =1;
	SBI  0x18,1
; 0000 01AE }
	RET
; .FEND

	.DSEG
_MaLed:
	.BYTE 0xA
_DemDo1:
	.BYTE 0x1
_DemXanh2:
	.BYTE 0x1
_DemVang2:
	.BYTE 0x1
_DemDo2:
	.BYTE 0x1
_TenDuong:
	.BYTE 0x1
_CheDo:
	.BYTE 0x1
_Flag:
	.BYTE 0x1
_CacSo:
	.BYTE 0x8
_Dem:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	__POINTW1MN _CacSo,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_CacSo)
	LDI  R27,HIGH(_CacSo)
	RJMP __TachSo

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	__POINTW1MN _CacSo,5
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _CacSo,4
	RJMP __TachSo

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	__POINTW1MN _CacSo,3
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _CacSo,2
	RJMP __TachSo

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	__POINTW1MN _CacSo,7
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _CacSo,6
	RJMP __TachSo

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	SBI  0x18,4
	SBI  0x18,5
	SBI  0x18,6
	SBI  0x18,7
	SBI  0x12,0
	SBI  0x12,1
	SBI  0x12,3
	SBI  0x12,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDD  R26,Y+4
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	SBI  0x18,5
	SBI  0x18,6
	SBI  0x18,7
	SBI  0x12,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	SBI  0x12,0
	SBI  0x12,1
	SBI  0x12,3
	SBI  0x12,4
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:
