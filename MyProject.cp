#line 1 "C:/Users/20190632/Desktop/New folder/MyProject.c"
unsigned int i;
unsigned int j;
unsigned int Wmotor;
unsigned int read=0;



unsigned char location;
unsigned char balval[6];
unsigned bal=0;
unsigned char Sel;

unsigned int mstep;
#line 44 "C:/Users/20190632/Desktop/New folder/MyProject.c"
void LCD_command(unsigned char);
void LCD_initialize();
void LCD_String_xy (unsigned char ,unsigned char ,unsigned char *);
void LCD_String (unsigned char *);
void LCD_Char (unsigned char );
void LCD_Clear();


void keyinit();
unsigned char key();
unsigned char keypad[4][3]={{'1','2','3'},{'4','5','6'},{'7','8','9'},{'*','0','#'}};
unsigned char rowloc,colloc;


void full_drive (unsigned char,unsigned int );


void Delay_ms(unsigned int );
void Delay_us(unsigned int microseconds);
void servo_position(int degrees);
void pwm_init();


void LCD_Initialize ()
{
  TRISD  = 0x00;
 delay_ms(20);
#line 72 "C:/Users/20190632/Desktop/New folder/MyProject.c"
 LCD_Command(0x02);
#line 74 "C:/Users/20190632/Desktop/New folder/MyProject.c"
 LCD_Command(0x28);
 LCD_Command(0x01);
 LCD_Command(0x0c);
 LCD_Command(0x06);
}
void LCD_command(unsigned char cmnd)
 {
  PORTD  = ( PORTD  & 0x0f) |(0xF0 & cmnd);
  RD0_bit  = 0;
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 Delay_ms(1);
  PORTD  = ( PORTD  & 0x0f) | (cmnd<<4);
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 Delay_ms(3);
 }
void LCD_String_xy (unsigned char row,unsigned char pos,unsigned char *str)
{
 location=0;
 if(row<=1)
 {
 location=(0x80) | ((pos) & 0x0f);
 LCD_Command(location);
 }
 else
 {
 location=(0xC0) | ((pos) & 0x0f);
 LCD_Command(location);
 }
 LCD_String(str);

}

void LCD_String (unsigned char *str)
{
 while((*str)!=0)
 {
 LCD_Char(*str);
 str++;
 }
}

void LCD_Char (unsigned char chardata)
{
  PORTD  = ( PORTD  & 0x0f) | (0xF0 & chardata);
  RD0_bit  = 1;
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 Delay_ms(1);
  PORTD  = ( PORTD  & 0x0f) | (chardata<<4);
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 Delay_ms(3);
}


 void LCD_Clear()
{
 LCD_Command(0x01);
 Delay_ms(3);
}


 void keyinit()
{
 TRISB=0XF0;
 OPTION_REG&=0X7F;
}
unsigned char key()
{
 PORTB=0X00;
 while(! RB4_bit ||! RB5_bit ||! RB6_bit ) {
  RB0_bit =0;
  RB1_bit = RB2_bit = RB3_bit =1;
 if(! RB4_bit ||! RB5_bit ||! RB6_bit ) {
 Delay_ms(100);
 rowloc=0;
 break;
 }
  RB1_bit =0; RB0_bit =1;
 if(! RB4_bit ||! RB5_bit ||! RB6_bit ) {
 Delay_ms(100);
 rowloc=1;
 break;
 }
  RB2_bit =0; RB1_bit =1;
 if(! RB4_bit ||! RB5_bit ||! RB6_bit ) {
 Delay_ms(100);
 rowloc=2;
 break;
 }
  RB3_bit =0;  RB2_bit =1;
 if(! RB4_bit ||! RB5_bit ||! RB6_bit ){
 Delay_ms(100);
 rowloc=3;
 break;
 }
 }
 if( RB4_bit ==0&& RB5_bit !=0&& RB6_bit !=0)
 {
 Delay_ms(100);
 colloc=0;
 }
 else if( RB4_bit !=0&& RB5_bit ==0&& RB6_bit !=0)
 {
 Delay_ms(100);
 colloc=1;
 }
 else if( RB4_bit !=0&& RB5_bit !=0&& RB6_bit ==0)
 {
 Delay_ms(100);
 colloc=2;
 }

 while( RB4_bit ==0|| RB5_bit ==0|| RB6_bit ==0);
 return (keypad[rowloc][colloc]);
}


void stepper_drive (unsigned char direction,unsigned int Wmot){
 if(Wmot==1)
 {
 if (direction ==  0 ){
 PORTA = 0b00001001;
 Delay_ms( 2 );
 PORTA = 0b00001100;
 Delay_ms( 2 );
 PORTA = 0b00000110;
 Delay_ms( 2 );
 PORTA = 0b00000011;
 Delay_ms( 2 );
 PORTA = 0b00001001;
 Delay_ms( 2 );
 }
 }
 else if(Wmot==2)
 {
 if (direction ==  0 ){
 PORTC = 0b10010000;
 Delay_ms( 2 );
 PORTC = 0b11000000;
 Delay_ms( 2 );
 PORTC = 0b01100000;
 Delay_ms( 2 );
 PORTC = 0b00110000;
 Delay_ms( 2 );
 PORTC = 0b10010000;
 Delay_ms( 2 );
 }
 }

}



