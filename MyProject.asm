
_LCD_Initialize:

;MyProject.c,67 :: 		void LCD_Initialize () /* LCD Initialize function */
;MyProject.c,69 :: 		LCD_Port = 0x00;       /*PORT as Output Port*/
	CLRF       TRISD+0
;MyProject.c,70 :: 		delay_ms(20);        /*15ms,16x2 LCD Power on delay*/
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_LCD_Initialize0:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Initialize0
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Initialize0
	NOP
	NOP
;MyProject.c,72 :: 		for nibble (4-bit) mode */
	MOVLW      2
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;MyProject.c,74 :: 		initialize 5*8 matrix in (4-bit mode)*/
	MOVLW      40
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;MyProject.c,75 :: 		LCD_Command(0x01);  /*clear display screen*/
	MOVLW      1
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;MyProject.c,76 :: 		LCD_Command(0x0c);  /*display on cursor off*/
	MOVLW      12
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;MyProject.c,77 :: 		LCD_Command(0x06);  /*increment cursor (shift cursor to right)*/
	MOVLW      6
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;MyProject.c,78 :: 		}
L_end_LCD_Initialize:
	RETURN
; end of _LCD_Initialize

_LCD_command:

;MyProject.c,79 :: 		void LCD_command(unsigned char cmnd)
;MyProject.c,81 :: 		ldata = (ldata & 0x0f) |(0xF0 & cmnd);  /*Send higher nibble of command first to PORT*/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVLW      240
	ANDWF      FARG_LCD_command_cmnd+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 0
	MOVWF      PORTD+0
;MyProject.c,82 :: 		RS = 0;  /*Command Register is selected i.e.RS=0*/
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
;MyProject.c,83 :: 		EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,84 :: 		asm NOP;
	NOP
;MyProject.c,85 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,86 :: 		Delay_ms(1);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_LCD_command1:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_command1
	DECFSZ     R12+0, 1
	GOTO       L_LCD_command1
	NOP
	NOP
;MyProject.c,87 :: 		ldata = (ldata & 0x0f) | (cmnd<<4);  /*Send lower nibble of command to PORT */
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R2+0
	MOVF       FARG_LCD_command_cmnd+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      PORTD+0
;MyProject.c,88 :: 		EN = 1;
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,89 :: 		asm NOP;
	NOP
;MyProject.c,90 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,91 :: 		Delay_ms(3);
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_LCD_command2:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_command2
	DECFSZ     R12+0, 1
	GOTO       L_LCD_command2
	NOP
	NOP
;MyProject.c,92 :: 		}
L_end_LCD_command:
	RETURN
; end of _LCD_command

_LCD_String_xy:

;MyProject.c,93 :: 		void LCD_String_xy (unsigned char row,unsigned char pos,unsigned char *str) /* Send string to LCD function */
;MyProject.c,95 :: 		location=0;
	CLRF       _location+0
;MyProject.c,96 :: 		if(row<=1)
	MOVF       FARG_LCD_String_xy_row+0, 0
	SUBLW      1
	BTFSS      STATUS+0, 0
	GOTO       L_LCD_String_xy3
;MyProject.c,98 :: 		location=(0x80) | ((pos) & 0x0f);  /*Print message on 1st row and desired location*/
	MOVLW      15
	ANDWF      FARG_LCD_String_xy_pos+0, 0
	MOVWF      R0+0
	BSF        R0+0, 7
	MOVF       R0+0, 0
	MOVWF      _location+0
;MyProject.c,99 :: 		LCD_Command(location);
	MOVF       R0+0, 0
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,100 :: 		}
	GOTO       L_LCD_String_xy4
L_LCD_String_xy3:
;MyProject.c,103 :: 		location=(0xC0) | ((pos) & 0x0f);  /*Print message on 2nd row and desired location*/
	MOVLW      15
	ANDWF      FARG_LCD_String_xy_pos+0, 0
	MOVWF      R0+0
	MOVLW      192
	IORWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _location+0
;MyProject.c,104 :: 		LCD_Command(location);
	MOVF       R0+0, 0
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,105 :: 		}
L_LCD_String_xy4:
;MyProject.c,106 :: 		LCD_String(str);
	MOVF       FARG_LCD_String_xy_str+0, 0
	MOVWF      FARG_LCD_String+0
	CALL       _LCD_String+0
;MyProject.c,108 :: 		}
L_end_LCD_String_xy:
	RETURN
; end of _LCD_String_xy

_LCD_String:

;MyProject.c,110 :: 		void LCD_String (unsigned char *str) /* Send string to LCD function */
;MyProject.c,112 :: 		while((*str)!=0)
L_LCD_String5:
	MOVF       FARG_LCD_String_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_String6
;MyProject.c,114 :: 		LCD_Char(*str);
	MOVF       FARG_LCD_String_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_LCD_Char+0
	CALL       _LCD_Char+0
;MyProject.c,115 :: 		str++;
	INCF       FARG_LCD_String_str+0, 1
;MyProject.c,116 :: 		}
	GOTO       L_LCD_String5
L_LCD_String6:
;MyProject.c,117 :: 		}
L_end_LCD_String:
	RETURN
; end of _LCD_String

_LCD_Char:

