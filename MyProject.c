unsigned int i;
unsigned int j;
unsigned int Wmotor;
unsigned int read=0;
//Wmotor 1 is for PORTA 0x0F

//Wmotor 2 is for PORTC 0x0F
unsigned char location;
unsigned char balval[6];
unsigned bal=0;//Credits
unsigned char Sel;//3Decimal points
//Counting for motor
unsigned int mstep;


//Define IR sensors
#define IR2 PORTE.RE0
#define IR1 PORTE.RE1

// Define Stepper variables
#define speed 2 // Speed Range 10 to 1  10 = lowest , 1 = highest
#define steps 1080 // how much step it will take
#define clockwise 0 // clockwise direction macro
#define anti_clockwise 1 // anti clockwise direction macro

// Start Lcd module connections
#define RS RD0_bit  /*PIN 0 of PORTB is assigned for register select Pin of LCD*/
#define EN RD1_bit  /*PIN 1 of PORTB is assigned for enable Pin of LCD */
#define ldata PORTD  /*PORTB(PB4-PB7) D4-D7 is assigned for LCD Data Output*/
#define LCD_Port TRISD  /*define macros for PORTB Direction Register*/

// Start Keypad module connections
#define R1 RB0_bit
#define R2 RB1_bit
#define R3 RB2_bit
#define R4 RB3_bit
#define C1 RB4_bit
#define C2 RB5_bit
#define C3 RB6_bit
#define C4 RB7_bit


//LCD functions
void LCD_command(unsigned char);
void LCD_initialize();
void LCD_String_xy (unsigned char ,unsigned char ,unsigned char *);
void LCD_String (unsigned char *);
void LCD_Char (unsigned char );
void LCD_Clear();

//Keypad functions
void keyinit();
unsigned char key();
unsigned char keypad[4][3]={{'1','2','3'},{'4','5','6'},{'7','8','9'},{'*','0','#'}};
unsigned char rowloc,colloc;

//Stepper functions
void full_drive (unsigned char,unsigned int );

//Delay function
void Delay_ms(unsigned int );
void Delay_us(unsigned int microseconds);
void servo_position(int degrees);
void pwm_init();

//Start of LCD functions
void LCD_Initialize () /* LCD Initialize function */
{
    LCD_Port = 0x00;       /*PORT as Output Port*/
    delay_ms(20);        /*15ms,16x2 LCD Power on delay*/
    LCD_Command(0x02);  /*send for initialization of LCD
                          for nibble (4-bit) mode */
    LCD_Command(0x28);  /*use 2 line and
                          initialize 5*8 matrix in (4-bit mode)*/
    LCD_Command(0x01);  /*clear display screen*/
    LCD_Command(0x0c);  /*display on cursor off*/
    LCD_Command(0x06);  /*increment cursor (shift cursor to right)*/
}
void LCD_command(unsigned char cmnd)
 {
    ldata = (ldata & 0x0f) |(0xF0 & cmnd);  /*Send higher nibble of command first to PORT*/
        RS = 0;  /*Command Register is selected i.e.RS=0*/
        EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
        asm NOP;
        EN = 0;
        Delay_ms(1);
    ldata = (ldata & 0x0f) | (cmnd<<4);  /*Send lower nibble of command to PORT */
        EN = 1;
        asm NOP;
        EN = 0;
        Delay_ms(3);
 }
void LCD_String_xy (unsigned char row,unsigned char pos,unsigned char *str) /* Send string to LCD function */
{
    location=0;
    if(row<=1)
    {
        location=(0x80) | ((pos) & 0x0f);  /*Print message on 1st row and desired location*/
        LCD_Command(location);
    }
    else
    {
        location=(0xC0) | ((pos) & 0x0f);  /*Print message on 2nd row and desired location*/
        LCD_Command(location);
    }
    LCD_String(str);

}

void LCD_String (unsigned char *str) /* Send string to LCD function */
{
   while((*str)!=0)
        {
          LCD_Char(*str);
          str++;
        }
}

void LCD_Char (unsigned char chardata) /* LCD data write function */
{
        ldata = (ldata & 0x0f) | (0xF0 & chardata);  /*Send higher nibble of data first to PORT*/
        RS = 1;  /*Data Register is selected*/
        EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
        asm NOP;
        EN = 0;
        Delay_ms(1);
        ldata = (ldata & 0x0f) | (chardata<<4);  /*Send lower nibble of data to PORT*/
        EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
        asm NOP;
        EN = 0;
        Delay_ms(3);
}


 void LCD_Clear()
{
    LCD_Command(0x01);  /*clear display screen*/
    Delay_ms(3);
}

//Start of Keypad functions
 void keyinit()
{
    TRISB=0XF0;
    OPTION_REG&=0X7F;   //ENABLE WEAK PULL UP resistors for he keypad
}
unsigned char key()
{
    PORTB=0X00;
    while(!C1||!C2||!C3) {
        R1=0;
        R2=R3=R4=1;
        if(!C1||!C2||!C3) {
        Delay_ms(100);
            rowloc=0;
            break;
        }
        R2=0;R1=1;
        if(!C1||!C2||!C3) {
        Delay_ms(100);
            rowloc=1;
            break;
        }
        R3=0;R2=1;
        if(!C1||!C2||!C3) {
        Delay_ms(100);
            rowloc=2;
            break;
        }
        R4=0; R3=1;
        if(!C1||!C2||!C3){
        Delay_ms(100);
            rowloc=3;
            break;
        }
    }
    if(C1==0&&C2!=0&&C3!=0)
    {
            Delay_ms(100);
            colloc=0;
    }
    else if(C1!=0&&C2==0&&C3!=0)
    {
            Delay_ms(100);
            colloc=1;
    }
    else if(C1!=0&&C2!=0&&C3==0)
    {
            Delay_ms(100);
            colloc=2;
    }

    while(C1==0||C2==0||C3==0);
    return (keypad[rowloc][colloc]);
}

