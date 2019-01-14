*------------------------------------------------------------------
* Title      :  Team A Disassembler- CSS 422
* Written by :  Orpal Nagra, Kris (Giwhan) Kwon, Yuunbum Lim
* Date       :  12/8/2018
* Description:  Please see attached docs for detailed description 
*------------------------------------------------------------------

STACK  EQU $7000                    ; 
range_start EQU $7000               ;
range_end   EQU $9FFF               ;       
list_hex_size   EQU     16          ; 
clear           EQU     $00000000   ;
display_size    EQU 20              ;    
init    EQU 0                       ; 
increment   EQU 1                   ;
long EQU    8                       ;  
word    EQU 4                       ; 
byte    EQU 2                       ; 

* Special characters                ; 
CR  EQU $0D                         ; 
LF  EQU $0A                         ; 
NULL    EQU $00                     ; 
TAB EQU $09                         ; 
DOLLAR EQU  $24                     ; #36 in dec 
COMMA   EQU $2C                     ; 
PERIOD  EQU $2E                     ; 
PLUS    EQU $2B                     ; 
MINUS   EQU  $2D                    ; 
Open_paren  EQU $28                 ; 
Close_paren EQU $29                 ;
SPACE   EQU $20                     ;     
SHARP   EQU $23                     ;    
SLASH   EQU $2F                     ; 
DASH    EQU $2D                     ;
COLON   EQU $3A                     ;

* Alphabet  
A_  EQU $41 ; 
B_  EQU $42 ; 
C_  EQU $43 ; 
D_  EQU $44 ; 
E_  EQU $45 ; 
F_  EQU $46 ; 
G_  EQU $47 ;
H_  EQU $48 ;
I_  EQU $49 ;
J_  EQU $4A ; 
K_  EQU $4B ; 
L_  EQU $4C ;
M_  EQU $4D ; 
N_  EQU $4E ;
O_  EQU $4F ; 
P_  EQU $50 ; 
Q_  EQU $51 ; 
R_  EQU $52 ; 
S_  EQU $53 ; 
T_  EQU $54 ; 
U_  EQU $55 ; 
V_  EQU $56 ; 
W_  EQU $57 ; 
X_  EQU $58 ; 
Y_  EQU $59 ; 
Z_  EQU $5A ; 

* Numbers   
ZERO_   EQU $30 ;   
ONE_    EQU $31 ;   
TWO_    EQU $32 ;   
THREE_  EQU $33 ;
FOUR_   EQU $34 ;   
FIVE_   EQU $35 ;   
SIX_    EQU $36 ;   
SEVEN_  EQU $37 ;   
EIGHT_  EQU $38 ;   
NINE_   EQU $39 ;   

    ORG $1000   
START:                                      ; first instruction of program
* Put program code here

* get starting address
StartPrompt    
    * prompt user to ask starting address   
    BSR PROMPT_START            ;

    * take starting address from the user     
    BSR TAKE_INPUT        ;   
    
    * convert input string to hex value 
    BSR STR_TO_HEX  ; result hex in D1  
    
    * check if starting address is in the range 
    BSR CHECK_STARTING_BOUND    ;
    
    BGE startingIsGreater       ;
    BRA StartPrompt    ;      
    
startingIsGreater   
    MOVE.L  D1, START_HEX   ;  

* get ending address
EndPrompt      
    * prompt to ask ending address  
    BSR PROMPT_END
    
    * take ending address from the user 
    BSR TAKE_INPUT
    
    * convert input string to hex value 
    BSR STR_TO_HEX
    
    * check if starting address is in the range
    BSR CHECK_ENDING_BOUND
    
    BGT endingIsGreaterThanStart    ; 
    
    
    BRA EndPrompt   
    
endingIsGreaterThanStart    ; 
    CMP.L   #range_end, D1   ; 
    BGT EndPrompt   ;    
    
    MOVE.L  D1, END_HEX ;    
    
    BRA MAIN


       

PROMPT_START            ; Asking starting address    
    LEA PROMPT_1, A1    ;   
    MOVE.B  #13, D0     ;   
    TRAP    #15         ;   
    
    LEA PROMPT_3, A1    ;   
    MOVE.B  #14, D0     ;   
    TRAP    #15         ;    
    
    RTS 
    
TAKE_INPUT
    LEA INPUT, A1       ;  
    
    * take input    
    MOVE.B  #2, D0      ;   
    TRAP    #15         ;   
    
    * move input to INPUT_LENGTH   
    MOVE.W  D1, INPUT_LENGTH
    RTS     
       
                
* convert input string to hex       
STR_TO_HEX    
    MOVE.B  #0, D2              ; starting index of the string  
    MOVE.W  D1, D3              ; size of input string in D3    
    MOVE.L  #clear, D1          ; clear D1
    
str_loop    
    CMP.L   D2, D3              ; compare currentIndex of the string and the size   
    BEQ str_loop_end            ; 
    
    MOVE.B  (A1)+, D6           ; read one character from the input string store in D6  
    
    MOVE.B  #0, D4              ; store starting index of list hex in D4 
    MOVE.B  list_hex_size, D5   ; store list hex size in D5 
    
hex_loop    
    CMP.B   D4, D5      ;   
    BEQ str_loop    
    
    LEA LIST_HEX, A2    ; address hex list in A2    
    ADDA.L  D4, A2      ; current index in the list 
    
    CMP.B   (A2), D6    ; compare with current character and the list character 
    BEQ hex_found       ; 
    
    ADD.B   #1, D4      ; increment D4 by 1 
    BRA hex_loop        ; go back to hex loop   
    
hex_found   
    ASL #4, D1          ; shift D1 by 4bits 
    ADD.B   D4, D1      ; add current index into D1 
    ADD.B   #1, D2      ; increment currentIndex pointing at input hex string   
    BRA str_loop        ; go back to str_loop   

str_loop_end    
    RTS 

* check if the input is valid   
CHECK_STARTING_BOUND    
    CMP.L   #range_start, D1    ;   input is greater than the starting range
    RTS                         ;   

PROMPT_END              ; Asking ending address  
    LEA PROMPT_2, A1    ;    
    MOVE.B  #13, D0     ; 
    TRAP    #15         ;
    
    LEA PROMPT_3, A1    ;   
    MOVE.B  #14, D0     ;   
    TRAP    #15         ;   
    
    RTS                 ;   
    
CHECK_ENDING_BOUND 
    CMP.L   (START_HEX), D1 ; ending address bigger than starting address
    RTS 
    
* Global variables (START_HEX & END_HEX) is set, use any registers.     
MAIN
    * Output display 20 lines per enter
    MOVEA.L  #STACK, A7   ;    
    * Print the humanReadable codes until reaches the end_hex   
    MOVEA.L  (END_HEX), A3       ; move endHex address to A3
    MOVEA.L (START_HEX), A2     ; move start address to A2 
    LEA RESULT_MSG, A4       ; move result message starting address   
        
decode_loop 
    CMPA.L   A2, A3             ;  
    BEQ finishProgram           ;   reached the end, finish Program
    
    * otherwise initialize counter and ask user for 'ENTER' to continue
    MOVE.B  #display_size, D4   ; move display size to D4   
    MOVE.B  #init, D3           ; move 0 to D3  ;
    MOVEA.L A4, A5              ; initialize current message index by copying starting addr
    BSR printContinueMessage    ; 
    BSR takeContinueInput       ; 
        
 
continue_decoding     
    * if not reached the end Index, 
    * read 20 instructions or currentHex to endHex (if fewer than 20 left)
    CMP.B   D3, D4          ; reached 20 lines, 
    BEQ finish_page         ; go back to decode_loop
        
decode
    MOVEA.L A2, A6          ;   
    MOVE.W  (A2)+, D5       ; move current opcode into D5
    
    * move D3 (= i), D4( = 20), A3(endHex), A4(result_message) into stack
    MOVEM.L D3/D4/A3/A4, -(A7)  ;       
    * D5 contains current opcode and A2 contains startHex      
decode_start    
    * decode starts here****************************************************************************    
    
    MOVEM.L D5, -(A7)   ; store opcode in the stack     
    * print address of current instruction  
    MOVE.B  #word, D1      ;   size is word 
    BSR hex_to_string   ; put current opcode address into A6 and size into D1,  
    MOVE.B  #TAB, (A5)+ ; then current opcode address will be added in the result msg
    
    MOVEM.L (A7)+, D5   ; get opcode back from stack  

    LEA $6000, A6   ;   A6 as $6000 where temporary result is going to be saved   
    
    *   if RTS      
    CMPI.W  #$4E75, D5  ;
    BEQ RTS_function    ;    
    
    CMPI.W  #$4E71, D5  ;   check if nop function
    BEQ NOP_function    ;  

    BSR get_firstFourBits   ; return first four bits in D0
    BSR get_secondFourBits  ; return second four bits in D1 
    
    *  if first four bits are 0  
    CMPI.B  #0, D0  ;
    BEQ zero_start  ;    
    
    CMPI.B  #1, D0  ;
    BEQ one_start   ;

    CMPI.B  #2, D0  ;   
    BEQ two_start   ;   

    CMPI.B  #3, D0  ;   
    BEQ three_start ;   
    
    CMPI.B  #4, D0  ;   
    BEQ four_start  ;   
    
    CMPI.B  #5, D0  ;   
    BEQ five_start  ;   
    
    CMPI.B  #6, D0  ;   
    BEQ six_start   ;   
    
    CMPI.B  #8, D0  ;   
    BEQ eight_start ;

    CMPI.B  #9, D0  ;   
    BEQ nine_start  ;   

    CMPI.B  #$B, D0 ;   
    BEQ B_start     ;   
    
    CMPI.B  #$C, D0 ;   
    BEQ C_start     ;   
    
    CMPI.B  #$D, D0 ;   
    BEQ D_start     ;

    CMPI.B  #$E, D0 ;   
    BEQ E_start     ;     
    
    * no matcing operation 
    BRA invalid_code    ;   
    
* check second four bits and send to decode functions

invalid_code    
    LEA INVALID_MSG, A6 ;   move message in A6  
    MOVE.B  #12, D6  ;   size is 10 for DATA    $WXYZ   
    BSR copy_string ;   
    BRA decode_end  ;   
     
zero_start  
    * if second four bits are 0, ORI function   
    CMPI.B   #0, D1  ;
    BEQ ORI_function    ;   

    * if second foubits are 8, BCLR #, EA function  
    CMPI.B   #8, D1  ;   
    BEQ BCLR_immediate_EA_function  ; 

    * if second four bits are C, CMPI function  
    CMPI.B   #$C, D1 ;   
    BEQ CMPI_function   ;   
    
    * otherwise, go to BCLR Dn, EA function
    BRA BCLR_Dn_EA  ; 
    
one_start
    * branch to move.B function 
    BRA MOVE_B  ;   
    
two_start
    * branch to move.L or movea.L function  
    BRA MOVE_MOVEA_L    ;   
    
three_start 
    * branch to move.w or movea.w funciton 
    BRA MOVE_MOVEA_W    ;   
    
four_start  
    * if second four bits are 4, branch to NEG function 
    CMPI.B   #4, D1     ; 
    BEQ NEG_function    ;   
    
    * if second four bits are 8, branch to MOVEM.W, or MOVEM.L (Register to memory) function    
    CMPI.B   #8, D1    ;   
    BEQ MOVEM_W_L_RtoM ;
    
    * if second fourbits are C, branch to MULS.L, DIVS.L, MOVEM.W, MOVEM.L (Memory to Register) function    
    CMPI.B   #$C, D1 ;   
    BEQ MULS_DIVS_L_MOVEM_W_L_MtoR ;   
    
    * if second four bits are E, branch to JSR_function 
    CMPI.B   #$E, D1 ;   
    BEQ JSR_function    ;   
    
    * otherwise, branch to LEA function 
    BRA LEA_function    ; 
    
five_start  
    * branch to SUBQ function   
    BRA SUBQ_function   ;
    
six_start   
    * if second four bits are 0, branch to BRA function 
    CMPI.B   #0, D1  ; 
    BEQ BRA_function    ;
    
    * if second four bits are 4, branch to BCC function 
    CMPI.B   #4, D1  ;
    BEQ BCC_function    ;   
    
    * if second four bits are 5, branch to BCS function 
    CMPI.B   #5, D1  ;
    BEQ BCS_function    ;
    
    * if second four bits are 8, branch to BVC function     
    CMPI.B   #8, D1  ;
    BEQ BVC_function    ;
    
    * if second four bits are C, branch to BGE function  
    CMPI.B   #$C, D1 ; 
    BEQ BGE_function    ;
    
    * if second four bts are D, branch to BLT function 
    CMPI.B   #$D, D1    ; 
    BEQ BLT_function    ; 
    
    * otherwise, branch to invalid code function 
    BRA invalid_code    ;
    
eight_start
    * branch to OR or DIVS.W function   
    BRA OR_DIVS_W   ; 
    
nine_start
    * branch to SUB function 
    BRA SUB_function    ; 
    
B_start
    * barnch to EOR or CMP function 
    BRA EOR_CMP ;  

C_start
    * branch to ASLR, LSLR, ROLR, MULS.W function   
    BRA MULS_W  ;    

D_start
    * branch to Add or ADDA function 
    BRA ADD_ADDA    ;     
    
E_start 
    * banch to ASLR_LSLR_ROLR   
    BRA ASLR_LSLR_ROLR  ;   

    
    
    

       
    
    


         
    
        
    * decode ends here*******************************************************************************      
decode_end
    * add decoded instruction to the result
    * this should have done in decode functions   
    
    
    * add CR, LF at the end of line 
    MOVE.B  #CR, (A5)+      ; 
    MOVE.B  #LF, (A5)+      ;
    
    MOVEM.L (A7)+, D3-D4/A3 ; move parameters back from stack  
    ADDI.B  #increment, D3  ; increment D3 by 1 
    CMPA.L  A2, A3          ; if input hex reached the end before reaching 20 lines, 
    BEQ finish_page         ; go back to decode_loop to finish the program 
    BRA continue_decoding   ; otherwise, continue decoding  

* hex in A6, size in D1 convert to string and put it in the A5,    
* Long 4byte, Word = 2byte, Byte = 1byte, therefore D1 = 4, 2, or 1; 
hex_to_string   ; since address is in word size 
    LEA LIST_HEX, A0        ; load list hex into A0 
    MOVE.L  A6, D2          ; move A6(address value) into D2   
    MOVE.B  #init, D0       ; initilize count 0 in D0   
        
    CMPI.B  #long, D1       ; if size is long 
    BEQ initLong            ; 
    
    CMPI.B  #word, D1       ; if size is word   
    BEQ initWord            ; 
    
    CMPI.B  #byte, D1       ; if size is byte   
    BEQ initByte            ; 
    
initLong
    MOVE.L  #$F0000000, D3  ;
    BRA htsLoop             ;  

initWord
    MOVE.L  #$0000F000, D3  ; 
    BRA htsLoop             ; 

initByte    
    MOVE.L  #$000000F0, D3  ; 
    BRA htsLoop             ; 
    