;MyProject.c,119 :: 		void LCD_Char (unsigned char chardata) /* LCD data write function */
;MyProject.c,121 :: 		ldata = (ldata & 0x0f) | (0xF0 & chardata);  /*Send higher nibble of data first to PORT*/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVLW      240
	ANDWF      FARG_LCD_Char_chardata+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 0
	MOVWF      PORTD+0
;MyProject.c,122 :: 		RS = 1;  /*Data Register is selected*/
	BSF        RD0_bit+0, BitPos(RD0_bit+0)
;MyProject.c,123 :: 		EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,124 :: 		asm NOP;
	NOP
;MyProject.c,125 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,126 :: 		Delay_ms(1);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_LCD_Char7:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Char7
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Char7
	NOP
	NOP
;MyProject.c,127 :: 		ldata = (ldata & 0x0f) | (chardata<<4);  /*Send lower nibble of data to PORT*/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R2+0
	MOVF       FARG_LCD_Char_chardata+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      PORTD+0
;MyProject.c,128 :: 		EN = 1;  /*High-to-low pulse on Enable pin to latch data*/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,129 :: 		asm NOP;
	NOP
;MyProject.c,130 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;MyProject.c,131 :: 		Delay_ms(3);
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_LCD_Char8:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Char8
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Char8
	NOP
	NOP
;MyProject.c,132 :: 		}
L_end_LCD_Char:
	RETURN
; end of _LCD_Char

_LCD_Clear:

;MyProject.c,135 :: 		void LCD_Clear()
;MyProject.c,137 :: 		LCD_Command(0x01);  /*clear display screen*/
	MOVLW      1
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,138 :: 		Delay_ms(3);
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_LCD_Clear9:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Clear9
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Clear9
	NOP
	NOP
;MyProject.c,139 :: 		}
L_end_LCD_Clear:
	RETURN
; end of _LCD_Clear

_keyinit:

;MyProject.c,142 :: 		void keyinit()
;MyProject.c,144 :: 		TRISB=0XF0;
	MOVLW      240
	MOVWF      TRISB+0
;MyProject.c,145 :: 		OPTION_REG&=0X7F;   //ENABLE WEAK PULL UP resistors for he keypad
	MOVLW      127
	ANDWF      OPTION_REG+0, 1
;MyProject.c,146 :: 		}
L_end_keyinit:
	RETURN
; end of _keyinit

_key:

;MyProject.c,147 :: 		unsigned char key()
;MyProject.c,149 :: 		PORTB=0X00;
	CLRF       PORTB+0
;MyProject.c,150 :: 		while(!C1||!C2||!C3) {
L_key10:
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key141
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key141
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key141
	GOTO       L_key11
L__key141:
;MyProject.c,151 :: 		R1=0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;MyProject.c,152 :: 		R2=R3=R4=1;
	BSF        RB3_bit+0, BitPos(RB3_bit+0)
	BTFSC      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__key154
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key155
L__key154:
	BSF        RB2_bit+0, BitPos(RB2_bit+0)
L__key155:
	BTFSC      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L__key156
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__key157
L__key156:
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
L__key157:
;MyProject.c,153 :: 		if(!C1||!C2||!C3) {
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key140
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key140
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key140
	GOTO       L_key16
L__key140:
;MyProject.c,154 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key17:
	DECFSZ     R13+0, 1
	GOTO       L_key17
	DECFSZ     R12+0, 1
	GOTO       L_key17
	DECFSZ     R11+0, 1
	GOTO       L_key17
	NOP
;MyProject.c,155 :: 		rowloc=0;
	CLRF       _rowloc+0
;MyProject.c,156 :: 		break;
	GOTO       L_key11
;MyProject.c,157 :: 		}
L_key16:
;MyProject.c,158 :: 		R2=0;R1=1;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;MyProject.c,159 :: 		if(!C1||!C2||!C3) {
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key139
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key139
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key139
	GOTO       L_key20
L__key139:
;MyProject.c,160 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key21:
	DECFSZ     R13+0, 1
	GOTO       L_key21
	DECFSZ     R12+0, 1
	GOTO       L_key21
	DECFSZ     R11+0, 1
	GOTO       L_key21
	NOP
;MyProject.c,161 :: 		rowloc=1;
	MOVLW      1
	MOVWF      _rowloc+0
;MyProject.c,162 :: 		break;
	GOTO       L_key11
;MyProject.c,163 :: 		}
L_key20:
;MyProject.c,164 :: 		R3=0;R2=1;
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;MyProject.c,165 :: 		if(!C1||!C2||!C3) {
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key138
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key138
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key138
	GOTO       L_key24
L__key138:
;MyProject.c,166 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key25:
	DECFSZ     R13+0, 1
	GOTO       L_key25
	DECFSZ     R12+0, 1
	GOTO       L_key25
	DECFSZ     R11+0, 1
	GOTO       L_key25
	NOP
;MyProject.c,167 :: 		rowloc=2;
	MOVLW      2
	MOVWF      _rowloc+0
;MyProject.c,168 :: 		break;
	GOTO       L_key11
;MyProject.c,169 :: 		}
L_key24:
;MyProject.c,170 :: 		R4=0; R3=1;
	BCF        RB3_bit+0, BitPos(RB3_bit+0)
	BSF        RB2_bit+0, BitPos(RB2_bit+0)
;MyProject.c,171 :: 		if(!C1||!C2||!C3){
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key137
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key137
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key137
	GOTO       L_key28
L__key137:
;MyProject.c,172 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key29:
	DECFSZ     R13+0, 1
	GOTO       L_key29
	DECFSZ     R12+0, 1
	GOTO       L_key29
	DECFSZ     R11+0, 1
	GOTO       L_key29
	NOP
;MyProject.c,173 :: 		rowloc=3;
	MOVLW      3
	MOVWF      _rowloc+0
;MyProject.c,174 :: 		break;
	GOTO       L_key11
;MyProject.c,175 :: 		}
L_key28:
;MyProject.c,176 :: 		}
	GOTO       L_key10
