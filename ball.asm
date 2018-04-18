bits 16
org 0x7C00


	cli
      mov ah,0x02
      mov al,8
      mov dl,0x80
      mov dh ,0
      mov ch,0
       mov cl,2
      mov bx,start
      int 0x13
      jmp start
      
 times (510 - ($ - $$)) db 0
 db 0x55 , 0xAA
    start: 

  
      




call drawWall
call drawplayer1
call drawplayer2
call drawball
call showscore1
call showscore2
call interfacePoster
call interface
call selectmode
 mode1:
         
          call getInput
          call moveComputer
          call checkBounce
          call moveBall
          call sleep
          jmp mode1
          ret
    mode2:
          
         
          call getInput
          call checkBounce
          call moveBall
          call sleep
          jmp mode2
ret

interface:
      xor ecx,ecx
      mov edi,0xb8030
      add edi,0x500
      add edi ,0x500
      sub edi ,0xa0
    
     boo:
      mov al ,[msg+ecx]
      mov [edi],al
      add edi ,2
      inc ecx
     cmp ecx ,30
     jl boo
     xor ecx ,ecx 
      mov edi,0xb8030
       add edi,0x500
        add edi,0x500
         moo:
      mov al ,[msg2+ecx]
      mov [edi],al
      add edi ,2
      inc ecx
     cmp ecx ,30
     jl moo
     ret 
     clearthis:
      xor ecx,ecx
      mov edi,0xb8030
      add edi,0x500
      add edi, 0x500
      sub edi ,0xa0
    
     booo:
      mov al ,0
      mov [edi],al
      add edi ,2
      inc ecx
     cmp ecx ,30
     jl booo
     xor ecx ,ecx 
      mov edi,0xb8030
       add edi,0x500
        add edi,0x500
         mooo:
      mov al ,0
      mov [edi],al
      add edi ,2
      inc ecx
     cmp ecx ,30
     jl mooo
     ret 
     
    sleep:
       mov ah,0  
       int 1ah   
       add dx,1  
       mov bx,dx 
    sleepLoop:
       int 1ah
       cmp dx,bx
       jne sleepLoop
       ret

      moveBall:
       mov cl,[ballloc+1]
       mov ch,[ballloc]
       mov [cursorX],cl
       mov [cursorY],ch
       call setCursorsor
       mov ah,0x9
       mov bl , 0
       mov al,20
       mov cx,1
       int 0x10
       mov al,[direction]
       cmp al,0x01
       je moveBall1
       cmp al,0x02
       je moveBall2
       cmp al,0x03
       je moveBall3
       cmp al,0x04
       je moveBall4

    moveBall1:
       mov ax, [ballloc]
       cmp ah,0x01 ;check that it is not on the wall
       je coui
       jne vi
       coui:
       call bouncePlayer1
       call playercount
       ret
       vi:
       cmp al,0x01
       je theDirection4 ;
       dec al
       dec ah
       mov [ballloc], ax
       call drawball
       ret

    moveBall2:
       mov ax, [ballloc]
       cmp ah,0x4d
       je oo
       jne ooo
       oo:
   
       call player2count
       call bouncePlayer2
       ret
       ooo:
       cmp al,0x01
       je theDirection3
       inc ah
       dec al
       mov [ballloc], ax
       call drawball
       ret

    moveBall3:
       mov ax, [ballloc]
       cmp ah,0x4d
       je pp
       jne ppp
       pp:
       call player2count
       call bouncePlayer2
       ret
      ppp:
       cmp al,0x17
       je theDirection2  
       inc ah
       inc al
       mov [ballloc], ax
       call drawball
       ret

    moveBall4:
       mov ax, [ballloc]
       cmp ah,0x01
       je couv
       jne vvvv
       couv:
       call bouncePlayer1
       call playercount
       ret
       vvvv:
       cmp al,0x17
       je theDirection1
       dec ah
        inc al
       mov [ballloc], ax
       call drawball
       ret

    theDirection1:
       mov al,0x01
       mov [direction],al
       call drawball
       ret
    theDirection2:
       mov al,0x02
       mov [direction],al
       call drawball
       ret
    theDirection3:
       mov al,0x03
       mov [direction],al
       call drawball
       ret
    theDirection4:
       mov al,0x04
       mov [direction],al
       call drawball
       ret
       
  drawball:
       mov cl,[ballloc+1]
       mov ch,[ballloc]
       here:
       mov [cursorX],cl
       mov [cursorY],ch
       call setCursorsor
       mov ah,0x9
       mov bl ,77h
       mov al,20
       mov cx,1
       int 0x10
       ret
        
  deletComputer:
         mov edi,[Computerloc]
         dec edi
         dec edi
         xor ecx,ecx
         add edi,0x500
         inc edi
         mov al,0x00
          z:
        mov al , 0x00
        mov [edi],al
        add edi,0xa0
        inc ecx
        cmp ecx,7
        jl z
         ret
 drawplayer2:
        xor ecx,ecx
        mov edi,[Computerloc]
        dec edi
        DEC EDI 
        add edi,0x500
        inc edi
        player2:
        mov al,0xff
        mov [edi],al
        add edi,0xa0
        inc ecx
        cmp ecx,7
        mov [Computerlast],edi
        jl player2
        ret
       moveComputer:
       mov bl,[cursorX]
       cmp bl,0x29
       jl ComputerNoMove
       mov al, [cursorY]
       mov ah, [p2cur]
       inc ah
       cmp al,ah
       jl ComputerMoveUp
       jg ComputerMoveDown
       ret
          
       
      
       
       moveplayer2up:
       mov ch,[p2cur]
       cmp ch,0x03
       je fee
       call deletComputer
       mov ebx,[Computerloc]
       sub ebx,0xa0
       mov [Computerloc],ebx
       xor ebx,ebx
       call drawplayer2
       mov bl,[p2cur]
       sub bl,0x01
       mov [p2cur],bl
       call player2Cursor
       fee:
       ret
      
     moveplayer2down:
       mov ch,[p2cur]
       cmp ch,0x13
       je ComputerNoMove
       call deletComputer
      mov ebx,[Computerloc]
       add ebx,0xa0
       mov [Computerloc],ebx
       xor ebx,ebx
       call drawplayer2
       mov bl,[p2cur]
       add bl,0x01
       mov [p2cur],bl
       call player2Cursor
       ret
     ComputerMoveUp:
       mov ch,[p2cur]
       cmp ch,0x03
       je ComputerNoMove
       call deletComputer
      mov ebx,[Computerloc]
      sub ebx,0xa0
       mov [Computerloc],ebx
       xor ebx,ebx
       call drawplayer2
       mov bl,[p2cur]
       sub bl,0x01
       mov [p2cur],bl
       call player2Cursor
       ret
    ComputerMoveDown:
       mov ch,[p2cur]
       cmp ch,0x13
       je ComputerNoMove
       call deletComputer
      mov ebx,[Computerloc]
       add ebx,0xa0
       mov [Computerloc],ebx
       xor ebx,ebx
       call drawplayer2
       mov bl,[p2cur]
       add bl,0x01
       mov [p2cur],bl
       call player2Cursor
    ComputerNoMove:
       ret
       
       
    checkBounce:
       mov ax, [ballloc]
       cmp ah,0x02
       je checkBounce1
       cmp ah,0x4b
       je checkBounce2
       ret

      checkBounce1:
      mov bl, [playercur]
       cmp al,bl
       je bouncePlayer1
       inc bl
       cmp al,bl
       je bouncePlayer1
       inc bl
       cmp al,bl
       je bouncePlayer1
       inc bl
        cmp al,bl
       je bouncePlayer1
       inc bl
       cmp al,bl
       je bouncePlayer1
       inc bl
       cmp al,bl
       je bouncePlayer1
       inc bl
       cmp al,bl
       je bouncePlayer1
       ret
       checkBounce2:
     
       mov bl, [player2Cursor]
       cmp al,bl
       je bouncePlayer2
       inc bl
       cmp al,bl
       je bouncePlayer2
       inc bl
       cmp al,bl
       je bouncePlayer2
       inc bl
        cmp al,bl
       je bouncePlayer2
       inc bl
       cmp al,bl
       je bouncePlayer2
       inc bl
       cmp al,bl
       je bouncePlayer2
       inc bl
       cmp al,bl
       je bouncePlayer2
       ret

    bouncePlayer1:
       mov al,[direction]
       cmp al,0x01
       je theDirection2
       cmp al,0x04
       je theDirection3
       ret

    bouncePlayer2:
       mov al,[direction]
       cmp al,0x02
       je theDirection1
       cmp al,0x03
       je theDirection4
       ret
       
       selectmode:
       call sleep
       call sleep
       call sleep 
        call sleep
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep
        call sleep
       call sleep
       call sleep 
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep 
        call sleep
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep
        call sleep
       call sleep
       call sleep 
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep 
        call sleep
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep
        call sleep
       call sleep
       call sleep 
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep 
        call sleep
       call sleep
       call sleep
       call sleep
       call sleep
       call sleep
        call sleep
       call sleep
       call sleep 
       call sleep
       call sleep
       call clearTheInterface
       call clearthis
        mov ah,0x01
        int 0x16
        jnz see
       Get:
       mov ah,0x00
       int 0x16
        cmp ah ,4dh
       je mode1
       cmp ah,4bh
       je mode2
       see:
       ret
       
    endProgram:
      mov ax,0x4c00
       int 0x21
       
       getInput:
       mov ah,0x01
       int 0x16
       jz getInputEnd
    getInputGet:
       mov ah,0x00
       int 0x16
       cmp al,0x1b
       je endProgram
       cmp ah,0x11
       je playerMoveUp
      cmp ah,0x1f
       je playerMoveDown
       cmp ah,0x48
       je moveplayer2up
       cmp ah ,0x50
       je moveplayer2down
    getInputEnd:
       ret
   playerMoveUp:
       mov edx,[player1x]
       cmp edx,0xb7c40 ;original-160*8
       jl playerNoMove
       sub edx , 0xa0
       call deletplayer
       mov [player1x],edx
       call drawplayer1
       mov bl,[playercur]
       sub bl,0x01
       mov [playercur],bl
       call pcursor
       ret


    playerMoveDown:
       mov edx,[player1x]
       cmp edx,0xb85a0 ;original+160*9
       jg playerNoMove
       add edx,0xa0
       call deletplayer
       mov [player1x],edx
       call drawplayer1
       mov bl ,[playercur]
       add bl,0x01
       mov [playercur],bl
       call pcursor
    playerNoMove:
       ret
        drawplayer1:

        xor ecx,ecx
        mov edi,[player1x]
        add edi,0x500
        inc edi
         mov al,0xff
        player:
        mov [edi],al
        add edi,0xa0
        inc ecx
        cmp ecx,7
        jl player
        ret
 deletplayer:
         mov edi,[player1x]
         xor ecx,ecx
         add edi,0x500
         inc edi
         mov al,0x00
          q:
        mov al , 0x00
        mov [edi],al
        add edi,0xa0
        inc ecx
        cmp ecx,7
        jl q
         ret
 
 clearScreen:
     call cursorHide
       mov ah,0x06
       mov al,0x00
       mov bh,0x07
       mov cx,0x0000
       mov dl,0x79
       mov dh,0x24
       int 0x10
       mov bx,0x0000
       mov [cursorX],bx
       mov [cursorY],bx
       call setCursorsor
       ret
       
       setCursorsor:
       mov ah,0x02
       mov bh,0x00
       mov dl,[cursorX]
       mov dh,[cursorY]
       int 0x10
       ret
  cursorHide:
       mov cx,0x2000
       mov ah,0x01
       int 0x10
       ret
       
       
    
       
   
        
        

   drawWall:
     mov edi, 0xB8000
     inc edi 
     mov al,0xcc
     ;;first line row
    first:
     mov [edi],al
     add edi,2
     inc ecx
     cmp ecx,80
     jl first
     
     xor ecx ,ecx 
     mov edi, 0xB8000
     inc edi
     
     ;;second line countlmb
     second:
     mov al,0xcc
     mov [edi],al
     add edi,0xA0;mov to 160
     inc ecx
     cmp ecx,25
     jl second
     
     
     ;;third line countlmb
     xor ecx ,ecx 
     mov edi, 0xB809E
     inc edi
     third:
     mov al,0xcc
     mov [edi],al
     add edi,0xA0;mov to 160
     inc ecx
     cmp ecx,25
     jl third
     
     ;; fourth line row
     
      xor ecx ,ecx 
      mov edi, 0xB8000
      add edi,0xF00 
      inc edi
     fourth:
     mov al,0xcc
     mov [edi],al
     add edi,2
     inc ecx
     cmp ecx,80
     jl fourth
     ret
     
     
   
     gameOver:
       call clearScreen
       call deletComputer
       call deletplayer
       
       ;GAME:
   mov al , 20      ;R1:
   mov dh , 4   
   mov bh , 0   ;page
   mov bl , 0x44  ;color
   
    mov dl ,16    
    mov cx,7  
     call p
    
    MOV DL,31   
    mov cx,4   
    call p

    mov dl,42 
    mov cx,2   
     call p
       
    mov dl,50   
    mov cx,2  
      call p

    mov dl,56 
    mov cx,8   
     call p
    
   mov al , 20   ;R2
   mov dh , 5   
   mov bh , 0   
   mov bl ,0x44   
 
   mov dl ,14  
   mov cx,2  
    call p

    MOV DL,29  
    mov cx,2   
      call p
       
    MOV DL,35   
    mov cx,2   
     call p

    mov dl,42   
    mov cx,4  
      call p
    
    mov dl,48  
    mov cx,4  
      call p

    mov dl,56  
    mov cx,2 
    call p

  mov al , 20   ;R3
  mov dh , 6       

     mov dl ,14 
    mov cx,2  
     call p
    
    mov dl ,19    
    mov cx,4   
     call p

    MOV DL,28    
    mov cx,2    
       call p
       
    MOV DL,36   
    mov cx,2   
     call p
       
    mov dl,42  
    mov cx,2  
      call p
       
     mov dl,45  
    mov cx,4   
     call p
       
    mov dl,50  
    mov cx,2
    call p

    mov dl,56   
    mov cx,8 
      call p
    
    mov al , 20   ;R4
    mov dh , 7  

   mov dl ,14    
    mov cx,2   
     call p
    
    mov dl ,21   
    mov cx,2    
    call p
    
    MOV DL,28   
    mov cx,10   
     call p
    
    mov dl,42  
    mov cx,2  
     call p
       
    mov dl,46  
    mov cx,2  
     call p
       
    mov dl,50  
    mov cx,2  
      call p

    mov dl,56  
    mov cx,2   
     call p
                
      mov al , 20   ;R5
  mov dh , 8    

   mov dl ,16    
    mov cx,7
    call p
         
    MOV DL,28   
    mov cx,2        
     call p
       
    MOV DL,36  
    mov cx,2    
     call p
    
    
    mov dl,42  
    mov cx,2       
     call p
    
       
    mov dl,50  
    mov cx,2  
     call p

    mov dl,56 
    mov cx,8 
    call p
       
