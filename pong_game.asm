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
    call clear_screan
    call pong
    call clear_screan
call draw_wall
call draw_players
call draw_ball
call show_score1
call show_score2
l:
call get_input
call move_ball
call sleep
mov si,[score1]
cmp si,2
je lose_and_win
mov si,[score2]
cmp si,2
je lose_and_win
jmp l
ret
draw_wall:
 mov al , 0x20    ;space
 mov bl , 0x11   ;color
 mov bh , 0
 ROWS:
 R1:
 mov dh , 00  ;x
 mov dl , 00  ;y
 call drowR
 R2:
 mov dh,24  ;x
 mov dl , 00  ;y
 call drowR
 jmp COLUMNS
 ret
 drowR:
 mov cx,80
 call p
ret
COLUMNS:
mov bl,0x44   ;color
C1:
mov dh , 1  ;x
mov dl , 00  ;y
call drwowC
C2:mov dh ,1    ;x
mov dl ,79    ;y
call drwowC
ret
drwowC:
e:
mov cx,1
call p
inc dh
cmp dh,24
jl e
ret

draw_players:
mov bl,0x77   ;color
player1:
 mov dh , 09  ;x
 mov dl , 01  ;y
 mov [player1x],dh
 mov [player1y],dl
call drawp
player2:
 mov dh , 09  ;x
 mov dl , 78  ;y
 mov [player2x],dh
 mov [player2y],dl
 call drawp
ret
drawp:
mov si,7
 s:
mov cx,1
call p
inc dh
dec si
jnz s
ret

draw_ball:
mov bl,0x77   ;color
 mov dh,12  ;x
 mov dl,39  ;y
 mov [nballx],dh
 mov [nbally],dl
 drawball:
mov cx,1
call p
ret
get_input:
mov ah,1h
       int 0x16
       jnz check_input
       ret