htsLoop 
    CMP.B   D0, D1          ; 
    BEQ htsDone             ;
    
    * A0 has list_hex, D2 has address val, D3 has mask (D0, D1 reserved) 
    MOVE.L  D2, D4  ; copy addr value into D4   
    AND.L   D3, D4  ; masking and store in D4   
    
    * shift amount(D5) = (size(D1) * 2) - 1 - current(D0)
    MOVE.L  D1, D5      ; 
    SUBI.L  #1, D5      ;   ((size) - 1 -> D5); 
    SUB.L  D0, D5       ;   ((size) - 1 - current ->D5)
    MOVE.L  #4, D6      ; 
    MULU.W  D6, D5      ;  ((size) - 1 - current ->D5) * 4
    
    LSR.L   D5, D4      ; shift masked value right by shift amount
    LSR.L   D6, D3      ; shift mask to the right   
    
    * now D4 contains 4bits, find character in the hex list and add into result message 
    MOVEA.L A0, A3      ; copy hex list starting address to A3     
    ADD.L   D4, A3      ; index of character    
    MOVE.B  (A3), (A5)+ ; move the character into result message    
    
    ADDI.B  #increment, D0  ; 
    BRA htsLoop ;  
    
htsDone    
    RTS 
    
    

* logical shift because sign is not necessary 
get_firstFourBits       ; from word input in D5,    return in D0    
    MOVE.W  D5, D0      ;
    MOVE.B  #12, D1     ;  
    LSR.W   D1, D0      ; 
    RTS 
    
*  logical shift because sign is not necessary 
get_secondFourBits      ; from word input in D5, return in D1 
    MOVE.W  D5, D1      ;
    MOVE.B  #4, D2      ; 
    LSL.W   D2, D1      ;
    MOVE.B  #12, D2     ;  
    LSR.W   D2, D1  ;  
    RTS 


* clear console page    
* print a page and go back to decode_loop to continue   
finish_page 
    BSR clearScreen 
    BSR print_page  
    BRA decode_loop

* print a page that contains "human readable" code    
print_page  
    MOVE.B  #NULL, (A5)+ 
    MOVEA.L A4, A1          ; 
    MOVE.B  #13, D0         ; 
    TRAP    #15             ; 
    RTS 
        
        
        
finishProgram   
    BSR printFinalMessage   ; 
    BSR finishingInput      ; 
    
    SIMHALT                 ; halt simulator

    
printContinueMessage
    LEA CONTINUE_MSG, A1    ;   
    MOVE.B  #14, D0         ;   
    TRAP    #15             ;   

    RTS 

takeContinueInput
    LEA INPUT, A1           ; dummy input holder      
    
    * take input    
    MOVE.B  #2, D0          ;   
    TRAP    #15             ;
   
    RTS     
    
    
* print final message before exit   
printFinalMessage           ;     
    LEA FINAL_MSG, A1       ;   
    MOVE.B  #14, D0         ;   
    TRAP    #15             ;   

    RTS 

* take final input to exit program  
finishingInput              ; 
    LEA INPUT, A1           ;  
    
    * take input    
    MOVE.B  #2, D0          ;   
    TRAP    #15             ;   
    RTS     
    
clearScreen     
    MOVE.B  #11, D0         ;    
    MOVE.W  #$FF00, D1      ;    
    TRAP    #15             ;
    RTS    



*OP_ADD_MSG 
*    LEA ADD_MSG, A6 ; 
*    MOVE.B  #3, D6  ; we know that 'add' size is 3  
*    BSR copyLoop    ; 


* D6 contains the size of the string and A6  has string 
copy_string 
    MOVE.B  #0, D5          ;
copyLoop          
    CMP.B   D5, D6          ;    
    BEQ copyLoopDone        ;   
    MOVE.B  (A6)+, (A5)+    ; A6 = string, A5 = result message
    ADDI.B  #1, D5          ;   
    BRA copyLoop           ;
copyLoopDone
    RTS                     ;     

* D5 contains opcode, A2 contains next opcode to read from memory   
* A5 contains result output pointer (string) 
* Decode functions************************************************************************************ 
RTS_function    
    LEA RTS_, A6    ; move memory address for RTS characters    
    MOVE.B  #3, D6      ; RTS is 3 characters, size of string into D6   
    BSR copy_string       ;   
    BRA decode_end  

NOP_function
    LEA NOP_, A6        ; move memory address for NOP characters    
    MOVE.B  #3, D6      ; NOP is 3 characters, size of string into D6   
    BSR copy_string     ;   
    BRA decode_end  
 
* zero_start********************
ORI_function
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0        
    * add function name in temporary memory 
    MOVE.B  #O_, (A5)+   ;   
    MOVE.B  #R_, (A5)+   ;   
    MOVE.B  #I_, (A5)+   ; 
    MOVE.B  #PERIOD, (A5)+    
    
    * check size  00 - byte, 01 - word, 10 - long     
    MOVE.W  D5, D0          ;   copy opcode into D0 only byte size because starts with $00    
    MOVE.W  #$00C0, D6      ;   bit mask in D6  
    MOVE.B  #6, D7          ;   shift value after masking   
    BSR get_bit             ;   return size in D0   
    
    CMPI.B  #$00, D0        ;   if size == 0
        BEQ add_B           ;         
    CMPI.B  #$01, D0        ;   if size == 1 
        BEQ add_W      
    CMPI.B  #$02, D0        ;   if size == 2    
        BEQ add_L           ; 
    
    MOVEM.L (A7)+, A5       ;   
    BRA invalid_code        ;  

add_B
    MOVE.B  #B_, (A5)+      ;
    MOVE.B  #TAB, (A5)+     ;
    MOVE.B  #SHARP, (A5)+   ; 
    MOVE.B  #DOLLAR, (A5)+  ;    
    MOVE.W  (A2)+, A6       ;   A6 now contains word size next opcode   
      
valid   
    MOVE.B  #byte, D1       ; 
    MOVEM.L D5/A0, -(A7)    ;   
    BSR hex_to_string       ;   
    MOVEM.L (A7)+, D5/A0    ; 
    
    BRA check_mode          ;     
add_W   
    MOVE.B  #W_, (A5)+      ;
    MOVE.B  #TAB, (A5)+     ;
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+  ;   
    MOVE.W  (A2)+, A6       ;   read next opcode word size    
    MOVE.B  #word, D1       ;   
    MOVEM.L D5/A0, -(A7)    ; 
    BSR hex_to_string       ;   
    MOVEM.L (A7)+, D5/A0    ;
    
    BRA check_mode          ;   
add_L     
    MOVE.B  #L_, (A5)+      ;   
    MOVE.B  #TAB, (A5)+     ;
    MOVE.B  #SHARP, (A5)+   ;  
    MOVE.B  #DOLLAR, (A5)+  ;   
    MOVE.L  (A2)+, A6       ;   
    MOVE.B  #long, D1       ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string       ;   
    MOVEM.L (A7)+, D5/A0    ;
    
    BRA check_mode          ;   
    

check_mode  
    MOVE.B  #COMMA, (A5)+   ;   
    MOVe.B  #SPACE, (A5)+   ;   
    * check mode 000(Dn), 010 ((An)), 011((An)+), 100, (-(An)), 111(xxx.W or xxx.L)
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6  
    MOVE.B  #3, D7      ;   shift value after masking  
    BSR get_bit         ;   get mode bit    
    MOVE.W  D0, D1      ;   move mode bits to D1    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking  
    BSR get_bit         ;   get mode bit    
    
    * now D1 has mode bits, D0 has register bits    
    
    CMPI.W  #$00, D1            ;   if mode == 000   
    BEQ ori_Data_reg            ;   
    
    CMPI.W  #$02, D1            ;   if mode == 010 
    BEQ ori_Addr_paren          ;      
    
    CMPI.W  #$03, D1            ;   if mode == 011 
    BEQ ori_Addr_paren_plus     ;   
    
    CMPI.W  #$04, D1            ;   if mode == 100 
    BEQ ori_Addr_paren_minus    ;

    CMPI.w  #$07, D1            ;   if mode == 111 
    BEQ ori_ea                  ;      
    
    MOVEM.L (A7)+, A5           ;   Restore A5  from the stack  
    BRA invalid_code            ;   otherwise, invalid code 
    
ori_Data_reg
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;      

    BRA ori_done                ;   

ori_Addr_paren
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number  
    MOVE.B  #A_, (A5)+          ;
    BSR put_number              ;      
  
    MOVE.B  #Close_paren, (A5)+ ;
    BRA ori_done                ;   

ori_Addr_paren_plus
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number        
    MOVE.B  #A_, (A5)+          ;
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    MOVE.B  #PLUS, (A5)+        ;

    BRA ori_done                ;      
ori_Addr_paren_minus
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number    
    MOVE.B  #Open_paren, (A5)+  ;   
    MOVE.B  #A_, (A5)+          ;
    BSR put_number              ;      
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA ori_done                ;   
ori_ea  
    MOVE.B  #DOLLAR, (A5)+      ;   
    CMPI.W  #$00, D0            ; if register == 00 
    BEQ word_ea                 ;   
    
    CMPI.W  #$01, D0            ; if register == 01   
    BEQ long_ea                 ;  

    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ;    
    
word_ea                         ;       
    MOVEA.W (A2)+, A6           ; read word size more opcode       
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;       
    MOVEM.L (A7)+, D5/A0        ;
    BRA ori_done                ;   

long_ea                         ;   
    MOVEA.L (A2)+, A6           ; 
    MOVE.W  #long, D1           ; read long size more opcode      
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    BRA ori_done                ;   

ori_done    
    * copy into the result message  ;  
    * get size of the message    
    MOVEA.L A0, A6              ; move starting address back to A6   
    * count till A0 == A5       ;
    CLR D6                      ; D6 == 0    
ori_loop    
    CMPA.L  A0, A5  ;   
    BEQ ori_message_out 
    ADDI.L  #1, D6  ;   increment count  
    MOVE.L  A0, D5  ;   
    ADDI.L  #1, D5  ;   
    MOVEA.L D5, A0  ;   increment address   
    BRA ori_loop    ;   

    
ori_message_out     
    * D6 contains size and A6 pointing to the tempMessage   
    MOVEM.L (A7)+, A5   ;   Restore A5  from the stack  
    BSR copy_string     ;   
    BRA decode_end
    
***********************************************************************

BCLR_immediate_EA_function 
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0    
    
    * add function name in temporary memory 
    MOVE.B  #B_, (A5)+   ;   
    MOVE.B  #C_, (A5)+   ;   
    MOVE.B  #L_, (A5)+   ; 
    MOVE.B  #R_, (A5)+  ;       
    MOVE.B  #TAB, (A5)+ ;   
    
    * check size  00 - byte, 01 - word, 10 - long     
    MOVE.W  D5, D0  ;   copy opcode into D0 only byte size because starts with $00    
    MOVE.W  #$00C0, D6    ;   bit mask in D6  
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;   return size in D0   
  
    CMPI.B  #$02, D0    ;   if size == 1 
        BEQ bclr_immediate_ea_valid ;     
    
    MOVEM.L (A7)+, A5   ;   
    BRA invalid_code    ;  

bclr_immediate_ea_valid ;   
    * put immediate value in the temp message   
    MOVE.B  #SHARP, (A5)+   ; 
    MOVE.B  #DOLLAR, (A5)+  ;    
    MOVE.W  (A2)+, A6   ;   A6 now contains word size next opcode   
    
    * check if first 8 bits are 0s  
    MOVE.L  A6, D1      ;   
    LSR.W   #8, D1      ;   shift right 8   
    CMPI.B  #$00, D1    ;   if $00 is starting bits 
    BEQ bclr_im_val           ;   true, then go to valid  
    
    MOVEM.L (A7)+, A5   ;   Restore A5  from the stack  
    BRA invalid_code    ;   otherwise, go to invalid code   
bclr_im_val 
    MOVE.B  #byte, D1   ; 
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, D5/A0  ; 
    
    MOVE.B  #COMMA, (A5)+   ;
    MOVE.B  #SPACE, (A5)+   ;      

    * now get mode and register number  
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6  
    MOVE.B  #3, D7      ;   shift value after masking  
    BSR get_bit         ;   get mode bit    
    MOVE.W  D0, D1      ;   move mode bits to D1    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking  
    BSR get_bit         ;   get mode bit
    
    * D1 has mode, D0 has register number   
    CMPI.W  #$00, D1    ;  000   
    BEQ ori_Data_reg    ;   
    
    CMPI.W  #$02, D1    ;   010 
    BEQ ori_Addr_paren  ;      
    
    CMPI.W  #$03, D1    ;   011 
    BEQ ori_Addr_paren_plus  ;   
    
    CMPI.W  #$04, D1    ;   100 
    BEQ ori_Addr_paren_minus    ;

    CMPI.w  #$07, D1    ;   111 
    BEQ ori_ea          ;      
    
    
    MOVEM.L (A7)+, A5   ;   Restore A5  from the stack  
    BRA invalid_code    ;   otherwise, invalid code 
    
***********************************************************************

CMPI_function
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0        
    * add function name in temporary memory 
    MOVE.B  #C_, (A5)+   ;   
    MOVE.B  #M_, (A5)+   ;   
    MOVE.B  #P_, (A5)+  ;       
    MOVE.B  #I_, (A5)+   ; 
    MOVE.B  #PERIOD, (A5)+    
    
    * check size  00 - byte, 01 - word, 10 - long     
    MOVE.W  D5, D0  ;   copy opcode into D0 only byte size because starts with $00    
    MOVE.W  #$00C0, D6    ;   bit mask in D6  
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;   return size in D0   
    
    CMPI.B  #$00, D0    ;   if size == 0
        BEQ add_B     ;         
    CMPI.B  #$01, D0    ;   if size == 1 
        BEQ add_W      
    CMPI.B  #$02, D0    ;   if size == 2    
        BEQ add_L   ; 
    
    MOVEM.L (A7)+, A5   ;   
    BRA invalid_code    ;  

    
***********************************************************************
BCLR_Dn_EA 
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0        
    * add function name in temporary memory 
    MOVE.B  #B_, (A5)+   ;   
    MOVE.B  #C_, (A5)+   ;   
    MOVE.B  #L_, (A5)+  ;       
    MOVE.B  #R_, (A5)+   ; 
    MOVE.B  #TAB, (A5)+    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    CMPI.W  #6, D0      ;   
    BEQ bclr_dn_valid   ;   
    
    MOVEM.L (A7)+, A5   ;
    BRA invalid_code    ;

bclr_dn_valid                   ;
    * get first D register value    ;   
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0F00, D6  ; bit mask in D6    
    MOVE.B  #9, D7      ;   shift value after masking in D7 
    BSR get_bit     ;    

    MOVE.B  #D_, (A5)+  ;
    BSR put_number  ;   

    BRA check_mode     ;      
***********************************************************************
* one_start **********************************************************************************  
MOVE_B   
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    MOVE.B  #M_, (A5)+   ;   
    MOVE.B  #O_, (A5)+   ;   
    MOVE.B  #V_, (A5)+  ;       
    MOVE.B  #E_, (A5)+   ; 
    MOVE.B  #PERIOD, (A5)+  ;   
    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+ ;   

