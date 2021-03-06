;---------------------

    ;include "./registers.i"


color00=$180

COPPERLIST_SIZE=1000		;Size of the copperlist
LINE=10			;<= 255

init:
              move.l    4.w,a6                  ; execbase
              moveq.l   #0,d0              

	; Allocation of chip memory

              move.l     #COPPERLIST_SIZE,d0
              move.l     #$10002,d1
              movea.l    $4,a6
              jsr        -198(a6)
              move.l     d0,copperlist


              move.l     #gfxname,a1             ; librairy name
              jsr        -408(a6)                ; oldopenlibrary()
              move.l     d0,a1                   
              move.l     38(a1),d4               ; copper list pointer to save
              jsr        -414(a6)                ; closelibrary()
 
              move.b     #$80,d7                 ; y position
              move       #-1,d6                  ; step
              move       $dff01c,d5              ; interruptions to d5 
              move       #$7fff,$dff09a

;---------- Copper list ----------
              movea.l    copperlist,a0
              move.w     #$1fc,(a0)+   
              move.w     #0,(a0)+                ;slow fetch mode for AGA compatibility
              move.w     #$100,(a0)+
              move.w     #$0200,(a0)+            ; wait for screen start

              move.w     #color00,(a0)+
              move.w     #$349,(a0)+

              move.w     #$2b07,(a0)+
              move.w     #$fffe,(a0)+           
              move.w     #color00,(a0)+
              move.w     #$56c,(a0)+
              move.w     #$2c07,(a0)+
              move.w     #$fffe,(a0)+           

              move.w     #color00,(a0)+
              move.w     #$113,(a0)+

;Copy copper bar
              move       #9,d0 
              move       #$050,d1
              move       #$8007,d3
              move.l     a0,waitras1
loopbar:
              move.w     d3,(a0)+
              move.w     #$fffe,(a0)+       
              move.w     #color00,(a0)+
              move.w     d1,(a0)+        
              add        #$0100,d3
              add        #$010,d1
              dbra       d0,loopbar              ; loop until -1

              move       #9,d0                   ; loop of 10
loopbar2:
              move.w     d3,(a0)+
              move.w     #$fffe,(a0)+   
              move.w     #color00,(a0)+
              move.w     d1,(a0)+  
              add        #$0100,d3
              sub        #$010,d1
              dbra       d0,loopbar2 

              move.l     a0,waitras2
              move.w     d3,(a0)+
              move.w     #$fffe,(a0)+ 
              move.w     #color00,(a0)+
              move.w     #$113,(a0)+  

; End of copper bar
              move.w     #$ffdf,(a0)+
              move.w     #$fffe,(a0)+ 
              move.w     #$2c07,(a0)+
              move.w     #$fffe,(a0)+ 
              move.w     #color00,(a0)+
              move.w     #$aaa,(a0)+             ; background color
              move.w     #$2d07,(a0)+
              move.w     #$fffe,(a0)+ 
              move.w     #color00,(a0)+
              move.w     #$349,(a0)+

              move.w     #$ffdf,(a0)+
              move.w     #$fffe,(a0)+ 

;End

              move.l     #$FFFFFFFE,(a0)

; Activate Copper list

              move.l     copperlist,$dff080
              clr.w      $dff088

resetcount:
              moveq      #$50,d2                 ; cycle duration
              neg        d6

******************************************************************	
mainloop:
	
		; Wait for vertical blank
              move.w     #$0c,d0                 ;No buffering, so wait until raster
              bsr.w      WaitRaster              ;is below the Display Window.

;----------- main loop ------------------
              add        d6,d7                   ; Increment
              dbf        d2,continue   
              jmp        resetcount 

continue: ; 200A8 - 20116
              move       #19,d0 
              move       d7,d3
              move.l     waitras1,a3
moveloop: ; 200A8 - 20116
              move.b     d3,(a3)
              add        #4,d3
              add        #6,a3
              add        #2,a3
              dbra       d0,moveloop

              move.l     waitras2,a3
              move.b     d3,(a3)
;----------- end main loop ------------------

checkmouse:
              btst       #6,$bfe001
              bne.b      mainloop

exit:
              move.l     d4,$dff080              ; restoring copperlist
              or         #$c000,d5               ; activating interruptions
              move       d5,$dff09a
              rts
	
WaitRaster:				;Wait for scanline d0. Trashes d1.
.l:           move.l     $dff004,d1
              lsr.l      #1,d1
              lsr.w      #7,d1
              cmp.w      d0,d1
              bne.s      .l                      ;wait until it matches (eq)
              rts
******************************************************************	
gfxname:
              dc.b       "graphics.library",0

              EVEN

waitras1:     DC.L       0
colorcpline:  DC.L       0
waitras2:     DC.L       0
copperlist:   DC.L       0