L_key11:
;MyProject.c,177 :: 		if(C1==0&&C2!=0&&C3!=0)
	BTFSC      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_key32
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_key32
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_key32
L__key136:
;MyProject.c,179 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key33:
	DECFSZ     R13+0, 1
	GOTO       L_key33
	DECFSZ     R12+0, 1
	GOTO       L_key33
	DECFSZ     R11+0, 1
	GOTO       L_key33
	NOP
;MyProject.c,180 :: 		colloc=0;
	CLRF       _colloc+0
;MyProject.c,181 :: 		}
	GOTO       L_key34
L_key32:
;MyProject.c,182 :: 		else if(C1!=0&&C2==0&&C3!=0)
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_key37
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_key37
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_key37
L__key135:
;MyProject.c,184 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key38:
	DECFSZ     R13+0, 1
	GOTO       L_key38
	DECFSZ     R12+0, 1
	GOTO       L_key38
	DECFSZ     R11+0, 1
	GOTO       L_key38
	NOP
;MyProject.c,185 :: 		colloc=1;
	MOVLW      1
	MOVWF      _colloc+0
;MyProject.c,186 :: 		}
	GOTO       L_key39
L_key37:
;MyProject.c,187 :: 		else if(C1!=0&&C2!=0&&C3==0)
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_key42
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_key42
	BTFSC      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_key42
L__key134:
;MyProject.c,189 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_key43:
	DECFSZ     R13+0, 1
	GOTO       L_key43
	DECFSZ     R12+0, 1
	GOTO       L_key43
	DECFSZ     R11+0, 1
	GOTO       L_key43
	NOP
;MyProject.c,190 :: 		colloc=2;
	MOVLW      2
	MOVWF      _colloc+0
;MyProject.c,191 :: 		}
L_key42:
L_key39:
L_key34:
;MyProject.c,193 :: 		while(C1==0||C2==0||C3==0);
L_key44:
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__key133
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__key133
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__key133
	GOTO       L_key45
L__key133:
	GOTO       L_key44
L_key45:
;MyProject.c,194 :: 		return (keypad[rowloc][colloc]);
	MOVLW      3
	MOVWF      R0+0
	MOVF       _rowloc+0, 0
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      _keypad+0
	ADDWF      R0+0, 1
	MOVF       _colloc+0, 0
	ADDWF      R0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
;MyProject.c,195 :: 		}
L_end_key:
	RETURN
; end of _key

_stepper_drive:

;MyProject.c,198 :: 		void stepper_drive (unsigned char direction,unsigned int Wmot){
;MyProject.c,199 :: 		if(Wmot==1)
	MOVLW      0
	XORWF      FARG_stepper_drive_Wmot+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__stepper_drive159
	MOVLW      1
	XORWF      FARG_stepper_drive_Wmot+0, 0
L__stepper_drive159:
	BTFSS      STATUS+0, 2
	GOTO       L_stepper_drive48
;MyProject.c,201 :: 		if (direction == clockwise){
	MOVF       FARG_stepper_drive_direction+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_stepper_drive49
;MyProject.c,202 :: 		PORTA = 0b00001001;
	MOVLW      9
	MOVWF      PORTA+0
;MyProject.c,203 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive50:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive50
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive50
	NOP
;MyProject.c,204 :: 		PORTA = 0b00001100;
	MOVLW      12
	MOVWF      PORTA+0
;MyProject.c,205 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive51:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive51
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive51
	NOP
;MyProject.c,206 :: 		PORTA = 0b00000110;
	MOVLW      6
	MOVWF      PORTA+0
;MyProject.c,207 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive52:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive52
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive52
	NOP
;MyProject.c,208 :: 		PORTA = 0b00000011;
	MOVLW      3
	MOVWF      PORTA+0
;MyProject.c,209 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive53:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive53
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive53
	NOP
;MyProject.c,210 :: 		PORTA = 0b00001001;
	MOVLW      9
	MOVWF      PORTA+0
;MyProject.c,211 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive54:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive54
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive54
	NOP
;MyProject.c,212 :: 		}
L_stepper_drive49:
;MyProject.c,213 :: 		}
	GOTO       L_stepper_drive55
L_stepper_drive48:
;MyProject.c,214 :: 		else if(Wmot==2)
	MOVLW      0
	XORWF      FARG_stepper_drive_Wmot+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__stepper_drive160
	MOVLW      2
	XORWF      FARG_stepper_drive_Wmot+0, 0
L__stepper_drive160:
	BTFSS      STATUS+0, 2
	GOTO       L_stepper_drive56
