*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $7000    
START:                  ; first instruction of program

* Put program code here
       
    
    MOVE.B  D0, D1  ;   
    MOVE.B  D0, (A5)    ;   
    MOVE.B  D0, (A5)+   ;   
    MOVE.B  D0, -(A5)   ;   
    MOVE.B  D0, $4803   ;   
    MOVE.B  D0, $10004803   ;   
    
    
   BCLR D5, D0  
   BCLR D5, (A3)    
   BCLR D5, (A3)+   
   BCLR D5, -(A3)   
    BCLR    D5, $5800   
    BCLR    D5, $10005800   
    CMPI.B  #$08, D0    
    CMPI.B  #$08, (A3)  
    CMPI.B  #$08, (A3)+ 
    CMPI.B  #$08, -(A3) 
    CMPI.B  #$08, $5800 
    CMPI.B  #$08, $10005800 
    
    BCLR    #$08, $5800 
    BCLR    #$07, $5800 
    BCLR    #$0A, $01005800 
    

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

       * add.b permutations
        add.b           d0,d0
        add.b           (a5),d0
        add.b           (a5)+,d0
        add.b           -(a5),d0
        add.b           $7ffe,d0
        add.b           $ffff7ffe,d0

        add.b           d0,(a5)
        add.b           d0,(a5)+
        add.b           d0,-(a5)
        add.b           d0,$7ffe
        add.b           d0,$ffff7ffe

        * add.w permutations
        add.w           d0,d0
        add.w           (a5),d0
        add.w           (a5)+,d0
        add.w           -(a5),d0
        add.w           $7ffe,d0
        add.w           $ffff7ffe,d0

        add.w           d0,(a5)
        add.w           d0,(a5)+
        add.w           d0,-(a5)
        add.w           d0,$7ffe
        add.w           d0,$ffff7ffe

        * add.l permutations
        add.l           d0,d0
        add.l           (a5),d0
        add.l           (a5)+,d0
        add.l           -(a5),d0
        add.l           $7ffe,d0
        add.l           $ffff7ffe,d0

        add.l           d0,(a5)
        add.l           d0,(a5)+
        add.l           d0,-(a5)
        add.l           d0,$7ffe
        add.l           d0,$ffff7ffe

        * adda.w permutations
        adda.w          d2,a2
        adda.w          a2,a2
        adda.w          (a2),a2
        adda.w          (a2)+,a2
        adda.w          -(a3),a3
        adda.w          $7ffe,a3
        adda.w          $ffff7ffe,a4
        
        
        muls.w          d0,d0
        muls.w          (a0),d0
        muls.w          (a0)+,d0
        muls.w          -(a0),d0
        muls.w          $7ffe,d0
        muls.w          $ffff7ffe,d0
        muls.w          #$7ffe,d0
        
    CMP.B   D0, D1  
*    CMP.B   A1, D1  
    CMP.B   (A1), D1        
    CMP.B   (A1)+, D1   
    CMP.B   -(A1), D1   
    CMP.B   $811F, D1   
    CMP.B   $FFFF123F, D1   
    CMP.B   #$01, D1
 
    
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

* Put variables and constants here

    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
