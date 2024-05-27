#include <mega16a.h>
#include <delay.h>
#include <Timer.h>
#include <INT0.h>

#define DenXanh11   PORTA.0
#define DenXanh12   PORTA.6
#define DenVang11   PORTA.1
#define DenVang12   PORTA.7
#define DenDo11     PORTA.2
#define DenDo12     PORTB.0

#define DenXanh21   PORTA.3
#define DenXanh22   PORTB.3
#define DenVang21   PORTA.4
#define DenVang22   PORTB.2
#define DenDo21     PORTA.5
#define DenDo22     PORTB.1

#define MENU        PIND.2
#define TANG        PIND.5
#define GIAM        PIND.6

#define COT1        PORTB.4
#define COT2        PORTB.5
#define COT3        PORTB.6
#define COT4        PORTB.7
#define COT5        PORTD.0
#define COT6        PORTD.1
#define COT7        PORTD.3
#define COT8        PORTD.4

unsigned int Delay = 30;
signed  char MaLed[]={0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90}; // Anode chung
//signed  char MaLed[]={0x3F, 0x06, 0x5B, 0X4F, 0x66, 0x6D, 0x7C, 0x07, 0x7F, 0x6F}; // Cathode chung
signed char Xanh1 =15,Vang1 =3,Do1;
signed char Xanh2 =10,Vang2 =3,Do2;

signed char DemXanh1,DemVang1,DemDo1;
signed char DemXanh2,DemVang2,DemDo2;
signed char TenDuong=0;
char CheDo =0,Flag=0;
signed char CacSo[8];
unsigned int Dem=0;

//-----------------------CHUONG TRINH CON-----------------------------
void _TachSo(signed char Dem, signed char *Chuc, signed char *DonVi);
void _QuetCot(char TenCot);
void _HienThiLed(signed char CacSo[]);
void _DenXanh11(void);
void _DenVang11(void);
void _DenDo11(void);
void _DenXanh21(void);
void _DenVang21(void);
void _DenDo21(void);

//NGAT INT0
interrupt [EXT_INT0] void ext_int0_isr(void)
{
  if((PIND & (1<<PIND2))== 0)
  { 
        while((PIND & (1<<PIND2))== 0);
        CheDo = CheDo + 1; 
        if(CheDo > 1)
        {
            CheDo = 0;
        }
        Flag = 0;
  }
} 

//NGAT TIMER0
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
   
   Dem++;
   if(Dem>=5000)
   {
     if(CheDo==0)
     {
        if(Flag==0)
        {
           Do1 = Xanh2 + Vang2;
           DemDo1 = Do1;
           DemXanh2 = Xanh2+1;
           DemVang2 = Vang2+1;
           Do2 = Xanh1 + Vang1;
           DemDo2 = Do2;
           DemXanh1 = Xanh1+1;
           DemVang1 = Vang1+1;
           Flag =1;  
        }
        if(TenDuong==0)
        {
           _DenDo11();
           if(DemDo1>=0) 
           {
              _TachSo(DemDo1,&CacSo[1],&CacSo[0]);  
              _TachSo(DemDo1,&CacSo[5],&CacSo[4]);
             DemDo1--; 
             if(DemXanh2>=1)
             {
                DemXanh2--;
                _DenXanh21();
                _TachSo(DemXanh2,&CacSo[3],&CacSo[2]);
                _TachSo(DemXanh2,&CacSo[7],&CacSo[6]);
             }
             if(DemXanh2==0)
             {
                if(DemVang2>=1)
                {
                    DemVang2--;
                    _DenVang21();
                    if(DemVang2==0)
                    {
                        TenDuong=1; 
                        
                    }
                    _TachSo(DemVang2,&CacSo[3],&CacSo[2]);  
                    _TachSo(DemVang2,&CacSo[7],&CacSo[6]);
                }
             }
             
           }
            _HienThiLed(CacSo);
        }
        
        
       else if(TenDuong==1) 
        {
           _DenDo21();
           if(DemDo2>=0) 
           {
             _TachSo(DemDo2,&CacSo[3],&CacSo[2]);  
             _TachSo(DemDo2,&CacSo[7],&CacSo[6]);
             DemDo2--;
              
             if(DemXanh1>=1)
             {
                DemXanh1--;
                _DenXanh11();
                _TachSo(DemXanh1,&CacSo[1],&CacSo[0]);
                _TachSo(DemXanh1,&CacSo[5],&CacSo[4]);
             }
             if(DemXanh1==0)
             {
                if(DemVang1>=1)
                {
                    DemVang1--;
                    _DenVang11();
                    if(DemVang1==0)
                    {
                        TenDuong=0;  
                        Flag =0;
                    }
                    _TachSo(DemVang1,&CacSo[1],&CacSo[0]);  
                    _TachSo(DemVang1,&CacSo[5],&CacSo[4]);
                }
             }   
           }
           _HienThiLed(CacSo);   
        }
     }
     Dem=0;
   }
   
   TCNT0 =56;  
}
 