;OVER:
  mov al , 20   ;R1:
  mov dh , 12   ;x

  mov dl ,16 
  mov cx,5     
   call p
  
    MOV DL,28   
    mov cx,2  
    call p
       
    MOV DL,36    
    mov cx,2     
     call p

    mov dl,42   
    mov cx,8   
     call p

    mov dl,56   
    mov cx,6  
     call p
    
    mov al , 20       ;R2
    mov dh , 13   ;x
    mov dl ,14    
    mov cx,2     
      call p
    
    mov dl ,21    
    mov cx,2    
     call p
    
    MOV DL,28   
    mov cx,2    
     call p
       
    MOV DL,36   
    mov cx,2        
         call p
    
    mov dl,42   
    mov cx,2  
    call p

    MOV DL,56   
    mov cx,2    
       call p
       
    MOV DL,62    
    mov cx,2      
     call p       
    

 mov al , 20   ;R3:
  mov dh , 14   ;x
  
    mov dl ,14   
    mov cx,2    
      call p
    
    mov dl ,21  
    mov cx,2    
     call p
    
    MOV DL,28    
    mov cx,4         
     call p
    
    MOV DL,34  
    mov cx,4      
     call p
    
    mov dl,42   
    mov cx,8      
      call p
    
  mov dl,56   
    mov cx,6   
    call p

  mov al , 20   ;R4:
  mov dh , 15   ;x
  
    mov dl ,14   
    mov cx,2 
      call p
    
    mov dl ,21   
    mov cx,2 
     call p

    MOV DL,30   
    mov cx,6    
      call p

    mov dl,42  
    mov cx,2       
       call p
          
    MOV DL,56   
    mov cx,2        
      call p
       
    MOV DL,62   
    mov cx,2  
     call p

  mov al , 20   ;R5:
  mov dh , 16   ;x                          

  mov dl ,16   
  mov cx,5          
   call p

    MOV DL,32  
    mov cx,2        
     call p
 
    mov dl,42 
    mov cx,8  
    call p
    
    MOV DL,56  
    mov cx,2         
      call p

    MOV DL,62   
    mov cx,2    
     call p
    