move_b_src     
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6    
    MOVE.B  #3, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of source  

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    * now D1 has source mode, D0 has source register number 
    CMPI.W  #$0000, D1          ; if mode == 0  
    BEQ move_b_Data_reg         ;   

    CMPI.W  #$0001, D1          ; if mode == 1  
    BEQ move_b_Addr_reg         ;   

    CMPI.W  #$0002, D1          ; if mode == 2     
    BEQ move_b_Addr_reg_paren ;   

    CMPI.W  #$0003, D1          ; if mode == 3    
    BEQ move_b_Addr_reg_plus    ;   

    CMPI.W  #$0004, D1          ; if mode == 4  
    BEQ move_b_Addr_reg_minus   ;   

    CMPI.W  #$0007, D1          ; if mode == 7  
    BEQ move_b_ea_im            ;   
    
    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ; otherwise return invalid message  

move_b_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;   
    
    BRA move_b_dest             ;   

move_b_Addr_reg 
    MOVE.B  #A_, (A5)+          ; put An with number    
    BSR put_number              ;   
    
    BRA move_b_dest             ;

move_b_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number  
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA move_b_dest             ;   

move_b_addr_reg_plus            ;   
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA move_b_dest             ;

move_b_addr_reg_minus           ; put -(An) with number 
    MOVE.B  #MINUS, (A5)+       ;   
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA move_b_dest ;

move_b_ea_im    ;
    CMPI.W  #$0000, D0          ; if register == 0  
    BEQ move_b_src_word         ;   
    
    CMPI.W  #$0001, D0          ; if register == 1  
    BEQ move_b_src_long         ;   
    
    CMPI.W  #$0004, D0          ; if register == 4  
    BEQ move_b_src_imm          ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid message  
    BRA invalid_code            ;   

move_b_src_word 
    MOVE.B  #DOLLAR, (A5)+      ; read more opcode word size    
    MOVEA.W (A2)+, A6           ;   
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ; 
    
    BRA move_b_dest 
move_b_src_long
    MOVE.B  #DOLLAR, (A5)+      ; read more opcode long size    
    MOVEA.L (A2)+, A6           ;   
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ; 
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_b_dest ;   
    
move_b_src_imm      
    MOVE.B  #SHARP, (A5)+       ; read more opcode word size      
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ;   
    MOVE.W  #byte, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_b_dest ;

move_b_dest
    MOVE.B  #COMMA, (A5)+       ;   
    MOVE.B  #SPACE, (A5)+       ;   
    
    * now do the samething for dest 
    * get dest mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of dest mode    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0E00, D6  ;   bit mask in D6  
    MOVE.B  #9, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains register of dest    
    
    * now D1 has dest mode, D0 has dest register number 
    CMPI.W  #$0000, D1                  ; if mode == 0     
    BEQ dest_move_b_Data_reg            ;    

    CMPI.W  #$0002, D1                  ; if mode == 2  
    BEQ dest_move_b_Addr_reg_paren      ;   

    CMPI.W  #$0003, D1                  ; if mode == 3  
    BEQ dest_move_b_Addr_reg_plus       ;   

    CMPI.W  #$0004, D1                  ; if mode == 4  
    BEQ dest_move_b_Addr_reg_minus      ;   

    CMPI.W  #$0007, D1                  ; if mode == 7  
    BEQ dest_move_b_ea                  ;   
    
    MOVEM.L (A7)+, A5                   ; otherwise return invalid message  
    BRA invalid_code    

dest_move_b_Data_reg 
    MOVE.B  #D_, (A5)+                  ; put Dn with number    
    BSR put_number                      ;   
    
    BRA move_b_done                     ;     

dest_move_b_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+          ; putn (An) with number 
    MOVE.B  #A_, (A5)+                  ;   
    BSR put_number                      ;   
    MOVE.B  #Close_paren, (A5)+         ;   
    
    BRA move_b_done                     ;   

dest_move_b_addr_reg_plus               ; put (An)+ with number    
    MOVE.B  #Open_paren, (A5)+          ;     
    MOVE.B  #A_, (A5)+                  ;   
    BSR put_number                      ;   
    MOVE.B  #Close_paren, (A5)+         ;  
    MOVE.B  #PLUS, (A5)+                ;   
    BRA move_b_done                     ;

dest_move_b_addr_reg_minus              ;
    MOVE.B  #MINUS, (A5)+               ; put -(An) with number    
    MOVE.B  #Open_paren, (A5)+          ;     
    MOVE.B  #A_, (A5)+                  ;   
    BSR put_number                      ;   
    MOVE.B  #Close_paren, (A5)+         ;  

    BRA move_b_done                     ;

dest_move_b_ea                          ;
    CMPI.W  #$0000, D0                  ; if register == 0   
    BEQ dest_move_b_src_word            ;   
    
    CMPI.W  #$0001, D0                  ; if register == 1  
    BEQ dest_move_b_src_long            ;   
    
    MOVEM.L (A7)+, A5                   ;   
    BRA invalid_code                    ; otherwise return invalid message     

dest_move_b_src_word 
    MOVE.B  #DOLLAR, (A5)+              ; read word size opcode more      
    MOVEA.W (A2)+, A6                   ;   
    MOVE.W  #word, D1                   ;   
    MOVEM.L D5/A0, -(A7)                ;
    BSR hex_to_string                   ;   
    MOVEM.L (A7)+, D5/A0                ;
    
    BRA move_b_done 
dest_move_b_src_long
    MOVE.B  #DOLLAR, (A5)+              ; read long size opcode more    
    MOVEA.L (A2)+, A6                   ;   
    MOVE.W  #long, D1                   ;   
    MOVEM.L D5/A0, -(A7)                ; 
    BSR hex_to_string                   ;   
    MOVEM.L (A7)+, D5/A0                ;
    
    BRA move_b_done                     ;   
    
move_b_done 
    BRA ori_done    ;   
    
* two_start *************************************************************************************   
MOVE_MOVEA_L
    * check dest mode part and distinguish whether MOVE.L or MOVEA.L    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    MOVE.B  #M_, (A5)+      ;   
    MOVE.B  #O_, (A5)+      ;   
    MOVE.B  #V_, (A5)+      ;       
    MOVE.B  #E_, (A5)+      ; 
    
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains 6, 7, 8th bits  
    
    CMPI.W  #$0001, D0  ;   
    BEQ MOVEA_L 
    
    * other wise, it is move L  ;   
    MOVE.B  #PERIOD, (A5)+      ;   
    MOVE.B  #L_, (A5)+          ;   
    MOVE.B  #TAB, (A5)+         ;   
    
    BRA MOVE_L                  ;   

    
MOVEA_L 
    MOVE.B  #A_, (A5)+          ;   
    MOVE.B  #PERIOD, (A5)+      ;   
    MOVE.B  #L_, (A5)+          ;   
    MOVE.B  #TAB, (A5)+         ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6    
    MOVE.B  #3, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of source  

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    * now D1 has source mode, D0 has source register number 
    CMPI.W  #$0000, D1          ; if mode == 0
    BEQ movea_l_Data_reg        ;   

    CMPI.W  #$0001, D1          ; if mode == 1  
    BEQ movea_l_Addr_reg        ;   

    CMPI.W  #$0002, D1          ; if mode == 2  
    BEQ movea_l_Addr_reg_paren  ;   

    CMPI.W  #$0003, D1          ; if mode == 3  
    BEQ movea_l_Addr_reg_plus   ;   

    CMPI.W  #$0004, D1          ; if mode == 4  
    BEQ movea_l_Addr_reg_minus  ;   

    CMPI.W  #$0007, D1          ; if mode == 7  
    BEQ movea_l_ea_im           ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid message  
    BRA invalid_code    

movea_l_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;   
    
    BRA movea_l_dest            ;   

movea_l_Addr_reg 
    MOVE.B  #A_, (A5)+          ; put An with number    
    BSR put_number              ;   
    
    BRA movea_l_dest            ;

movea_l_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number  
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA movea_l_dest            ;   

movea_l_addr_reg_plus           ;   
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number 
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA movea_l_dest            ;

movea_l_addr_reg_minus          ;
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number 
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA movea_l_dest            ;

movea_l_ea_im                   ;
    CMPI.W  #$0000, D0          ; if register == 0  
    BEQ movea_l_src_word        ;   
    
    CMPI.W  #$0001, D0          ; if register == 1  
    BEQ movea_l_src_long        ;   
    
    CMPI.W  #$0004, D0          ; if register == 4  
    BEQ movea_l_src_imm         ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid message  
    BRA invalid_code            ;   

movea_l_src_word 
    MOVE.B  #DOLLAR, (A5)+      ; read word size more opcode    
    MOVEA.W (A2)+, A6           ;   
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;  
    
    BRA movea_l_dest 
movea_l_src_long
    MOVE.B  #DOLLAR, (A5)+      ; read long size more opcode    
    MOVEA.L (A2)+, A6           ;   
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ; 
    
    BRA movea_l_dest            ;   
    
movea_l_src_imm      
    MOVE.B  #SHARP, (A5)+       ; read long size more opcode    
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.L (A2)+, A6           ;   
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ; 
    
    BRA movea_l_dest            ;

movea_l_dest
    MOVE.B  #COMMA, (A5)+   ;   
    MOVE.B  #SPACE, (A5)+   ;   
    
    * now do the samething for dest but don't need mode everything goes to An    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0E00, D6  ;   bit mask in D6  
    MOVE.B  #9, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains register of dest    
    
    * now D1 has dest mode, D0 has dest register number 

dest_movea_l_Addr_reg        
    MOVE.B  #A_, (A5)+  ;   
    BSR put_number  ;      

movea_l_done    
    BRA ori_done    ;   

MOVE_L    
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6    
    MOVE.B  #3, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of source  

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    * now D1 has source mode, D0 has source register number 
    CMPI.W  #$0000, D1              ; if mode == 0  
    BEQ move_l_Data_reg             ;   

    CMPI.W  #$0001, D1              ; if mode == 1    
    BEQ move_l_Addr_reg             ;   

    CMPI.W  #$0002, D1              ; if mode == 2  
    BEQ move_l_Addr_reg_paren       ;   

    CMPI.W  #$0003, D1              ; if mode == 3  
    BEQ move_l_Addr_reg_plus        ;   

    CMPI.W  #$0004, D1              ; if mode == 4  
    BEQ move_l_Addr_reg_minus       ;   

    CMPI.W  #$0007, D1              ; if mode == 7  
    BEQ move_l_ea_im                ;   
    
    MOVEM.L (A7)+, A5               ; otherwise return invalid message  
    BRA invalid_code    

move_l_Data_reg 
    MOVE.B  #D_, (A5)+              ; put Dn with number    
    BSR put_number                  ;   
    
    BRA move_l_dest                 ;   

move_l_Addr_reg 
    MOVE.B  #A_, (A5)+              ; put An with number    
    BSR put_number                  ;   
    
    BRA move_l_dest                 ;

move_l_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+      ; put (An) with number   
    MOVE.B  #A_, (A5)+              ;   
    BSR put_number                  ;   
    MOVE.B  #Close_paren, (A5)+     ;   
    
    BRA move_l_dest                 ;   

move_l_addr_reg_plus                ;   
    MOVE.B  #Open_paren, (A5)+      ; put (An)+ with number 
    MOVE.B  #A_, (A5)+              ;   
    BSR put_number                  ;   
    MOVE.B  #Close_paren, (A5)+     ;  
    MOVE.B  #PLUS, (A5)+            ;   
    BRA move_l_dest                 ;

move_l_addr_reg_minus   ;
    MOVE.B  #MINUS, (A5)+           ; put -(An) with number 
    MOVE.B  #Open_paren, (A5)+      ;     
    MOVE.B  #A_, (A5)+              ;   
    BSR put_number                  ;   
    MOVE.B  #Close_paren, (A5)+     ;  

    BRA move_l_dest                 ;

move_l_ea_im    ;
    CMPI.W  #$0000, D0              ; if register == 0  
    BEQ move_l_src_word             ;   
    
    CMPI.W  #$0001, D0              ; if register == 1  
    BEQ move_l_src_long             ;   
    
    CMPI.W  #$0004, D0              ; if register == 4  
    BEQ move_l_src_imm              ;   
    
    MOVEM.L (A7)+, A5               ; otherwise return invalidemessage  
    BRA invalid_code                ;   

move_l_src_word 
    MOVE.B  #DOLLAR, (A5)+          ; read word size more opcode      
    MOVEA.W (A2)+, A6               ;   
    MOVE.W  #word, D1               ;   
    MOVEM.L D5/A0, -(A7)            ;
    BSR hex_to_string               ;   
    MOVEM.L (A7)+, D5/A0            ;
    
    BRA move_l_dest 
move_l_src_long
    MOVE.B  #DOLLAR, (A5)+          ; read long size more opcode    
    MOVEA.L (A2)+, A6               ;   
    MOVE.W  #long, D1               ;   
    MOVEM.L D5/A0, -(A7)            ;  
    BSR hex_to_string               ;   
    MOVEM.L (A7)+, D5/A0            ;
    
    BRA move_l_dest                 ;   
    
move_l_src_imm      
    MOVE.B  #SHARP, (A5)+           ; read long size more opcode       
    MOVE.B  #DOLLAR, (A5)+          ; 
    MOVEA.L (A2)+, A6               ;   
    MOVE.W  #long, D1               ;   
    MOVEM.L D5/A0, -(A7)            ;
    BSR hex_to_string               ;   
    MOVEM.L (A7)+, D5/A0            ;
    
    BRA move_l_dest                 ;

move_l_dest
    MOVE.B  #COMMA, (A5)+   ;   
    MOVE.B  #SPACE, (A5)+   ;   
    
    * now do the samething for dest 
    * get dest mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of dest mode    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0E00, D6  ;   bit mask in D6  
    MOVE.B  #9, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains register of dest    
    
    * now D1 has dest mode, D0 has dest register number 
    CMPI.W  #$0000, D1                  ; if mode == 0     
    BEQ dest_move_l_Data_reg            ;    

    CMPI.W  #$0002, D1                  ; if mode == 2  
    BEQ dest_move_l_Addr_reg_paren      ;   

    CMPI.W  #$0003, D1                  ; if mode == 3  
    BEQ dest_move_l_Addr_reg_plus       ;   

    CMPI.W  #$0004, D1                  ; if mode == 4  
    BEQ dest_move_l_Addr_reg_minus      ;   

    CMPI.W  #$0007, D1                  ; if mode == 7  
    BEQ dest_move_l_ea                  ;   
    
    MOVEM.L (A7)+, A5                   ; otherwise return invalid message     
    BRA invalid_code    

dest_move_l_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;   
    
    BRA move_l_done             ;     

dest_move_l_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number       
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA move_l_done             ;   

dest_move_l_addr_reg_plus       ;   
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number      
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA move_l_done             ;

dest_move_l_addr_reg_minus      ;
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number 
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA move_l_done             ;

dest_move_l_ea                  ;
    CMPI.W  #$0000, D0          ; if register == 0  
    BEQ dest_move_l_src_word    ;   
    
    CMPI.W  #$0001, D0          ; if register == 1  
    BEQ dest_move_l_src_long    ;   
    
    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ;   

dest_move_l_src_word 
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.W (A2)+, A6           ; read word size opcode more       
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_l_done 
dest_move_l_src_long
    MOVE.B  #DOLLAR, (A5)+      ; read long size opcode more    
    MOVEA.L (A2)+, A6           ;   
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ; 
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_l_done             ;   
    
move_l_done 
    
    BRA ori_done    ;    

