#define _Timer_h_
#include <mega16a.h>

//---------CHUONG TRINH CON------------------
void _KhoiTaoTimer0(void);
void _KhoiTaoTimer1(void);
void _KhoiTaoTimer2(void);
void _NgatToanCuc(char TrangThai);
//interrupt [TIM0_OVF] void timer0_ovf_isr(void)
//interrupt [TIM1_OVF] void timer1_ovf_isr(void)
//interrupt [TIM2_OVF] void timer2_ovf_isr(void)
//---------VIET CHUONG TRINH CON------------
void _KhoiTaoTimer0(void)
{
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 1000.000 kHz
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    // Timer Period: 0.256 ms         
    // Chon prescaler la 8
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
    TCNT0=56;//set gia tri dem bat dau la 56
    OCR0=0x00;
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    //cho phep ngat khi co tran xay ra
    // Global enable interrupts
    #asm("sei")
    //SREG.7 =1;
}
void _KhoiTaoTimer1(void)
{
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10); 
    //chon bo ti le Presclar
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
    //TCNT1H=0x00;
    TCNT1=15536;//bat dau dem tu gia tri nay 
    //TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
    //cho phep ngat khi co tran xay ra
    // Global enable interrupts
    #asm("sei")
    //SREG.7 =1;
}
void _KhoiTaoTimer2(void)
{
    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 1000.000 kHz
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    // Timer Period: 0.256 ms
    ASSR=0<<AS2;                  
    //chon bo ti le Prescler
    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
    //set gia tri dem ban dau cho timer
    TCNT2=56;
    OCR2=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
    //cho phep ngat khi tran xay ra
    // Global enable interrupts
    #asm("sei")  
    //SREG.7 =1;
}
void _NgatToanCuc(char TrangThai)
{
    switch(TrangThai)
    {
        case 0:
        {
           SREG.7 =0;//xoa ngat toan cuc
           break; 
        }
        case 1:
        {
           SREG.7 =1;//cho phep ngat toan cuc
           break; 
        }
    }
}