void pwm_init() {
 TRISC2_bit = 0;
 CCP1M3_bit = 1;
 CCP1M2_bit = 1;
 CCP1M1_bit = 0;
 CCP1M0_bit = 0;
 CCP1X_bit = 0;
 CCP1Y_bit = 0;
 T2CKPS0_bit = 1;
 T2CKPS1_bit = 1;
 TMR2ON_bit = 1;
 PR2 = 249;
}


void Delay_us(unsigned int microseconds) {
 unsigned int i;

 while (microseconds--) {
 for (i = 0; i < 12; i++) {
 asm nop;
 }
 }
}


void Delay_ms(unsigned int milliseconds) {
 unsigned int i;

 while (milliseconds--) {
 for (i = 0; i < 238; i++) {
 Delay_us(1000);
 }
 }
}


void servo_position(int degrees) {
 int pulse_width = (degrees + 90) * 8 + 500;
 CCPR1L = pulse_width >> 2;
 CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4);
 Delay_ms(50*4);
}





void main() {

 pwm_init();


 mstep=0;

 ADCON1 = 0x06;
 TRISC = 0x00;
 PORTC = 0xFF;
 TRISA = 0x00;
 PORTA = 0x0F;



 TRISE = TRISE | 0x03;


 LCD_Initialize();


 keyinit();
 servo_position(0);
 while(1)
 {
 LCD_String_xy(2,0,"Balance:");
 if(bal==0)
 {LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char('0');}
 else
 {WordToStr(bal,balval);
 LCD_String_xy(2,7,balval);}
 LCD_String_xy(1,0,"Item(1,2):");
 LCD_command(0x0F);
 while( RB4_bit && RB5_bit && RB6_bit )
 {
 if( PORTE.RE1 ==0)
 {
 bal=bal+5;
 WordToStr(bal,balval);
 LCD_String_xy(2,7,balval);
 LCD_String_xy(1,9,":");
 read=1;
 if(read==1)
 {
 Delay_ms(1000);
 read=0;
 }
 }

 if( PORTE.RE0 ==0)
 {
 Delay_ms(600);
 bal=bal+50;
 WordToStr(bal,balval);
 LCD_String_xy(2,7,balval);
 LCD_String_xy(1,9,":");
 read=1;
 if(read==1)
 {
 Delay_ms(1000);
 read=0;
 }
 }


 }
 Sel=key();


 if(Sel=='1'||Sel=='2'||Sel=='3'||Sel=='*')
 {
 LCD_String_xy(1,9,":");
 LCD_Char(Sel);
 }

 if(sel=='1')
 {
 LCD_command(0x0C);
 Delay_ms(500);
 LCD_clear();

 while(1)
 {
 LCD_String_xy(1,0,"Item1:5 Piasters");
 LCD_String_xy(2,0,"Balance:");
 if(bal==0)
 {
 LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char('0');}
 else
 {LCD_String_xy(2,7,balval);}
 if(bal>=5)
 {
 Wmotor=1;
 Delay_us(5000);
 bal=bal-5;
 Delay_ms(2500);
 LCD_clear();
 LCD_String_xy(1,0,"Please wait..");
 for (mstep=0;mstep< 1080 ;mstep++)
 {
 stepper_drive( 0 ,Wmotor);
 }
 Delay_ms(500);
 LCD_Clear();
 servo_position(90);
 Delay_ms(10000);
 servo_position(0);

 break;
 }
 PortB=0x00;
 while( RB4_bit && RB5_bit && RB6_bit );
 Sel=key();
 if(sel=='*'){
 LCD_clear();
 break;}
 }
 }

 else if (sel=='2')
 {
 LCD_command(0x0C);
 Delay_ms(500);
 LCD_clear();
 while(1)
 {
 LCD_String_xy(1,0,"Item2:50 Piasters");
 LCD_String_xy(2,0,"Balance:");
 if(bal==0)
 {
 LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char(' ');
 LCD_char('0');}
 else
 {LCD_String_xy(2,7,balval);}
 if(bal>=50)
 {
 Wmotor=2;
 Delay_us(5000);
 bal=bal-50;
 Delay_ms(2500);
 LCD_clear();
 LCD_String_xy(1,0,"Please wait..");
 for (mstep=0;mstep< 1080 ;mstep++)
 {
 stepper_drive( 0 ,Wmotor);
 }
 Delay_ms(500);
 LCD_clear();
 servo_position(90);
 Delay_ms(10000);
 servo_position(0);
 break;
 }
 PortB=0x00;
 while( RB4_bit && RB5_bit && RB6_bit );
 Sel=key();
 if(sel=='*'){
 LCD_clear();
 break;}
 }
 }


 Delay_ms(100);
 PortB=0x00;
 }

}
