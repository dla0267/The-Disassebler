*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000    
START:

    *   Test Program for Disassembler   
    BRA BRA_something   ;   
    
BRA_something   
    BCC BCC_something   ;   
    
BCC_something   ;   

    BCS BCS_something   ;   
    
BCS_something   ;   

    BVC BVC_something   ;   
    
BVC_something   ;   

    BGE BGE_something   ;   
    
BGE_something   ;   

    BLT BLT_something   ;   
    
BLT_something   ;    

    JSR JSR_something   ;    
    
JSR_something   ;   

    * MOVE INSTRUCTIONS 
    MOVE.B  D1, D0    ;   
    MOVE.B  #$01, D0  ;   
    MOVE.B  (A5), D0        ;   
    MOVE.B  (A5)+, D0   ;   
    MOVE.B  -(A5), D0   ;   
    MOVE.B  $4803, D0   ;   
    MOVE.B  $10004803, D0   ; 

    MOVE.B  D1, (A1)    ;   
    MOVE.B  #$01, (A1)  ;   
    MOVE.B  (A5), (A1)        ;   
    MOVE.B  (A5)+, (A1)   ;   
    MOVE.B  -(A5), (A1)   ;   
    MOVE.B  $4803, (A1)   ;   
    MOVE.B  $10004803, (A1)   ; 

    MOVE.B  D1, (A1)+    ;   
    MOVE.B  #$01, (A1)+  ;   
    MOVE.B  (A5), (A1)+        ;   
    MOVE.B  (A5)+, (A1)+   ;   
    MOVE.B  -(A5), (A1)+   ;   
    MOVE.B  $4803, (A1)+   ;   
    MOVE.B  $10004803, (A1)+   ; 

    MOVE.B  D1, -(A1)    ;   
    MOVE.B  #$01, -(A1)  ;   
    MOVE.B  (A5), -(A1)        ;   
    MOVE.B  (A5)+, -(A1)   ;   
    MOVE.B  -(A5), -(A1)   ;   
    MOVE.B  $4803, -(A1)   ;   
    MOVE.B  $10004803, -(A1)   ; 

    MOVE.B  D1, $FF1F    ;   
    MOVE.B  #$01, $FF1F  ;   
    MOVE.B  (A5), $FF1F        ;   
    MOVE.B  (A5)+, $FF1F   ;   
    MOVE.B  -(A5), $FF1F   ;   
    MOVE.B  $4803, $FF1F   ;   
    MOVE.B  $10004803, $FF1F   ; 

    MOVE.B  D1, $FF1F111F    ;   
    MOVE.B  #$01, $FFFF7FFF  ;   
    MOVE.B  (A5), $FFFF7FFF        ;   
    MOVE.B  (A5)+, $FFFF7FFF   ;   
    MOVE.B  -(A5), $FFFF7FFF   ;   
    MOVE.B  $4803, $FFFF7FFF   ;   
    MOVE.B  $10004803, $FFFF7FFF   ; 


    MOVE.W  D1, D0    ;   
    MOVE.W  #$1001, D0  ;   
    MOVE.W  A5, D0  ;   
    MOVE.W  (A5), D0        ;   
    MOVE.W  (A5)+, D0   ;   
    MOVE.W  -(A5), D0   ;   
    MOVE.W  $4803, D0   ;   
    MOVE.w  $10004803, D0   ; 


    MOVE.W  D1, D0    ;   
    MOVE.W  #$01, D0  ;
    MOVE.W  A5, D0  ;   
    MOVE.W  (A5), D0        ;   
    MOVE.W  (A5)+, D0   ;   
    MOVE.W  -(A5), D0   ;   
    MOVE.W  $4803, D0   ;   
    MOVE.W  $10004803, D0   ; 

    MOVE.W  D1, (A1)    ;   
    MOVE.W  #$01, (A1)  ;
    MOVE.W  #$1111, (A1)  ;          
    MOVE.W  A5, D0  ;    
    MOVE.W  (A5), (A1)        ;   
    MOVE.W  (A5)+, (A1)   ;   
    MOVE.W  -(A5), (A1)   ;   
    MOVE.W  $4803, (A1)   ;   
    MOVE.W  $10004803, (A1)   ; 
    
    MOVE.W  D1, (A1)+    ;   
    MOVE.W  #$01, (A1)+  ;   
    MOVE.W  #$1111, (A1)  ;          
    MOVE.W  A5, D0  ;
    MOVE.W  (A5), (A1)+        ;   
    MOVE.W  (A5)+, (A1)+   ;   
    MOVE.W  -(A5), (A1)+   ;   
    MOVE.W  $4803, (A1)+   ;   
    MOVE.W  $10004803, (A1)+   ; 

    MOVE.W  D1, -(A1)    ;   
    MOVE.W  #$01, -(A1)  ;   
    MOVE.W  #$1111, (A1)  ;              
    MOVE.W  A5, D0  ;   
    MOVE.W  (A5), -(A1)        ;   
    MOVE.W  (A5)+, -(A1)   ;   
    MOVE.W  -(A5), -(A1)   ;   
    MOVE.W  $4803, -(A1)   ;   
    MOVE.W  $10004803, -(A1)   ; 

    MOVE.W  D1, $FF1F    ;   
    MOVE.W  #$01, $FF1F  ;
    MOVE.W  #$1111, (A1)  ;             
    MOVE.W  A5, D0  ;   
    MOVE.W  (A5), $FF1F        ;   
    MOVE.W  (A5)+, $FF1F   ;   
    MOVE.W  -(A5), $FF1F   ;   
    MOVE.W  $4803, $FF1F   ;   
    MOVE.W  $10004803, $FF1F   ; 

    MOVE.W  D1, $FF1F111F    ;   
    MOVE.W  #$01, $FFFF7FFF  ;
    MOVE.W  #$1111, (A1)  ;             
    MOVE.W  A5, D0  ;   
    MOVE.W  (A5), $FFFF7FFF        ;   
    MOVE.W  (A5)+, $FFFF7FFF   ;   
    MOVE.W  -(A5), $FFFF7FFF   ;   
    MOVE.W  $4803, $FFFF7FFF   ;   
    MOVE.W  $10004803, $FFFF7FFF   ;   
    
    MOVE.L  D1, D0    ;   
    MOVE.L  #$1001, D0  ;   
    MOVE.L  A5, D0  ;   
    MOVE.L  (A5), D0        ;   
    MOVE.L  (A5)+, D0   ;   
    MOVE.L  -(A5), D0   ;   
    MOVE.L  $4803, D0   ;   
    MOVE.L  $10004803, D0   ; 


    MOVE.L  D1, D0    ;   
    * MOVE.L  #$01, D0  ; assembled to not supporting opcode(Kris)     
    MOVE.L  A5, D0  ;   
    MOVE.L  (A5), D0        ;   
    MOVE.L  (A5)+, D0   ;   
    MOVE.L  -(A5), D0   ;   
    MOVE.L  $4803, D0   ;   
    MOVE.L  $10004803, D0   ; 

    MOVE.L  D1, (A1)    ;   
    MOVE.L  #$01, (A1)  ;
    MOVE.L  #$1111, (A1)  ;          
    MOVE.L  A5, D0  ;    
    MOVE.L  (A5), (A1)        ;   
    MOVE.L  (A5)+, (A1)   ;   
    MOVE.L  -(A5), (A1)   ;   
    MOVE.L  $4803, (A1)   ;   
    MOVE.L  $10004803, (A1)   ; 
    
    MOVE.L  D1, (A1)+    ;   
    MOVE.L  #$01, (A1)+  ;   
    MOVE.L  #$1111, (A1)  ;          
    MOVE.L  A5, D0  ;
    MOVE.L  (A5), (A1)+        ;   
    MOVE.L  (A5)+, (A1)+   ;   
    MOVE.L  -(A5), (A1)+   ;   
    MOVE.L  $4803, (A1)+   ;   
    MOVE.L  $10004803, (A1)+   ; 

    MOVE.L  D1, -(A1)    ;   
    MOVE.L  #$01, -(A1)  ;   
    MOVE.L  #$1111, (A1)  ;              
    MOVE.L  A5, D0  ;   
    MOVE.L  (A5), -(A1)        ;   
    MOVE.L  (A5)+, -(A1)   ;   
    MOVE.L  -(A5), -(A1)   ;   
    MOVE.L  $4803, -(A1)   ;   
    MOVE.L  $10004803, -(A1)   ; 

    MOVE.L  D1, $FF1F    ;   
    MOVE.L  #$01, $FF1F  ;
    MOVE.L  #$1111, (A1)  ;
    MOVE.L  #$FFFF1111, (A1)  ;                          
    MOVE.L  A5, D0  ;   
    MOVE.L  (A5), $FF1F        ;   
    MOVE.L  (A5)+, $FF1F   ;   
    MOVE.L  -(A5), $FF1F   ;   
    MOVE.L  $4803, $FF1F   ;   
    MOVE.L  $10004803, $FF1F   ; 

    MOVE.L  D1, $FF1F111F    ;   
    MOVE.L  #$01, $FFFF7FFF  ;
    MOVE.L  #$1111, (A1)  ;
    MOVE.L  #$1111FFFF, (A1)  ;                          
    MOVE.L  A5, D0  ;   
    MOVE.L  (A5), $FFFF7FFF        ;   
    MOVE.L  (A5)+, $FFFF7FFF   ;   
    MOVE.L  -(A5), $FFFF7FFF   ;   
    MOVE.L  $4803, $FFFF7FFF   ;   
    MOVE.L  $10004803, $FFFF7FFF   ;   


    * MOVEA INSTRUCTIONS
    
    MOVEA.W D0, A3  ;   
    MOVEA.W A5, A3  ;   
    MOVEA.W (A5), A3    ;   
    MOVEA.W (A5)+, A3   ;   
    MOVEA.W -(A5), A3   ;   
    MOVEA.W $1000, A3   ;   
    MOVEA.W $10001001, A3   ;   
    MOVEA.W #$FF11, A3   ;

    MOVEA.L D0, A3  ;   
    MOVEA.L A5, A3  ;   
    MOVEA.L (A5), A3    ;   
    MOVEA.L (A5)+, A3   ;   
    MOVEA.L -(A5), A3   ;   
    MOVEA.L $1000, A3   ;   
    MOVEA.L $10001001, A3   ;   
    MOVEA.L #$10000010, A3   ;   
    
    * MOVEM INSTRUCTIONS    
    
    MOVEM.W D0-D7/A0-A7, (A0)
    MOVEM.W D0-D7/A0-A7, (A7)
    MOVEM.W D0-D7/A0-A7, (A4)
    
    MOVEM.L D0-D7/A0-A7, (A0)
    MOVEM.L D0-D7/A0-A7, (A7)
    MOVEM.L D0-D7/A0-A7, (A4)
    
    MOVEM.W D0-D7/A0-A7, -(A0)
    MOVEM.W D0-D7/A0-A7, -(A7)
    MOVEM.W D0-D7/A0-A7, -(A4)
    
    MOVEM.L D0-D7/A0-A7, -(A0)
    MOVEM.L D0-D7/A0-A7, -(A7)
    MOVEM.L D0-D7/A0-A7, -(A4)
    
    MOVEM.W (A0),D0-D7/A0-A7
    MOVEM.W (A7),D0-D7/A0-A7
    MOVEM.W (A3),D0-D7/A0-A7
    
    MOVEM.L (A0),D0-D7/A0-A7
    MOVEM.L (A7),D0-D7/A0-A7
    MOVEM.L (A3),D0-D7/A0-A7
    
    MOVEM.W (A0)+,D0-D7/A0-A7
    MOVEM.W (A7)+,D0-D7/A0-A7
    MOVEM.W (A3)+,D0-D7/A0-A7
    
    MOVEM.L (A0)+,D0-D7/A0-A7
    MOVEM.L (A7)+,D0-D7/A0-A7
    MOVEM.L (A3)+,D0-D7/A0-A7
    
    MOVEM.W $FFF7FFFF, D0-D7/A0-A7
    MOVEM.W $FFFF, D0-D7/A0-A7
    
    MOVEM.L D0-D7/A0-A7, $FFF7FFFF
    MOVEM.L D0-D7/A0-A7, $FFFF
    
    MOVEM.W D0-D7/A0-A7, $1DDDDDD1
    MOVEM.L D0-D7/A0-A7, $1DDDDDD1

    * BCLR INSTRUCTIONS 
    
    BCLR.B D5, (A3)    
    BCLR.B D5, (A3)+   
    BCLR.B D5, -(A3)   
    BCLR.B    D5, $5800   
    BCLR.B    D5, $10005800
   
    BCLR.L D5, D0  
 
    BCLR.B #$FF, (A3)    
    BCLR.B #$1F, (A3)+   
    BCLR.B #$FF, -(A3)      
    BCLR.B    #$08, $5800 
    BCLR.B    #$07, $5800 
    BCLR.B    #$0A, $01005800     
    
    BCLR.L #$01, D0  

    
    * CMPI INSTRUCTION
    CMPI.B  #$08, D0    
    CMPI.B  #$08, (A3)  
    CMPI.B  #$08, (A3)+ 
    CMPI.B  #$08, -(A3) 
    CMPI.B  #$08, $5800 
    CMPI.B  #$08, $10005800 

    CMPI.W  #$FF08, D0    
    CMPI.W  #$FF08, (A3)  
    CMPI.W  #$FF08, (A3)+ 
    CMPI.W  #$FF08, -(A3) 
    CMPI.W  #$FF08, $5800 
    CMPI.W  #$FF08, $10005800 
    
    CMPI.L  #$FFFFFF08, D0    
    CMPI.L  #$FFFFFF08, (A3)  
    CMPI.L  #$FFFFF08, (A3)+ 
    CMPI.L  #$FFFF08, -(A3) 
    CMPI.L  #$FFF08, $5800 
    CMPI.L  #$FF08, $10005800 
    
    * ORI INSTRUCTIONS
    ORI.B   #$F3, D0    
    ORI.B   #$03, D0    
    ORI.B   #$F3, (A1)  
    ORI.B   #$03, (A1)  
    ORI.B   #$F3, (A1)+  
    ORI.B   #$03, (A1)+  
    ORI.B   #$F3, -(A1)  
    ORI.B   #$03, -(A1)
    ORI.B   #$F3, $7000 
    ORI.B   #$03, $7000 
    ORI.B   #$F3, $10007000 
    ORI.B   #$03, $10007000   
    
    ORI.W   #$F3, D0    
    ORI.W   #$03, D0    
    ORI.W   #$F3, (A1)  
    ORI.W   #$03FF, (A1)  
    ORI.W   #$F3, (A1)+  
    ORI.W   #$03, (A1)+  
    ORI.W   #$F3, -(A1)  
    ORI.W   #$03, -(A1)
    ORI.W   #$F3, $7000 
    ORI.W   #$03, $7000 
    ORI.W   #$F3, $10007000 
    ORI.W   #$03, $10007000  
    
    ORI.L   #$0FFFFFF3, D0    
    ORI.L   #$0FFFFFF3, D0    
    ORI.L   #$0FFFFFF3, (A1)  
    ORI.L   #$0FFFFFF3, (A1)  
    ORI.L   #$FFF3, (A1)+  
    ORI.L   #$0FFFFF3, (A1)+  
    ORI.L   #$FF3, -(A1)  
    ORI.L   #$0FFFF3, -(A1)
    ORI.L   #$FFFFF3, $7000 
    ORI.L   #$0FFFFF3, $7000 
    ORI.L   #$3, $10007000 
    ORI.L   #$F3, $10007000      
 
       * NEG INSTRUCTIONS
    NEG.B   D1
    NEG.B   (A0)
    NEG.B   (A1)+
    NEG.B   -(A1)
    NEG.B   $10005800
    NEG.B   $5800     

    NEG.W   D1
    NEG.W   (A0)
    NEG.W   (A1)+
    NEG.W   -(A1)
    NEG.W   $10005800
    NEG.W   $5800     

    NEG.L   D1
    NEG.L   (A0)
    NEG.L   (A1)+
    NEG.L   -(A1)
    NEG.L   $10005800
    NEG.L   $5800     


    *MOVEM RtM, MtR added once they are working correctly
    MULS.W  #2,D1
    *Following not supported?
    *MULS.L  #3, D2
    *MULS.L  (A1),D5
 *   MULS.L  (A3)+,D4
 *   MULS.L  -(A6),D6
  *  MULS.L  $10004392, D7
  *  MULS.L  $2432, D0
    
   * DIVS.L  #3, D2
    *DIVS.L  (A1),D5
    *DIVS.L  (A3)+,D4
    *DIVS.L  -(A6),D6
    *DIVS.L  $10004392, D7
    *DIVS.L  $2432, D0
    
    * JSR INSTRUCTIONS
    
    JSR TEST
    JSR (A1)
    JSR TEST_MESSAGE
    JSR $FFF1   
    JSR $FFFF1FFF   
    
    BRA TEST
    BRA TEST_MESSAGE
    
    BCC TEST
    BCC TEST_MESSAGE
       
    BCS TEST
    BCS TEST_MESSAGE
    
    BVC TEST
    BVC TEST_MESSAGE
        
    BGE TEST
    BGE TEST_MESSAGE
       
    BLT TEST
    BLT TEST_MESSAGE
    
    * LEA INSTRUCTIONS  
    LEA TEST, A0
    LEA (A1),A7
    LEA TEST_MESSAGE, A1
    LEA $111F, A1   
    LEA $FFFF1FFF, A1
       
    * OR INSTRUCTIONS    
    OR.B  D1, D2   
    OR.B  (A1), D2
    OR.B  (A1)+, D2   
    OR.B  -(A1), D2   
    OR.B  $1231, D2   
    OR.B  $FFFF7FFF, D2   
    OR.B  #$11, D2   

    OR.W  D1, D2   
    OR.W  (A1), D2
    OR.W  (A1)+, D2   
    OR.W  -(A1), D2   
    OR.W  $1231, D2   
    OR.W  $FFFF7FFF, D2   
    OR.W  #$1DD1, D2   
    
    OR.L  D1, D2   
    OR.L  (A1), D2
    OR.L  (A1)+, D2   
    OR.L  -(A1), D2   
    OR.L  $1231, D2   
    OR.L  $FFFF7FFF, D2   
    OR.L  #$1DDDDDD1, D2   
    
    OR.B    D1, (A1)
    OR.B    D1, (A2)+
    OR.B    D1, -(A2)   
    OR.B    D1, $FF8F   
    OR.B    D1, $FFFF7FFF

    OR.W    D1, (A1)
    OR.W    D1, (A2)+
    OR.W    D1, -(A2)   
    OR.W    D1, $FF8F   
    OR.W    D1, $FFFF7FFF

    OR.L    D1, (A1)
    OR.L    D1, (A2)+
    OR.L    D1, -(A2)   
    OR.L    D1, $FF8F   
    OR.L    D1, $FFFF7FFF
    
    
    
    * DIVS INSTRUCTION
    
    DIVS.W  D1, D2
    DIVS.W  -(A1),D3
    DIVS.W  (A5)+,D7
    DIVS.W  #2, D4
    DIVS.W  $00FF, D1
    DIVS.W  $0010FFFF,D1    
    DIVS.W  #$0123, D1  
    
    * SUB INSTRUCTION 
    SUB.B   D2, D1
    SUB.B   (A1), D1
    SUB.B   (A1)+, D1    
    SUB.B   -(A1), D1
    SUB.B   $FF1F, D1
    SUB.B   $00008000, D1