;MyProject.c,216 :: 		if (direction == clockwise){
	MOVF       FARG_stepper_drive_direction+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_stepper_drive57
;MyProject.c,217 :: 		PORTC = 0b10010000;
	MOVLW      144
	MOVWF      PORTC+0
;MyProject.c,218 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive58:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive58
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive58
	NOP
;MyProject.c,219 :: 		PORTC = 0b11000000;
	MOVLW      192
	MOVWF      PORTC+0
;MyProject.c,220 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive59:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive59
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive59
	NOP
;MyProject.c,221 :: 		PORTC = 0b01100000;
	MOVLW      96
	MOVWF      PORTC+0
;MyProject.c,222 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive60:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive60
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive60
	NOP
;MyProject.c,223 :: 		PORTC = 0b00110000;
	MOVLW      48
	MOVWF      PORTC+0
;MyProject.c,224 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive61:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive61
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive61
	NOP
;MyProject.c,225 :: 		PORTC = 0b10010000;
	MOVLW      144
	MOVWF      PORTC+0
;MyProject.c,226 :: 		Delay_ms(speed);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_stepper_drive62:
	DECFSZ     R13+0, 1
	GOTO       L_stepper_drive62
	DECFSZ     R12+0, 1
	GOTO       L_stepper_drive62
	NOP
;MyProject.c,227 :: 		}
L_stepper_drive57:
;MyProject.c,228 :: 		}
L_stepper_drive56:
L_stepper_drive55:
;MyProject.c,230 :: 		}
L_end_stepper_drive:
	RETURN
; end of _stepper_drive

_pwm_init:

;MyProject.c,234 :: 		void pwm_init() {
;MyProject.c,235 :: 		TRISC2_bit = 0; // Set RC2 pin as output
	BCF        TRISC2_bit+0, BitPos(TRISC2_bit+0)
;MyProject.c,236 :: 		CCP1M3_bit = 1; // Configure CCP1 module for PWM
	BSF        CCP1M3_bit+0, BitPos(CCP1M3_bit+0)
;MyProject.c,237 :: 		CCP1M2_bit = 1;
	BSF        CCP1M2_bit+0, BitPos(CCP1M2_bit+0)
;MyProject.c,238 :: 		CCP1M1_bit = 0;
	BCF        CCP1M1_bit+0, BitPos(CCP1M1_bit+0)
;MyProject.c,239 :: 		CCP1M0_bit = 0;
	BCF        CCP1M0_bit+0, BitPos(CCP1M0_bit+0)
;MyProject.c,240 :: 		CCP1X_bit = 0;
	BCF        CCP1X_bit+0, BitPos(CCP1X_bit+0)
;MyProject.c,241 :: 		CCP1Y_bit = 0;
	BCF        CCP1Y_bit+0, BitPos(CCP1Y_bit+0)
;MyProject.c,242 :: 		T2CKPS0_bit = 1; // Set Timer2 prescaler to 16
	BSF        T2CKPS0_bit+0, BitPos(T2CKPS0_bit+0)
;MyProject.c,243 :: 		T2CKPS1_bit = 1;
	BSF        T2CKPS1_bit+0, BitPos(T2CKPS1_bit+0)
;MyProject.c,244 :: 		TMR2ON_bit = 1; // Enable Timer2
	BSF        TMR2ON_bit+0, BitPos(TMR2ON_bit+0)
;MyProject.c,245 :: 		PR2 = 249; // Set period register for 50Hz frequency
	MOVLW      249
	MOVWF      PR2+0
;MyProject.c,246 :: 		}
L_end_pwm_init:
	RETURN
; end of _pwm_init

_Delay_us:

;MyProject.c,249 :: 		void Delay_us(unsigned int microseconds) {
;MyProject.c,252 :: 		while (microseconds--) {
L_Delay_us63:
	MOVF       FARG_Delay_us_microseconds+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_us_microseconds+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_us_microseconds+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_us_microseconds+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay_us64
;MyProject.c,253 :: 		for (i = 0; i < 12; i++) {
	CLRF       R2+0
	CLRF       R2+1
L_Delay_us65:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_us163
	MOVLW      12
	SUBWF      R2+0, 0
L__Delay_us163:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_us66
;MyProject.c,254 :: 		asm nop;
	NOP
;MyProject.c,253 :: 		for (i = 0; i < 12; i++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;MyProject.c,255 :: 		}
	GOTO       L_Delay_us65
L_Delay_us66:
;MyProject.c,256 :: 		}
	GOTO       L_Delay_us63
L_Delay_us64:
;MyProject.c,257 :: 		}
L_end_Delay_us:
	RETURN
; end of _Delay_us

_Delay_ms:

;MyProject.c,260 :: 		void Delay_ms(unsigned int milliseconds) {
;MyProject.c,263 :: 		while (milliseconds--) {
L_Delay_ms68:
	MOVF       FARG_Delay_ms_milliseconds+0, 0
	MOVWF      R0+0
	MOVF       FARG_Delay_ms_milliseconds+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      FARG_Delay_ms_milliseconds+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_Delay_ms_milliseconds+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Delay_ms69
;MyProject.c,264 :: 		for (i = 0; i < 238; i++) {
	CLRF       R2+0
	CLRF       R2+1
L_Delay_ms70:
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay_ms165
	MOVLW      238
	SUBWF      R2+0, 0
L__Delay_ms165:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay_ms71
;MyProject.c,265 :: 		Delay_us(1000);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_Delay_ms73:
	DECFSZ     R13+0, 1
	GOTO       L_Delay_ms73
	DECFSZ     R12+0, 1
	GOTO       L_Delay_ms73
	NOP
	NOP
;MyProject.c,264 :: 		for (i = 0; i < 238; i++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;MyProject.c,266 :: 		}
	GOTO       L_Delay_ms70
L_Delay_ms71:
;MyProject.c,267 :: 		}
	GOTO       L_Delay_ms68
L_Delay_ms69:
;MyProject.c,268 :: 		}
L_end_Delay_ms:
	RETURN
; end of _Delay_ms

_servo_position:

;MyProject.c,271 :: 		void servo_position(int degrees) {
;MyProject.c,272 :: 		int pulse_width = (degrees + 90) * 8 + 500; // Calculate pulse width (500 to 2400)
	MOVLW      90
	ADDWF      FARG_servo_position_degrees+0, 0
	MOVWF      R3+0
	MOVF       FARG_servo_position_degrees+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__servo_position167:
	BTFSC      STATUS+0, 2
	GOTO       L__servo_position168
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__servo_position167
L__servo_position168:
	MOVLW      244
	ADDWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      1
	MOVWF      R3+1
;MyProject.c,273 :: 		CCPR1L = pulse_width >> 2; // Set CCPR1L register
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      CCPR1L+0
;MyProject.c,274 :: 		CCP1CON = (CCP1CON & 0xCF) | ((pulse_width & 0x03) << 4); // Set CCP1CON register
	MOVLW      207
	ANDWF      CCP1CON+0, 0
	MOVWF      R5+0
	MOVLW      3
	ANDWF      R3+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R5+0, 0
	MOVWF      CCP1CON+0
;MyProject.c,275 :: 		Delay_ms(50*4); // Delay for the servo to reach the desired position
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_servo_position74:
	DECFSZ     R13+0, 1
	GOTO       L_servo_position74
	DECFSZ     R12+0, 1
	GOTO       L_servo_position74
	DECFSZ     R11+0, 1
	GOTO       L_servo_position74
;MyProject.c,276 :: 		}
L_end_servo_position:
	RETURN
; end of _servo_position

_main:

;MyProject.c,282 :: 		void main() {
;MyProject.c,284 :: 		pwm_init(); // Initialize PWM module
	CALL       _pwm_init+0
;MyProject.c,287 :: 		mstep=0;
	CLRF       _mstep+0
	CLRF       _mstep+1
;MyProject.c,289 :: 		ADCON1 = 0x06; // To turn off analog to digital converters (Make all digital)
	MOVLW      6
	MOVWF      ADCON1+0
;MyProject.c,290 :: 		TRISC = 0x00; // PORT C as output port
	CLRF       TRISC+0
;MyProject.c,291 :: 		PORTC = 0xFF;// For 2 Stepper motors
	MOVLW      255
	MOVWF      PORTC+0
;MyProject.c,292 :: 		TRISA = 0x00; // PORT A as output port
	CLRF       TRISA+0
;MyProject.c,293 :: 		PORTA = 0x0F; // For 1 Stepper motors
	MOVLW      15
	MOVWF      PORTA+0
;MyProject.c,297 :: 		TRISE = TRISE | 0x03;
	MOVLW      3
	IORWF      TRISE+0, 1
;MyProject.c,300 :: 		LCD_Initialize();
	CALL       _LCD_Initialize+0
;MyProject.c,303 :: 		keyinit();
	CALL       _keyinit+0
;MyProject.c,304 :: 		servo_position(0);
	CLRF       FARG_servo_position_degrees+0
	CLRF       FARG_servo_position_degrees+1
	CALL       _servo_position+0
;MyProject.c,305 :: 		while(1)
L_main75:
;MyProject.c,307 :: 		LCD_String_xy(2,0,"Balance:");
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,308 :: 		if(bal==0)
	MOVLW      0
	XORWF      _bal+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main170
	MOVLW      0
	XORWF      _bal+0, 0
L__main170:
	BTFSS      STATUS+0, 2
	GOTO       L_main77
;MyProject.c,309 :: 		{LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,310 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,311 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,312 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,313 :: 		LCD_char('0');}
	MOVLW      48
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
	GOTO       L_main78
L_main77:
;MyProject.c,315 :: 		{WordToStr(bal,balval);
	MOVF       _bal+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       _bal+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _balval+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;MyProject.c,316 :: 		LCD_String_xy(2,7,balval);}
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      7
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      _balval+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
L_main78:
;MyProject.c,317 :: 		LCD_String_xy(1,0,"Item(1,2):");//Start from pos 14
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr2_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,318 :: 		LCD_command(0x0F);//Cursor Blinking
	MOVLW      15
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,319 :: 		while(C1&&C2&&C3)
L_main79:
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main80
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main80
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_main80
L__main145:
;MyProject.c,321 :: 		if(IR1==0)
	BTFSC      PORTE+0, 1
	GOTO       L_main83
;MyProject.c,323 :: 		bal=bal+5;
	MOVLW      5
	ADDWF      _bal+0, 0
	MOVWF      R0+0
	MOVF       _bal+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _bal+0
	MOVF       R0+1, 0
	MOVWF      _bal+1
;MyProject.c,324 :: 		WordToStr(bal,balval);
	MOVF       R0+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _balval+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;MyProject.c,325 :: 		LCD_String_xy(2,7,balval);
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      7
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      _balval+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,326 :: 		LCD_String_xy(1,9,":");//For cursor
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      9
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr3_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,327 :: 		read=1;
	MOVLW      1
	MOVWF      _read+0
	MOVLW      0
	MOVWF      _read+1
;MyProject.c,330 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main85:
	DECFSZ     R13+0, 1
	GOTO       L_main85
	DECFSZ     R12+0, 1
	GOTO       L_main85
	DECFSZ     R11+0, 1
	GOTO       L_main85
	NOP
	NOP
;MyProject.c,331 :: 		read=0;
	CLRF       _read+0
	CLRF       _read+1
;MyProject.c,333 :: 		}
L_main83:
;MyProject.c,335 :: 		if(IR2==0)
	BTFSC      PORTE+0, 0
	GOTO       L_main86
;MyProject.c,337 :: 		Delay_ms(600);
	MOVLW      7
	MOVWF      R11+0
	MOVLW      23
	MOVWF      R12+0
	MOVLW      106
	MOVWF      R13+0
L_main87:
	DECFSZ     R13+0, 1
	GOTO       L_main87
	DECFSZ     R12+0, 1
	GOTO       L_main87
	DECFSZ     R11+0, 1
	GOTO       L_main87
	NOP
;MyProject.c,338 :: 		bal=bal+50;
	MOVLW      50
	ADDWF      _bal+0, 0
	MOVWF      R0+0
	MOVF       _bal+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _bal+0
	MOVF       R0+1, 0
	MOVWF      _bal+1
;MyProject.c,339 :: 		WordToStr(bal,balval);
	MOVF       R0+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _balval+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;MyProject.c,340 :: 		LCD_String_xy(2,7,balval);
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      7
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      _balval+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,341 :: 		LCD_String_xy(1,9,":");//For cursor
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      9
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr4_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,342 :: 		read=1;
	MOVLW      1
	MOVWF      _read+0
	MOVLW      0
	MOVWF      _read+1
;MyProject.c,345 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main89:
	DECFSZ     R13+0, 1
	GOTO       L_main89
	DECFSZ     R12+0, 1
	GOTO       L_main89
	DECFSZ     R11+0, 1
	GOTO       L_main89
	NOP
	NOP
;MyProject.c,346 :: 		read=0;
	CLRF       _read+0
	CLRF       _read+1
;MyProject.c,348 :: 		}
L_main86:
;MyProject.c,351 :: 		}
	GOTO       L_main79