check_input:
   mov ah,0h
   int 16h  ;al=ascii character 
   cmp al,0x81   ;escape
   je end
   cmp ah,0x11   ;W
   je player1_move_up
   cmp ah,0x1f      ;S
   je player1_move_down
    cmp ah,0x48  
   je player2_move_up
   cmp ah,0x50      
   je player2_move_down
   ret
   end:
      call clear_screan
       mov ah,0x4c
       int 0x21
       ret
    player1_move_up:   
    mov dh,[player1x]
    mov dl,[player1y]
    cmp dh,1
    je no_mov
    call del_player
    mov dh,[player1x]
    dec dh
    mov [player1x],dh
    mov al,0x20
    mov bl,0x77
    call drawp
    ret
    
    player1_move_down:   
    mov dh,[player1x]
    mov dl,[player1y]
    cmp dh,17
    je no_mov
    call del_player
    mov dh,[player1x]
    inc dh
    mov [player1x],dh
    mov al,0x20
    mov bl,0x77
    call drawp
    ret
     player2_move_up:   
    mov dh,[player2x]
    mov dl,[player2y]
    cmp dh,1
    je no_mov
    call del_player
    mov dh,[player2x]
    dec dh
    mov [player2x],dh
    mov al,0x20
    mov bl,0x77
    call drawp
    ret
    
    player2_move_down:   
    mov dh,[player2x]
    mov dl,[player2y]
    cmp dh,17
    je no_mov
    call del_player
    mov dh,[player2x]
    inc dh
    mov [player2x],dh
    mov al,0x20
    mov bl,0x77
    call drawp
    ret
    
    no_mov:
    ret
    del_player:
    mov al,0x20
    mov bl,0x00
    call drawp
    ret
    
    
    move_ball:
    mov dh , [nballx]
    mov dl,[nbally]
    jmp check_ball
    ballmoved:
    mov si,[nballx]
    mov [ballx],si
    mov si,[nbally]
    mov [bally],si
    mov  [nballx], dh
    mov [nbally],dl
    ret
    
    check_ball:
    cmp dh,1
    je ball_in_the_roof
    cmp dh,23
    je ball_in_the_ground
    cmp dl,2
    je check_ball_with_p1
    cmp dl,77
    je check_ball_with_p2
    cmp dl,1
    je player1goal
    cmp dl , 78
    je player2goal
    balldir:
    mov si,[bally]
    mov bp,[nbally]
    cmp si,bp
    jl movright
    jg movleft
    movright:
    mov si,[ballx]
    mov bp,[nballx]
    cmp si,bp
    jl dawn1
    up1:  ;up right 
    call delball
    mov dl,[nbally]
    mov dh,[nballx]
    inc dl
    dec dh
    o:
    mov bl,0x77
    call drawball
    
   jmp ballmoved
    dawn1:    ;down right
    call delball
    mov dl,[nbally]
    mov dh,[nballx]
    inc dl
    inc dh
    call o
    ret
    movleft:
    mov si,[ballx]
    mov bp,[nballx]
    cmp si,bp
    jg up2
    jl dawn2
    up2:  ;up left 
    call delball
    mov dl,[nbally]
    mov dh,[nballx]
    dec dl
    dec dh
    call o
    ret
    dawn2:    ;down left
    call delball
    mov dl,[nbally]
    mov dh,[nballx]
    dec dl
    inc dh
    call o
   ret
     ball_in_the_roof:
    mov ch,[bally]
    mov cl,[nbally]
    cmp ch,cl
    jl d1
    call dawn2
    ret
    d1:
    call dawn1
    ret
    ball_in_the_ground:
    mov ch,[bally]
    mov cl,[nbally]
    cmp ch,cl
    jl u1
    call up2
    ret
    u1:
    call up1
    ret
    
     check_ball_with_p1:
    xor si,si
    mov al,[nballx]
       mov bl,[ player1x]
       check11:
       cmp al,bl
       je ball_with_p1
       inc bl
       inc si
       cmp si,7
       jl check11
       jmp balldir
    ret
     ball_with_p1:
       mov ch,[ballx]
    mov cl,[nballx]
    cmp ch,cl
    jl d111
    call up1
    ret
    d111:
    call dawn1
    ret
    
    
    check_ball_with_p2:
    xor si,si
    mov al,[nballx]
       mov bl,[ player2x]
       check1:
       cmp al,bl
       je ball_with_p2
       inc bl
       inc si
       cmp si,7
       jl check1
       jmp balldir
    ret
     ball_with_p2:
       mov ch,[ballx]
    mov cl,[nballx]
    cmp ch,cl
    jl d11
    call up2
    ret
    d11:
    call dawn2
    ret
    player1goal:
    call ooo
    mov si,[score2]
    inc si
    mov [score2],si
    mov al,[score0+si]
    mov dl,78
    call oooo

    ret
    
    player2goal:
    call ooo
    mov si,[score1]
    inc si
    mov [score1],si
    mov al,[score0+si]
    mov dl,10
    call oooo
    ret
    
    ooo:
    call delball
    call draw_ball
    mov [nballx],dh
    mov [nbally],dl
    ret
    
    oooo:
    mov bl,0x17
    mov cx , 1
    mov dh,0
    call p
    ret
    
   delball:
   mov al,0x20
   mov bl,0x00
   call drawball
   ret
    
     p:
mov ah,02h
int 10h
mov ah,09h
int 10h
ret

show_score1:
       xor si,si
       mov bl,0x17
       mov dh,0
       mov bh,0
       mov dl,2
     type:
      mov al ,[score+si]
      call p
      inc dl
      inc si
     cmp si ,7
     jl type
      ret
      show_score2:
      xor si,si
       mov bl,17h
       mov dh,0
       mov dl,70
       call type
      ret
      
      sleep:
      mov ah,86h
      xor si, si
      sl:
      int 15h
      inc si
      cmp si,15
      jl sl
       ret

lose_and_win:
mov si,[score1]
mov bp,[score2]
cmp si,bp
jl player2_win
player1_win:
call clear_screan
call drawl
mov dword[si],7
call win
mov dword[si],46
call lose
jmp press_any_key
ret

player2_win:
call clear_screan
call drawl
mov dword[si],46
call win
mov dword[si],7
call lose
jmp press_any_key
ret