*    SUB.B   #$FF, D1
   
    SUB.W   D2, D1
    SUB.W   A1, D1
    SUB.W   (A1), D1
    SUB.W   (A1)+, D1    
    SUB.W   -(A1), D1
    SUB.W   $FF1F, D1
    SUB.W   $00008000, D1
*    SUB.W   #$F, D1
*    SUB.W   #$FF, D1
*    SUB.W   #$FFF, D1
**    SUB.W   #$1FFF, D1
  
    SUB.B   D1, (A1)
    SUB.B   D1, (A1)+    
    SUB.B   D1, -(A1)
    SUB.B   D1, $FF1F
    SUB.B   D1, $00008000
    
    SUB.W   D1, (A1)
    SUB.W   D1, (A1)+    
    SUB.W   D1, -(A1)
    SUB.W   D1, $FF1F
    SUB.W   D1, $00008000
 
    * SUBQ INSTRUCTIONS---------------------
    
    SUBQ.B    #$01, D1
    SUBQ.B    #$08,(A1)
    SUBQ.B    #$01,(A1)+
    SUBQ.B    #$01, -(A2)
    SUBQ.B    #$04, $0044
    SUBQ.B    #$02, $0000FFF1
    
    SUBQ.W    #$01, D1
    SUBQ.W    #$01, A1
    SUBQ.W    #$08,(A1)
    SUBQ.W    #$01,(A1)+
    SUBQ.W    #$01, -(A2)
    SUBQ.W    #$04, $0044
    SUBQ.W    #$02, $0000FFF1    

    SUBQ.L    #$01, D1
    SUBQ.L    #$01, A1
    SUBQ.L    #$08,(A1)
    SUBQ.L    #$01,(A1)+
    SUBQ.L    #$01, -(A2)
    SUBQ.L    #$04, $0044
    SUBQ.L    #$02, $0000FFF1  
    
    * AS_LS_RO INSTRUCTION

    ASL.W   (A4)
    ASL.W   (A4)+
    ASL.W   -(A4)
    ASL.W   (A0)
    ASL.W   (A0)+
    ASL.W   -(A0)
    ASL.W   (A1)
    ASL.W   (A1)+
    ASL.W   -(A1)    
    ASL.W   (A2)
    ASL.W   (A2)+
    ASL.W   -(A2)    
    ASL.W   (A6)
    ASL.W   (A6)+
    ASL.W   -(A6)   
    ASL.W   (A7)
    ASL.W   (A7)+
    ASL.W   -(A7)
    LSR.W   (A4)
    LSR.W   (A4)+
    LSR.W   -(A4)  
    ASR.W   (A4)
    ASR.W   (A4)+
    ASR.W   -(A4) 
    LSL.W   (A4)
    LSL.W   (A4)+
    LSL.W   -(A4) 
    ROL.W   (A4)
    ROL.W   (A4)+
    ROL.W   -(A4)


    ASL.W   $10101111  
    ASR.W   $10101111  
    LSL.W   $10101111  
    LSR.W   $10101111  
    ROL.W   $10101111  
    ROR.W   $10101111  

    ASL.W   $1010  
    ASR.W   $1010  
    LSL.W   $1010  
    LSR.W   $1010  
    ROL.W   $1010  
    ROR.W   $1010  

    ASL.B   D2, D1       
    ASL.B   D3, D1       
    ASL.W   D2, D1       
    ASL.W   D3, D1  
    ASL.L   D2, D1       
    ASL.L   D3, D1 
    ASR.B   D2, D1       
    ASR.B   D3, D1 
    
    ASL.B   #$01, D1    * print it as hex
    ASL.B   #$08, D1    * print it as hex 
    ASL.B   #$1, D1      * print it as hex
    ASL.B   #$2, D1       
    ASL.W   #$3, D1       
    ASL.W   #$4, D1  
    ASL.L   #$5, D1       
    ASL.L   #$6, D1 
    ASR.B   #$7, D1       
    ASR.B   #$8, D1 
    

    * ADD INSTRUCTION    
    ADD.B    D1,D2
    ADD.B   (A5),D1
    ADD.B   (A5)+,D1
    ADD.B   -(A5),D1
    ADD.B   $6FFF,D1
    ADD.B   $FFFF7FFF,D1
