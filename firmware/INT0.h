#define _NgatINT0_h_
#include <mega16a.h>

//--------CHUONG TRINH CON----------
void _KhoiTaoNgatINT0(void);
//interrupt [EXT_INT0] void ext_int0_isr(void)
//--------VIET CHUONG TRINH CON-----
void _KhoiTaoNgatINT0(void)
{
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Falling Edge
    // INT1: Off
    // INT2: Off
    GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
    MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);
    GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);  
}