* three_start ***************************************************************************   
MOVE_MOVEA_W    
* check dest mode part and distinguish whether MOVE.L or MOVEA.L    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    MOVE.B  #M_, (A5)+   ;   
    MOVE.B  #O_, (A5)+   ;   
    MOVE.B  #V_, (A5)+  ;       
    MOVE.B  #E_, (A5)+   ; 
    
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains 6, 7, 8th bits  
    
    CMPI.W  #$0001, D0          ;   
    BEQ MOVEA_W 
    
    * other wise, it is move L  ;   
    MOVE.B  #PERIOD, (A5)+      ;   
    MOVE.B  #W_, (A5)+          ;   
    MOVE.B  #TAB, (A5)+         ;   
    
    BRA MOVE_W                  ;   

    
MOVEA_W 
    MOVE.B  #A_, (A5)+      ;   
    MOVE.B  #PERIOD, (A5)+  ;   
    MOVE.B  #W_, (A5)+      ;   
    MOVE.B  #TAB, (A5)+     ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6    
    MOVE.B  #3, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of source  

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    * now D1 has source mode, D0 has source register number 
    CMPI.W  #$0000, D1          ; if mode == 0  
    BEQ movea_w_Data_reg        ;   

    CMPI.W  #$0001, D1          ; if mode == 1  
    BEQ movea_w_Addr_reg        ;   

    CMPI.W  #$0002, D1          ; if mode == 2  
    BEQ movea_w_Addr_reg_paren  ;   

    CMPI.W  #$0003, D1          ; if mode == 3  
    BEQ movea_w_Addr_reg_plus   ;   

    CMPI.W  #$0004, D1          ; if mode == 4  
    BEQ movea_w_Addr_reg_minus  ;   

    CMPI.W  #$0007, D1          ; if mode == 7  
    BEQ movea_w_ea_im           ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid message  
    BRA invalid_code    

movea_w_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;   
    
    BRA movea_w_dest            ;   

movea_w_Addr_reg 
    MOVE.B  #A_, (A5)+          ; put An with number    
    BSR put_number              ;   
    
    BRA movea_w_dest            ;

movea_w_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number  
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA movea_w_dest            ;   

movea_w_addr_reg_plus           ;   
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number      
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA movea_w_dest            ;

movea_w_addr_reg_minus          ;
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number 
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA movea_w_dest            ;

movea_w_ea_im                   ;
    CMPI.W  #$0000, D0          ;   if register == 0    
    BEQ movea_w_src_word        ;   
    
    CMPI.W  #$0001, D0          ;   if register == 1    
    BEQ movea_w_src_long        ;   
    
    CMPI.W  #$0004, D0          ;   if register == 4    
    BEQ movea_w_src_imm         ;   
    
    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ; return invalid message    

movea_w_src_word 
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.W (A2)+, A6           ; read more opcode wordsize    
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;        
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;  
    
    BRA movea_w_dest            ; 
movea_w_src_long
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.L (A2)+, A6           ; read more opcode longsize 
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ; 
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ; 
    
    BRA movea_w_dest            ;   
    
movea_w_src_imm      
    MOVE.B  #SHARP, (A5)+       ;   
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ; read more opcode wordsize 
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ; 
    
    BRA movea_w_dest            ;

movea_w_dest
    MOVE.B  #COMMA, (A5)+   ;   
    MOVE.B  #SPACE, (A5)+   ;   
    
    * now do the samething for dest but don't need mode everything goes to An    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0E00, D6  ;   bit mask in D6  
    MOVE.B  #9, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains register of dest    
    
    * now D1 has dest mode, D0 has dest register number 

dest_movea_w_Addr_reg        
    MOVE.B  #A_, (A5)+      ;   
    BSR put_number          ;      

movea_w_done    
    BRA ori_done    ;   

MOVE_W    
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0038, D6  ;   bit mask in D6    
    MOVE.B  #3, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of source  

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0007, D6  ;   bit mask in D6  
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   
    
    * now D1 has source mode, D0 has source register number 
    CMPI.W  #$0000, D1          ; if mode == 0  
    BEQ move_w_Data_reg         ;   

    CMPI.W  #$0001, D1          ; if mode == 1  
    BEQ move_w_Addr_reg         ;   

    CMPI.W  #$0002, D1          ; if mode == 2     
    BEQ move_w_Addr_reg_paren   ;   

    CMPI.W  #$0003, D1          ; if mode == 3  
    BEQ move_w_Addr_reg_plus    ;   

    CMPI.W  #$0004, D1          ; if mode == 4  
    BEQ move_w_Addr_reg_minus   ;   

    CMPI.W  #$0007, D1          ; if mode == 7  
    BEQ move_w_ea_im            ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid opcode   
    BRA invalid_code    

move_w_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number    
    BSR put_number              ;   
    
    BRA move_w_dest             ;   

move_w_Addr_reg 
    MOVE.B  #A_, (A5)+          ; put An with number    
    BSR put_number              ;   
    
    BRA move_w_dest             ;

move_w_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number  
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA move_w_dest             ;   

move_w_addr_reg_plus            ; put (An)+ with number   
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA move_w_dest             ;

move_w_addr_reg_minus           ;
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number    
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA move_w_dest             ;

move_w_ea_im                    ;
    CMPI.W  #$0000, D0          ; check if register == 0     
    BEQ move_w_src_word         ;   
    
    CMPI.W  #$0001, D0          ; check if register == 1    
    BEQ move_w_src_long         ;   
    
    CMPI.W  #$0004, D0          ; check if register == 4       
    BEQ move_w_src_imm          ;   
    
    MOVEM.L (A7)+, A5           ; otherwise return invalid message  
    BRA invalid_code            ;   

move_w_src_word 
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.W (A2)+, A6           ;   
    MOVE.W  #word, D1           ; read more opcode wordsize 
    MOVEM.L D5/A0, -(A7)        ; 
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_w_dest 
move_w_src_long
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.L (A2)+, A6           ; read more opcode longsize   
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_w_dest             ;   
    
move_w_src_imm      
    MOVE.B  #SHARP, (A5)+       ;   
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ; read more opcode word size       
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;  
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_w_dest             ;

move_w_dest
    MOVE.B  #COMMA, (A5)+   ;   
    MOVE.B  #SPACE, (A5)+   ;   
    
    * now do the samething for dest 
    * get dest mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$01C0, D6  ;   bit mask in D6    
    MOVE.B  #6, D7      ;   shift value after masking   
    BSR get_bit         ;
    MOVE.W  D0, D1      ;   D1 contains mode of dest mode    

    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$0E00, D6  ;   bit mask in D6  
    MOVE.B  #9, D7      ;   shift value after masking   
    BSR get_bit         ;   D0 contains register of dest    
    
    * now D1 has dest mode, D0 has dest register number 
    CMPI.W  #$0000, D1          ;   if mode == 0    
    BEQ dest_move_w_Data_reg ;    

    CMPI.W  #$0002, D1          ;   if mode == 2    
    BEQ dest_move_w_Addr_reg_paren ;   

    CMPI.W  #$0003, D1          ;   if mode == 3    
    BEQ dest_move_w_Addr_reg_plus    ;   

    CMPI.W  #$0004, D1          ;   if mode == 4    
    BEQ dest_move_w_Addr_reg_minus   ;   

    CMPI.W  #$0007, D1          ;   if mode == 7    
    BEQ dest_move_w_ea          ;   
    
    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ; 

dest_move_w_Data_reg 
    MOVE.B  #D_, (A5)+          ; put Dn with number 
    BSR put_number              ;   
    
    BRA move_w_done             ;     

dest_move_w_Addr_reg_paren   
    MOVE.B  #Open_paren, (A5)+  ; put (An) with number   
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;   
    
    BRA move_w_done             ;   

dest_move_w_addr_reg_plus       ;   
    MOVE.B  #Open_paren, (A5)+  ; put (An)+ with number      
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  
    MOVE.B  #PLUS, (A5)+        ;   
    BRA move_w_done             ;

dest_move_w_addr_reg_minus      ;
    MOVE.B  #MINUS, (A5)+       ; put -(An) with number    
    MOVE.B  #Open_paren, (A5)+  ;     
    MOVE.B  #A_, (A5)+          ;   
    BSR put_number              ;   
    MOVE.B  #Close_paren, (A5)+ ;  

    BRA move_w_done             ;

dest_move_w_ea                  
    CMPI.W  #$0000, D0          ; check if register == 0    
    BEQ dest_move_w_src_word    ;   
    
    CMPI.W  #$0001, D0          ; check if register == 1    
    BEQ dest_move_w_src_long    ;   
    
    MOVEM.L (A7)+, A5           ;   
    BRA invalid_code            ; otherwise print invalid mode     

dest_move_w_src_word 
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ; read word size opcode more      
    MOVE.W  #word, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;  
    BSR hex_to_string           ; put address in the temp message     
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_w_done             ;
dest_move_w_src_long
    MOVE.B  #DOLLAR, (A5)+      ;   
    MOVEA.L (A2)+, A6           ; read long size opcode more       
    MOVE.W  #long, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;  
    BSR hex_to_string           ; put address in the temp message   
    MOVEM.L (A7)+, D5/A0        ;
    
    BRA move_w_done             ;   
    
move_w_done 
    
    BRA ori_done    ;    
    
*********four_start *********************
NEG_function      
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
*Move NEG. into the temporary result*********
    MOVE.B  #N_, (A5)+
    MOVE.B  #E_, (A5)+
    MOVE.B  #G_, (A5)+
    MOVE.B  #PERIOD, (A5)+
    
    MOVE.W  D5, D0      ;   move the opcode into d0
    MOVE.W  #$00C0, D6  ;   move the bitmask into d6
    MOVE.B  #6, D7      ;   intended shift after masking into d7
    BSR get_bit         ;   get the size returned in d0
    
    CMPI.B  #$00, D0
        BEQ is_byte
    CMPI.B  #$01, D0
        BEQ is_word
    CMPI.B  #$02, D0
        BEQ is_long
        
is_byte
    MOVE.B  #B_, (A5)+       ;   move B to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA
    BRA getEA
    
is_word
    MOVE.B  #W_, (A5)+       ;   move W to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA
    BRA getEA

is_long
    MOVE.B  #L_, (A5)+       ;   move L to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA    
    BRA getEA
    
*************Get effective address*****************************************
getEA
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0

    CMPI.W  #$00, D1        ;   check if mode bits are 000 
    BEQ neg_Data_reg        ;   branch to (Dn)
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ neg_Addr_paren      ;   branch to add (An)   
    
    CMPI.W  #$03, D1        ;   check if mode bits are 011
    BEQ neg_Addr_paren_plus ;   branch to add (An)+
    
    CMPI.W  #$04, D1        ;   check if mode bits are 100
    BEQ neg_Addr_paren_minus   ;    branch to add -(An)

    CMPI.w  #$07, D1        ;   Check if mode bits are 000
    BEQ neg_ea              ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    
neg_Data_reg
    MOVE.B  #D_, (A5)+      ;   move 'D' to result 
    BSR put_number          ;   put register number (in D0) 

    BRA ori_done            ;   finished

neg_Addr_paren
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)   
  
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    BRA ori_done                ;   finished

neg_Addr_paren_plus
    MOVE.B  #Open_paren, (A5)+  ;   Add '(' 
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    MOVE.B  #PLUS, (A5)+        ;   Add '+'
        
    BRA ori_done                ;   finished  
  
neg_Addr_paren_minus
    MOVE.B  #MINUS, (A5)+       ;   Add '-'  
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)    
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    
    BRA ori_done                ;   finished 
    
neg_ea  
    MOVE.B  #DOLLAR, (A5)+      ;   Add '$'
    CMPI.W  #$00, D0            ;   Check if is word
    BEQ neg_word_ea             ;   branch if word
    
    CMPI.W  #$01, D0            ;   check if is long
    BEQ neg_long_ea             ;   branch if long

    MOVEM.L (A7)+, A5           ;   restore A5 from stack
    BRA invalid_code            ;   code is invalid
    
neg_word_ea      
    MOVEA.W (A2)+, A6           ;   
    MOVE.W  #word, D1           ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, A0           ;
    
    BRA ori_done                ;   

neg_long_ea                
    MOVEA.L (A2)+, A6           ;   
    MOVE.W  #long, D1           ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, A0           ;
    
    BRA ori_done                ;   
***************************END OF NEG***********************************
MOVEM_W_L_RtoM
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0

*********Move movem to temp result************
    MOVE.B  #M_, (A5)+
    MOVE.B  #O_, (A5)+
    MOVE.B  #V_, (A5)+
    MOVE.B  #E_, (A5)+
    MOVE.B  #M_, (A5)+
    MOVE.B  #PERIOD, (A5)+
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0040, D6      ;   bitmask to get size bit
    MOVE.B  #6, D7          ;   number to shift after masking
    BSR get_bit             ;   get this bit in d0
    
    CMPI.W  #$00, D0
    BEQ movem_w_RtM
    CMPI.W  #$01, D0
    BEQ movem_l_RtM
    
movem_invalid
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 

movem_w_RtM
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA movem_RtM
    
movem_l_RtM
    MOVE.B  #L_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA movem_RtM

movem_RtM
****Validation****
    MOVE.W (A2)+, D4       ;   move register list mask into d4 
    CMPI.W  #$00, D4        ;   validate that D4 is not all 0s
    BEQ movem_invalid
***Check if EA mode is predecrement***
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    
    CMPI.W  #$04, D0        ;   check if mode bits are 100 -(An)
    BEQ movem_predec        ;   branch to predec mode for reg list mas
    
    MOVE.B  #0, D1          ;   set D1 to 0 (acts as counter)
    
rlm_dn_loop
    CMPI.W  #8, D1          ;   check counter
    BEQ rlm_an_loop         ;   if 8, move to an loop (bits 8-15)
    BSR get_lsb             ;   get lsb in D0
    CMPI.W  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ add_reg             ;   add to list
    ADDI.B  #1, D1          ;   increment ctr
    LSR.W   #1, D4          ;   shift D4 right to get next lsb
    BRA rlm_dn_loop         ;   continue loop
    
   
add_reg
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #D_, (A5)+      ;   add 'D' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    ADDI.B  #1, D1          ;   add 1 to counter
    LSR.W   #1, D4          ;   
    CMPI.B  #$00, D4        ;   if rest is 0, no need to continue
    BEQ RtoM_EA
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    BRA rlm_dn_loop         ;   continue loop
    
    
rlm_an_loop
    MOVE.B  #0, D1          ;   reset counter
an_loop
    CMPI.W  #8, D1          ;   check counter
    BEQ RtoM_EA             ;   if 0, move to EA
    BSR get_lsb             ;   get lsb in D0
    CMPI.W  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ add_an_reg          ;   add to list
    ADDI.B  #1, D1          ;   increment ctr
    LSR.W   #1, D4          ;   shift D4 right to get next lsb
    BRA an_loop             ;   continue loop
    
   
add_an_reg
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #A_, (A5)+      ;   add 'A' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    ADDI.B  #1, D1          ;   add 1 to counter
    LSR.W   #1, D4          ;   shift right for next lsb
    CMPI.B  #$0000, D4        ;   if rest is 0 no need to continue
    BEQ RtoM_EA
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    BRA an_loop             ;   continue loop

get_lsb
    MOVE.W  D4, D0          ;   move reg list mask into d0
    MOVE.W  #$0001, D6      ;   bitmask to get ls bit
    MOVE.B  #0, D7          ;   number to shift after masking (none needed)
    BSR get_bit             ;   get this bit in d0
    RTS