;frame : 
    mov dh , 00  ;x
    MOV DL,00   ;y
    mov bh , 0   ;page
    mov ah,2
    int 10h
    
    mov ah,9
    mov al , 20   ;space
    mov bl , 0x44  ;color 
    mov cx,80
    int 10h 
    
    mov si,80
    mov dh ,00  ;x
    mov bh , 0   ;page
    MOV DL,00   ;y
    mov al , 20h   ;space
    mov bl , 0xDD  ;color
    call a
     mov dh,24   ;x
     mov dl,00
     call a
     ret 
    
    
    a:
    
    mov cx,1
    call p
    dec si
    jz lp
    inc dl
    test si,1
    jz b
    mov bl,0xDD
    jmp a
    b:
    mov bl,0x44
    jmp a
    
    lp:
    ret
 p:
mov ah,02h
int 10h
mov ah,09h
int 10h
ret
   
  
  
    playercount:
     mov ebp,[result]
     inc ebp 
     mov [result],ebp
     call thescore
     cmp ebp,5
     je bin
     jne binn
     bin:
     call gameOver
     binn:
       ret
       
       showscore1:
       xor ecx,ecx
      mov edi,0xb8002
     there:
      mov al ,[score+ecx]
      mov [edi],al
      add edi ,2
      inc ecx
     cmp ecx ,5
     jl there
      ret
      showscore2:
      xor ecx,ecx
      mov edi,0xb8090
     tthere:
      mov al ,[score+ecx]
      mov [edi],al
      add edi ,2
      inc ecx
      cmp ecx ,5
     jl tthere
      ret
      
      
       thescore:
       mov edi,0xb809c
      mov al ,[number+ebp]
      mov [edi],al
      add edi ,2
       ret
       
      player2count:
     mov esi,[resultt]
     inc esi 
     mov [resultt],esi
     call thescore2
     cmp esi,5
     je kin
     jne kinn
     kin:
     call gameOver
     kinn:
       ret
       
       
       thescore2:
      mov edi,0xb8010
      mov al ,[number2+esi]
      mov [edi],al
      add edi ,2
       ret
       
      pcursor:
       mov bl,[playercur]
       mov ah,0x02
       mov bh,0x00
       mov dl,0x02
       mov dh,[playercur]
       int 0x10
       nu:
       ret
       player2Cursor:
       mov bl,[p2cur]
       mov ah,0x02
       mov bh,0x00
       mov dl,0x4b
       mov dh,[p2cur]
       int 0x10
       bu:
       ret
       
      interfacePoster:
       ;PONG
  mov al , 20      ;R1:
   mov dh , 2  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,10
     call p 
    mov dl ,26 
    mov cx,10
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p
    mov dl ,61 
    mov cx,10
     call p   
   mov al , 20      ;R2:
   mov dh , 3  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,44 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p     
   mov al , 20      ;R3:
   mov dh , 4 
   mov bh , 0   ;page
   mov bl , 0x44  ;color 
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,45 
    mov cx,1
     call p 
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R4:
   mov dh , 5  
   mov bh , 0   ;page
   mov bl , 0x44  ;color 
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p 
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,46 
    mov cx,1
     call p 
    mov dl ,61
    mov cx,2
     call p    
   mov al , 20      ;R5:
   mov dh , 6  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p  
    mov dl ,18 
    mov cx,2
     call p 
     mov dl ,26 
     mov cx,2
      call p 
     mov dl ,34
     mov cx,2
      call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,47 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R6:
   mov dh , 7  
   mov bh , 0   ;page 
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,10
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,48 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p  
   mov al , 20      ;R7:
   mov dh , 8  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p   
    mov dl ,49 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R8:
   mov dh , 9  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,50 
    mov cx,1
     call p
     mov dl ,61 
    mov cx,2
     call p 
    mov dl ,67 
    mov cx,4
     call p  
   mov al , 20      ;R9:
   mov dh , 10  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,51 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p
    mov dl ,69 
    mov cx,2
     call p 
   mov al , 20      ;R10:
   mov dh , 11  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,52 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p
    mov dl ,69 
    mov cx,2
     call p  
   mov al , 20      ;R11:
   mov dh , 12  
   mov bh , 0   ;page
   mov bl , 0x44  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26  
    mov cx,10
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,61 
    mov cx,10
     call p
    ret
    
    clearTheInterface:
       ;PONG
  mov al , 20      ;R1:
   mov dh , 2  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,10
     call p 
    mov dl ,26 
    mov cx,10
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p
    mov dl ,61 
    mov cx,10
     call p   
   mov al , 20      ;R2:
   mov dh , 3  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,44 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p     
   mov al , 20      ;R3:
   mov dh , 4 
   mov bh , 0   ;page
   mov bl , 00  ;color 
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,45 
    mov cx,1
     call p 
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R4:
   mov dh , 5  
   mov bh , 0   ;page
   mov bl , 00  ;color 
    mov dl ,10  
    mov cx,2
     call p 
    mov dl ,18 
    mov cx,2
     call p 
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,46 
    mov cx,1
     call p 
    mov dl ,61
    mov cx,2
     call p    
   mov al , 20      ;R5:
   mov dh , 6  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p  
    mov dl ,18 
    mov cx,2
     call p 
     mov dl ,26 
     mov cx,2
      call p 
     mov dl ,34
     mov cx,2
      call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,47 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R6:
   mov dh , 7  
   mov bh , 0   ;page 
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,10
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,48 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p  
   mov al , 20      ;R7:
   mov dh , 8  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p   
    mov dl ,49 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p    
   mov al , 20      ;R8:
   mov dh , 9  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,50 
    mov cx,1
     call p
     mov dl ,61 
    mov cx,2
     call p 
    mov dl ,67 
    mov cx,4
     call p  
   mov al , 20      ;R9:
   mov dh , 10  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
    mov dl ,51 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p
    mov dl ,69 
    mov cx,2
     call p 
   mov al , 20      ;R10:
   mov dh , 11  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26 
    mov cx,2
     call p 
    mov dl ,34
    mov cx,2
     call p
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,52 
    mov cx,1
     call p
    mov dl ,61 
    mov cx,2
     call p
    mov dl ,69 
    mov cx,2
     call p  
   mov al , 20      ;R11:
   mov dh , 12  
   mov bh , 0   ;page
   mov bl , 00  ;color
    mov dl ,10  
    mov cx,2
     call p
    mov dl ,26  
    mov cx,10
     call p 
    mov dl ,42 
    mov cx,2
     call p 
    mov dl ,53 
    mov cx,2
     call p 
     mov dl ,61 
    mov cx,10
     call p
    ret


       d: db 00
       p2cur:  db 0x0a
      playerx: db 0x0a
      player1x dd 0xb8002
       bally: dd 0xb80a0
       ballx: dd 0xb8000
       Computerloc: dd  0xb809e
      cursorX: dd 0x00
      cursorY: dd 0x00
      direction: db 0x01
     ballloc: db 0x0b,0x27
     Computerlast: dd 0x0000
     player1last: dd 0x0000
     playercur: db 0x0a
     result: dd 0
     resultt: dd 0
     score: db 'score'
     number: db '012345'
     number2: db '012345'
     msg: db 'for 1 player press right arrow' ;30
     msg2: db 'for 2 players press left arrow' ;30
;shapes




times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00