L_main80:
;MyProject.c,352 :: 		Sel=key();
	CALL       _key+0
	MOVF       R0+0, 0
	MOVWF      _Sel+0
;MyProject.c,355 :: 		if(Sel=='1'||Sel=='2'||Sel=='3'||Sel=='*')
	MOVF       R0+0, 0
	XORLW      49
	BTFSC      STATUS+0, 2
	GOTO       L__main144
	MOVF       _Sel+0, 0
	XORLW      50
	BTFSC      STATUS+0, 2
	GOTO       L__main144
	MOVF       _Sel+0, 0
	XORLW      51
	BTFSC      STATUS+0, 2
	GOTO       L__main144
	MOVF       _Sel+0, 0
	XORLW      42
	BTFSC      STATUS+0, 2
	GOTO       L__main144
	GOTO       L_main92
L__main144:
;MyProject.c,357 :: 		LCD_String_xy(1,9,":");//Move cursor back to select
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      9
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr5_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,358 :: 		LCD_Char(Sel); // Display value on Keypad
	MOVF       _Sel+0, 0
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,359 :: 		}
L_main92:
;MyProject.c,361 :: 		if(sel=='1')//Item 1
	MOVF       _Sel+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main93
;MyProject.c,363 :: 		LCD_command(0x0C);//Cursor off
	MOVLW      12
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,364 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main94:
	DECFSZ     R13+0, 1
	GOTO       L_main94
	DECFSZ     R12+0, 1
	GOTO       L_main94
	DECFSZ     R11+0, 1
	GOTO       L_main94
	NOP
	NOP
;MyProject.c,365 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,367 :: 		while(1)
L_main95:
;MyProject.c,369 :: 		LCD_String_xy(1,0,"Item1:5 Piasters");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr6_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,370 :: 		LCD_String_xy(2,0,"Balance:");
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr7_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,371 :: 		if(bal==0)
	MOVLW      0
	XORWF      _bal+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main171
	MOVLW      0
	XORWF      _bal+0, 0
L__main171:
	BTFSS      STATUS+0, 2
	GOTO       L_main97
;MyProject.c,373 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,374 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,375 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,376 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,377 :: 		LCD_char('0');}
	MOVLW      48
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
	GOTO       L_main98
L_main97:
;MyProject.c,379 :: 		{LCD_String_xy(2,7,balval);}
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      7
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      _balval+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
L_main98:
;MyProject.c,380 :: 		if(bal>=5)
	MOVLW      0
	SUBWF      _bal+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main172
	MOVLW      5
	SUBWF      _bal+0, 0
L__main172:
	BTFSS      STATUS+0, 0
	GOTO       L_main99
;MyProject.c,382 :: 		Wmotor=1;
	MOVLW      1
	MOVWF      _Wmotor+0
	MOVLW      0
	MOVWF      _Wmotor+1