RtoM_EA
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ neg_Addr_paren      ;   branch to add (An)   
    
    CMPI.W  #$04, D1        ;   check if mode bits are 100
    BEQ neg_Addr_paren_minus   ;    branch to add -(An)

    CMPI.w  #$07, D1        ;   Check if mode bits are 111
    BEQ neg_ea              ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    
******this mode works only for predecrement (RtM)
movem_predec
    MOVE.B  #8, D1          ;   set counter
RtM_predec_loop
    CMPI.B  #0, D1          ;   check counter
    BEQ RtM_dn_predec       ;   if 0, move to Dn loop (bits 8-15)
    BSR get_lsb             ;   get lsb in D0
    CMPI.B  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ add_an_reg_predec   ;   add to list
    LSR.W   #1, D4          ;   shift right for next lsb
    SUBI.B  #1, D1          ;   decrement ctr
    BRA RtM_predec_loop     ;   continue loop
    
   
add_an_reg_predec
    SUBI.B   #1, D1         ;   subtract 1 from counter
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #A_, (A5)+      ;   add 'A' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    LSR.W   #1, D4          ;   shift D4 right to prep for next lsb
    CMPI.W  #$0000, D4      ;   if the rest of D4 is 0, move on. No slash needed
    BEQ RtM_dn_predec
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    
    BRA RtM_predec_loop         ;   continue loop
    
    
RtM_dn_predec
    MOVE.B  #8, D1          ;   reset counter
RtM_dn_loop
    CMPI.B  #0, D1          ;   check counter
    BEQ RtoM_EA             ;   if 0, get EA
    BSR get_lsb             ;   get lsb in D0
    CMPI.B  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ add_dn_reg_RtM      ;   add to list
    LSR.W   #1, D4          ;   shift right for next lsb
    SUBI.B  #1, D1          ;   decrement ctr
    BRA RtM_dn_loop         ;   continue loop
    
   
add_dn_reg_RtM
    SUBI.B  #1, D1          ;   decrement counter
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #D_, (A5)+      ;   add 'D' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    LSR.W   #1, D4          ;   shift D4 right to get next lsb
    CMPI.W  #$0000, D4      ;   if rest is 0, get EA
    BEQ RtoM_EA
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    
    BRA RtM_dn_loop         ;   continue loop

  
**********************END OF RtM***********************
MULS_DIVS_L_MOVEM_W_L_MtoR  
    MOVEM.L A5, -(A7)       ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0          ;   starting address of temp      
    MOVEA.L A6, A5          ;   move starting address of curent temp Message
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$00C0, D6      ;   bitmask to get bits 6,7
    MOVE.B  #6, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0

    CMPI.W  #$00, D0
    BEQ muls_l              
    CMPI.W  #$01, D0
    BEQ divs_l
    
    BRA movem_w_l_mtr
    
muls_l
    MOVE.B  #M_, (A5)+
    MOVE.B  #U_, (A5)+
    MOVE.B  #L_, (A5)+
    MOVE.B  #S_, (A5)+
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #L_, (A5)+
    
    BSR muls_l_EA
    BRA check_muls
    
muls_l_EA
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0

    CMPI.W  #$00, D1        ;   check if mode bits are 000 
    BEQ muls_Data_reg        ;   branch to (Dn)
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ muls_Addr_paren      ;   branch to add (An)   
    
    CMPI.W  #$03, D1        ;   check if mode bits are 011
    BEQ muls_Addr_paren_plus ;   branch to add (An)+
    
    CMPI.W  #$04, D1        ;   check if mode bits are 100
    BEQ muls_Addr_paren_minus   ;    branch to add -(An)

    CMPI.w  #$07, D1        ;   Check if mode bits are 111
    BEQ muls_ea              ;   branch to check if W or L or data
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    
muls_Data_reg
    MOVE.B  #D_, (A5)+      ;   move 'D' to result 
    BSR put_number          ;   put register number (in D0) 

    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS

muls_Addr_paren
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)   
  
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS

muls_Addr_paren_plus
    MOVE.B  #Open_paren, (A5)+  ;   Add '(' 
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    MOVE.B  #PLUS, (A5)+        ;   Add '+'
        
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS
  
muls_Addr_paren_minus
    MOVE.B  #MINUS, (A5)+       ;   Add '-'  
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)    
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS
    
muls_ea  
    MOVE.B  #DOLLAR, (A5)+      ;   Add '$'
    CMPI.W  #$00, D0            ;   Check if is word
    BEQ muls_word_ea             ;   branch if word
    
    CMPI.W  #$01, D0            ;   check if is long
    BEQ muls_long_ea             ;   branch if long
    
    CMPI.W  #$03, D0
    BEQ muls_data_ea

    MOVEM.L (A7)+, A5           ;   restore A5 from stack
    BRA invalid_code            ;   code is invalid
    
muls_word_ea      
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS 

muls_long_ea                
    MOVEA.L (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS
    
muls_data_ea
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ;  
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    RTS

********END OF EA FOR MULS (also used for divs)*******
check_muls
**VALIDATE FORMAT**
    MOVE.W (A2)+, D4        ;   move next 16 bits into d4              ***************************************************************************************************************
    CMPI.W  #$00, D4        ;   validate that D4 is not all 0s
    BEQ movem_invalid       ;   invalid if true
    
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0800, D6      ;   bitmask to check bit 11- needs to be 1
    MOVE.B  #11, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bit in d0
    
    CMPI.W  #$01, D0        ;   compare result with necessary format (bit 11 = 1)
    BNE movem_invalid       ;   if not equal, invalid code
    
    MOVE.W  D4, D0          ;   move bits into d0
    MOVE.W  #$0400, D6      ;   bitmask to get bit 10
    MOVE.B  #10, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bit in d0
    
    CMPI.B  #$00, D0        ;   check size bit
    BEQ one_reg_muls
    CMPI.B  #$01, D0        ;   check size bit
    BEQ range_reg_muls
    
    BRA movem_invalid       ;   if somehow doesn't get branched- invalid code
    
one_reg_muls
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0700, D6      ;   bitmask to check bits 12-14 (register)
    MOVE.B  #12, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #D_, (A5)+
    BSR put_number          ;   add data register
    BRA ori_done            ;   finished
    
range_reg_muls
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0700, D6      ;   bitmask to check bits 12-14 (register)
    MOVE.B  #12, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #D_, (A5)+
    BSR put_number          ;   add data register
    
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0007, D6      ;   bitmask to check bits 0-2 (register 2)
    MOVE.B  #0, D7          ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #DASH, (A5)+
    MOVE.B  #D_, (A5)+
    BSR put_number
    
    BRA ori_done            ;   finished
***********END OF MULS.L*****************

divs_l
    MOVE.B  #D_, (A5)+
    MOVE.B  #I_, (A5)+
    MOVE.B  #V_, (A5)+
    MOVE.B  #S_, (A5)+
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #L_, (A5)+
    
    BSR muls_l_EA
    BRA check_divs
    
check_divs
**VALIDATE FORMAT**
    MOVE.W (A2)+, D4        ;   move next 16 bits into d4              ***************************************************************************************************************
    CMPI.W  #$00, D4        ;   validate that D4 is not all 0s
    BEQ movem_invalid       ;   invalid if true
    
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0800, D6      ;   bitmask to check bit 11- needs to be 1
    MOVE.B  #11, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bit in d0
    
    CMPI.W  #$01, D0        ;   compare result with necessary format (bit 11 = 1)
    BNE movem_invalid       ;   if not equal, invalid code
    
    MOVE.W  D4, D0          ;   move bits into d0
    MOVE.W  #$0400, D6      ;   bitmask to get bit 10
    MOVE.B  #10, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bit in d0
    
    CMPI.B  #$00, D0        ;   check size bit
    BEQ one_reg_divs
    CMPI.B  #$01, D0        ;   check size bit
    BEQ range_reg_divs
    
    BRA movem_invalid       ;   if somehow doesn't get branched- invalid code
    
one_reg_divs
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0700, D6      ;   bitmask to check bits 12-14 (register)
    MOVE.B  #12, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #D_, (A5)+
    BSR put_number          ;   add data register
    BRA ori_done            ;   finished
    
range_reg_divs
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0700, D6      ;   bitmask to check bits 12-14 (register)
    MOVE.B  #12, D7         ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #D_, (A5)+
    BSR put_number          ;   add data register
    
    MOVE.W  D4, D0          ;   move next 16 bits into d0
    MOVE.W  #$0007, D6      ;   bitmask to check bits 0-2 (register 2)
    MOVE.B  #0, D7          ;   number to shift after masking
    BSR get_bit             ;   get this bits in d0
    
    MOVE.B  #COLON, (A5)+
    MOVE.B  #D_, (A5)+
    BSR put_number
    
    BRA ori_done            ;   finished
    
*********END OF DIVS.l***************************************
    
movem_w_l_mtr
    MOVE.B  #M_, (A5)+
    MOVE.B  #O_, (A5)+
    MOVE.B  #V_, (A5)+
    MOVE.B  #E_, (A5)+
    MOVE.B  #M_, (A5)+
    MOVE.B  #PERIOD, (A5)+

    CMPI.W  #$02, D0
    BEQ movem_w_mtr
    CMPI.W  #$03, D0
    BEQ movem_l_mtr
    
    MOVEM.L (A7)+, A5           ;   restore A5 from stack
    BRA invalid_code            ;   code is invalid
    
movem_w_mtr
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA movem_MtR
    
movem_l_mtr
    MOVE.B  #L_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA movem_MtR
    
movem_MtR
    MOVE.W (A2)+, D4        ;   move register list mask into d4              ***************************************************************************************************************
    CMPI.W  #$0000, D4        ;   validate that D4 is not all 0s
    BEQ movem_invalid
 
MtR_movem_EA 
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ MtR_Addr_paren      ;   branch to add (An)   
    
    CMPI.W  #$03, D1        ;   check if mode bits are 011
    BEQ MtR_Addr_paren_plus ;   branch to add (An)+

    CMPI.W  #$07, D1        ;   Check if mode bits are 111
    BEQ MtR_ea              ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 

MtR_Addr_paren
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)   
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #0, D1              ;  set counter 
    BRA MtR_dn_loop             ;  branch to loop for list of registers

MtR_Addr_paren_plus
    MOVE.B  #Open_paren, (A5)+  ;   Add '(' 
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    MOVE.B  #PLUS, (A5)+        ;   Add '+'
        
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #0, D1              ;  set counter 
    BRA MtR_dn_loop             ;  branch to loop for list of registers
    
MtR_ea 
    MOVE.B  #DOLLAR, (A5)+      ;   Add '$'
    CMPI.W  #$00, D0            ;   Check if is word
    BEQ MtR_word_ea             ;   branch if word
    
    CMPI.W  #$01, D0            ;   check if is long
    BEQ MtR_long_ea             ;   branch if long

    MOVEM.L (A7)+, A5           ;   restore A5 from stack
    BRA invalid_code            ;   code is invalid
    
MtR_word_ea      
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #0, D1              ;  set counter 
    BRA MtR_dn_loop             ;  branch to loop for list of registers   