//--------------------------CHUONG TRINH CHINH--------------------------
void main(void)
{
    char i;
    //signed char a[8];  
    
    DDRA = 0xFF;
    DDRB = 0xFF;
    DDRC = 0xFF;
    DDRD.0 = 1;
    DDRD.1 = 1;
    DDRD.3 = 1;
    DDRD.4 = 1;

    DDRD.2 = 0;
    DDRD.5 = 0;
    DDRD.6 = 0;

    PORTA = 0x00;
    PORTC = 0xFF;
    PORTB.0 = 0;
    PORTB.1 = 0;
    PORTB.2 = 0;
    PORTB.3 = 0;    

    PORTB.4 = 1;
    PORTB.5 = 1;
    PORTB.6 = 1;
    PORTB.7 = 1;
    PORTD.0 = 1;
    PORTD.1 = 1;
    PORTD.3 = 1;
    PORTD.4 = 1;

_KhoiTaoNgatINT0();
_KhoiTaoTimer0();
_NgatToanCuc(1);

while (1)
      {
         _HienThiLed(CacSo);  
         while(CheDo==1)
         {
                DenXanh11 =0;
                DenXanh12 = 0;
                DenDo11 = 0;
                DenDo12 = 0;
                DenXanh21 = 0;
                DenXanh22 = 0;
                DenDo21 = 0;
                DenDo22 = 0;

                DenVang11 = 1;
                DenVang12 = 1;
                DenVang21 = 1;
                DenVang22 = 1;                
                delay_ms(1000);
                DenVang11 = 0;
                DenVang12 = 0;
                DenVang21 = 0;
                DenVang22 = 0;
                delay_ms(1000);
         }
      }
}

//-------------------CHUONG TRINH CON-----------------------------
void _TachSo(signed char Dem, signed char *Chuc, signed char *DonVi)
{
    *Chuc = Dem/10;
    *DonVi =Dem%10;
}

void _QuetCot(char TenCot)
{
    switch(TenCot)
    {
        case 0:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        } 
         case 1:
        {
            COT1 =0;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 2:
        {
            COT1 =1;
            COT2 =0;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 3:
        {
            COT1 =1;
            COT2 =1;
            COT3 =0;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 4:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =0;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 5:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =0;
            COT6 =1;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 6:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =0;
            COT7 =1;
            COT8 =1;
            break;
        }
         case 7:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =0;
            COT8 =1;
            break;
        }
         case 8:
        {
            COT1 =1;
            COT2 =1;
            COT3 =1;
            COT4 =1;
            COT5 =1;
            COT6 =1;
            COT7 =1;
            COT8 =0;
            break;
        }
    }
}

void _HienThiLed(signed char CacSo[])
{
    signed char a[8];
    char i;
    
    for(i=0;i<=7;i++)
    {
        a[i] =MaLed[CacSo[i]];
    }
    
    for(i=0;i<=7;i++)
    {
        PORTC =a[i];
        _QuetCot(i+1);
        delay_ms(1);
        _QuetCot(0);
    }
}

void _DenXanh11(void)
{
   DenXanh11 =1;
   DenXanh12 =1;
   DenVang11 =0;
   DenVang12 =0;
   DenDo11 =0;
   DenDo12 =0; 
}
void _DenVang11(void)
{
   DenXanh11 =0;
   DenXanh12 =0;
   DenVang11 =1;
   DenVang12 =1;
   DenDo11 =0;
   DenDo12 =0;  
}
void _DenDo11(void)
{
   DenXanh11 =0;
   DenXanh12 =0;
   DenVang11 =0;
   DenVang12 =0;
   DenDo11 =1;
   DenDo12 =1; 
}
void _DenXanh21(void)
{
    DenXanh21 =1;
    DenXanh22 =1;
    DenVang21 =0;
    DenVang22 =0;
    DenDo21 =0;
    DenDo22 =0;
}
void _DenVang21(void)
{
    DenXanh21 =0;
    DenXanh22 =0;
    DenVang21 =1;
    DenVang22 =1;
    DenDo21 =0;
    DenDo22 =0;
}
void _DenDo21(void)
{
    DenXanh21 =0;
    DenXanh22 =0;
    DenVang21 =0;
    DenVang22 =0;
    DenDo21 =1;
    DenDo22 =1;
}