;MyProject.c,383 :: 		Delay_us(5000);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main100:
	DECFSZ     R13+0, 1
	GOTO       L_main100
	DECFSZ     R12+0, 1
	GOTO       L_main100
	NOP
	NOP
;MyProject.c,384 :: 		bal=bal-5;
	MOVLW      5
	SUBWF      _bal+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bal+1, 1
;MyProject.c,385 :: 		Delay_ms(2500);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main101:
	DECFSZ     R13+0, 1
	GOTO       L_main101
	DECFSZ     R12+0, 1
	GOTO       L_main101
	DECFSZ     R11+0, 1
	GOTO       L_main101
	NOP
;MyProject.c,386 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,387 :: 		LCD_String_xy(1,0,"Please wait..");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr8_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,388 :: 		for (mstep=0;mstep<steps;mstep++)
	CLRF       _mstep+0
	CLRF       _mstep+1
L_main102:
	MOVLW      4
	SUBWF      _mstep+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main173
	MOVLW      56
	SUBWF      _mstep+0, 0
L__main173:
	BTFSC      STATUS+0, 0
	GOTO       L_main103
;MyProject.c,390 :: 		stepper_drive(clockwise,Wmotor);
	CLRF       FARG_stepper_drive_direction+0
	MOVF       _Wmotor+0, 0
	MOVWF      FARG_stepper_drive_Wmot+0
	MOVF       _Wmotor+1, 0
	MOVWF      FARG_stepper_drive_Wmot+1
	CALL       _stepper_drive+0
;MyProject.c,388 :: 		for (mstep=0;mstep<steps;mstep++)
	INCF       _mstep+0, 1
	BTFSC      STATUS+0, 2
	INCF       _mstep+1, 1
;MyProject.c,391 :: 		}
	GOTO       L_main102
L_main103:
;MyProject.c,392 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main105:
	DECFSZ     R13+0, 1
	GOTO       L_main105
	DECFSZ     R12+0, 1
	GOTO       L_main105
	DECFSZ     R11+0, 1
	GOTO       L_main105
	NOP
	NOP
;MyProject.c,393 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;MyProject.c,394 :: 		servo_position(90);
	MOVLW      90
	MOVWF      FARG_servo_position_degrees+0
	MOVLW      0
	MOVWF      FARG_servo_position_degrees+1
	CALL       _servo_position+0
;MyProject.c,395 :: 		Delay_ms(10000);
	MOVLW      102
	MOVWF      R11+0
	MOVLW      118
	MOVWF      R12+0
	MOVLW      193
	MOVWF      R13+0
L_main106:
	DECFSZ     R13+0, 1
	GOTO       L_main106
	DECFSZ     R12+0, 1
	GOTO       L_main106
	DECFSZ     R11+0, 1
	GOTO       L_main106
;MyProject.c,396 :: 		servo_position(0);
	CLRF       FARG_servo_position_degrees+0
	CLRF       FARG_servo_position_degrees+1
	CALL       _servo_position+0
;MyProject.c,398 :: 		break;
	GOTO       L_main96
;MyProject.c,399 :: 		}
L_main99:
;MyProject.c,400 :: 		PortB=0x00;
	CLRF       PORTB+0
;MyProject.c,401 :: 		while(C1&&C2&&C3);
L_main107:
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main108
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main108
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_main108
L__main143:
	GOTO       L_main107
L_main108:
;MyProject.c,402 :: 		Sel=key();
	CALL       _key+0
	MOVF       R0+0, 0
	MOVWF      _Sel+0
;MyProject.c,403 :: 		if(sel=='*'){
	MOVF       R0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main111
;MyProject.c,404 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,405 :: 		break;}
	GOTO       L_main96
L_main111:
;MyProject.c,406 :: 		}
	GOTO       L_main95
L_main96:
;MyProject.c,407 :: 		}
	GOTO       L_main112
L_main93:
;MyProject.c,409 :: 		else if (sel=='2')//Item 2
	MOVF       _Sel+0, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_main113
;MyProject.c,411 :: 		LCD_command(0x0C);//Cursor off
	MOVLW      12
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;MyProject.c,412 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main114:
	DECFSZ     R13+0, 1
	GOTO       L_main114
	DECFSZ     R12+0, 1
	GOTO       L_main114
	DECFSZ     R11+0, 1
	GOTO       L_main114
	NOP
	NOP
;MyProject.c,413 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,414 :: 		while(1)
L_main115:
;MyProject.c,416 :: 		LCD_String_xy(1,0,"Item2:50 Piasters");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr9_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,417 :: 		LCD_String_xy(2,0,"Balance:");
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr10_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,418 :: 		if(bal==0)
	MOVLW      0
	XORWF      _bal+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main174
	MOVLW      0
	XORWF      _bal+0, 0
L__main174:
	BTFSS      STATUS+0, 2
	GOTO       L_main117
;MyProject.c,420 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,421 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,422 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,423 :: 		LCD_char(' ');
	MOVLW      32
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
;MyProject.c,424 :: 		LCD_char('0');}
	MOVLW      48
	MOVWF      FARG_LCD_Char_chardata+0
	CALL       _LCD_Char+0
	GOTO       L_main118
L_main117:
;MyProject.c,426 :: 		{LCD_String_xy(2,7,balval);}
	MOVLW      2
	MOVWF      FARG_LCD_String_xy_row+0
	MOVLW      7
	MOVWF      FARG_LCD_String_xy_pos+0
	MOVLW      _balval+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