MtR_long_ea                
    MOVEA.L (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #0, D1              ;  set counter 
    BRA MtR_dn_loop             ;  branch to loop for list of registers
   
************************************END of MtR EA********************************************
MtR_dn_loop
    CMPI.W  #8, D1          ;   check counter
    BEQ MtR_an_loop         ;   if 8, move to an loop (bits 8-15)
    BSR get_lsb             ;   get lsb in D0
    CMPI.W  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ MtR_add_reg             ;   add to list
    ADDI.B  #1, D1          ;   increment ctr
    LSR.W   #1, D4          ;   shift D4 right to get next lsb
    BRA MtR_dn_loop         ;   continue loop
    
   
MtR_add_reg
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #D_, (A5)+      ;   add 'D' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    ADDI.B  #1, D1          ;   add 1 to counter
    LSR.W   #1, D4          ;   
    CMPI.W  #$0000, D4      ;   if rest is 0, no need to continue
    BEQ ori_done
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    BRA MtR_dn_loop         ;   continue loop
    
    
MtR_an_loop
    MOVE.B  #0, D1          ;   reset counter
an_loop_MtR
    CMPI.W  #8, D1          ;   check counter
    BEQ ori_done            ;   if 0, done
    BSR get_lsb             ;   get lsb in D0
    CMPI.W  #1, D0          ;   if bit == 1, branch to add to list 
    BEQ add_an_reg_MtR          ;   add to list
    ADDI.B  #1, D1          ;   increment ctr
    LSR.W   #1, D4          ;   shift D4 right to get next lsb
    BRA an_loop_MtR             ;   continue loop
    
   
add_an_reg_MtR
    MOVE.B  D1, D0          ;   move counter into d0
    MOVE.B  #A_, (A5)+      ;   add 'A' to result msg
    BSR put_number          ;   add reg num (counter) to result msg
    ADDI.B  #1, D1          ;   add 1 to counter
    LSR.W   #1, D4          ;   shift right for next lsb
    CMPI.B  #$0000, D4        ;   if rest is 0 no need to continue
    BEQ ori_done
    MOVE.B  #SLASH, (A5)+   ;   add '/' to result
    BRA an_loop_MtR             ;   continue loop
    
**********JSR***********
JSR_function    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
*****PUT JSR IN TEMP RESULT
    MOVE.B  #J_, (A5)+
    MOVE.B  #S_, (A5)+
    MOVE.B  #R_, (A5)+
    MOVE.B  #TAB, (A5)+
    
*Get EA*
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ neg_Addr_paren      ;   branch to add (An)   

    CMPI.W  #$07, D1        ;   Check if mode bits are 111
    BEQ neg_ea              ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    
*********END OF JSR****************

LEA_function
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
******MOVE LEA INTO TEMP RESULT************************
    MOVE.B  #L_, (A5)+
    MOVE.B  #E_, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  #TAB, (A5)+
    
lea_EA
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ lea_Addr_paren      ;   branch to add (An)   

    CMPI.W  #$07, D1        ;   Check if mode bits are 111
    BEQ lea_word_long_ea    ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    

lea_Addr_paren
    MOVE.B  #Open_paren, (A5)+  ;   Add '('
    MOVE.B  #A_, (A5)+          ;   Add 'A'
    BSR put_number              ;   Add register num (from d0)   
  
    MOVE.B  #Close_paren, (A5)+ ;   Add ')'
    BRA lea_add_an
    
lea_word_long_ea  
    MOVE.B  #DOLLAR, (A5)+      ;   Add '$'
    CMPI.W  #$00, D0            ;   Check if is word
    BEQ lea_word_ea             ;   branch if word
    
    CMPI.W  #$01, D0            ;   check if is long
    BEQ lea_long_ea             ;   branch if long

    MOVEM.L (A7)+, A5           ;   restore A5 from stack
    BRA invalid_code            ;   code is invalid
    
lea_word_ea      
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    BRA lea_add_an  

lea_long_ea                
    MOVEA.L (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L A0, -(A7)  
    BSR hex_to_string   ;   
    MOVEM.L (A7)+, A0  ;
    
    BRA lea_add_an
    
lea_add_an
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0E00, D6      ;   bitmask to get register bits
    MOVE.B  #9, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    
    BSR put_number          ;   Add the register number to result
    BRA ori_done            ;   finished

* five_start **********************
SUBQ_function     
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
*Move SUBQ. into the temporary result*********
    MOVE.B  #S_, (A5)+
    MOVE.B  #U_, (A5)+
    MOVE.B  #B_, (A5)+
    MOVE.B  #Q_, (A5)+
    MOVE.B  #PERIOD, (A5)+
    
    MOVE.W  D5, D0      ;   move the opcode into d0
    MOVE.W  #$00C0, D6  ;   move the bitmask into d6
    MOVE.B  #6, D7      ;   intended shift after masking into d7
    BSR get_bit         ;   get the size returned in d0
    
    CMPI.B  #$00, D0
        BEQ subq_is_byte
    CMPI.B  #$01, D0
        BEQ subq_is_word
    CMPI.B  #$02, D0
        BEQ subq_is_long
        
subq_is_byte
    MOVE.B  #B_, (A5)+       ;   move B to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA
    BRA get_subq_data
    
subq_is_word
    MOVE.B  #W_, (A5)+       ;   move W to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA
    BRA get_subq_data

subq_is_long
    MOVE.B  #L_, (A5)+       ;   move L to end of result
    MOVE.B  #TAB, (A5)+      ;   move tab to end of result to prepare for EA    
    BRA get_subq_data
    
*******Get the data field and add this. After this, get EA(will be same as neg EA)
get_subq_data
    MOVE.B  #SHARP, (A5)+
    
    MOVE.W  D5, D0
    MOVE.W  #$0E00, D6
    MOVE.B  #9, D7
    BSR get_bit
    
    CMPI.B  #$00, D0
        BEQ subq_eight
        
    BSR put_number
    MOVE.B #COMMA, (A5)+
    MOVE.B #SPACE, (A5)+
    BRA get_subq_EA
    
subq_eight                  ;   SUBQ supports 1-8 (000= 8)
    MOVE.B  #EIGHT_, (A5)+  ;
    MOVE.B  #COMMA, (A5)+   ;   
    MOVE.B  #SPACE, (A5)+   ;
    BRA get_subq_EA         ;
    
get_subq_EA
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   move mode bits into d1
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get register bits in d0
    
*************************This section refers to code used above for NEG***********
    CMPI.W  #$00, D1        ;   check if mode bits are 000 
    BEQ neg_Data_reg        ;   branch to (Dn)
    
    CMPI.W  #$01, D1        ;   check if mode bits are 001
    BEQ subq_add_an
    
    CMPI.W  #$02, D1        ;   check if mode bits are 010
    BEQ neg_Addr_paren      ;   branch to add (An)   
    
    CMPI.W  #$03, D1        ;   check if mode bits are 011
    BEQ neg_Addr_paren_plus ;   branch to add (An)+
    
    CMPI.W  #$04, D1        ;   check if mode bits are 100
    BEQ neg_Addr_paren_minus   ;    branch to add -(An)

    CMPI.w  #$07, D1        ;   Check if mode bits are 111
    BEQ neg_ea              ;   branch to check if W or L
    
    MOVEM.L (A7)+, A5       ;   Restore A5  from the stack  
    BRA invalid_code        ;   invalid code 
    
subq_add_an
    MOVE.B #A_, (A5)+       ;   Add 'A'
    BSR put_number          ;   Add register num (from d0)
    
    BRA ori_done            ;   finished
    

* six_start ***********************
BRA_function 
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #R_, (A5)+  ;   
    MOVE.B  #A_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0
    
bra_check   
    CMPI.B  #$00, D0    ;   if last 8 bits are $00  
    BRA bra_word        ;   go to word branch   
    
    CMPI.B  #$FF, D0    ;   if last 8bits are $FF   
    BRA bra_long        ;   go to long branch   
    
    * otherwise add current opcode number += D0 (8bit displacement) 
    MOVE.W  A2, D1  ;     
    ADD.L   D1, D0  ;   opcode += 8bit displacement -> D0   ;   
    BRA bra_end ;   
    
    
bra_word    
    MOVE.W  A2, D1          ;       
    MOVE.W   (A2)+, D0      ;
    ADD.L   D1, D0          ; Add displacement and current opcode address   
      
    BRA bra_end             ;   

bra_long    
    MOVE.W  A2, D1          ;    
    MOVE.L  (A2)+, D0       ;
    ADD.L   D1, D0          ; Add displacement and current opcode address   
      
    BRA bra_end             ;   

bra_end  
    MOVE.B  #DOLLAR, (A5)+  ;       
    MOVEA.L D0, A6          ;   
    MOVE.W  #long, D1       ;   
    MOVEM.L D5/A0, -(A7)    ;  
    BSR hex_to_string       ; put hex address of displacement + opcode into temp message       
    MOVEM.L (A7)+, D5/A0    ;

    BRA ori_done            ;   

BCC_function    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #C_, (A5)+  ;   
    MOVE.B  #C_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0

    BRA bra_check       ;    

BCS_function 
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #C_, (A5)+  ;   
    MOVE.B  #S_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0

    BRA bra_check       ;    

BVC_function    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #V_, (A5)+  ;   
    MOVE.B  #C_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0

    BRA bra_check       ;    
    
BGE_function    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #G_, (A5)+  ;   
    MOVE.B  #E_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0

    BRA bra_check       ;    
    
BLT_function    
    MOVEM.L A5, -(A7)   ;   save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0


    MOVE.B  #B_, (A5)+  ;   
    MOVE.B  #L_, (A5)+  ;   
    MOVE.B  #T_, (A5)+  ;   
    MOVE.B  #TAB, (A5)+    ;   
    * get source mode and register in D1 and D0 
    MOVE.W  D5, D0      ;   copy opcode into D0 
    MOVE.W  #$00FF, D6  ;   bit mask in D6    
    MOVE.B  #0, D7      ;   shift value after masking   
    BSR get_bit         ;   masked opcode in D0

    BRA bra_check       ;    

* eight_start *********************** 
OR_DIVS_W   
    MOVEM.L A5, -(A7)   ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0 
    
*decipher from or or divs.w
    MOVE.W  D5, D0      ;   move the opcode into d0
    MOVE.W  #$01C0, D6  ;   move the bitmask into d6
    MOVE.B  #6, D7      ;   intended shift after masking into d7
    BSR get_bit         ;   get the opmode returned in d0
    
    CMPI.B  #$07, D0    ;   is it DIVS.W
    BEQ divs_w
    BRA or
    
or
    MOVE.B  #O_, (A5)+
    MOVE.B  #R_, (A5)+
    
    MOVE.W  D0, D2          ;   copy the opmod into D2
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0E00, D6      ;   bitmask to get register bits
    MOVE.B  #9, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   copy the register into D1
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D3          ;   move EA mode bits into d3
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get EA register bits in d4
    MOVE.W  D0,D4           ;   move into d4
    
    *if EA mode is 001- An- invalid code (OR identical to ADD except doesn't
    *support An
    CMPI.B  #$01, D3
    BEQ add_invalid
    
    CMPI.B  #0, D2  
    BEQ add_byte_sourceEA
    CMPI.B  #1, D2
    BEQ add_word_sourceEA
    CMPI.B  #2, D2
    BEQ add_long_sourceEA
    CMPI.B  #4, D2  
    BEQ add_byte_destEA
    CMPI.B  #5, D2  
    BEQ add_word_destEA
    CMPI.B  #6, D2  
    BEQ add_long_destEA
    
    BRA add_invalid
    
*****end of or****

*DIVS.W and MULS.W are identical in structure except for their first four bits
*This function reuses functions from muls.w 
divs_w  
    MOVE.W  D0, D2          ;   copy the opmod into D2
    
    CMPI.B  #7, D2  
    BEQ keep_DIVS_W
    BRA invalid_code  

keep_DIVS_W 
    MOVE.B  #D_, (A5)+  
    MOVE.B  #I_, (A5)+  
    MOVE.B  #V_, (A5)+  
    MOVE.B  #S_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+  
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0E00, D6      ;   bitmask to get register bits
    MOVE.B  #9, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   copy the register into D1
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D3          ;   move EA mode bits into d3
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get EA register bits in d4
    MOVE.W  D0,D4           ;   move into d4
    
    BRA MULS_W_ea            * branch to MULS function for EA and Dn
    
* nine_start ***********************
SUB_function    
    MOVEM.L A5, -(A7)     ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    *Move SUB. into the temporary result*********
    MOVE.B  #S_, (A5)+
    MOVE.B  #U_, (A5)+
    MOVE.B  #B_, (A5)+
    
    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0E00, D6      ;   bitmask to get register bits
    MOVE.B  #9, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D1          ;   copy the register into D1
    
    MOVE.W  D5, D0      ;   move the opcode into d0
    MOVE.W  #$01C0, D6  ;   move the bitmask into d6
    MOVE.B  #6, D7      ;   intended shift after masking into d7
    BSR get_bit         ;   get the opmode returned in d0
    MOVE.B  D0,D2       ;   move into d2

    MOVE.W  D5, D0          ;   move opcode into d0
    MOVE.W  #$0038, D6      ;   bitmask to get mode bits
    MOVE.B  #3, D7          ;   number to shift after masking
    BSR get_bit             ;   get these bits in d0
    MOVE.W  D0, D3          ;   move EA mode bits into D3
    
    MOVE.W  D5, D0          ;   move the opcode into d0 again
    MOVE.W  #$0007, D6      ;   mask for last three bits
    MOVE.W  #0, D7          ;   no shift needed
    BSR get_bit             ;   get EA register bits in D4
    MOVE.W  D0,D4           ;   move into D4

    CMPI.B  #0, D2  
    BEQ add_byte_sourceEA
    CMPI.B  #1, D2
    BEQ add_word_sourceEA
    CMPI.B  #2, D2
    BEQ add_long_sourceEA
    CMPI.B  #4, D2  
    BEQ add_byte_destEA
    CMPI.B  #5, D2  
    BEQ add_word_destEA
    CMPI.B  #6, D2  
    BEQ add_long_destEA

    BRA add_invalid  
     

    
* B_start   ***********************
EOR_CMP 
    MOVEM.L A5, -(A7)     ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    

    MOVE.W  D5, D0  
    LSL.W   #7, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit 
    MOVE.W  D0, D2           * copy the value of bits stored in from 8-6 into D2
    
    MOVE.W  D5, D0           
    LSL.W   #4, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7
    BSR get_bit
    MOVE.W  D0, D1  *       copy the register into D1
            
    MOVE.W  D5, D0  
    LSL.W   #8, D0 
    LSL.W   #2, D0   
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D3           * copy the EA MODE into D3
    
    MOVE.W  D5, D0  
    LSL.W   #8, D0
    LSL.W   #5, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D4           * copy the EA Register into D4    
 
    CMPI.B  #0, D2  
    BEQ CMP_B_  
    CMPI.B  #1, D2
    BEQ CMP_W_    
    CMPI.B  #2, D2
    BEQ CMP_L_    
    CMPI.B  #4, D2
    BEQ EOR_B_    
    CMPI.B  #5, D2
    BEQ EOR_W_   
    CMPI.B  #6, D2
    BEQ EOR_L_    
    BRA invalid_code

CMP_B_
    MOVE.B  #C_, (A5)+  
    MOVE.B  #M_, (A5)+  
    MOVE.B  #P_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #B_, (A5)+  
    MOVE.B  #TAB, (A5)+ 
    BRA CMP_EA  
    
CMP_W_
    MOVE.B  #C_, (A5)+  
    MOVE.B  #M_, (A5)+  
    MOVE.B  #P_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #W_, (A5)+      
    MOVE.B  #TAB, (A5)+     
    BRA CMP_EA  

CMP_L_  
        MOVE.B  #C_, (A5)+    
        MOVE.B  #M_, (A5)+     
        MOVE.B  #P_, (A5)+  
        MOVE.B  #PERIOD, (A5)+  
        MOVE.B  #L_, (A5)+  
        MOVE.B  #TAB, (A5)+         
        BRA CMP_EA
      
EOR_B_
    MOVE.B  #E_, (A5)+  
    MOVE.B  #O_, (A5)+  
    MOVE.B  #R_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #B_, (A5)+  
    MOVE.B  #TAB, (A5)+
    BRA EOR_EA  
    
EOR_W_
    MOVE.B  #E_, (A5)+  
    MOVE.B  #O_, (A5)+  
    MOVE.B  #R_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #W_, (A5)+  
    MOVE.B  #TAB, (A5)+  
    BRA EOR_EA  
    
EOR_L_
    MOVE.B  #E_, (A5)+  
    MOVE.B  #O_, (A5)+  
    MOVE.B  #R_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #L_, (A5)+  
    MOVE.B  #TAB, (A5)+  
    BRA EOR_EA  
    
CMP_EA
     * check mode if it's valid 
     * addressing Mode is Dn
        CMPI.B  #0, D3  
        BEQ CMP_Dn
          
         CMPI.B #1, D3  
         BEQ    CMP_An
    
        * addressing Mode is (An)
       CMPI.B  #2, D3
        BEQ CMP_indirect_An  
        
        * addressing Mode is (An)+
        CMPI.B  #3, D3  
        BEQ CMP_An_plus
        
        * addressing Mode is -(An)
        CMPI.B  #4, D3  
        BEQ CMP_Minus_An
        
        * addressing Mode is either (xxx).W or (xxx).L
        CMPI.B  #7, D3 
        BEQ CMP_word_long_data  
        BRA CMP_EOR_invalid
   
 
CMP_Dn
        MOVE.B  #D_, (A5)+
        MOVE.B  D4, D0
        BSR put_number
        MOVE.B  #COMMA, (A5)+
        MOVE.B  #SPACE, (A5)+            
        MOVE.B  #D_, (A5)+
        MOVE.B  D1, D0  
        BSR put_number    
        BRA CMP_done  
       
       
CMP_An
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA CMP_done         
       
CMP_indirect_An
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA CMP_done  
  
CMP_An_plus 
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+       
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number  
    BRA CMP_done
    
CMP_Minus_An
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+       
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0
    BSR put_number        
    BRA CMP_done

CMP_word_long_data
    CMPI.B  #0, D4
    BEQ CMP_word
    CMPI.B  #1, D4
    BEQ CMP_long
    CMPI.B  #4, D4  
    BEQ CMP_data    
    BRA CMP_EOR_invalid
    
CMP_word
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #D_,    (A5)+
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA CMP_done      
    
CMP_long 
    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string    
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+   
    MOVEM.L (A7)+, A0   
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number  
    BRA CMP_done

CMP_data
    CMPI.B  #0, D2  
    BEQ CMP_data_byte    
    CMPI.B  #1, D2  
    BEQ CMP_data_word    
    CMPI.B  #2, D2  
    BEQ CMP_data_long    
    
    BRA CMP_EOR_invalid        

CMP_data_byte
    MOVE.B  D1, D7  
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;
    
    * check if first 8 bits are 0s  
    MOVE.L  A6, D1      ;   
    LSR.W   #8, D1      ;   shift right 8   
    CMPI.B  #$00, D1    ;   if $00 is starting bits 
    BEQ CMP_valid
    BRA CMP_EOR_invalid      

CMP_valid
    MOVE.B  #byte, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ; 
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number    
    BRA CMP_done      
   
CMP_data_word     
    MOVE.B  D1, D7  
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ; 
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number    
    BRA CMP_done    
 
CMP_data_long
    MOVE.B  D1, D7       
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.L (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ; 
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number    
    BRA CMP_done    

EOR_EA  
     * check mode if it's valid 
     * addressing Mode is Dn
    CMPI.B  #0, D3  
    BEQ EOR_Dn
                
    * addressing Mode is (An)
    CMPI.B  #2, D3
    BEQ EOR_indirect_An  
        
        * addressing Mode is (An)+
    CMPI.B  #3, D3  
   BEQ EOR_An_plus
        
        * addressing Mode is -(An)
     CMPI.B  #4, D3  
    BEQ EOR_Minus_An
        
        * addressing Mode is either (xxx).W or (xxx).L
    CMPI.B  #7, D3 
    BEQ EOR_word_long
     BRA CMP_EOR_invalid     
 
EOR_Dn
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    
    MOVE.B  #D_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    BRA CMP_done  
       
EOR_indirect_An
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+  
    BRA CMP_done  
  
EOR_An_plus
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    BRA CMP_done
    
EOR_Minus_An
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    BRA CMP_done

EOR_word_long
    CMPI.B  #0, D4
    BEQ EOR_word
    CMPI.B  #1, D4
    BEQ EOR_long
    BRA CMP_EOR_invalid

EOR_word
    MOVE.B  #D_,    (A5)+
    MOVE.B  D7, D0  
    BSR put_number  
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+       
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVEM.L (A7)+, A0   
    BRA CMP_done      
    
EOR_long
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number  
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string     
    MOVEM.L (A7)+, A0   
    BRA CMP_done

CMP_EOR_invalid
    MOVEM.L (A7)+, A5
    BRA invalid_code  
    
CMP_done   
    MOVEA.L A0, A6  
    CLR D6  
 
CMP_loop
    CMPA.L  A0, A5  ;   
    BEQ CMP_message_out 
    ADDI.L  #1, D6  ;   increment count  
    MOVE.L  A0, D5  ;   
    ADDI.L  #1, D5  ;   
    MOVEA.L D5, A0  ;   increment address   
    BRA CMP_loop    ;    

CMP_message_out
    MOVEM.L (A7)+, A5   
    BSR copy_string 
    BRA decode_end  


* C_start       ***********************    
MULS_W  
 MOVEM.L A5, -(A7)     ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    

    MOVE.W  D5, D0  
    LSL.W   #7, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit 
    MOVE.W  D0, D2           * copy the value of bits stored in from 8-6 into D2
    
    CMPI.B  #7, D2  
    BEQ keep_MULS_W
    BRA invalid_code  

keep_MULS_W 
    MOVE.B  #M_, (A5)+  
    MOVE.B  #U_, (A5)+  
    MOVE.B  #L_, (A5)+  
    MOVE.B  #S_, (A5)+  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+  
    
    MOVE.W  D5, D0           
    LSL.W   #4, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7
    BSR get_bit
    MOVE.W  D0, D1  *       copy the register into D1
            
    MOVE.W  D5, D0  
    LSL.W   #8, D0 
    LSL.W   #2, D0   
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D3           * copy the EA MODE into D3
    
    MOVE.W  D5, D0  
    LSL.W   #8, D0
    LSL.W   #5, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D4           * copy the EA Register into D4 
  
MULS_W_ea
    * check mode if it's valid 
    * addressing Mode is Dn
    CMPI.B  #0, D3  
    BEQ MULS_W_Dn    
    * addressing Mode is (An)
    CMPI.B  #2, D3
    BEQ MULS_W_indirect_An  
    * addressing Mode is (An)+
    CMPI.B  #3, D3  
    BEQ MULS_W_An_plus
    * addressing Mode is -(An)
    CMPI.B  #4, D3  
    BEQ MULS_W_Minus_An
    * addressing Mode is either (xxx).W or (xxx).L
    CMPI.B  #7, D3 
    BEQ MULS_W_source_word_long_data
    
    BRA MULS_W_invalid 

MULS_W_Dn
    MOVE.B  #D_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA MULS_W_done    

MULS_W_indirect_An
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA MULS_W_done  
  
MULS_W_An_plus
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA MULS_W_done
    
MULS_W_Minus_An
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA MULS_W_done
    
MULS_W_source_word_long_data
    CMPI.B  #0, D4
    BEQ MULS_W_word
    CMPI.B  #1, D4
    BEQ MULS_W_long
    CMPI.B  #4, D4  
    BEQ MULS_W_source_data 
    BRA MULS_W_invalid
    
MULS_W_word
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #D_,    (A5)+
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA MULS_W_done      
    
MULS_W_long
    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string     
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA MULS_W_done

MULS_W_source_data  
    MOVE.B  D1, D7
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ; 
  
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number    
    BRA MULS_W_done
 
MULS_W_invalid
    MOVEM.L (A7)+, A5
    BRA invalid_code  
    
MULS_W_done   
    MOVEA.L A0, A6  
    CLR D6  
 
MULS_W_loop
    CMPA.L  A0, A5  ;   
    BEQ message_out 
    ADDI.L  #1, D6  ;   increment count  
    MOVE.L  A0, D5  ;   
    ADDI.L  #1, D5  ;   
    MOVEA.L D5, A0  ;   increment address   
    BRA MULS_W_loop    ;    

message_out
    MOVEM.L (A7)+, A5   
    BSR copy_string 
    BRA decode_end  
    
* D_start   ***********************
ADD_ADDA    
    MOVEM.L A5, -(A7)     ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0          ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    MOVE.W  D5, D0            * copy the original opcode into D0
    LSL.W   #4, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7
    BSR get_bit
    MOVE.W  D0, D1  *       copy the register into D1
    
    MOVE.W  D5, D0  
    LSL.W   #7, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit 
    MOVE.W  D0, D2           * copy the opmod into D2
    
    MOVE.W  D5, D0  
    LSL.W   #8, D0 
    LSL.W   #2, D0   
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D3           * copy the EA MODE into D3
    
    MOVE.W  D5, D0  
    LSL.W   #8, D0
    LSL.W   #5, D0  
    MOVE.W  #$E000, D6  
    MOVE.B  #13, D7 
    BSR get_bit
    MOVE.W  D0, D4           * copy the EA Register into D4 
   
    * CHECK THE OPMODE TO CHECK WHICH Operand is EA (either source or destination)
    MOVE.B  #A_, (A5)+
    MOVE.B  #D_, (A5)+  
    MOVE.B  #D_, (A5)+
    
    CMPI.B  #0, D2  
    BEQ add_byte_sourceEA
    CMPI.B  #1, D2
    BEQ add_word_sourceEA
    CMPI.B  #2, D2
    BEQ add_long_sourceEA
    CMPI.B  #4, D2  
    BEQ add_byte_destEA
    CMPI.B  #5, D2  
    BEQ add_word_destEA
    CMPI.B  #6, D2  
    BEQ add_long_destEA
    CMPI.B  #3, D2  
    BEQ adda_word
    CMPI.B  #7, D2  
    BEQ adda_long   
    BRA add_invalid  
     
   
add_byte_sourceEA
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #B_, (A5)+
    MOVE.B  #TAB, (A5)+
    CMPI.B  #1, D3  
    BEQ add_invalid
    BRA add_source_ea
    
add_word_sourceEA
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA add_source_ea
    
add_long_sourceEA
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #L_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA add_source_ea
    
add_byte_destEA
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #B_, (A5)+
    MOVE.B  #TAB, (A5)+
    CMPI.B  #1, D3  
    BEQ add_invalid    
    BRA add_dest_ea
    
add_word_destEA
    MOVE.B  #PERIOD, (A5)+
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA add_dest_ea
    
add_long_destEA  
    MOVE.B  #PERIOD, (A5)+  
    MOVE.B  #L_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA add_dest_ea

adda_word    
    MOVE.B  #A_, (A5)+
    MOVE.B  #PERIOD, (A5)+    
    MOVE.B  #W_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA adda_source_ea   

adda_long
    MOVE.B  #A_, (A5)+ 
    MOVE.B  #PERIOD, (A5)+   
    MOVE.B  #L_, (A5)+
    MOVE.B  #TAB, (A5)+
    BRA adda_source_ea
 
add_source_ea
    * check mode if it's valid 
    * addressing Mode is Dn
    CMPI.B  #0, D3  
    BEQ add_Dn
    * addressing Mode is An    
    CMPI.B  #1, D3  
    BEQ add_An       
    * addressing Mode is (An)
    CMPI.B  #2, D3
    BEQ add_indirect_An  
    * addressing Mode is (An)+
    CMPI.B  #3, D3  
    BEQ add_An_plus
    * addressing Mode is -(An)
    CMPI.B  #4, D3  
    BEQ add_Minus_An
    * addressing Mode is either (xxx).W or (xxx).L
    CMPI.B  #7, D3 
    BEQ add_source_word_long_data
    BRA add_invalid 

add_dest_ea
    * check mode if it's valid        
    * addressing Mode is (An)
    CMPI.B  #2, D3
    BEQ add_dest_indirect_An  
    * addressing Mode is (An)+
    CMPI.B  #3, D3  
    BEQ add_dest_An_plus
    * addressing Mode is -(An)
    CMPI.B  #4, D3  
    BEQ add_dest_Minus_An
    * addressing Mode is either (xxx).W or (xxx).L
    CMPI.B  #7, D3 
    BEQ add_dest_word_long    
    BRA add_invalid
     
adda_source_ea
    * check mode if it's valid 
    * addressing Mode is Dn
    CMPI.B  #0, D3  
    BEQ adda_Dn
    * addressing Mode is An    
    CMPI.B  #1, D3  
    BEQ adda_An       
    * addressing Mode is (An)
    CMPI.B  #2, D3
    BEQ adda_indirect_An  
    * addressing Mode is (An)+
    CMPI.B  #3, D3  
    BEQ adda_An_plus
    * addressing Mode is -(An)
    CMPI.B  #4, D3  
    BEQ adda_Minus_An
    * addressing Mode is either (xxx).W or (xxx).L
    CMPI.B  #7, D3 
    BEQ adda_source_word_long
    
    BRA add_invalid   



    
add_Dn
    MOVE.B  #D_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done   
    
add_An
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done  

add_indirect_An
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done  
  
add_An_plus
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done
    
add_Minus_An
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done
    
add_source_word_long_data
    CMPI.B  #0, D4
    BEQ add_word
    CMPI.B  #1, D4
    BEQ add_long
    CMPI.B  #4, D4  
    BEQ add_source_data 
    BRA add_invalid
    
add_word
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #D_,    (A5)+
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA add_adda_done      
    
add_long

    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string     
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA add_adda_done
     
add_source_data
    CMPI.B  #0, D2  
    BEQ add_source_data_byte    
    CMPI.B  #1, D2  
    BEQ add_source_data_word    
    CMPI.B  #2, D2  
    BEQ add_source_data_long    
    
    BRA add_invalid       

add_source_data_byte
    MOVE.B  D1, D7   
    MOVE.B  #SHARP, (A5)+       ; read more opcode word size      
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ;   
    * check if first 8 bits are 0s  
    MOVE.L  A6, D1      ;   
    LSR.W   #8, D1      ;   shift right 8   
    CMPI.B  #$00, D1    ;   if $00 is starting bits 
    BEQ ADD_source_valid
    BRA ADD_invalid      

ADD_source_valid
    MOVE.W  #byte, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
    
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number     
    BRA add_adda_done    
    
add_source_data_word  
    MOVE.B  D1, D7
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ;
    
    
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number 
    BRA add_adda_done
 
add_source_data_long     
    MOVE.B  D1, D7
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ;
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #D_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number 
    BRA add_adda_done
  
      
add_dest_indirect_An
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+    
    BRA add_adda_done  
  
add_dest_An_plus
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    BRA add_adda_done
    
add_dest_Minus_An
    MOVE.B  #D_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    BRA add_adda_done

add_dest_word_long
    CMPI.B  #0, D4
    BEQ add_dest_word
    CMPI.B  #1, D4
    BEQ add_dest_long
    BRA add_invalid

add_dest_word
    MOVE.B  #D_,    (A5)+
    MOVE.B  D1, D0  
    BSR put_number  
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+       
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVEM.L (A7)+, A0   
    BRA add_adda_done      
    
add_dest_long
    MOVE.B  #D_, (A5)+  
    MOVE.B  D1, D0  
    BSR put_number  
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string     
    MOVEM.L (A7)+, A0   
    BRA add_adda_done
      
adda_Dn
    MOVE.B  #D_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done   
    
adda_An
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done  

adda_indirect_An
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done  
  
adda_An_plus
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #PLUS, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done
    
adda_Minus_An
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D4, D0
    BSR put_number
    MOVE.B  #Close_paren, (A5)+
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+
    MOVE.B  D1, D0  
    BSR put_number
    BRA add_adda_done
    
adda_source_word_long
    CMPI.B  #0, D4
    BEQ adda_word_ea
    CMPI.B  #1, D4
    BEQ adda_long_ea
    CMPI.B  #4, D4  
    BEQ adda_source_data 
    BRA add_invalid
    
adda_word_ea
    MOVE.B  D1, D7    
    MOVE.B  #DOLLAR, (A5)+
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7) 
    BSR hex_to_string 
    MOVE.B  #COMMA, (A5)+
    MOVE.B  #SPACE, (A5)+    
    MOVE.B  #A_,    (A5)+
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
        
    BRA add_adda_done      
    
    
adda_long_ea
    MOVE.B  D1, D7  
    MOVE.B  #DOLLAR, (A5)+  
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string     
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number  
    MOVEM.L (A7)+, A0   
    BRA add_adda_done
    
adda_source_data  
    CMPI.B  #3, D2  
    BEQ adda_source_data_word    
    CMPI.B  #7, D2  
    BEQ adda_source_data_long    
    
    BRA add_invalid       

adda_source_data_byte
    MOVE.B  D1, D7  
    MOVE.B  #SHARP, (A5)+       ; read more opcode word size      
    MOVE.B  #DOLLAR, (A5)+      ; 
    MOVEA.W (A2)+, A6           ;   
    * check if first 8 bits are 0s  
    MOVE.L  A6, D1      ;   
    LSR.W   #8, D1      ;   shift right 8   
    CMPI.B  #$00, D1    ;   if $00 is starting bits 
    BEQ ADDA_source_valid
    BRA ADD_invalid      

ADDA_source_valid
    MOVE.W  #byte, D1           ;   
    MOVEM.L D5/A0, -(A7)        ;
    BSR hex_to_string           ;   
    MOVEM.L (A7)+, D5/A0        ;
 
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+  
    MOVE.B  #A_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number     
    BRA add_adda_done      

addA_source_data_word  
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #word, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ;
    
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number 
    BRA add_adda_done
 
addA_source_data_long     
    MOVE.B  #SHARP, (A5)+   ;   
    MOVE.B  #DOLLAR, (A5)+ ; 
    MOVEA.W (A2)+, A6      ;   
    MOVE.W  #long, D1   ;   
    MOVEM.L D5/A0, -(A7)  
    BSR hex_to_string   ; 
    MOVEM.L (A7)+, D5/A0   ;
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+
    MOVE.B  #A_, (A5)+  
    MOVE.B  D7, D0  
    BSR put_number 
    BRA add_adda_done
  
    
    
add_invalid
    MOVEM.L (A7)+, A5
    BRA invalid_code  
    
add_adda_done   
    MOVEA.L A0, A6  
    CLR D6  
 
add_adda_loop
    CMPA.L  A0, A5  ;   
    BEQ add_adda_message_out 
    ADDI.L  #1, D6  ;   increment count  
    MOVE.L  A0, D5  ;   
    ADDI.L  #1, D5  ;   
    MOVEA.L D5, A0  ;   increment address   
    BRA add_adda_loop    ;    

add_adda_message_out
    MOVEM.L (A7)+, A5   
    BSR copy_string 
    BRA decode_end  
    
*   E_start     ******************************

ASLR_LSLR_ROLR
    MOVEM.L A5, -(A7)     ;    save A5 in the stack (pointer to result message)  
    MOVEA.L A6, A0      ;   starting address of temp      
    MOVEA.L A6, A5      ;   move starting address of curent temp Message into A0
    
    * check the shifting type whether it's memory shifting or not with size bits
   
    MOVE.W  D5, D0            * copy the original opcode into D0
    LSL.W   #4, D0            * Shift 4 bits to the left, so we can read next three bits of count/register num
    MOVE.W  #$E000, D6       * copy data to be used for bit masking into D2    
    MOVE.B  #13, D7          * copy parameter that indicates a number of bits to shift into D3   
    BSR get_bit              
    MOVE.W  D0,D1              * now we have either count or data register three bits in D1   
    
    MOVE.W  D5, D0  
    LSL.W   #7, D0  
    MOVE.W  #$8000, D6    
    MOVE.B  #15, D7  
    BSR get_bit 
    MOVE.W  D0, D2   * copy the value for direction into D2    

    MOVE.W  D5, D0  
    LSL.W   #8, D0  
    MOVE.W  #$C000, D6  
    MOVE.B  #14, D7 
    BSR get_bit 
    MOVE.W  D0, D3         * copy the value for size into D3   

    MOVE.W  D5,  D0 
    LSL.W   #8, D0 
    LSL.W   #2, D0 
    MOVE.W  #$8000, D6  
    MOVE.W  #15, D7 
    BSR get_bit 
    MOVE.W  D0,  D4    * copy the value for i/r into D4    
    
    MOVE.W  D5, D0  
    LSL.W   #8, D0
    LSL.W   #3, D0  
    MOVE.W  #$C000, D6  
    MOVE.W  #14, D7 
    BSR get_bit 
    MOVE.W  D0, D6 * copy the value for the type into D6
           
    MOVE.W  D5, D0
    LSL.W   #8, D0
    LSL.W   #5, D0   * keep the register value into D0    
    LSR.W   #8, D0
    LSR.W   #5, D0   

    CMPI.B  #3, D3    * check if it's memory shifting or not
    BEQ memory_shift       
    CMPI.B  #0, D6    * AS register shift
    BEQ as_shift  
    CMPI.B  #1, D6    * LS register shift
    BEQ ls_shift    
    CMPI.B  #3, D6    * RO rigister shift
    BEQ ro_shift
    BRA invalid_code         
     
as_shift
    MOVE.B  #A_, (A5)+  
    MOVE.B  #S_, (A5)+     
    CMPI.B  #0, D2    
    BEQ as_ls_ro_right 
    CMPI.B  #1, D2    
    BEQ as_ls_ro_left
    BRA as_ls_ro_invalid    
    
as_ls_ro_right
    MOVE.B  #R_, (A5)+  
    MOVE.B  #PERIOD, (A5)+   
    BRA as_ls_ro_size
    
as_ls_ro_left
    MOVE.B  #L_, (A5)+      
    MOVE.B  #PERIOD, (A5)+   
    BRA as_ls_ro_size
    
    
as_ls_ro_size
    CMPI.B  #$00, D3    
    BEQ byte_shift  
    CMPI.B  #1, D3    
    BEQ word_shift  
    CMPI.B  #2, D3    
    BEQ long_shift  

    BRA as_ls_ro_invalid         


    
byte_shift
    MOVE.B  #B_, (A5)+  
    MOVE.B  #TAB, (A5)+ 
    BRA check_ir_bit   
 
word_shift
    MOVE.B  #W_, (A5)+  
    MOVE.B  #TAB, (A5)+ 
    BRA check_ir_bit  
    
long_shift
    MOVE.B  #L_, (A5)+  
    MOVE.B  #TAB, (A5)+ 
    BRA check_ir_bit    
  
check_ir_bit    
    CMPI.B  #0, D4    
    BEQ as_ls_ro_count  
    CMPI.B  #1, D4    
    BEQ as_ls_ro_register   

    BRA as_ls_ro_invalid
            
    
as_ls_ro_count     
    MOVE.B  #SHARP, (A5)+
    MOVE.B  #DOLLAR, (A5)+ 
    BSR put_zero        
    MOVE.B  D0, D4  
    MOVE.W  D1, D0 
    CMPI.W  #0, D0  
    BEQ as_ls_ro_eight  
       
    BSR put_number
    MOVE.B  D4, D0   
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+   
    MOVE.B  #D_, (A5)+
    BSR put_number
    BRA AS_LS_RO_done

as_ls_ro_eight
    BSR PUT_EIGHT
    MOVE.B  D4, D0   
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+   
    MOVE.B  #D_, (A5)+
    BSR put_number
    BRA AS_LS_RO_done     

as_ls_ro_register
    MOVE.B  #D_, (A5)+  
    MOVE.B  D0, D4  
    MOVE.B  D1, D0 
    BSR put_number
    MOVE.B  D4, D0          
    MOVE.B  #COMMA, (A5)+   
    MOVE.B  #SPACE, (A5)+   
    MOVE.B  #D_, (A5)+
    BSR put_number
    BRA AS_LS_RO_done
    
ls_shift    
    MOVE.B  #L_, (A5)+  
    MOVE.B  #S_, (A5)+  
    
    CMPI.B  #0, D2    
    BEQ as_ls_ro_right 
    CMPI.B  #1, D2    
    BEQ as_ls_ro_left
    
    BRA as_ls_ro_invalid 
    
ro_shift
    MOVE.B  #R_, (A5)+  
    MOVE.B  #O_, (A5)+  
    
    CMPI.B  #0, D2    
    BEQ as_ls_ro_right 
    CMPI.B  #1, D2    
    BEQ as_ls_ro_left

    BRA as_ls_ro_invalid 
        
as_ls_ro_invalid
    MOVEM.L (A7)+, A5
    BRA invalid_code     
    
memory_shift
    CMPI.B  #0, D2    
    BEQ right_shift 
    
    CMPI.B  #1, D2    
    BEQ left_shift  
    BRA as_ls_ro_invalid         

right_shift
    * check the type among ASR.W, LSR.W, ROR.W
    CMPI.w  #0, D1
    BEQ asr_w_memory
    
    CMPI.w  #1, D1
    BEQ lsr_w_memory
    
    CMPI.w  #3, D1
    BEQ ror_w_memory

    BRA invalid_code         
    
asr_w_memory       
    MOVE.B #A_, (A5)+   
     MOVE.B #S_, (A5)+   
    MOVE.B #R_, (A5)+   
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+  
    MOVE.B #TAB, (A5)+          
    BRA memory_type

lsr_w_memory
    MOVE.B #L_, (A5)+       
    MOVE.B #S_, (A5)+   
    MOVE.B #R_, (A5)+   
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+ 
    MOVE.B #TAB, (A5)+               
    BRA memory_type
  
ror_w_memory
    MOVE.B #R_, (A5)+       
    MOVE.B #O_, (A5)+       
    MOVE.B #R_, (A5)+   
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+ 
    MOVE.B #TAB, (A5)+                
    BRA memory_type

         
left_shift
    * check the type among ASL.W, LSL.W, ROL.W
    
    CMPI.w  #0, D1      * hex 0000       
    BEQ asl_w_memory
    
    CMPI.w  #1, D1  * hex 0001
    BEQ lsl_w_memory
    
    CMPI.w  #3, D1
    BEQ rol_w_memory

    BRA invalid_code         

asl_w_memory       
    MOVE.B #A_, (A5)+   
    MOVE.B #S_, (A5)+   
    MOVE.B #L_, (A5)+       
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+  
    MOVE.B #TAB, (A5)+  
    BRA memory_type

lsl_w_memory
    MOVE.B #L_, (A5)+       
    MOVE.B #S_, (A5)+   
    MOVE.B #L_, (A5)+    
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+
    MOVE.B #TAB, (A5)+           
    BRA memory_type
        
rol_w_memory
    MOVE.B #R_, (A5)+       
    MOVE.B #O_, (A5)+       
    MOVE.B #L_, (A5)+       
    MOVE.B #PERIOD, (A5)+    
    MOVE.B #W_, (A5)+ 
    MOVE.B #TAB, (A5)+          
    BRA memory_type
       

memory_type
        *CHECK I/R BIT AND TYPE BITS TO VALIDATE THE TYPE OF EA
    
    CMPI.B  #0, D4
        BEQ check_nextTwo  * next two digits are one of 10, 11
    CMPI.B  #1, D4    
        BEQ  check_nextTwo2 * next two digits should be one of 11, 00

    BRA as_ls_ro_invalid         

check_nextTwo
    CMPI.B  #2, D6    
        BEQ indirect
    CMPI.B  #3, D6    
        BEQ indirect_postIncrement
    BRA as_ls_ro_invalid         

check_nextTwo2
    CMPI.B  #0, D6    
        BEQ indirect_preDecrement
    CMPI.B  #3, D6    
        BEQ absolute
    BRA as_ls_ro_invalid

indirect
    MOVE.B  #Open_paren, (A5)+  
    MOVE.B  #A_, (A5)+ 
    BSR put_number  
    MOVE.B  #Close_paren, (A5)+ 
    BRA AS_LS_RO_done
     
indirect_postIncrement  
        MOVE.B  #Open_paren, (A5)+     
        MOVE.B  #A_, (A5)+   
        BSR put_number  
        MOVE.B  #Close_paren, (A5)+ 
        MOVE.B  #PLUS,  (A5)+   
    BRA AS_LS_RO_done

indirect_preDecrement
    MOVE.B  #MINUS, (A5)+
    MOVE.B  #Open_paren, (A5)+     
    MOVE.B  #A_, (A5)+  
    BSR put_number  
    MOVE.B  #Close_paren, (A5)+ 
    BRA AS_LS_RO_done

    
    
absolute
    MOVE.B  #DOLLAR, (A5)+      
    CMPI.W #$0000, D0      
    BEQ AS_LS_RO_word_ea    
    CMPI.W  #$0001, D0    
    BEQ AS_LS_RO_long_ea    
    BRA as_ls_ro_invalid  
    
AS_LS_RO_word_ea
    MOVEA.W (A2)+, A6   
    MOVE.W  #word, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string   
    MOVEM.L (A7)+, A0   
    BRA AS_LS_RO_done      
    
AS_LS_RO_long_ea
    MOVEA.L (A2)+, A6   
    MOVE.W  #long, D1   
    MOVEM.L A0, -(A7)   
    BSR hex_to_string   
    MOVEM.L (A7)+, A0   
    BRA AS_LS_RO_done     

AS_LS_RO_done   
        MOVEA.L A0, A6  
        CLR D6  
 
AS_LS_RO_loop
    CMPA.L  A0, A5  ;   
    BEQ AS_LS_RO_message_out 
    ADDI.L  #1, D6  ;   increment count  
    MOVE.L  A0, D5  ;   
    ADDI.L  #1, D5  ;   
    MOVEA.L D5, A0  ;   increment address   
    BRA AS_LS_RO_loop    ;    


AS_LS_RO_message_out
    MOVEM.L (A7)+, A5   
    BSR copy_string 
    BRA decode_end  
 

* D0 contains opcode, D6 contains mask, D7 contains shift value 
* return D0 after masking and shifting 
get_bit
    * bitmasking
    AND.W   D6, D0  ;   
    LSR.W   D7, D0  ;
    RTS 

* add .B, .W, .L in the A6  (temp result) 
add_dot_B
    MOVE.B  PERIOD, (A5)+   
    MOVE.B  B_, (A5)+   
    MOVE.B  TAB, (A5)+  ;   

    RTS     ;   
    
add_dot_W   
    MOVE.B  PERIOD, (A5)+   
    MOVE.B  W_, (A5)+   
    MOVE.B  TAB, (A5)+  ;
    RTS     ;   
    
add_dot_L   
    MOVE.B  PERIOD, (A5)+   ;   
    MOVE.B  L_, (A5)+   ;   
    MOVE.B  TAB, (A5)+  ;
    RTS     ;   

* D0 has digit  
*   put digit in the A5 with Ascii  
put_number  
    CMPI.B  #0, D0  
    BEQ put_zero    

    CMPI.B  #1, D0  
    BEQ put_one 

  CMPI.B    #2, D0  ;   
  BEQ   put_two 
  
  CMPI.B    #3, D0  ;   
  BEQ   put_three   ;   
  
  CMPI.B    #4, D0  ;   
  BEQ   put_four    ;   
  
  CMPI.B    #5, D0  ;   
  BEQ   put_five    ;   
  
  CMPI.B    #6, D0  ;   
  BEQ   put_six     ;   
  
  CMPI.B    #7, D0  ;   
  BEQ   put_seven   ;  

  CMPI.W    #8, D0  
  BEQ   PUT_EIGHT    
  
put_zero
    MOVE.B  #ZERO_, (A5)+    
        BRA put_number_done ;    
put_one
    MOVE.B  #ONE_, (A5)+ 
    BRA put_number_done ;   
put_two
    MOVE.B  #TWO_, (A5)+ 
     BRA put_number_done ;   
put_three
    MOVE.B  #THREE_, (A5)+
    BRA put_number_done ;   
put_four
    MOVE.B  #FOUR_, (A5)+
    BRA put_number_done ;   
put_five
    MOVE.B  #FIVE_, (A5)+
    BRA put_number_done ;   
put_six
    MOVE.B  #SIX_, (A5)+
    BRA put_number_done ;   
put_seven
    MOVE.B  #SEVEN_, (A5)+   
    BRA put_number_done ;  
PUT_EIGHT   
    MOVE.B  #EIGHT_, (A5)+  
    BRA put_number_done 
put_number_done 
    RTS 


* Decode functions end*********************************************************************************    
* INSTRUCTION_NAME   
RTS_    DC.B    'RTS'   ;    
NOP_     DC.B    'NOP'   ;  

* CONSTANTS 

CONTINUE_MSG    DC.B    'To continue, press ENTER: ', 0
FINAL_MSG       DC.B    'Finished decoding. Press any key to EXIT', 0  
INVALID_MSG     DC.B    'DATA   $WXYZ'                        ;INVALID MESSAGE       


PROMPT_1        DC.B    'Enter starting address. RANGE= [$7000, $9FFF]', 0 
PROMPT_2        DC.B    'Enter ending address. RANGE = [$7000, $9FFF]', 0
PROMPT_3        DC.B    '$', 0
PROMPT_4        DC.B    'Press ENTER to continue...', 0

LIST_HEX        DC.B    '0123456789ABCDEF'

START_HEX       DS.L    $1      ; starting pointer  
END_HEX         DS.L    $1      ; ending pointer    
INPUT           DS.B    $8      ; input string  
INPUT_LENGTH    DS.W    $1      ; size of the input string  

RESULT_MSG  DC.B    ''  ; 


    END    START        ; last line of source









































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