clear_screan:
mov dh,0
mov dl,0
mov bl , 0x00
mov al,0x20
mov cx,80
cl_sc:
call p
inc dh
cmp dh,25
jl cl_sc
ret 


win:
mov bl , 0xAA    ;color
mov dh ,8     ;x
mov al,0x20
mov dl,[si]       ;y
;R1:
mov cx,2
call p

add dl,7         
mov cx,2
call p

add dl,3  
mov cx,3
call p

add dl,4 
mov cx,2 
call p

add dl,7
mov cx,2
call p

;R2:
inc dh
mov dl,[si] 
mov cx,2
call p

add dl,7
mov cx,2
call p

add dl,4   
mov cx,1
call p

add dl,3 
mov cx,4
call p

add dl,7
mov cx,2
call p

;R3:

inc dh
mov dl,[si]
mov cx,2
call p

add dl,4
mov cx,1
call p

add dl,3
mov cx,2
call p

add dl,4 
mov cx,1
call p

add dl,3  
mov cx,2
call p

add dl,4
mov cx,2
call p

add dl,3
mov cx,2
call p

;R4:

inc dh
mov dl,[si] 
mov cx,2
call p

add dl,4
mov cx,1
call p

add dl,3
mov cx,2
call p

add dl,4 
mov cx,1
call p

add dl,3  
mov cx,2
call p

add dl,6
mov cx,3
call p

;R5:

inc dh
mov dl,[si] 
INC dl    
mov cx,3
call p

add dl,4
mov cx,3
call p
add dl,5
mov cx,3
call p

add dl,4 
mov cx,2
call p

add dl,7
mov cx,2
call p

;CUP:
mov bl,0x66
mov dl,[si]
mov dh,15       ;x
add dl,9
mov cx,5
call p
inc dh
dec dl
mov cx,7
call p
inc dh
inc dl
mov cx,5
call p
inc dh
add dl,2
mov cx,1
call p
inc dh
sub dl,1
mov cx,3
call p
stars:
mov al,0x2A
mov dh,0
g:mov bp,17
mov dl,[si]
sub dl,3
mov cx,1
call t
add dh,2
cmp dh,8
jl g
mov dh,20
v:mov bp,17
mov dl,[si]
sub dl,3
mov cx,1
call t
add dh,2
cmp dh,23
jl v
ret
t:
mov bl,0xD
test bp,1
jnz i
mov bl,0x00
i:
call p
add dl , 2
dec bp
jnz t
ret
lose:
mov bl , 0x44    ;color
mov dh ,8     ;x
mov al,0x20
mov dl,[si]       ;y
;R1:
mov cx,2
call p

add dl,9         
mov cx,3
call p

add dl,6  
mov cx,6
call p

add dl,7
mov cx,6 
call p

;R2:
inc dh
mov dl,[si] 
mov cx,2
call p

add dl,7
mov cx,2
call p

add dl,5   
mov cx,2
call p

add dl,3 
mov cx,2
call p

add dl,7
mov cx,2
call p

;R3:

inc dh
mov dl,[si]
mov cx,2
call p

add dl,7
mov cx,2
call p

add dl,5
mov cx,2
call p

add dl,3 
mov cx,6
call p

add dl,7  
mov cx,6
call p

;R4:

inc dh
mov dl,[si]
mov cx,2
call p

add dl,7
mov cx,2
call p

add dl,5
mov cx,2
call p

add dl,7 
mov cx,2
call p

add dl,3  
mov cx,2
call p

;R5:

inc dh
mov dl,[si] 
mov cx,6
call p

add dl,9
mov cx,3
call p

add dl,6
mov cx,6
call p

add dl,7 
mov cx,6
call p