L_main118:
;MyProject.c,427 :: 		if(bal>=50)
	MOVLW      0
	SUBWF      _bal+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main175
	MOVLW      50
	SUBWF      _bal+0, 0
L__main175:
	BTFSS      STATUS+0, 0
	GOTO       L_main119
;MyProject.c,429 :: 		Wmotor=2;
	MOVLW      2
	MOVWF      _Wmotor+0
	MOVLW      0
	MOVWF      _Wmotor+1
;MyProject.c,430 :: 		Delay_us(5000);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main120:
	DECFSZ     R13+0, 1
	GOTO       L_main120
	DECFSZ     R12+0, 1
	GOTO       L_main120
	NOP
	NOP
;MyProject.c,431 :: 		bal=bal-50;
	MOVLW      50
	SUBWF      _bal+0, 1
	BTFSS      STATUS+0, 0
	DECF       _bal+1, 1
;MyProject.c,432 :: 		Delay_ms(2500);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main121:
	DECFSZ     R13+0, 1
	GOTO       L_main121
	DECFSZ     R12+0, 1
	GOTO       L_main121
	DECFSZ     R11+0, 1
	GOTO       L_main121
	NOP
;MyProject.c,433 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,434 :: 		LCD_String_xy(1,0,"Please wait..");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy_row+0
	CLRF       FARG_LCD_String_xy_pos+0
	MOVLW      ?lstr11_MyProject+0
	MOVWF      FARG_LCD_String_xy_str+0
	CALL       _LCD_String_xy+0
;MyProject.c,435 :: 		for (mstep=0;mstep<steps;mstep++)
	CLRF       _mstep+0
	CLRF       _mstep+1
L_main122:
	MOVLW      4
	SUBWF      _mstep+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main176
	MOVLW      56
	SUBWF      _mstep+0, 0
L__main176:
	BTFSC      STATUS+0, 0
	GOTO       L_main123
;MyProject.c,437 :: 		stepper_drive(clockwise,Wmotor);
	CLRF       FARG_stepper_drive_direction+0
	MOVF       _Wmotor+0, 0
	MOVWF      FARG_stepper_drive_Wmot+0
	MOVF       _Wmotor+1, 0
	MOVWF      FARG_stepper_drive_Wmot+1
	CALL       _stepper_drive+0
;MyProject.c,435 :: 		for (mstep=0;mstep<steps;mstep++)
	INCF       _mstep+0, 1
	BTFSC      STATUS+0, 2
	INCF       _mstep+1, 1
;MyProject.c,438 :: 		}
	GOTO       L_main122
L_main123:
;MyProject.c,439 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main125:
	DECFSZ     R13+0, 1
	GOTO       L_main125
	DECFSZ     R12+0, 1
	GOTO       L_main125
	DECFSZ     R11+0, 1
	GOTO       L_main125
	NOP
	NOP
;MyProject.c,440 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,441 :: 		servo_position(90);
	MOVLW      90
	MOVWF      FARG_servo_position_degrees+0
	MOVLW      0
	MOVWF      FARG_servo_position_degrees+1
	CALL       _servo_position+0
;MyProject.c,442 :: 		Delay_ms(10000);
	MOVLW      102
	MOVWF      R11+0
	MOVLW      118
	MOVWF      R12+0
	MOVLW      193
	MOVWF      R13+0
L_main126:
	DECFSZ     R13+0, 1
	GOTO       L_main126
	DECFSZ     R12+0, 1
	GOTO       L_main126
	DECFSZ     R11+0, 1
	GOTO       L_main126
;MyProject.c,443 :: 		servo_position(0);
	CLRF       FARG_servo_position_degrees+0
	CLRF       FARG_servo_position_degrees+1
	CALL       _servo_position+0
;MyProject.c,444 :: 		break;
	GOTO       L_main116
;MyProject.c,445 :: 		}
L_main119:
;MyProject.c,446 :: 		PortB=0x00;
	CLRF       PORTB+0
;MyProject.c,447 :: 		while(C1&&C2&&C3);
L_main127:
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main128
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main128
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_main128
L__main142:
	GOTO       L_main127
L_main128:
;MyProject.c,448 :: 		Sel=key();
	CALL       _key+0
	MOVF       R0+0, 0
	MOVWF      _Sel+0
;MyProject.c,449 :: 		if(sel=='*'){
	MOVF       R0+0, 0
	XORLW      42
	BTFSS      STATUS+0, 2
	GOTO       L_main131
;MyProject.c,450 :: 		LCD_clear();
	CALL       _LCD_Clear+0
;MyProject.c,451 :: 		break;}
	GOTO       L_main116
L_main131:
;MyProject.c,452 :: 		}
	GOTO       L_main115
L_main116:
;MyProject.c,453 :: 		}
L_main113:
L_main112:
;MyProject.c,456 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main132:
	DECFSZ     R13+0, 1
	GOTO       L_main132
	DECFSZ     R12+0, 1
	GOTO       L_main132
	DECFSZ     R11+0, 1
	GOTO       L_main132
	NOP
;MyProject.c,457 :: 		PortB=0x00;
	CLRF       PORTB+0
;MyProject.c,458 :: 		}
	GOTO       L_main75
;MyProject.c,460 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