//Start of Stepper motor functions
void stepper_drive (unsigned char direction,unsigned int Wmot){
    if(Wmot==1)
    {
    if (direction == clockwise){
        PORTA = 0b00001001;
        Delay_ms(speed);
        PORTA = 0b00001100;
        Delay_ms(speed);
        PORTA = 0b00000110;
        Delay_ms(speed);
        PORTA = 0b00000011;
        Delay_ms(speed);
        PORTA = 0b00001001;
        Delay_ms(speed);
          }
       }
    else if(Wmot==2)
    {
    if (direction == clockwise){
        PORTC = 0b10010000;
        Delay_ms(speed);
        PORTC = 0b11000000;
        Delay_ms(speed);
        PORTC = 0b01100000;
        Delay_ms(speed);
        PORTC = 0b00110000;
        Delay_ms(speed);
        PORTC = 0b10010000;
        Delay_ms(speed);
          }
       }

}
//End of stepper motor functions

// pwm
void pwm_init() {
    TRISC2_bit = 0; // Set RC2 pin as output
    CCP1M3_bit = 1; // Configure CCP1 module for PWM
    CCP1M2_bit = 1;
    CCP1M1_bit = 0;
    CCP1M0_bit = 0;
    CCP1X_bit = 0;
    CCP1Y_bit = 0;
    T2CKPS0_bit = 1; // Set Timer2 prescaler to 16
    T2CKPS1_bit = 1;
    TMR2ON_bit = 1; // Enable Timer2
    PR2 = 249; // Set period register for 50Hz frequency
}

//delay function
void Delay_us(unsigned int microseconds) {
    unsigned int i;

    while (microseconds--) {
        for (i = 0; i < 12; i++) {
            asm nop;
        }
    }
}

//delay function 2
void Delay_ms(unsigned int milliseconds) {
    unsigned int i;

    while (milliseconds--) {
        for (i = 0; i < 238; i++) {
            Delay_us(1000);
        }
    }
}

//servo motor function
void servo_position(int degrees) {
    int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
    CCPR1L = pulse_width >> 2; // Set CCPR1L register
    CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
    Delay_ms(50*4); // Delay for the servo to reach the desired position
}


    /*   ----------------------------------  Start of main   ---------------------------------- */


void main() {

        pwm_init(); // Initialize PWM module

     //Stepper motor counting variable
     mstep=0;
     //CMCON = 0x07; // To turn off comparators
     ADCON1 = 0x06; // To turn off analog to digital converters (Make all digital)
     TRISC = 0x00; // PORT C as output port
     PORTC = 0xFF;// For 2 Stepper motors
     TRISA = 0x00; // PORT A as output port
     PORTA = 0x0F; // For 1 Stepper motors


     //IR Sensor for RE0 and RE1 as inputs
     TRISE = TRISE | 0x03;

     //Initialize LCD to 5*8 matrix in 4-bit mode
      LCD_Initialize();

     //Keypad
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
        LCD_String_xy(1,0,"Item(1,2):");//Start from pos 14
        LCD_command(0x0F);//Cursor Blinking
         while(C1&&C2&&C3)
         {
          if(IR1==0)
          {
          bal=bal+5;
          WordToStr(bal,balval);
          LCD_String_xy(2,7,balval);
          LCD_String_xy(1,9,":");//For cursor
          read=1;
          if(read==1)
          {
          Delay_ms(1000);
          read=0;
          }
          }

          if(IR2==0)
          {
          Delay_ms(600);
          bal=bal+50;
          WordToStr(bal,balval);
          LCD_String_xy(2,7,balval);
          LCD_String_xy(1,9,":");//For cursor
          read=1;
          if(read==1)
          {
          Delay_ms(1000);
          read=0;
          }
          }

             //Enter value from keypad to be stored in Sel
         }
         Sel=key();


        if(Sel=='1'||Sel=='2'||Sel=='3'||Sel=='*')
        {
        LCD_String_xy(1,9,":");//Move cursor back to select
        LCD_Char(Sel); // Display value on Keypad
        }

        if(sel=='1')//Item 1
        {
        LCD_command(0x0C);//Cursor off
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
        for (mstep=0;mstep<steps;mstep++)
         {
           stepper_drive(clockwise,Wmotor);
         }
        Delay_ms(500);
        LCD_Clear();
          servo_position(90);
          Delay_ms(10000);
            servo_position(0);

        break;
        }
        PortB=0x00;
        while(C1&&C2&&C3);
        Sel=key();
        if(sel=='*'){
        LCD_clear();
        break;}
          }
        }

        else if (sel=='2')//Item 2
        {
        LCD_command(0x0C);//Cursor off
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
        for (mstep=0;mstep<steps;mstep++)
         {
           stepper_drive(clockwise,Wmotor);
         }
         Delay_ms(500);
        LCD_clear();
                  servo_position(90);
          Delay_ms(10000);
            servo_position(0);
        break;
        }
        PortB=0x00;
        while(C1&&C2&&C3);
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