;Sad face:
mov al,20h
mov bl,0xE0
mov dl,[si]
mov dh,16     ;x      
add dl,10
mov cx,1
call p
add dl,1
mov cx,1
mov al,0x59 
call p
inc dl
mov cx,1
mov al,0x20 
call p
inc dl
mov cx,1
mov al,0x59 
call p
inc dl
mov cx,1
mov al,0x20 
call p
inc dh
sub dl,4
mov cx,1
call p
inc dl
mov cx,3
mov al,0x2D
call p
add dl,3
mov cx,1
mov al,0x20 
call p
call Rrain
ret
Rrain:
mov al,0x27
mov dh,0
gg:mov bp,17
mov dl,[si]
sub dl,3
mov cx,1
call tt
add dh,2
cmp dh,8
jl gg
mov dh,20
vv:mov bp,17
mov bl,88
mov dl,[si]
sub dl,3
mov cx,1
call tt
add dh,2
cmp dh,23
jl vv
ret
tt:
mov bl,0x88
test bp,1
jnz ii
mov bl,0x00
ii:
call p
add dl , 2
dec bp
jnz tt
ret

drawl:

mov cx,1
mov dh ,00    ;x
mov dl ,39    ;y
w:
mov bl,0x77
test dh,1
jnz q
mov bl,0x00
q:
call p
inc dh
cmp dh,26
jl w

ret

press_any_key:

call ww
call Game_Over
call options2
call ww
mov si,0
mov [score1],si
mov [score2],si
call clear_screan
      jmp start
ret
ww:
mov ah,0x01
       int 0x16
jz ww
ret
options2:
mov bl,0x01
mov cx,1
 mov dh,20
mov bh,0
;op1
 xor si,si
 mov dl,14
 type1:
 mov al ,[op1+si]
 call p
 inc dl
 inc si
 cmp si ,13
 jl type1
;op2
 xor si,si
 mov dl,50
 type2:
 mov al ,[op2+si]
 call p
 inc dl
 inc si
 cmp si ,8
 jl type2
 call hidecursor
ret
 hidecursor:
       mov ch,0x20
       mov ah,0x01
       int 0x10
       ret
Game_Over:
call clear_screan
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
    call frame
    ret
frame : 
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
    jz d
    inc dl
    test si,1
    jz b
    mov bl,0xDD
    jmp a
    b:
    mov bl,0x44
    jmp a
    
    d:
    ret
    pong:
   mov al , 20      ;R1:
   mov dh , 5  
   mov bh , 0   ;page
   mov bl , 0xaa ;color
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
   mov dh , 6  
   mov bh , 0   ;page
   mov bl , 0xaa  ;color
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
   mov dh , 7
   mov bh , 0   ;page
   mov bl , 0xee  ;color 
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
   mov dh ,8  
   mov bh , 0   ;page
   mov bl , 0xee  ;color 
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
   mov dh , 9  
   mov bh , 0   ;page
   mov bl , 0xcc  ;color
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
   mov dh , 10  
   mov bh , 0   ;page 
   mov bl , 0xcc  ;color
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
   mov dh , 11  
   mov bh , 0   ;page
   mov bl , 0xcc ;color
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
   mov dh , 12  
   mov bh , 0   ;page
   mov bl , 0xdd ;color
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
   mov dh , 13  
   mov bh , 0   ;page
   mov bl , 0xdd  ;color
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
   mov dh , 14  
   mov bh , 0   ;page
   mov bl , 0x11  ;color
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
   mov dh , 15  
   mov bh , 0   ;page
   mov bl , 0x11  ;color
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
     call frame
     call options1
ret
options1:
mov bl,0x01
mov cx,1
 mov dh,20
mov bh,0
;op1
 xor si,si
 mov dl,14
 type111:
 mov al ,[op11+si]
 call p
 inc dl
 inc si
 cmp si ,14
 jl type111
;op2
 xor si,si
 mov dl,50
 type222:
 mov al ,[op21+si]
 call p
 inc dl
 inc si
 cmp si ,15
 jl type222
 call hidecursor
 call ww
     ret

       op1:db '*1* TRY AGAIN'
       op2: db '*2* EXIT'
       op11: db '*1* One Player'
       op21:db '*2* Two Players'
      score: db 'Score :'
      player1x: db  9
      player1y: db   1
       player2x: db  9
      player2y: db   78
      score1: dw 00
      score2: dw 00
      score0:dw '0123456789'
      nballx: dd    12
      nbally: dd  39
      ballx: dd    13
      bally: dd  00
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