*    ADD.B   #$F2, D1    * this should be omitted because 68 K receives it as ADDI

    ADD.B   D1,(A5)
    ADD.B   D1,(A5)+ 
    ADD.B   D1, -(A5)
    ADD.B   D1, $6FFE   
    ADD.B   D1, $FFFF7FFF   

    ADD.W    D1,D2
    ADD.W   (A5),D1
    ADD.W   (A5)+,D1
    ADD.W   -(A5),D1
    ADD.W   $6FFF,D1
    ADD.W   $FFFF7FFF,D1
*    ADD.W   #$11F2, D1    * this should be omitted because 68 K receives it as ADDI


    ADD.W   D1,(A5)
    ADD.W   D1,(A5)+ 
    ADD.W   D1, -(A5)
    ADD.W   D1, $6FFE   
    ADD.W   D1, $FFFF7FFF  
    
    ADD.L    D1,D2
    ADD.L   (A5),D1
    ADD.L   (A5)+,D1
    ADD.L   -(A5),D1
    ADD.L   $6FFF,D1
    ADD.L   $FFFF7FFF,D1
*    ADD.L   #$FFFFFFF2, D1    * this should be omitted because 68 K receives it as ADDI


    ADD.L   D1,(A5)
    ADD.L   D1,(A5)+ 
    ADD.L   D1, -(A5)
    ADD.L   D1, $6FFE   
    ADD.L   D1, $FFFF7FFF      

    * ADDA INSTRUCTION  
    ADDA.W   D2,A1
    ADDA.W   A2,A1
    ADDA.W  (A2),A1
    ADDA.W  (A2)+,A1
    ADDA.W  -(A2),A1
    ADDA.W  $6FFF,A1
    ADDA.W  $FFFF1FFF, A4
*    ADDA.W  #$1, A1   68k reads it as SUBQ instruction
    ADDA.W  #$101, A1
    ADDA.W  #$1101, A1     
                   
    ADDA.L   D2,A1
    ADDA.L   A2,A1
    ADDA.L  (A2),A1
    ADDA.L  (A2)+,A1
    ADDA.L  -(A2),A1
    ADDA.L  $6FFF,A1
    ADDA.L  $FFFF1FFF, A4
**    ADDA.L  #$101, A1
**    ADDA.L  #$FFF11011, A1
*        
        
    * MULS.W INSTURCTION 
    MULS.W  d0,d1
    MULS.W  (a0),d1
    MULS.W  (a0)+,d1
    MULS.W  -(a0),d1
    MULS.W  $7FFF,d1
    MULS.W  $FFFF7FFF,d0
    MULS.W  #$FFFF,d0
    MULS.W  #$7FFF,d0
    
*    MULS.L  D2,d1   
*    MULS.L  I2,d1
*    MULS.L  I2,d1
*    MULS.L  I3,d1
*    MULS.L  I1,d1
*    MULS.L  I1,d0
*    MULS.L  I1,d0    
*    
*    MULS.L  D1, I1
*    MULS.L  (A1), I2
*    MULS.L  (A1)+, I2
*    MULS.L  -(A2), I3
*    MULS.L  $0011, I1   
*    MULS.L  $00001111, I1   
*    MULS.L  #$00111111, I1    
TEST_MESSAGE      
    * CMP INSTRUCTION 
    CMP.B   D0, D1  
    CMP.B   (A1), D1        
    CMP.B   (A1)+, D1   
    CMP.B   -(A1), D1   
    CMP.B   $0000811F, D1   
    CMP.B   $FFFF123F, D1   
    CMP.B   #$01, D1
    CMP.B   #1, D1  
 
    
    CMP.W   D0, D1  
    CMP.W   A1, D1  
    CMP.W   (A1), D1        
    CMP.W   (A1)+, D1   
    CMP.W   -(A1), D1   
    CMP.W   $711F, D1   
    CMP.W   $FFFF123F, D1  
    CMP.W   #$0111, D1

    CMP.L   D0, D1  
    CMP.L   A1, D1  
    CMP.L   (A1), D1        
    CMP.L   (A1)+, D1   
    CMP.L   -(A1), D1   
    CMP.L   $811F, D1   
    CMP.L   $FFFF123F, D1      
    CMP.L   #$10101010, D1  

TEST
    * EOR INSTRUCTION    
    EOR.B   D1, D2  
    EOR.B   D1, (A2)
    EOR.B   D1, (A2)+
    EOR.B   D1, -(A2)   
    EOR.B   D1, $0011
    EOR.B   D1, $11FFFFFF
    
    EOR.W   D1, D2
    EOR.W   D1, (A2)
    EOR.W   D1, (A2)+
    EOR.W   D1, -(A2)   
    EOR.W   D1, $0011
    EOR.W   D1, $11FFFFFF
      
    EOR.L   D1, D2
    EOR.L   D1, (A2)
    EOR.L   D1, (A2)+
    EOR.L   D1, -(A2)   
    EOR.L   D1, $0011
    EOR.L   D1, $11FFFFFF
    
    RTS 
 
    
    SIMHALT             ; halt simulator
* Put variables and constants here

    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
