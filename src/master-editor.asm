  processor 6502

  .org $8000

fa = $ba

      lda  #$00                         
      sta  $D020                        ; Border color
      sta  $0286                        ; Current char color code
      lda  #$0F                         
      sta  $D021                        ; Background 0 color
;==========
; Main menu
;==========
draw_menu:
      lda  #$48                         
      ldx  #$8C                         
      jsr  W85D9                        ; "Menue"
      lda  #$74                         
      ldx  #$8C                         
      jsr  W85D9                        ; "1) character-editor"
      lda  #$94                         
      ldx  #$8C                         
      jsr  W85D9                        ; "2) screen-editor"
      lda  #$B0                         
      ldx  #$8C                         
      jsr  W85D9                        ; "3) sprite-editor"
      lda  #$56                         
      ldx  #$8E                         
      jsr  W85D9                        ; "4) directory"
      lda  #$6E                         
      ldx  #$8E                         
      jsr  W85D9                        ; "5) floppy-commands"
      jsr draw_drive_menu_entry
      nop
      nop
      nop
      nop
      lda  #$8C                         
      ldx  #$8E                         
      jsr  W85D9                        ; "7) reset"
;---------------------
; Main menu input loop
;---------------------
menu_input_loop:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  menu_input_loop                        
      sec                               
      sbc  #$31                         
      cmp  #$07                         
      bcs  menu_input_loop                        
      asl                               
      tax                               
      lda  menu_jmp_tbl,x                      
      sta  W8062+1                      
      inx                               
      lda  menu_jmp_tbl,x                      
      sta  W8062+2                      
W8062:
      jmp  WC168                        

;----------------------
; Menu entry jump table
;----------------------
menu_jmp_tbl:
  .word #chredit
  .byte $F4, $8E
  .byte $68, $C1
  .byte $82, $C0
  .byte $00, $C0
  .word #toggle_device
  .byte $E2, $FC
;===============
; Charset editor
;===============
chredit:
      jsr  W8652+2                      
      lda  #$CC                         
      ldx  #$8C                         
      jsr  W85D9                        ; Clear screen
      lda  #$F7                         
      ldx  #$8C                         
      jsr  W85D9                        ; Reverse video on
      lda  #$02                         
      sta  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$26                         
      ldx  #$8D                         
      jsr  W85D9                        
      lda  #$04                         
      sta  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$2C                         
      ldx  #$8D                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$37                         
      ldx  #$8D                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$42                         
      ldx  #$8D                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$4D                         
      ldx  #$8D                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$58                         
      ldx  #$8D                         
      jsr  W85D9                        
      ldy  #$00                         
      lda  #$02                         
      ldx  #$10                         
      jsr  W86B0                        
      jsr  W872F                        
      jsr  W8682                        
      jsr  W86A2                        
      jsr  W86CC                        
      jsr  W8C18                        
      jsr  W82A9                        
      jsr  W8869                        
      lda  #$00                         
      sta  W822F                        
      sta  W8230                        
      lda  #$80                         
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      jsr  W88AE                        
      jmp  W823C                        

;--------------------------
; Charset editor input loop
;--------------------------
W8119:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
W811C:
      cmp  #$00                         
      beq  W8119                        
      cmp  #$4F                         
      beq  W817F                        
      cmp  #$51                         
      beq  W819A                        ; q - return to main menu
      cmp  #$4D                         
      beq  W819D                        ; m - toggle single/multi-color mode
      cmp  #$43                         
      beq  W81A0                        ; c - choose color
      cmp  #$9D                         
      beq  W81AC                        ; cursor left
      cmp  #$1D                         
      beq  W81A9                        ; cursor right
      cmp  #$91                         
      beq  W81A3                        ; cursor up
      cmp  #$11                         
      beq  W81A6                        ; cursor down
      cmp  #$20                         
      beq  W81B8                        ; space - set/del point
      cmp  #$A0                         
      beq  W81B8                        ; space - set/del point
      cmp  #$31                         
      beq  W81AF                        ; 1 - set 1st color (multi-color mode)
      cmp  #$32                         
      beq  W81B2                        ; 2 - set 2nd color (multi-color mode)
      cmp  #$33                         
      beq  W81B5                        ; 3 - set 3rd color (multi-color mode)
      cmp  #$93                         
      beq  W81C7                        ; clr - clear screen
      cmp  #$49                         
      beq  W81BB                        ; i - invert char
      cmp  #$54                         
      beq  W81BE                        ; t - transfer char to cursor pos.
      cmp  #$53                         
      beq  W81C1                        ; s - save charset
      cmp  #$4C                         
      beq  W81C4                        ; l - load charset
      cmp  #$85                         
      beq  W81CA                        ; f1 - select char right
      cmp  #$86                         
      beq  W81CD                        ; f3 - select char left
      cmp  #$88                         
      beq  W81D3                        ; f7 - select char down
      cmp  #$87                         
      beq  W81D6                        ; f5 - select char up
      cmp  #$CF                         
      beq  W81D0                        
      jmp  W8119                        

W817F:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W817F                        
      cmp  #$A9                         
      bne  W811C                        
      lda  #$00                         
      sta  $FD                          
      jsr  W86FF                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W819A:
      jmp  W8231                        

W819D:
      jmp  W8313                        

W81A0:
      jmp  W851A                        

W81A3:
      jmp  W81D9                        

W81A6:
      jmp  W81E7                        

W81A9:
      jmp  W81FA                        

W81AC:
      jmp  W8217                        

W81AF:
      jmp  W823C                        

W81B2:
      jmp  W8264                        

W81B5:
      jmp  W8286                        

W81B8:
      jmp  W82B4                        

W81BB:
      jmp  W834E                        

W81BE:
      jmp  W8365                        

W81C1:
      jmp  W83C8                        

W81C4:
      jmp  W8415                        

W81C7:
      jmp  W82FE                        

W81CA:
      jmp  W8460                        

W81CD:
      jmp  W84B9                        

W81D0:
      jmp  W84FC                        

W81D3:
      jmp  W85A8                        

W81D6:
      jmp  W85C2                        

W81D9:
      jsr  W891F                        
W81DC:
      dec  W8230                        
      bmi  W81EA                        
      jsr  W88AE                        
      jmp  W8119                        

W81E7:
      jsr  W891F                        
W81EA:
      inc  W8230                        
      lda  W8230                        
      cmp  #$08                         
      beq  W81DC                        
      jsr  W88AE                        
      jmp  W8119                        

W81FA:
      jsr  W891F                        
W81FD:
      lda  W864C                        
      and  #$10                         
      beq  W8207                        
      inc  W822F                        
W8207:
      inc  W822F                        
      lda  W822F                        
      cmp  #$08                         
      beq  W821A                        
      jsr  W88AE                        
      jmp  W8119                        

W8217:
      jsr  W891F                        
W821A:
      lda  W864C                        
      and  #$10                         
      beq  W8224                        
      dec  W822F                        
W8224:
      dec  W822F                        
      bmi  W81FD                        
      jsr  W88AE                        
      jmp  W8119                        

W822F:
      .byte $00
W8230:
      .byte $00
W8231:
      jsr  W8BF2                        
      lda  #$00                         
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      jmp  draw_menu                        

W823C:
      ldx  W864E                        
      lda  W864C                        
      and  #$10                         
      beq  W824C                        
      txa                               
      sec                               
      sbc  #$08                         
      tax                               
      sec                               
W824C:
      stx  W82A8                        
      lda  #$16                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$93                         
      ldx  #$8D                         
      jsr  W85D9                        
W8261:
      jmp  W8119                        

W8264:
      lda  W864C                        
      and  #$10                         
      beq  W8261                        
      lda  W864F                        
      sta  W82A8                        
      lda  #$16                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$9E                         
      ldx  #$8D                         
      jsr  W85D9                        
      jmp  W8119                        

W8286:
      lda  W864C                        
      and  #$10                         
      beq  W8261                        
      lda  W8650                        
      sta  W82A8                        
      lda  #$16                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$A9                         
      ldx  #$8D                         
      jsr  W85D9                        
      jmp  W8119                        

W82A8:
      brk                               
W82A9:
      lda  #$02                         
      ldx  #$10                         
      ldy  W8843                        
      jsr  W86B0                        
      rts                               

W82B4:
      jsr  W891F                        
      jsr  W88FB                        
      ldy  #$00                         
      lda  W864C                        
      and  #$10                         
      beq  W82CF                        
      lda  ($FB),y                      ; Free 0 page for user program
      eor  #$80                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  W82A8                        
      sta  ($FD),y                      
      iny                               
W82CF:
      lda  ($FB),y                      ; Free 0 page for user program
      eor  #$80                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  W82A8                        
      sta  ($FD),y                      
      jsr  W88AE                        
      jsr  W8A0D                        
      jmp  W8119                        

W82E3:
      lda  W8843                        
      ldx  #$03                         
      ldy  #$00                         
W82EA:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W82EA                        
      clc                               
      adc  #$00                         
      sta  $FD                          
      tya                               
      adc  #$08                         
      sta  $FE                          ; Free 0 page for user program
      rts                               

W82FE:
      jsr  W82E3                        
      ldy  #$07                         
      lda  #$00                         
W8305:
      sta  ($FD),y                      
      dey                               
      bpl  W8305                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W8313:
      jsr  W891F                        
      lda  W864C                        
      eor  #$10                         
      sta  W864C                        
      jsr  W8682                        
      lda  #$00                         
      sta  W822F                        
      lda  W864C                        
      and  #$10                         
      beq  W8339                        
      lda  W864E                        
      cmp  #$08                         
      bcs  W8339                        
      lda  #$08                         
      sta  W864E                        
W8339:
      jsr  W86CC                        
      lda  W864E                        
      sta  W82A8                        
      jsr  W8869                        
      jsr  W88AE                        
      jsr  W86A2                        
      jmp  W823C                        

W834E:
      jsr  W82E3                        
      ldy  #$07                         
W8353:
      lda  ($FD),y                      
      eor  #$FF                         
      sta  ($FD),y                      
      dey                               
      bpl  W8353                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W8365:
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$0A                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$B4                         
      ldx  #$8D                         
      jsr  W85D9                        
      ldy  W8843                        
      lda  #$0A                         
      ldx  #$20                         
      jsr  W86B0                        
      lda  #$0A                         
      ldx  #$19                         
      jsr  W880E                        
      ldy  W87E4                        
      lda  W8843                        
      pha                               
      sty  W8843                        
      jsr  W82E3                        
      lda  $FD                          
      ldx  $FE                          ; Free 0 page for user program
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      pla                               
      sta  W8843                        
      jsr  W82E3                        
      ldy  #$07                         
W83A6:
      lda  ($FB),y                      ; Free 0 page for user program
      sta  ($FD),y                      
      dey                               
      bpl  W83A6                        
      jsr  W8869                        
      jsr  W88AE                        
      lda  #$0A                         
      sta  $D6                          ; Cursor line number
      lda  #$0B                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$CB                         
      ldx  #$8D                         
      jsr  W85D9                        
      jmp  W8119                        

W83C8:
      lda  #$0C                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$E5                         
      ldx  #$8D                         
      jsr  W85D9                        
      lda  #$12                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      sta  W8739                        
      jsr  W873A                        
      bcs  W8400                        
      jsr  W8BF2                        
      lda  #$00                         
      ldx  #$08                         
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      lda  #$00                         
      ldx  #$10                         
      jsr  W8A49                        
      jsr  W8652+2                      
W8400:
      lda  #$0C                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$0F                         
      ldx  #$8E                         
      jsr  W85D9                        
      jmp  W8119                        

W8415:
      lda  #$0C                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$FA                         
      ldx  #$8D                         
      jsr  W85D9                        
      lda  #$12                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      sta  W8739                        
      jsr  W873A                        
      bcs  W8445                        
      jsr  W8BF2                        
      lda  #$00                         
      ldx  #$08                         
      jsr  W8B97                        
      jsr  W8652+2                      
W8445:
      lda  #$0C                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$0F                         
      ldx  #$8E                         
      jsr  W85D9                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W8460:
      inc  W8843                        
      beq  W84B3                        
      lda  W8C47                        
      beq  W8484                        
      lda  W8C45                        
      cmp  #$4F                         
      bcc  W8484                        
      clc                               
      lda  W8C46                        
      adc  #$08                         
      sta  W8C46                        
      lda  #$0F                         
      sta  W8C45                        
      lda  #$00                         
      sta  W8C47                        
W8484:
      clc                               
      lda  W8C45                        
      adc  #$08                         
      sta  W8C45                        
      lda  W8C47                        
      adc  #$00                         
      sta  W8C47                        
W8495:
      lda  W8C45                        
      ldx  W8C46                        
      ldy  W8C47                        
      sta  $D000                        ; Position X sprite 0
      stx  $D001                        ; Position Y sprite 0
      sty  $D010                        ; Position X MSB sprites 0..7
      jsr  W82A9                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W84B3:
      dec  W8843                        
      jmp  W8119                        

W84B9:
      dec  W8843                        
      lda  W8843                        
      cmp  #$FF                         
      beq  W84F6                        
      lda  W8C47                        
      bne  W84E2                        
      lda  W8C45                        
      cmp  #$17                         
      bne  W84E2                        
      lda  W8C46                        
      sec                               
      sbc  #$08                         
      sta  W8C46                        
      lda  #$57                         
      sta  W8C45                        
      lda  #$01                         
      sta  W8C47                        
W84E2:
      sec                               
      lda  W8C45                        
      sbc  #$08                         
      sta  W8C45                        
      lda  W8C47                        
      sbc  #$00                         
      sta  W8C47                        
      jmp  W8495                        

W84F6:
      inc  W8843                        
      jmp  W8119                        

W84FC:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W84FC                        
      cmp  #$A9                         
      beq  W850A                        
      jmp  W811C                        

W850A:
      lda  #$08                         
      sta  $FD                          
      jsr  W86FF                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W8119                        

W851A:
      lda  #$04                         
      ldx  #$16                         
      jsr  W880E                        
      bcs  W852D                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W851A                        
      sta  W8651                        
W852D:
      jsr  W86CC                        
W8530:
      lda  #$05                         
      ldx  #$16                         
      jsr  W880E                        
      bcs  W8543                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W8530                        
      sta  W8652                        
W8543:
      jsr  W86CC                        
W8546:
      lda  #$06                         
      ldx  #$16                         
      jsr  W880E                        
      bcs  W8567                        
      lda  W864C                        
      and  #$10                         
      beq  W855D                        
      lda  W87E4                        
      cmp  #$08                         
      bcc  W8546                        
W855D:
      lda  W87E4                        
      cmp  #$10                         
      bcs  W8546                        
      sta  W864E                        
W8567:
      jsr  W86CC                        
      jsr  W86A2                        
W856D:
      lda  #$07                         
      ldx  #$16                         
      jsr  W880E                        
      bcs  W8580                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W856D                        
      sta  W864F                        
W8580:
      jsr  W86CC                        
W8583:
      lda  #$08                         
      ldx  #$16                         
      jsr  W880E                        
      bcs  W8596                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W8583                        
      sta  W8650                        
W8596:
      jsr  W86CC                        
      lda  W864E                        
      sta  W82A8                        
      jsr  W8869                        
      jsr  W88AE                        
      jmp  W823C                        

W85A8:
      lda  W8843                        
      clc                               
      adc  #$28                         
      bcs  W85BF                        
      sta  W8843                        
      lda  W8C46                        
      clc                               
      adc  #$08                         
      sta  W8C46                        
      jmp  W8495                        

W85BF:
      jmp  W8119                        

W85C2:
      lda  W8843                        
      sec                               
      sbc  #$28                         
      bcc  W85BF                        
      sta  W8843                        
      lda  W8C46                        
      sec                               
      sbc  #$08                         
      sta  W8C46                        
      jmp  W8495                        

W85D9:
      sta  W85E1+1                      
      stx  W85E1+2                      
      ldx  #$00                         
W85E1:
      lda  W8E8C,x                      
      beq  W85ED                        
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      inx                               
      jmp  W85E1                        

W85ED:
      lda  W85E1+1                      
      ldx  W85E1+2                      
      rts                               

      lda  $D019                        ; Interrupt indicator register
      sta  $D019                        ; Interrupt indicator register
      lda  $D012                        ; Reading/Writing IRQ balance value
      cmp  #$E2                         
      bcs  W862D                        
      lda  W864D                        
      sta  $D018                        ; VIC memory control register
      lda  W864C                        
      sta  $D016                        ; VIC control register
      lda  W864F                        
      sta  $D022                        ; Background 1 color
      lda  W8650                        
      sta  $D023                        ; Background 2 color
      lda  #$E2                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      lda  W8651                        
      sta  $D020                        ; Border color
      lda  W8652                        
      sta  $D021                        ; Background 0 color
      jmp  $FEBC                        ; Restores cpu registers and goes out from interrupt

W862D:
      lda  #$00                         
      sta  $D020                        ; Border color
      lda  #$0F                         
      sta  $D021                        ; Background 0 color
      lda  #$C8                         
      sta  $D016                        ; VIC control register
      lda  #$15                         
      sta  $D018                        ; VIC memory control register
      lda  #$A9                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      inc  $D027                        ; Color sprite 0
      jmp  $EA31                        ; Default hardware interrupt (IRQ)

W864C:
  .byte $C8
W864D:
  .byte $12
W864E:
  .byte $00
W864F:
  .byte $0C
W8650:
  .byte $0B
W8651:
  .byte $0F
W8652:
  .byte $0F, $00
W8654:
      sei                               
      lda  $DC0D                        ; Interrupt control register CIA #1
      and  #$7F                         
      ora  #$01                         
      sta  $DC0D                        ; Interrupt control register CIA #1
      lda  #$A9                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      lda  $D011                        ; VIC control register
      and  #$7F                         
      sta  $D011                        ; VIC control register
      lda  #$81                         
      sta  $D01A                        ; IRQ mask register
      lda  #$F4                         
      ldx  #$85                         
      sta  $0314                        ; Vector: Hardware Interrupt (IRQ)
      stx  $0315                        ; Vector: Hardware Interrupt (IRQ)
      cli                               
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      rts                               

W8682:
      lda  #$07                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  W864C                        
      and  #$10                         
      bne  W869B                        
      lda  #$63                         
      ldx  #$8D                         
      jmp  W85D9                        

W869B:
      lda  #$6C                         
      ldx  #$8D                         
      jmp  W85D9                        

W86A2:
      ldx  #$00                         
      sei                               
      lda  W864E                        
W86A8:
      sta  $DA58,x                      ; Color RAM
      inx                               
      bne  W86A8                        
      cli                               
      rts                               

W86B0:
      sta  $D6                          ; Cursor line number
      stx  $D3                          ; Column of cursor on the current line
      jsr  $b3A2                        ; Routine: Convert the byte in Y to Floating Point
      jsr  $bDDD                        ; Routine: Convert Floating Point to PETSCII string which starts (YA) with $0100 and ends with $00
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$01                         
      ldx  #$01                         
      jsr  W85D9                        
      lda  #$8F                         
      ldx  #$8D                         
      jsr  W85D9                        
      rts                               

W86CC:
      ldy  W8651                        
      lda  #$04                         
      ldx  #$16                         
      jsr  W86B0                        
      ldy  W8652                        
      lda  #$05                         
      ldx  #$16                         
      jsr  W86B0                        
      ldy  W864E                        
      lda  #$06                         
      ldx  #$16                         
      jsr  W86B0                        
      ldy  W864F                        
      lda  #$07                         
      ldx  #$16                         
      jsr  W86B0                        
      ldy  W8650                        
      lda  #$08                         
      ldx  #$16                         
      jsr  W86B0                        
      rts                               

W86FF:
      ldx  #$00                         
      lda  #$D0                         
      clc                               
      adc  $FD                          
      stx  $FB                          ; Free 0 page for user program
      sta  $FC                          
      lda  #$00                         
      ldx  #$08                         
      sta  $FD                          
      stx  $FE                          ; Free 0 page for user program
      sei                               
      lda  #$33                         
      sta  $01                          ; 6510 I/O register
      ldx  #$08                         
      ldy  #$00                         
W871B:
      lda  ($FB),y                      ; Free 0 page for user program
      sta  ($FD),y                      
      iny                               
      bne  W871B                        
      inc  $FC                          
      inc  $FE                          ; Free 0 page for user program
      dex                               
      bne  W871B                        
      lda  #$37                         
      sta  $01                          ; 6510 I/O register
      cli                               
      rts                               

W872F:
      ldx  #$00                         
W8731:
      txa                               
      sta  $0658,x                      ; Video matrix (25*40)
      inx                               
      bne  W8731                        
      rts                               

W8739:
      plp                               
W873A:
      ldx  #$00                         
W873C:
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      inx                               
      cpx  W8739                        
      bne  W873C                        
      ldx  #$00                         
W8749:
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      inx                               
      cpx  W8739                        
      bne  W8749                        
      lda  #$00                         
      sta  W880B+2                      
W8759:
      lda  #$AF                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
W8763:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W8763                        
      cmp  #$0D                         
      beq  W87C9                        ; ret
      ldx  W880B+2                      
      cmp  #$91                         
      beq  W8763                        
      cmp  #$11                         
      beq  W8763                        
      cmp  #$1D                         
      beq  W8763                        
      cmp  #$9D                         
      beq  W8763                        
      cmp  #$13                         
      beq  W8763                        
      cmp  #$93                         
      beq  W8763                        
      cmp  #$94                         
      beq  W8763                        
      cmp  #$14                         
      beq  W87A3                        
      cpx  W8739                        
      bcs  W8763                        
      sta  W87E4,x                      
      inx                               
      stx  W880B+2                      
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  W8759                        

W87A3:
      lda  W880B+2                      
      cmp  #$00                         
      beq  W8763                        
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      dec  W880B+2                      
      jmp  W8759                        

W87C9:
      lda  #$00                         
      ldx  W880B+2                      
      sta  W87E4,x                      
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  W880B+2                      
      bne  W87E2                        
      sec                               
      rts                               

W87E2:
      clc                               
      rts                               

W87E4:
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
      jsr  $2020                        
W880B:
      jsr  $0020                        ; Transient strings stack
W880E:
      sta  $D6                          ; Cursor line number
      stx  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$03                         
      sta  W8739                        
      jsr  W873A                        
      bcs  W8842                        
      lda  $7A                          ; CHRGET (Introduce a char) subroutine
      pha                               
      lda  $7B                          ; CHRGET (Introduce a char) subroutine
      pha                               
      lda  #$E4                         
      ldx  #$87                         
      sta  $7A                          ; CHRGET (Introduce a char) subroutine
      stx  $7B                          ; CHRGET (Introduce a char) subroutine
      lda  W87E4                        
      jsr  $bCF3                        ; BASIC ROM
      jsr  $bC9B                        ; Routine: Convert Floating Point to 4-byte integer
      lda  $65                          ; Floating point accumulator #1: Mantissa
      sta  W87E4                        
      pla                               
      sta  $7B                          ; CHRGET (Introduce a char) subroutine
      pla                               
      sta  $7A                          ; CHRGET (Introduce a char) subroutine
      clc                               
W8842:
      rts                               

W8843:
      brk                               
W8844:
      ldx  #$07                         
W8846:
      asl                               
      pha                               
      bcc  W8855                        
      lda  W82A8                        
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
W8855:
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      pla                               
      dex                               
      bpl  W8846                        
      lda  #$00                         
      sta  $0286                        ; Current char color code
      rts                               

W8869:
      lda  #$02                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      jsr  W82E3                        
      lda  $FD                          
      sta  $FB                          ; Free 0 page for user program
      lda  $FE                          ; Free 0 page for user program
      sta  $FC                          
      ldy  #$00                         
W8881:
      lda  W864C                        
      and  #$10                         
      beq  W8890                        
      lda  ($FB),y                      ; Free 0 page for user program
      jsr  W8954                        
      jmp  W8895                        

W8890:
      lda  ($FB),y                      ; Free 0 page for user program
      jsr  W8844                        
W8895:
      iny                               
      inc  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      tya                               
      pha                               
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      pla                               
      tay                               
      cpy  #$08                         
      bne  W8881                        
      lda  W8843                        
      sta  $0465                        ; Video matrix (25*40)
      rts                               

W88AE:
      jsr  W88FB                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      cmp  #$2A                         
      beq  W88D1                        
      cmp  #$AA                         
      beq  W88D1                        
      cmp  #$20                         
      beq  W88E2                        
      lda  #$AA                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  W864C                        
      and  #$10                         
      beq  W88D1                        
      lda  #$AA                         
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
W88D1:
      rts                               

W88D2:
  .byte $50, $04, $78, $04, $A0, $04
W88D8:
  .byte $C8, $04, $F0, $04, $18, $05, $40, $05
W88E0:
  .byte $68, $05
W88E2:
      lda  #$2A                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  #$00                         
      sta  ($FD),y                      
      lda  W864C                        
      and  #$10                         
      beq  W88D1                        
      lda  #$2A                         
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      lda  #$00                         
      sta  ($FD),y                      
      rts                               

W88FB:
      lda  W8230                        
      asl                               
      tax                               
      lda  W88D2,x                      
      sta  $FB                          ; Free 0 page for user program
      inx                               
      lda  W88D2,x                      
      sta  $FC                          
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W822F                        
      sta  $FB                          ; Free 0 page for user program
      clc                               
      adc  #$00                         
      sta  $FD                          
      lda  $FC                          
      adc  #$D4                         
      sta  $FE                          ; Free 0 page for user program
      rts                               

W891F:
      jsr  W88FB                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      cmp  #$A0                         
      beq  W8942                        
      cmp  #$20                         
      beq  W8942                        
      cmp  #$AA                         
      beq  W8943                        
      lda  #$20                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  W864C                        
      and  #$10                         
      beq  W8942                        
      iny                               
      lda  #$20                         
      sta  ($FB),y                      ; Free 0 page for user program
W8942:
      rts                               

W8943:
      lda  #$A0                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  W864C                        
      and  #$10                         
      beq  W8942                        
      lda  #$A0                         
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

W8954:
      ldx  #$04                         
W8956:
      asl                               
      bcs  W8981                        
      asl                               
      pha                               
      bcc  W8968                        
      lda  W864F                        
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
W8968:
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      pla                               
      dex                               
      bne  W8956                        
      lda  #$00                         
      sta  $0286                        ; Current char color code
      rts                               

W8981:
      asl                               
      pha                               
      bcs  W8993                        
      lda  W8650                        
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  W8968                        

W8993:
      lda  W864E                        
      sec                               
      sbc  #$08                         
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  W8968                        

W89A4:
      ldy  #$00                         
      lda  #$00                         
W89A8:
      pha                               
      lda  ($FB),y                      ; Free 0 page for user program
      cmp  #$A0                         
      pla                               
      rol                               
      iny                               
      cpy  #$08                         
      bne  W89A8                        
      rts                               

W89B5:
      ldy  #$00                         
      lda  #$00                         
      pha                               
W89BA:
      lda  ($FB),y                      ; Free 0 page for user program
      bpl  W89EF                        
      clc                               
      lda  $FC                          
      adc  #$D4                         
      sta  $FC                          
      lda  ($FB),y                      ; Free 0 page for user program
      and  #$0F                         
      cmp  W864F                        
      beq  W89E7                        
      cmp  W8650                        
      beq  W89F8                        
      clc                               
      adc  #$08                         
      cmp  W864E                        
      beq  W89DF                        
      sty  $02A7                        ; Not used
      brk                               
W89DF:
      pla                               
      sec                               
      rol                               
      sec                               
      rol                               
      jmp  W89FD                        

W89E7:
      pla                               
      clc                               
      rol                               
      sec                               
      rol                               
      jmp  W89FD                        

W89EF:
      pla                               
      clc                               
      rol                               
      clc                               
      rol                               
      pha                               
      jmp  W8A05                        

W89F8:
      pla                               
      sec                               
      rol                               
      clc                               
      rol                               
W89FD:
      pha                               
      sec                               
      lda  $FC                          
      sbc  #$D4                         
      sta  $FC                          
W8A05:
      iny                               
      iny                               
      cpy  #$08                         
      bne  W89BA                        
      pla                               
      rts                               

W8A0D:
      jsr  W82E3                        
      lda  #$50                         
      ldx  #$04                         
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  #$08                         
W8A1A:
      lda  W864C                        
      and  #$10                         
      beq  W8A2B                        
      jsr  W89B5                        
      ldy  #$00                         
      sta  ($FD),y                      
      jmp  W8A32                        

W8A2B:
      jsr  W89A4                        
      ldy  #$00                         
      sta  ($FD),y                      
W8A32:
      inc  $FD                          
      bne  W8A38                        
      inc  $FE                          ; Free 0 page for user program
W8A38:
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  #$28                         
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  #$00                         
      sta  $FC                          
      dex                               
      bne  W8A1A                        
      rts                               

W8A49:
      sei                               
      sta  $8A6B                        
      stx  $8A6D                        
      lda  $9D                          ; Flag: 80=direct mode 00=program mode
      pha                               
      lda  #$00                         
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  #$01                         
      ldx  fa
      ldy  #$01                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      ldx  #$E4                         
      ldy  #$87                         
      lda  W880B+2                      
      jsr  $FFBD                        ; Routine: Set file name
      ldx  #$FF                         
      ldy  #$FF                         
      lda  #$FB                         
      jsr  $FFD8                        ; Routine: Save the Ram to a device
      pla                               
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  #$0F                         
      ldx  fa                         
      ldy  #$0F                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  #$00                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$0F                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$30                         
      bne  W8A9D                        
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$0F                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      cli                               
      rts                               

W8A9D:
      cmp  #$36                         
      beq  W8AF8                        
W8AA1:
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$2C                         
      bne  W8AA1                        
      ldx  #$00                         
W8AAA:
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$0D                         
      beq  W8AB8                        
      sta  W87E4,x                      
      inx                               
      jmp  W8AAA                        

W8AB8:
      inx                               
      lda  #$00                         
      sta  W87E4,x                      
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      lda  #$0F                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      cli                               
      lda  #$0D                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$E4                         
      ldx  #$87                         
      jsr  W85D9                        
W8ADE:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W8ADE                        
      lda  #$0D                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$0F                         
      ldx  #$8E                         
      jsr  W85D9                        
      rts                               

W8AF8:
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$33                         
      beq  W8B0B                        
      ldx  #$00                         
      cmp  #$2C                         
      beq  W8AAA                        
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jmp  W8AAA                        

W8B0B:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      lda  #$0F                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      cli                               
      lda  #$0D                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$37                         
      ldx  #$8E                         
      jsr  W85D9                        
W8B2B:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W8B2B                        
      cmp  #$59                         
      beq  W8B45                        
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$0F                         
      ldx  #$8E                         
      jsr  W85D9                        
      rts                               

W8B45:
      lda  #$0F                         
      ldx  fa                         
      ldy  #$0F                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  #$00                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$0F                         
      jsr  $FFC9                        ; Routine: Open an output canal
      lda  #$53                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      lda  #$3A                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      ldx  #$00                         
W8B67:
      lda  W87E4,x                      
      beq  W8B73                        
      jsr  $FFD2                        ; Routine: Send a char in the channel
      inx                               
      jmp  W8B67                        

W8B73:
      lda  #$0D                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$0F                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$0F                         
      ldx  #$8E                         
      jsr  W85D9                        
      lda  $8A6B                        
      ldx  $8A6D                        
      jmp  W8A49                        

W8B97:
      sei                               
      sta  $8BBB                        
      stx  $8BBD                        
      lda  $9D                          ; Flag: 80=direct mode 00=program mode
      pha                               
      lda  #$00                         
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  #$01                         
      ldx  fa                         
      ldy  #$00                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      ldx  #$E4                         
      ldy  #$87                         
      lda  W880B+2                      
      jsr  $FFBD                        ; Routine: Set file name
      lda  #$00                         
      ldx  #$FF                         
      ldy  #$FF                         
      jsr  $FFD5                        ; Routine: Load the Ram from a device
      stx  $FB                          ; Free 0 page for user program
      sty  $FC                          
      pla                               
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  #$0F                         
      ldx  fa                         
      ldy  #$0F                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  #$00                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$0F                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$30                         
      bne  W8BEF                        
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$0F                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      cli                               
      rts                               

W8BEF:
      jmp  W8A9D                        

W8BF2:
      sei                               
      lda  #$04                         
      ldx  #$8C                         
      sta  $0314                        ; Vector: Hardware Interrupt (IRQ)
      stx  $0315                        ; Vector: Hardware Interrupt (IRQ)
      cli                               
      lda  #$00                         
      sta  $D015                        ; Sprites Abilitator
      rts                               

      lda  $D019                        ; Interrupt indicator register
      sta  $D019                        ; Interrupt indicator register
      jmp  $EA31                        ; Default hardware interrupt (IRQ)

      jmp  $EA31                        ; Default hardware interrupt (IRQ)

      jmp  $EA31                        ; Default hardware interrupt (IRQ)

      jmp  $EA31                        ; Default hardware interrupt (IRQ)

      nop                               
      nop                               
W8C18:
      ldx  #$3F                         
W8C1A:
      lda  W8EB5,x                      
      sta  $0340,x                      ; Tape I/O buffer
      dex                               
      bpl  W8C1A                        
      lda  #$0D                         
      sta  $07F8                        ; Pointer to data sprites
      lda  #$01                         
      sta  $D027                        ; Color sprite 0
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      lda  W8C45                        
      ldx  W8C46                        
      ldy  W8C47                        
      sta  $D000                        ; Position X sprite 0
      stx  $D001                        ; Position Y sprite 0
      sty  $D010                        ; Position X MSB sprites 0..7
      rts                               

W8C45:
  .byte $17
W8C46:
  .byte $A9
W8C47:
  .byte $00, $93, $12, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20
  .byte "MENUE"
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $0D, $00, $11, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte "1) CHARACTER-EDITOR" 
  .byte $0D, $00, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20
  .byte "2) SCREEN-EDITOR" 
  .byte $0D, $00, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte "3) SPRITE-EDITOR"
  .byte $0D, $00, $93, $12, $53, $54, $41, $54
  .byte $55, $53, $3A, $20, $20, $20, $20, $20
  .byte $20, $2D, $43, $4F, $4C, $4F, $52, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $00, $12, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $11
  .byte $9D, $20, $11, $9D, $20, $11, $9D, $20
  .byte $11, $9D, $20, $11, $9D, $20, $11, $9D
  .byte $20, $11, $9D, $20, $11, $9D, $20, $0D
  .byte $12, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $92, $00, $43, $4F, $44, $45
  .byte $3A, $00, $42, $4F, $52, $44, $45, $52
  .byte $20, $20, $20, $3A, $00, $53, $43, $52
  .byte $45, $45, $4E, $20, $20, $20, $3A, $00
  .byte $43, $4F, $4C, $4F, $52, $20, $23, $31
  .byte $20, $3A, $00, $43, $4F, $4C, $4F, $52
  .byte $20, $23, $32, $20, $3A, $00, $43, $4F
  .byte $4C, $4F, $52, $20, $23, $33, $20, $3A
  .byte $00, $12, $53, $49, $4E, $47, $4C, $45
  .byte $92, $00, $12, $4D, $55, $4C, $54, $49
  .byte $20, $92, $00, $12, $49, $4E, $50, $55
  .byte $54, $2D, $4D, $4F, $44, $45, $92, $00
  .byte $12, $45, $44, $49, $54, $2D, $4D, $4F
  .byte $44, $45, $20, $92, $00, $20, $20, $00
  .byte $00, $12, $43, $4F, $4C, $4F, $52, $20
  .byte $23, $31, $92, $00, $12, $43, $4F, $4C
  .byte $4F, $52, $20, $23, $32, $92, $00, $12
  .byte $43, $4F, $4C, $4F, $52, $20, $23, $33
  .byte $92, $00, $20, $20, $20, $20, $54, $52
  .byte $41, $4E, $53, $46, $45, $52, $20, $20
  .byte $20, $20, $20, $20, $54, $4F, $20, $20
  .byte $00, $20, $20, $20
W8DCE:
  .byte $20
W8DCF:
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $00, $12, $20
  .byte $53, $41, $56, $45, $20, $92, $20, $20
  .byte $46, $49, $4C, $45, $4E, $41, $4D, $45
  .byte $20, $3A, $00, $12, $20, $4C, $4F, $41
  .byte $44, $20, $92, $20, $20, $46, $49, $4C
  .byte $45, $4E, $41, $4D, $45, $20, $3A, $00
  .byte $92, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $00
  .byte $46, $49, $4C, $45, $20, $45, $58, $49
  .byte $53, $54, $53, $20, $21, $20, $52, $45
  .byte $50, $4C, $41, $43, $45, $20, $3F, $20
  .byte $20, $28, $59, $2F, $4E, $29, $00, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20
  .byte "4) DIRECTORY" 
  .byte $0D, $00, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20
  .byte "5) FLOPPY-COMMANDS"
W8E8A:
  .byte $0D, $00
W8E8C:
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20
  .byte "7) RESET" 
  .byte $00, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20
  .byte "6) DRIVE 8"
  .byte $0D, $00
W8EB5:
  .byte $FF, $C0, $00, $80, $40, $00, $80, $40
  .byte $00, $80, $40, $00, $80, $40, $00, $80
  .byte $40, $00, $80, $40, $00, $80, $40, $00
  .byte $80, $40, $00, $FF, $C0, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00
      lda  #$93                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$A9                         
      ldx  #$9D                         
      jsr  W85D9                        
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      inc  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$CD                         
      ldx  #$9D                         
      jsr  W85D9                        
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      inc  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$F1                         
      ldx  #$9D                         
      jsr  W85D9                        
      lda  #$0E                         
      sta  $D3                          ; Column of cursor on the current line
      inc  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$11                         
      ldx  #$9E                         
      jsr  W85D9                        
      lda  #$80                         
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      jsr  W8FEA                        
      jsr  W953C                        
      jsr  W9597                        
      jsr  W94BB                        
      jsr  W95CD                        
      jsr  W8C18                        
      ldx  #$59                         
      lda  #$17                         
      sta  $D000                        ; Position X sprite 0
      stx  $D001                        ; Position Y sprite 0
      lda  #$00                         
      sta  W9066                        
      lda  #$05                         
      sta  W9067                        
      jsr  W9651                        
      jsr  W9672                        
      jsr  W9BA7                        
;------------------------- 
; Screen editor input loop
;------------------------- 
W8F6F:
      lda  $028D                        ; Flag: Key SHIFT/CTRL/Commodore
      cmp  #$04                         
      beq  W8FB1                        
      lda  W9671                        
      beq  W8FD8                        
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W8F6F                        
W8F82:
      cmp  #$51                         
      beq  W8FC6                        
      cmp  #$4D                         
      beq  W8FC9                        
      cmp  #$43                         
      beq  W8FCC                        
      cmp  #$45                         
      beq  W8FCF                        
      cmp  #$42                         
      beq  W8FD2                        
      cmp  #$53                         
      beq  W8FD5                        
      cmp  #$4C                         
      beq  W8FDB                        
      cmp  #$46                         
      beq  W8FDE                        
      cmp  #$50                         
      beq  W8FE1                        
      cmp  #$3C                         
      beq  W8FE4                        
      cmp  #$3E                         
      beq  W8FE7                        
      jmp  W8F6F                        

W8FB1:
      lda  W9671                        
      eor  #$01                         
      sta  W9671                        
      jsr  W9651                        
W8FBC:
      lda  $028D                        ; Flag: Key SHIFT/CTRL/Commodore
      bne  W8FBC                        
      sta  $C6                          ; Number of char in keyboard buffer
      jmp  W8F6F                        

W8FC6:
      jmp  W900C                        

W8FC9:
      jmp  W9195                        

W8FCC:
      jmp  W91A3                        

W8FCF:
      jmp  W9217                        

W8FD2:
      jmp  W9254                        

W8FD5:
      jmp  W92F3                        

W8FD8:
      jmp  W906E                        

W8FDB:
      jmp  W938B                        

W8FDE:
      jmp  W940D                        

W8FE1:
      jmp  W9B94                        

W8FE4:
      jmp  W9459                        

W8FE7:
      jmp  W9D46+2                      

W8FEA:
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      lda  #$0E                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  W864C                        
      and  #$10                         
      beq  W9004                        
      lda  #$27                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W9004:
      lda  #$2E                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W900C:
      jsr  W8BF2                        
      lda  #$00                         
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      jmp  draw_menu                        

W9017:
      inc  W9066                        
      lda  W9066                        
      cmp  #$28                         
      beq  W902C                        
      jsr  W9625                        
      lda  W9BB8                        
      bne  W9068                        
      jmp  W8F6F                        

W902C:
      dec  W9066                        
      bmi  W9017                        
      jsr  W9625                        
      lda  W9BB8                        
      bne  W9068                        
      jmp  W8F6F                        

W903C:
      dec  W9067                        
      lda  W9067                        
      cmp  #$04                         
      beq  W9051                        
      jsr  W9625                        
      lda  W9BB8                        
      bne  W9068                        
      jmp  W8F6F                        

W9051:
      inc  W9067                        
      lda  W9067                        
      cmp  #$19                         
      beq  W903C                        
      jsr  W9625                        
      lda  W9BB8                        
      bne  W9068                        
      jmp  W8F6F                        

W9066:
  .byte $00
W9067:
  .byte $05
W9068:
      lda  W9BB9                        
      jmp  W92B1                        

W906E:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W90A8                        
      cmp  #$91                         
      beq  W90AB                        
      cmp  #$11                         
      beq  W90AE                        
      cmp  #$9D                         
      beq  W90B1                        
      cmp  #$1D                         
      beq  W90B4                        
      cmp  #$88                         
      beq  W90B7                        
      cmp  #$85                         
      beq  W90BA                        
      cmp  #$86                         
      beq  W90BD                        
      cmp  #$89                         
      beq  W90C0                        
      cmp  #$8A                         
      beq  W90C3                        
      cmp  #$87                         
      beq  W90C6                        
      cmp  #$93                         
      beq  W90A8                        
      cmp  #$94                         
      beq  W90A8                        
      jmp  W92B1                        

W90A8:
      jmp  W8F6F                        

W90AB:
      jmp  W903C                        

W90AE:
      jmp  W9051                        

W90B1:
      jmp  W902C                        

W90B4:
      jmp  W9017                        

W90B7:
      jmp  W90C9                        

W90BA:
      jmp  W90D7                        

W90BD:
      jmp  W90FD                        

W90C0:
      jmp  W9132                        

W90C3:
      jmp  W9164                        

W90C6:
      jmp  W944B                        

W90C9:
      lda  W9692                        
      eor  #$01                         
      sta  W9692                        
      jsr  W9672                        
      jmp  W8F6F                        

W90D7:
      lda  W95C6                        
      cmp  W95CA                        
      bne  W90EA                        
      lda  W95C5                        
      cmp  W95C7+2                      
      bne  W90EA                        
      jmp  W8F6F                        

W90EA:
      inc  W95C5                        
      bne  W90F2                        
      inc  W95C6                        
W90F2:
      jsr  W95CD                        
      lda  W9BB8                        
      bne  W9110                        
      jmp  W8F6F                        

W90FD:
      lda  W95C5                        
      clc                               
      adc  W95C6                        
      bne  W9116                        
      bcs  W9116                        
      lda  W9BB8                        
      bne  W9110                        
      jmp  W8F6F                        

W9110:
      lda  W9BB9                        
      jmp  W92B1                        

W9116:
      sec                               
      lda  W95C5                        
      sbc  #$01                         
      sta  W95C5                        
      lda  W95C6                        
      sbc  #$00                         
      sta  W95C6                        
      jsr  W95CD                        
      lda  W9BB8                        
      bne  W9110                        
      jmp  W8F6F                        

W9132:
      clc                               
      lda  W95C5                        
      adc  #$28                         
      sta  W95C5                        
      lda  W95C6                        
      adc  #$00                         
      sta  W95C6                        
      cmp  W95CA                        
      bcc  W915E                        
      bne  W9152                        
      lda  W95C5                        
      cmp  W95C7+2                      
      bcc  W915E                        
W9152:
      lda  W95C7+2                      
      ldx  W95CA                        
      sta  W95C5                        
      stx  W95C6                        
W915E:
      jsr  W95CD                        
      jmp  W8F6F                        

W9164:
      lda  W95C6                        
      bne  W917E                        
      lda  W95C5                        
      cmp  #$28                         
      bcs  W917E                        
      lda  #$00                         
      sta  W95C5                        
      sta  W95C6                        
      jsr  W95CD                        
      jmp  W8F6F                        

W917E:
      sec                               
      lda  W95C5                        
      sbc  #$28                         
      sta  W95C5                        
      lda  W95C6                        
      sbc  #$00                         
      sta  W95C6                        
      jsr  W95CD                        
      jmp  W8F6F                        

W9195:
      lda  W864C                        
      eor  #$10                         
      sta  W864C                        
      jsr  W8FEA                        
      jmp  W8F6F                        

W91A3:
      lda  #$01                         
      ldx  #$18                         
      jsr  W880E                        
      bcs  W91B9                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W91A3                        
      sta  W864E                        
      jsr  W9693                        
W91B9:
      jsr  W953C                        
W91BC:
      lda  #$02                         
      ldx  #$18                         
      jsr  W880E                        
      bcs  W91CF                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W91BC                        
      sta  W864F                        
W91CF:
      jsr  W953C                        
W91D2:
      lda  #$03                         
      ldx  #$18                         
      jsr  W880E                        
      bcs  W91E5                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W91D2                        
      sta  W8650                        
W91E5:
      jsr  W953C                        
W91E8:
      lda  #$00                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  W91FB                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W91E8                        
      sta  W8651                        
W91FB:
      jsr  W953C                        
W91FE:
      lda  #$01                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  W9211                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  W91FE                        
      sta  W8652                        
W9211:
      jsr  W953C                        
      jmp  W8F6F                        

W9217:
      lda  #$01                         
      ldx  #$08                         
      jsr  W96AD                        
      bcs  W9243                        
W9220:
      lda  W87E4                        
      cmp  #$28                         
      bcs  W922C                        
      lda  W87E4+1                      
      beq  W9243                        
W922C:
      sec                               
      lda  W87E4                        
      sta  W95C7                        
      sbc  #$28                         
      sta  W95C7+2                      
      lda  W87E4+1                      
      sta  W95C7+1                      
      sbc  #$00                         
      sta  W95CA                        
W9243:
      jsr  W9597                        
      lda  #$00                         
      sta  W95C5                        
      sta  W95C6                        
      jsr  W95CD                        
      jmp  W8F6F                        

W9254:
      lda  #$02                         
      ldx  #$08                         
      jsr  W96AD                        
      bcs  W9243                        
      lda  W87E4                        
      ldx  W87E4+1                      
      sta  W95CB                        
      stx  W95CC                        
      jmp  W9243                        

W926C:
      lda  W95CB                        
      ldx  W95CC                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  W9067                        
      dex                               
      dex                               
      dex                               
      dex                               
      dex                               
W927E:
      beq  W9293                        
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W95C7                        
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  W95C7+1                      
      sta  $FC                          
      dex                               
      jmp  W927E                        

W9293:
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W95C5                        
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  W95C6                        
      sta  $FC                          
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W9066                        
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  #$00                         
      sta  $FC                          
      rts                               

W92B1:
      tax                               
      stx  W9BB9                        
      lda  $0400                        ; Video matrix (25*40)
      pha                               
      lda  #$13                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      txa                               
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jsr  W926C                        
      lda  $0400                        ; Video matrix (25*40)
      cmp  #$22                         
      bne  W92DD                        
      lda  #$22                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$4F                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$22                         
W92DD:
      asl                               
      tax                               
      lda  W9692                        
      lsr                               
      txa                               
      ror                               
      ldy  #$00                         
      sta  ($FB),y                      ; Free 0 page for user program
      pla                               
      sta  $0400                        ; Video matrix (25*40)
      jsr  W95CD                        
      jmp  W8F6F                        

W92F3:
      jsr  W8BF2                        
      jsr  W96FB                        
      lda  #$04                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$58                         
      ldx  #$9E                         
      jsr  W85D9                        
      lda  #$10                         
      sta  W8739                        
      lda  #$11                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      jsr  W873A                        
      bcs  W9366                        
      lda  W95CB                        
      ldx  W95CC                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  #$14                         
W9328:
      beq  W933D                        
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W95C7                        
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  W95C7+1                      
      sta  $FC                          
      dex                               
      jmp  W9328                        

W933D:
      ldy  #$00                         
      lda  W95C7                        
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      lda  W95C7+1                      
      sta  ($FB),y                      ; Free 0 page for user program
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  #$02                         
      tay                               
      lda  $FC                          
      adc  #$00                         
      tax                               
      lda  W95CB                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95CC                        
      sta  $FC                          
      tya                               
      jsr  W8A49                        
      jsr  W9693                        
W9366:
      jsr  W94BB                        
      lda  #$0D                         
      sta  $07F8                        ; Pointer to data sprites
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      lda  #$04                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$6C                         
      ldx  #$9E                         
      jsr  W85D9                        
      jsr  W95CD                        
      jmp  W8F6F                        

W938B:
      jsr  W8BF2                        
      jsr  W96FB                        
      lda  #$04                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$90                         
      ldx  #$9E                         
      jsr  W85D9                        
      lda  #$10                         
      sta  W8739                        
      lda  #$11                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      jsr  W873A                        
      bcs  W93E8                        
      lda  W95CB                        
      ldx  W95CC                        
      jsr  W8B97                        
      sec                               
      lda  $FB                          ; Free 0 page for user program
      sbc  #$02                         
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      sbc  #$00                         
      sta  $FC                          
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      sta  W95C7                        
      sec                               
      sbc  #$28                         
      sta  W95C7+2                      
      iny                               
      lda  ($FB),y                      ; Free 0 page for user program
      sta  W95C7+1                      
      sbc  #$00                         
      sta  W95CA                        
      jsr  W9693                        
      jsr  W9597                        
W93E8:
      jsr  W94BB                        
      lda  #$0D                         
      sta  $07F8                        ; Pointer to data sprites
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      lda  #$04                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$6C                         
      ldx  #$9E                         
      jsr  W85D9                        
      jsr  W95CD                        
      jmp  W8F6F                        

W940D:
      lda  $028D                        ; Flag: Key SHIFT/CTRL/Commodore
      cmp  #$04                         
      beq  W9448                        
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W940D                        
      cmp  #$0D                         
      beq  W9422                        
      jmp  W8F82                        

W9422:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  W9422                        
      cmp  #$0D                         
      beq  W9448                        
      tax                               
      lda  $0400                        ; Video matrix (25*40)
      pha                               
      lda  #$13                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      txa                               
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  $0400                        ; Video matrix (25*40)
      jsr  W9714                        
      pla                               
      sta  $0400                        ; Video matrix (25*40)
      jsr  W95CD                        
W9448:
      jmp  W8F6F                        

W944B:
      lda  W9BB8                        
      eor  #$01                         
      sta  W9BB8                        
      jsr  W9BA7                        
      jmp  W8F6F                        

W9459:
      lda  #$01                         
      ldx  #$08                         
      jsr  W96AD                        
      bcs  W9480                        
      lda  W87E4                        
      cmp  #$28                         
      bcs  W946E                        
      lda  W87E4+1                      
      beq  W9480                        
W946E:
      lda  W87E4+1                      
      cmp  W95C7+1                      
      bcc  W9491                        
      bne  W9480                        
      lda  W87E4                        
      cmp  W95C7                        
      bcc  W9491                        
W9480:
      jsr  W9597                        
      lda  #$00                         
      sta  W95C5                        
      sta  W95C6                        
      jsr  W95CD                        
      jmp  W8F6F                        

W9491:
      lda  W95C7                        
      ldx  W95C7+1                      
      sta  W9C44                        
      stx  W9C44+1                      
      lda  W87E4                        
      ldx  W87E4+1                      
      sta  W95C7                        
      stx  W95C7+1                      
      sec                               
      sbc  #$28                         
      sta  W95C7+2                      
      txa                               
      sbc  #$00                         
      sta  W95CA                        
      jsr  W9BBA                        
      jmp  W9480                        

W94BB:
      sei                               
      lda  $DC0D                        ; Interrupt control register CIA #1
      and  #$7F                         
      ora  #$01                         
      sta  $DC0D                        ; Interrupt control register CIA #1
      lda  #$59                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      lda  $D011                        ; VIC control register
      and  #$7F                         
      sta  $D011                        ; VIC control register
      lda  #$81                         
      sta  $D01A                        ; IRQ mask register
      lda  #$E4                         
      ldx  #$94                         
      sta  $0314                        ; Vector: Hardware Interrupt (IRQ)
      stx  $0315                        ; Vector: Hardware Interrupt (IRQ)
      cli                               
      rts                               

      lda  $D019                        ; Interrupt indicator register
      sta  $D019                        ; Interrupt indicator register
      lda  $D012                        ; Reading/Writing IRQ balance value
      cmp  #$FA                         
      bcs  W951D                        
      lda  W8652                        
      sta  $D021                        ; Background 0 color
      lda  W864D                        
      sta  $D018                        ; VIC memory control register
      lda  W864C                        
      sta  $D016                        ; VIC control register
      lda  W8651                        
      sta  $D020                        ; Border color
      lda  W864F                        
      sta  $D022                        ; Background 1 color
      lda  W8650                        
      sta  $D023                        ; Background 2 color
      lda  #$FA                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      jmp  $FEBC                        ; Restores cpu registers and goes out from interrupt

W951D:
      lda  #$00                         
      sta  $D020                        ; Border color
      lda  #$0F                         
      sta  $D021                        ; Background 0 color
      lda  #$C8                         
      sta  $D016                        ; VIC control register
      lda  #$15                         
      sta  $D018                        ; VIC memory control register
      lda  #$59                         
      sta  $D012                        ; Reading/Writing IRQ balance value
      inc  $D027                        ; Color sprite 0
      jmp  $EA31                        ; Default hardware interrupt (IRQ)

W953C:
      ldy  W864E                        
      lda  #$01                         
      ldx  #$18                         
      jsr  W86B0                        
      ldy  W864F                        
      lda  #$02                         
      ldx  #$18                         
      jsr  W86B0                        
      ldy  W8650                        
      lda  #$03                         
      ldx  #$18                         
      jsr  W86B0                        
      ldy  W8651                        
      lda  #$00                         
      ldx  #$23                         
      jsr  W86B0                        
      ldy  W8652                        
      lda  #$01                         
      ldx  #$23                         
      jsr  W86B0                        
      jsr  W9693                        
      rts                               

W9572:
      stx  $D6                          ; Cursor line number
      sty  $D3                          ; Column of cursor on the current line
      sta  $62                          ; Floating point accumulator #1: Mantissa
      lda  $FB                          ; Free 0 page for user program
      sta  $63                          ; Floating point accumulator #1: Mantissa
      ldx  #$90                         
      sec                               
      jsr  $bC49                        ; BASIC ROM
      jsr  $bDDD                        ; Routine: Convert Floating Point to PETSCII string which starts (YA) with $0100 and ends with $00
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$35                         
      ldx  #$9E                         
      jsr  W85D9                        
      lda  #$01                         
      ldx  #$01                         
      jsr  W85D9                        
      rts                               

W9597:
      lda  W95C5                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95C6                        
      ldx  #$00                         
      ldy  #$08                         
      jsr  W9572                        
      lda  W95C7                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95C7+1                      
      ldx  #$01                         
      ldy  #$08                         
      jsr  W9572                        
      lda  W95CB                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95CC                        
      ldx  #$02                         
      ldy  #$08                         
      jsr  W9572                        
      rts                               

W95C5:
      brk                               
W95C6:
      brk                               
W95C7:
      isb  $D700,x                      ; SID images
W95CA:
      brk                               
W95CB:
      brk                               
W95CC:
      rti                               

W95CD:
      clc                               
      lda  W95C5                        
      adc  W95CB                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95C6                        
      adc  W95CC                        
      sta  $FC                          
      lda  #$C8                         
      ldx  #$04                         
      sta  $FD                          
      stx  $FE                          ; Free 0 page for user program
      ldx  #$14                         
      ldy  #$27                         
W95EA:
      lda  ($FB),y                      ; Free 0 page for user program
      sta  ($FD),y                      
      dey                               
      bpl  W95EA                        
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  W95C7                        
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  W95C7+1                      
      sta  $FC                          
      clc                               
      lda  $FD                          
      adc  #$28                         
      sta  $FD                          
      lda  $FE                          ; Free 0 page for user program
      adc  #$00                         
      sta  $FE                          ; Free 0 page for user program
      ldy  #$27                         
      dex                               
      bne  W95EA                        
      lda  W95C5                        
      sta  $FB                          ; Free 0 page for user program
      lda  W95C6                        
      ldx  #$00                         
      ldy  #$08                         
      jsr  W9572                        
      jsr  W96E8                        
      rts                               

W9625:
      lda  W9066                        
      ldy  #$00                         
      ldx  #$03                         
W962C:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W962C                        
      clc                               
      adc  #$17                         
      sta  $D000                        ; Position X sprite 0
      tya                               
      adc  #$00                         
      sta  $D010                        ; Position X MSB sprites 0..7
      lda  W9067                        
      asl                               
      asl                               
      asl                               
      clc                               
      adc  #$31                         
      sta  $D001                        ; Position Y sprite 0
      jsr  W96E8                        
      rts                               

W9651:
      lda  #$03                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  W9671                        
      bne  W9669                        
      lda  #$40                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W9669:
      lda  #$48                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W9671:
  .byte $01
W9672:
      lda  #$02                         
      sta  $D6                          ; Cursor line number
      lda  #$20                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  W9692                        
      beq  W968A                        
      lda  #$50                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W968A:
      lda  #$54                         
      ldx  #$9E                         
      jsr  W85D9                        
      rts                               

W9692:
  .byte $00
W9693:
      lda  #$00                         
      ldx  #$D8                         
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  #$04                         
      ldy  #$C8                         
      lda  W864E                        
W96A2:
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      bne  W96A2                        
      inc  $FC                          
      dex                               
      bne  W96A2                        
      rts                               

W96AD:
      sta  $D6                          ; Cursor line number
      stx  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$05                         
      sta  W8739                        
      jsr  W873A                        
      bcs  W96E7                        
      lda  $7A                          ; CHRGET (Introduce a char) subroutine
      pha                               
      lda  $7B                          ; CHRGET (Introduce a char) subroutine
      pha                               
      lda  #$E4                         
      ldx  #$87                         
      sta  $7A                          ; CHRGET (Introduce a char) subroutine
      stx  $7B                          ; CHRGET (Introduce a char) subroutine
      lda  W87E4                        
      jsr  $bCF3                        ; BASIC ROM
      jsr  $bC9B                        ; Routine: Convert Floating Point to 4-byte integer
      lda  $65                          ; Floating point accumulator #1: Mantissa
      sta  W87E4                        
      lda  $64                          ; Floating point accumulator #1: Mantissa
      sta  W87E4+1                      
      pla                               
      sta  $7B                          ; CHRGET (Introduce a char) subroutine
      pla                               
      sta  $7A                          ; CHRGET (Introduce a char) subroutine
      clc                               
      rts                               

W96E7:
      rts                               

W96E8:
      jsr  W926C                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      sta  $0499                        ; Video matrix (25*40)
      tay                               
      lda  #$03                         
      ldx  #$23                         
      jsr  W86B0                        
      rts                               

W96FB:
      lda  #$00                         
      ldx  #$04                         
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  #$04                         
      ldy  #$C8                         
      lda  #$20                         
W9709:
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      bne  W9709                        
      inc  $FC                          
      dex                               
      bne  W9709                        
      rts                               

W9714:
      pha                               
      lda  W95CB                        
      ldx  W95CC                        
      sta  $FB                          ; Free 0 page for user program
      sta  $FD                          
      stx  $FC                          
      stx  $FE                          ; Free 0 page for user program
      ldx  #$14                         
W9725:
      beq  W973A                        
      clc                               
      lda  $FD                          
      adc  W95C7                        
      sta  $FD                          
      lda  $FE                          ; Free 0 page for user program
      adc  W95C7+1                      
      sta  $FE                          ; Free 0 page for user program
      dex                               
      jmp  W9725                        

W973A:
      pla                               
      asl                               
      tax                               
      lda  W9692                        
      lsr                               
      txa                               
      ror                               
      pha                               
W9744:
      ldy  #$00                         
      pla                               
      sta  ($FB),y                      ; Free 0 page for user program
      pha                               
      lda  $FC                          
      cmp  $FE                          ; Free 0 page for user program
      bne  W9758                        
      lda  $FB                          ; Free 0 page for user program
      cmp  $FD                          
      bcc  W9758                        
      pla                               
      rts                               

W9758:
      inc  $FB                          ; Free 0 page for user program
      bne  W9744                        
      inc  $FC                          
      jmp  W9744                        

W9761:
      pha                               
      txa                               
      pha                               
      tya                               
      pha                               
      lda  W9857                        
      ldx  #$03                         
W976B:
      lsr                               
      dex                               
      bne  W976B                        
      sta  W985C                        
      ldx  #$03                         
W9774:
      asl                               
      dex                               
      bne  W9774                        
      sta  W97EF+1                      
      lda  W9857                        
      sec                               
      sbc  W97EF+1                      
      sta  W985A                        
      ldx  W985C                        
      lda  W95CB                        
      sta  W97EF+1                      
      lda  W95CC                        
      sta  W97EF+2                      
      cpx  #$00                         
W9796:
      beq  W97AF                        
      clc                               
      lda  W97EF+1                      
      adc  W95C7                        
      sta  W97EF+1                      
      lda  W97EF+2                      
      adc  W95C7+1                      
      sta  W97EF+2                      
      dex                               
      jmp  W9796                        

W97AF:
      ldy  W9858                        
      lda  W9859                        
      ldx  #$03                         
W97B7:
      lsr                               
      pha                               
      tya                               
      ror                               
      tay                               
      pla                               
      dex                               
      bne  W97B7                        
      pha                               
      tax                               
      tya                               
      pha                               
      clc                               
      adc  W97EF+1                      
      sta  W97EF+1                      
      txa                               
      adc  W97EF+2                      
      sta  W97EF+2                      
      pla                               
      tax                               
      pla                               
      tay                               
      txa                               
      ldx  #$03                         
W97D9:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W97D9                        
      sta  W985C                        
      sec                               
      lda  W9858                        
      sbc  W985C                        
      sta  W985B                        
W97EF:
      lda  $FFFF                        
      sta  W985D                        
      ldy  #$00                         
      ldx  #$03                         
W97F9:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W97F9                        
      clc                               
      adc  #$00                         
      sta  W9825+1                      
      tya                               
      adc  #$08                         
      sta  W9825+2                      
      lda  W9825+1                      
      clc                               
      adc  W985A                        
      sta  W9825+1                      
      lda  W9825+2                      
      adc  #$00                         
      sta  W9825+2                      
      sei                               
      lda  #$33                         
      sta  $01                          ; 6510 I/O register
W9825:
      lda  $FFFF                        
      ldx  #$37                         
      stx  $01                          ; 6510 I/O register
      cli                               
      pha                               
      lda  #$07                         
      sec                               
      sbc  W985B                        
      tax                               
      lda  #$01                         
      cpx  #$00                         
W9839:
      beq  W9840                        
      asl                               
      dex                               
      jmp  W9839                        

W9840:
      sta  W985C                        
      pla                               
      and  W985C                        
      bne  W9850                        
      pla                               
      tay                               
      pla                               
      tax                               
      pla                               
      clc                               
      rts                               

W9850:
      pla                               
      tay                               
      pla                               
      tax                               
      pla                               
      sec                               
      rts                               

W9857:
      brk                               
W9858:
      brk                               
W9859:
      brk                               
W985A:
      brk                               
W985B:
      brk                               
W985C:
      brk                               
W985D:
      brk                               
W985E:
      brk                               
W985F:
      lda  #$9F                         
      sta  W9857                        
      lda  #$01                         
      ldx  #$04                         
      ldy  #$00                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$01                         
      jsr  $FFC9                        ; Routine: Open an output canal
      lda  #$08                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      lda  #$00                         
      sta  W985E                        
      ldy  #$03                         
      ldx  #$A0                         
      lda  #$00                         
W9885:
      jsr  W9761                        
      php                               
      ror                               
      plp                               
      ror                               
      inc  W9858                        
      bne  W9894                        
      inc  W9859                        
W9894:
      dey                               
      bne  W9885                        
      pha                               
      lda  W985E                        
      lsr                               
      pla                               
      bcs  W98FF                        
      jsr  W9761                        
      ror                               
W98A3:
      sec                               
      ror                               
      pha                               
      jsr  $FFD2                        ; Routine: Send a char in the channel
      pla                               
      jsr  $FFD2                        ; Routine: Send a char in the channel
      sec                               
      lda  W9858                        
      sbc  #$03                         
      sta  W9858                        
      lda  W9859                        
      sbc  #$00                         
      sta  W9859                        
      lda  #$00                         
      dec  W9857                        
      ldy  #$03                         
      dex                               
      bne  W9885                        
      lda  #$0D                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      lda  W985E                        
      bne  W98F6                        
      clc                               
      lda  W9858                        
      adc  #$03                         
      sta  W9858                        
      lda  W9859                        
      adc  #$00                         
      sta  W9859                        
      lda  #$9F                         
      sta  W9857                        
      ldx  #$A0                         
      ldy  #$03                         
      lda  #$01                         
      sta  W985E                        
      lda  #$00                         
      jmp  W9885                        

W98F6:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      rts                               

W98FF:
      jsr  W9761                        
      php                               
      ror                               
      plp                               
      ror                               
      jmp  W98A3                        

W9909:
      lda  #$00                         
      sta  W9858                        
      sta  W9859                        
      ldx  #$03                         
      lda  W95C7                        
      ldy  W95C7+1                      
W9919:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W9919                        
      sta  W9964                        
      sty  W9965                        
      jsr  W8BF2                        
W992B:
      lda  W9859                        
      cmp  W9965                        
      beq  W9938                        
      bcc  W9948                        
      jmp  W9940                        

W9938:
      lda  W9858                        
      cmp  W9964                        
      bcc  W9948                        
W9940:
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      jmp  W94BB                        

W9948:
      jsr  W985F                        
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      bne  W9940                        
      clc                               
      lda  W9858                        
      adc  #$04                         
      sta  W9858                        
      lda  W9859                        
      adc  #$00                         
      sta  W9859                        
      jmp  W992B                        

W9964:
      brk                               
W9965:
      brk                               
W9966:
      txa                               
      pha                               
      tya                               
      pha                               
      sec                               
      lda  W9858                        
      sbc  #$06                         
      sta  W9858                        
      lda  W9859                        
      sbc  #$00                         
      sta  W9859                        
      lda  #$00                         
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      cmp  #$03                         
      beq  W999D                        
      cmp  #$02                         
      beq  W99AC                        
      cmp  #$01                         
      beq  W99A6                        
      lda  W8652                        
      jmp  W99AF                        

W999D:
      lda  W864E                        
      sec                               
      sbc  #$08                         
      jmp  W99AF                        

W99A6:
      lda  W864F                        
      jmp  W99AF                        

W99AC:
      lda  W8650                        
W99AF:
      sta  W9A09                        
      ldy  W9A08                        
      beq  W99F6                        
      ldx  W9A09                        
      lda  #$00                         
      pha                               
      lda  W9A07                        
      bne  W99C8                        
      lda  W9EA4,x                      
      jmp  W99CB                        

W99C8:
      lda  W9EB4,x                      
W99CB:
      asl                               
      asl                               
      asl                               
      asl                               
W99CF:
      asl                               
      sta  W985C                        
      pla                               
      rol                               
      pha                               
      lda  W985C                        
      dey                               
      bne  W99CF                        
      pla                               
      sta  W985C                        
W99E0:
      clc                               
      lda  W9858                        
      adc  #$04                         
      sta  W9858                        
      lda  W9859                        
      adc  #$00                         
      sta  W9859                        
      pla                               
      tay                               
      pla                               
      tax                               
      rts                               

W99F6:
      lda  #$00                         
      sta  W985C                        
      jmp  W99E0                        

W99FE:
      inc  W9858                        
      bne  W9A06                        
      inc  W9859                        
W9A06:
      rts                               

W9A07:
  .byte $00
W9A08:
  .byte $00
W9A09:
  .byte $00
W9A0A:
  .byte $00
W9A0B:
      lda  #$9F                         
      sta  W9857                        
      lda  #$00                         
      sta  W9A07                        
      lda  #$01                         
      ldx  #$04                         
      ldy  #$00                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$01                         
      jsr  $FFC9                        ; Routine: Open an output canal
      lda  #$08                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      ldy  #$A0                         
W9A2D:
      lda  #$00                         
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      cmp  #$03                         
      beq  W9A52                        
      cmp  #$02                         
      beq  W9A67                        
      cmp  #$01                         
      beq  W9A5E                        
      lda  W8652                        
      sta  W9A0A                        
      jmp  W9A6D                        

W9A52:
      lda  W864E                        
      sec                               
      sbc  #$08                         
      sta  W9A0A                        
      jmp  W9A6D                        

W9A5E:
      lda  W864F                        
      sta  W9A0A                        
      jmp  W9A6D                        

W9A67:
      lda  W8650                        
      sta  W9A0A                        
W9A6D:
      tax                               
      lda  W9A07                        
      bne  W9A79                        
      lda  W9EA4,x                      
      jmp  W9A7C                        

W9A79:
      lda  W9EB4,x                      
W9A7C:
      pha                               
      lda  #$00                         
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      jsr  W9761                        
      rol                               
      jsr  W99FE                        
      cmp  #$03                         
      beq  W9AA2                        
      cmp  #$02                         
      beq  W9AB7                        
      cmp  #$01                         
      beq  W9AAE                        
      lda  W8652                        
      sta  W9A0A                        
      jmp  W9ABD                        

W9AA2:
      lda  W864E                        
      sec                               
      sbc  #$08                         
      sta  W9A0A                        
      jmp  W9ABD                        

W9AAE:
      lda  W864F                        
      sta  W9A0A                        
      jmp  W9ABD                        

W9AB7:
      lda  W8650                        
      sta  W9A0A                        
W9ABD:
      tax                               
      lda  W9A07                        
      bne  W9AC9                        
      lda  W9EA4,x                      
      jmp  W9ACC                        

W9AC9:
      lda  W9EB4,x                      
W9ACC:
      asl                               
      asl                               
      asl                               
      asl                               
      sta  W985C                        
      pla                               
      ora  W985C                        
      ldx  W9A08                        
W9ADA:
      beq  W9AE4                        
      asl                               
      dex                               
      jmp  W9ADA                        

W9AE1:
      jmp  W9A2D                        

W9AE4:
      pha                               
      jsr  W9966                        
      pla                               
      ora  W985C                        
      ora  #$80                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      sec                               
      lda  W9858                        
      sbc  #$04                         
      sta  W9858                        
      lda  W9859                        
      sbc  #$00                         
      sta  W9859                        
      lda  W9A07                        
      eor  #$01                         
      sta  W9A07                        
      bne  W9AE1                        
      dec  W9857                        
      dey                               
      bne  W9AE1                        
      inc  W9A08                        
      lda  W9A08                        
      cmp  #$04                         
      bcc  W9B32                        
      lda  #$00                         
      sta  W9A08                        
      sec                               
      lda  W9858                        
      sbc  #$02                         
      sta  W9858                        
      lda  W9859                        
      sbc  #$00                         
      sta  W9859                        
W9B32:
      lda  #$0D                         
      jsr  $FFD2                        ; Routine: Send a char in the channel
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      rts                               

W9B40:
      lda  #$00                         
      sta  W9858                        
      sta  W9859                        
      sta  W9A08                        
      clc                               
      lda  W95C7                        
      ldy  W95C7+1                      
      ldx  #$03                         
W9B54:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  W9B54                        
      sta  W9964                        
      sty  W9965                        
      jsr  W8BF2                        
W9B66:
      jsr  W9A0B                        
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      bne  W9B8C                        
      clc                               
      lda  W9858                        
      adc  #$04                         
      sta  W9858                        
      lda  W9859                        
      adc  #$00                         
      sta  W9859                        
      cmp  W9965                        
      bcc  W9B66                        
      lda  W9858                        
      cmp  W9964                        
      bcc  W9B66                        
W9B8C:
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      jmp  W94BB                        

W9B94:
      lda  W864C                        
      and  #$10                         
      bne  W9BA1                        
      jsr  W9909                        
      jmp  W8F6F                        

W9BA1:
      jsr  W9B40                        
      jmp  W8F6F                        

W9BA7:
      lda  W9BB8                        
      bne  W9BB2                        
      lda  #$20                         
      sta  $0476                        ; Video matrix (25*40)
      rts                               

W9BB2:
      lda  #$2A                         
      sta  $0476                        ; Video matrix (25*40)
      rts                               

W9BB8:
  .byte $00
W9BB9:
  .byte $41
W9BBA:
      clc                               
      lda  W95CB                        
      adc  W95C7                        
      sta  W9BEE+1                      
      lda  W95CC                        
      adc  W95C7+1                      
      sta  W9BEE+2                      
      clc                               
      lda  W95CB                        
      adc  W9C44                        
      sta  W9BEB+1                      
      lda  W95CC                        
      adc  W9C44+1                      
      sta  W9BEB+2                      
      lda  #$14                         
      sta  W9C44+2                      
      ldx  W95C7+1                      
      ldy  W95C7                        
W9BEB:
      lda  $FFFF                        
W9BEE:
      sta  $FFFF                        
      inc  W9BEB+1                      
      bne  W9BF9                        
      inc  W9BEB+2                      
W9BF9:
      inc  W9BEE+1                      
      bne  W9C01                        
      inc  W9BEE+2                      
W9C01:
      dey                               
      cpy  #$00                         
      beq  W9C47                        
      cpy  #$FF                         
      bne  W9BEB                        
      cpx  #$00                         
      beq  W9C12                        
      dex                               
      jmp  W9BEB                        

W9C12:
      ldx  W95C7+1                      
      ldy  W95C7                        
      sec                               
      lda  W9BEB+1                      
      sbc  W95C7                        
      sta  W9BEB+1                      
      lda  W9BEB+2                      
      sbc  W95C7+1                      
      sta  W9BEB+2                      
      clc                               
      lda  W9BEB+1                      
      adc  W9C44                        
      sta  W9BEB+1                      
      lda  W9BEB+2                      
      adc  W9C44+1                      
      sta  W9BEB+2                      
      dec  W9C44+2                      
      bne  W9BEB                        
      rts                               

W9C44:
      isb  $14FF,x                      
W9C47:
      cpx  #$00                         
      beq  W9C12                        
      jmp  W9BEB                        

W9C4E:
      lda  W95CB                        
      ldx  W95CC                        
      sta  W9CEC+1                      
      stx  W9CEC+2                      
      ldx  #$14                         
W9C5C:
      clc                               
      lda  W9CEC+1                      
      adc  W95C7                        
      sta  W9CEC+1                      
      lda  W9CEC+2                      
      adc  W95C7+1                      
      sta  W9CEC+2                      
      dex                               
      bne  W9C5C                        
      sec                               
      lda  W9CEC+1                      
      sbc  #$01                         
      sta  W9CEC+1                      
      lda  W9CEC+2                      
      sbc  #$00                         
      sta  W9CEC+2                      
      lda  W95CB                        
      ldx  W95CC                        
      sta  W9CE9+1                      
      stx  W9CE9+2                      
      ldx  #$14                         
W9C91:
      clc                               
      lda  W9CE9+1                      
      adc  W9C44                        
      sta  W9CE9+1                      
      lda  W9CE9+2                      
      adc  W9C44+1                      
      sta  W9CE9+2                      
      dex                               
      bne  W9C91                        
      sec                               
      lda  W9CE9+1                      
      sbc  #$01                         
      sta  W9CE9+1                      
      lda  W9CE9+2                      
      sbc  #$00                         
      sta  W9CE9+2                      
      lda  #$14                         
      sta  W9C44+2                      
      sec                               
      lda  W95C7                        
      sbc  W9C44                        
      sta  W9D46                        
      lda  W95C7+1                      
      sbc  W9C44+1                      
      sta  W9D46+1                      
      sec                               
      lda  W9CEC+1                      
      sbc  W9D46                        
      sta  W9CEC+1                      
      lda  W9CEC+2                      
      sbc  W9D46+1                      
      sta  W9CEC+2                      
      ldx  W9C44                        
      ldy  W9C44+1                      
W9CE9:
      lda  $FFFF                        
W9CEC:
      sta  $FFFF                        
      sec                               
      lda  W9CE9+1                      
      sbc  #$01                         
      sta  W9CE9+1                      
      lda  W9CE9+2                      
      sbc  #$00                         
      sta  W9CE9+2                      
      sec                               
      lda  W9CEC+1                      
      sbc  #$01                         
      sta  W9CEC+1                      
      lda  W9CEC+2                      
      sbc  #$00                         
      sta  W9CEC+2                      
W9D11:
      dex                               
      beq  W9D3F                        
      cpx  #$FF                         
      bne  W9CE9                        
      cpy  #$00                         
      beq  W9D20                        
      dey                               
      jmp  W9CE9                        

W9D20:
      ldx  W9C44                        
      ldy  W9C44+1                      
      sec                               
      lda  W9CEC+1                      
      sbc  W9D46                        
      sta  W9CEC+1                      
      lda  W9CEC+2                      
      sbc  W9D46+1                      
      sta  W9CEC+2                      
      dec  W9C44+2                      
      bne  W9CE9                        
      rts                               

W9D3F:
      cpy  #$00                         
      beq  W9D20                        
      jmp  W9CE9                        

W9D46:
      isb  $a9FF,x                      ; BASIC ROM
      ora  ($A2,x)                      ; Real time clock HMS (1/60 sec)
      php                               
      jsr  W96AD                        
      bcs  W9D98                        
      lda  W87E4                        
      cmp  #$28                         
      bcs  W9D5D                        
      lda  W87E4+1                      
      beq  W9D98                        
W9D5D:
      lda  W87E4+1                      
      cmp  W95C7+1                      
      bcc  W9D98                        
      bne  W9D71                        
      lda  W87E4                        
      cmp  W95C7                        
      bcc  W9D98                        
      beq  W9D98                        
W9D71:
      lda  W95C7                        
      ldx  W95C7+1                      
      sta  W9C44                        
      stx  W9C44+1                      
      lda  W87E4                        
      ldx  W87E4+1                      
      sta  W95C7                        
      stx  W95C7+1                      
      sec                               
      sbc  #$28                         
      sta  W95C7+2                      
      txa                               
      sbc  #$00                         
      sta  W95CA                        
      jsr  W9C4E                        
W9D98:
      jsr  W9597                        
      lda  #$00                         
W9D9D:
      sta  W95C5                        
      sta  W95C6                        
      jsr  W95CD                        
      jmp  W8F6F                        

  .byte $50, $4F, $53, $2E, $20, $20, $20, $3A
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $2D, $43, $4F, $4C
  .byte $4F, $52, $20, $20, $42, $4F, $52, $44
  .byte $45, $52, $3A, $00, $45, $58, $54, $45
  .byte $4E, $44, $2E, $3A, $20, $20, $20, $20
  .byte $20, $20, $43, $4F, $4C, $4F, $52, $20
  .byte $23, $31, $20, $3A, $20, $20, $20, $20
  .byte $53, $43, $52, $45, $45, $4E, $3A, $00
  .byte $53, $54, $41, $52, $54, $20, $20, $3A
  .byte $20
W9DFA:
  .byte $20, $20, $20, $20, $20, $43, $4F, $4C
  .byte $4F, $52, $20, $23, $32, $20, $3A, $20
  .byte $20, $20, $20, $52, $56, $53, $00, $43
  .byte $4F, $4C, $4F, $52, $20, $23, $33, $20
  .byte $3A, $20, $20, $20, $20, $43, $4F, $44
  .byte $45, $20, $20, $3D, $00, $4D, $55, $4C
  .byte $54, $49, $20, $00, $53, $49, $4E, $47
  .byte $4C, $45, $00, $20, $20, $20, $20, $20
  .byte $9D, $9D, $9D, $9D, $9D, $00, $57, $52
  .byte $49, $54, $45, $20, $20, $00, $43, $4F
  .byte $4D, $4D, $41, $4E, $44, $00, $4F, $4E
  .byte $20, $00, $4F, $46, $46, $00, $12, $20
  .byte $53, $41, $56, $45, $20, $92, $20, $46
  .byte $49, $4C, $45, $4E, $41, $4D, $45, $20
  .byte $3A, $00, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $00, $12, $20
  .byte $4C, $4F, $41, $44, $20, $92, $20, $46
  .byte $49, $4C, $45, $4E, $41, $4D, $45, $20
  .byte $3A, $00
W9EA4:
  .byte $0F, $00, $0A, $02, $0A, $0C, $0F, $04
  .byte $0F, $09, $04, $0B, $0D, $04, $02
W9EB3:
  .byte $02
W9EB4:
  .byte $0F, $00, $05, $08, $02, $03, $09, $02
  .byte $05, $0F, $02, $0F, $06, $01, $04, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00
W9EFD:
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $00, $00, $00

draw_drive_menu_entry:
      lda  fa
      adc  #$30
      sta  $8eb2                        ; set displayed dev. #
      lda  #$9F                         
      ldx  #$8E                         
      jsr  W85D9                        ; "6) drive 8"
      rts

toggle_device:
      ldx  #$09
      cpx  fa
      beq  dev8
      jmp  setdev
dev8:
      ldx  #$08
setdev:
      stx  fa
      txa
      adc  #$30
      sta  $8eb2                        ; set displayed dev. #
      jmp  draw_menu

W9FB8:
      jsr  W9FD6                        
      jmp  $a093                        ; BASIC ROM

W9FBE:
      jsr  W9FD6                        
      jmp  $a0F0                        ; BASIC ROM

W9FC4:
      jsr  W9FD6                        
      jmp  $a134                        ; BASIC ROM

W9FCA:
      jsr  W9FD6                        
      jmp  $a1D7                        ; BASIC ROM

W9FD0:
      jsr  W9FD6                        
      jmp  $a2B6                        ; BASIC ROM

W9FD6:
      sei                               
      lda  #$30                         
      sta  $01                          ; 6510 I/O register
      rts                               

W9FDC:
      lda  #$37                         
      sta  $01                          ; 6510 I/O register
      cli                               
      rts                               

      jsr  W9FDC                        
      jmp  WC168                        

W9FE8:
      jsr  W9FDC                        
W9FEB:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      pha                               
      jsr  W9FD6                        
      pla                               
      cmp  #$00                         
      rts                               

      jsr  W9FDC                        
      jsr  WC95A                        
      jsr  W9FD6                        
      rts                               


  .org $C000

WC000:
      lda  #$EB                         
      ldx  #$CC                         
      jsr  W85D9                        
      lda  #$01                         
      ldx  fa
      ldy  #$0F                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  #$00                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
WC018:
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
WC020:
      pha                               
      jsr  $FFCC                        ; Routine: Close the input and output channel
      pla                               
      cmp  #$0D                         
      beq  WC02F                        
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WC018                        

WC02F:
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      lda  #$08                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$29                         
      ldx  #$CD                         
      jsr  W85D9                        
      lda  #$1F                         
      sta  W8739                        
      jsr  W873A                        
      bcs  WC07F                        
      lda  #$01                         
      ldx  fa
      ldy  #$0F                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  #$00                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$01                         
      jsr  $FFC9                        ; Routine: Open an output canal
      ldx  #$00                         
WC068:
      lda  W87E4,x                      
      beq  WC074                        
      jsr  $FFD2                        ; Routine: Send a char in the channel
      inx                               
      jmp  WC068                        

WC074:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jmp  WC000                        

      jsr  $FFC3                        ; Routine: Close a specified logical file
WC07F:
      jmp  draw_menu                        

      lda  #$93                         
      jsr  $AB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$01                         
      ldx  fa
      ldy  #$00                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      ldx  #$32                         
      ldy  #$CD                         
      lda  #$01                         
      jsr  $FFBD                        ; Routine: Set file name
      jsr  $FFC0                        ; Routine: Open a logical file
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$51                         
      ldx  #$CD                         
      jsr  W85D9                        
WC0BD:
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$00                         
      beq  WC0D4                        
      pha                               
      jsr  $FFCC                        ; Routine: Close the input and output channel
      pla                               
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WC0BD                        

WC0D4:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$0D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      jsr  $FFCF                        ; Routine: Acept a char in the channel
WC0EC:
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      sta  $63                          ; Floating point accumulator #1: Mantissa
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      sta  $62                          ; Floating point accumulator #1: Mantissa
      jsr  $FFCC                        ; Routine: Close the input and output channel
      ldx  #$90                         
      sec                               
      jsr  $bC49                        ; BASIC ROM
      jsr  $bDDD                        ; Routine: Convert Floating Point to PETSCII string which starts (YA) with $0100 and ends with $00
      lda  #$01                         
      ldx  #$01                         
      jsr  W85D9                        
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
WC10E:
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      cmp  #$00                         
      beq  WC125                        
      pha                               
      jsr  $FFCC                        ; Routine: Close the input and output channel
      pla                               
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WC10E                        

WC125:
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      sta  WC167                        
      jsr  $FFCF                        ; Routine: Acept a char in the channel
      clc                               
      adc  WC167                        
      bcs  WC136                        
      beq  WC150                        
WC136:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$0D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
WC13E:
      lda  $028D                        ; Flag: Key SHIFT/CTRL/Commodore
      bne  WC13E                        
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      bne  WC150                        
      ldx  #$01                         
      jsr  $FFC6                        ; Routine: Open an input canal
      jmp  WC0EC                        

WC150:
      jsr  $FFCC                        ; Routine: Close the input and output channel
      lda  #$01                         
      jsr  $FFC3                        ; Routine: Close a specified logical file
      lda  #$33                         
      ldx  #$CD                         
      jsr  W85D9                        
WC15F:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      beq  WC15F                        
      jmp  draw_menu                        

WC167:
      brk                               
WC168:
      lda  #$93                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$80                         
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$15                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$54                         
      ldx  #$CD                         
      jsr  W85D9                        
      lda  #$18                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
WC18F:
      lda  #$70                         
      ldx  #$CD                         
      jsr  W85D9                        
      lda  $D6                          ; Cursor line number
      cmp  #$16                         
      bne  WC18F                        
      lda  #$01                         
      sta  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$76                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$7D                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$87                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$91                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$9B                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$A5                         
      ldx  #$CD                         
      jsr  W85D9                        
      lda  #$0B                         
      sta  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$AF                         
      ldx  #$CD                         
      jsr  W85D9                        
      inc  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$B9                         
      ldx  #$CD                         
      jsr  W85D9                        
      jsr  WC7FA                        
      jsr  WC81F+2                      
      jsr  WC8A2                        
      jsr  WC943                        
      jsr  WC95A                        
      jsr  WCAD7                        
      jsr  WCCAA                        
      jsr  WCCCB                        
      jmp  WC24C                        

WC23D:
      jmp  W9FB8                        

WC240:
      jmp  W9FBE                        

WC243:
      jmp  W9FC4                        

WC246:
      jmp  W9FCA                        

WC249:
      jmp  W9FD0                        

;-------------------------
; Sprite editor input loop
;-------------------------
WC24C:
      jsr  $FFE4                        ; Routine: Take the char from keyboard buffer
      cmp  #$00                         
      beq  WC24C                        
      cmp  #$51                         
      beq  WC2D6                        
      cmp  #$43                         
      beq  WC2D9                        
      cmp  #$4D                         
      beq  WC2DC                        
      cmp  #$45                         
      beq  WC2DF                        
      cmp  #$85                         
      beq  WC2E2                        
      cmp  #$86                         
      beq  WC2E5                        
      cmp  #$89                         
      beq  WC2E8                        
      cmp  #$8A                         
      beq  WC2EB                        
      cmp  #$54                         
      beq  WC2EE                        
      cmp  #$91                         
      beq  WC2F1                        
      cmp  #$11                         
      beq  WC2F4                        
      cmp  #$9D                         
      beq  WC2F7                        
      cmp  #$1D                         
      beq  WC2FA                        
      cmp  #$88                         
      beq  WC306                        
      cmp  #$5F                         
      beq  WC23D                        
      cmp  #$5E                         
      beq  WC240                        
      cmp  #$49                         
      beq  WC243                        
      cmp  #$2B                         
      beq  WC249                        
      cmp  #$52                         
      beq  WC246                        
      cmp  #$20                         
      beq  WC309                        
      cmp  #$A0                         
      beq  WC309                        
      cmp  #$31                         
      beq  WC2FD                        
      cmp  #$32                         
      beq  WC300                        
      cmp  #$33                         
      beq  WC303                        
      cmp  #$87                         
      beq  WC30C                        
      cmp  #$93                         
      beq  WC30F                        
      cmp  #$13                         
      beq  WC312                        
      cmp  #$53                         
      beq  WC315                        
      cmp  #$4C                         
      beq  WC318                        
      cmp  #$0D                         
      beq  WC31B                        
      cmp  #$41                         
      beq  WC31E                        
      cmp  #$44                         
      beq  WC321                        
      jmp  WC24C                        

WC2D6:
      jmp  WC324                        

WC2D9:
      jmp  WC338                        

WC2DC:
      jmp  WC3B2                        

WC2DF:
      jmp  WC3F7                        

WC2E2:
      jmp  WC457                        

WC2E5:
      jmp  WC46C                        

WC2E8:
      jmp  WC472                        

WC2EB:
      jmp  WC47E                        

WC2EE:
      jmp  WC48A                        

WC2F1:
      jmp  WC520                        

WC2F4:
      jmp  WC52E                        

WC2F7:
      jmp  WC541                        

WC2FA:
      jmp  WC559                        

WC2FD:
      jmp  WC5C6                        

WC300:
      jmp  WC5D1                        

WC303:
      jmp  WC5E1                        

WC306:
      jmp  WC5F1                        

WC309:
      jmp  WC587                        

WC30C:
      jmp  WC600                        

WC30F:
      jmp  WC619                        

WC312:
      jmp  WC576                        

WC315:
      jmp  WC646                        

WC318:
      jmp  WC70B                        

WC31B:
      jmp  WC7B0                        

WC31E:
      jmp  ($7802)                      

WC321:
      jmp  ($7804)                      

WC324:
      lda  #$00                         
      sta  $D015                        ; Sprites Abilitator
      sta  $028A                        ; Flag: repeat pressed key, case 0x80=all keys
      sta  $D017                        ; (2X) vertical expansion (Y) sprite 0..7
      sta  $D01D                        ; (2X) horizontal expansion (X) sprite 0..7
      sta  $D01C                        ; Set multicolor mode for sprite 0..7
      jmp  draw_menu                        

WC338:
      lda  #$03                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  WC34B                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  WC338                        
      sta  WC816                        
WC34B:
      jsr  WC8A2                        
WC34E:
      lda  #$04                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  WC361                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  WC34E                        
      sta  WC817                        
WC361:
      jsr  WC8A2                        
WC364:
      lda  #$05                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  WC377                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  WC364                        
      sta  WC818                        
WC377:
      jsr  WC8A2                        
WC37A:
      lda  #$06                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  WC38D                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  WC37A                        
      sta  WC820                        
WC38D:
      jsr  WC8A2                        
WC390:
      lda  #$07                         
      ldx  #$23                         
      jsr  W880E                        
      bcs  WC3A3                        
      lda  W87E4                        
      cmp  #$10                         
      bcs  WC390                        
      sta  WC81F                        
WC3A3:
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jsr  WC95A                        
      jsr  WCAD7                        
      jmp  WC24C                        

WC3B2:
      lda  WC81B                        
      bmi  WC3DB                        
      bne  WC3CA                        
      lda  #$01                         
      sta  WC81B                        
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jsr  WC95A                        
      jmp  WC576                        

WC3CA:
      lda  #$80                         
      sta  WC81B                        
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jsr  WC95A                        
      jmp  WC576                        

WC3DB:
      lda  #$00                         
      sta  WC81B                        
      lda  #$01                         
      sta  WC5C5                        
      jsr  WCCAA                        
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jsr  WC95A                        
      jsr  WCAD7                        
      jmp  WC576                        

WC3F7:
      lda  #$01                         
      sta  W8739                        
      lda  #$0B                         
      sta  $D6                          ; Cursor line number
      lda  #$23                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      jsr  W873A                        
      bcs  WC424                        
      lda  W87E4                        
      cmp  #$59                         
      beq  WC41F                        
      cmp  #$4E                         
      bne  WC3F7                        
      lda  #$00                         
      sta  WC819                        
      jmp  WC424                        

WC41F:
      lda  #$07                         
      sta  WC819                        
WC424:
      jsr  WC8A2                        
      jsr  WC81F+2                      
      lda  #$23                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      jsr  W873A                        
      bcs  WC44E                        
      lda  W87E4                        
      cmp  #$59                         
      beq  WC449                        
      cmp  #$4E                         
      bne  WC424                        
      lda  #$00                         
      sta  WC81A                        
      jmp  WC44E                        

WC449:
      lda  #$07                         
      sta  WC81A                        
WC44E:
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jmp  WC24C                        

WC457:
      inc  WC81C                        
WC45A:
      jsr  WC943                        
      jsr  WC8A2                        
      jsr  WC81F+2                      
      jsr  WC95A                        
      jsr  WCAD7                        
      jmp  WC24C                        

WC46C:
      dec  WC81C                        
      jmp  WC45A                        

WC472:
      clc                               
      lda  WC81C                        
      adc  #$10                         
      sta  WC81C                        
      jmp  WC45A                        

WC47E:
      sec                               
      lda  WC81C                        
      sbc  #$10                         
      sta  WC81C                        
      jmp  WC45A                        

WC48A:
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$EA                         
      ldx  #$CD                         
      jsr  W85D9                        
      ldy  WC81C                        
      lda  #$17                         
      ldx  #$22                         
      jsr  W86B0                        
      lda  #$17                         
      ldx  #$15                         
      jsr  W880E                        
      php                               
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      ldx  #$CE                         
      jsr  W85D9                        
      plp                               
      bcs  WC50D                        
      lda  WC81D                        
      ldx  WC81E                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      lda  WC81C                        
      pha                               
      lda  W87E4                        
      sta  WC81C                        
      jsr  WC943                        
      lda  WC81D                        
      ldx  WC81E                        
      sta  $FD                          
      stx  $FE                          ; Free 0 page for user program
      lda  $FB                          ; Free 0 page for user program
      ldx  $FC                          
      sta  WC81D                        
      stx  WC81E                        
      pla                               
      sta  WC81C                        
      ldy  #$00                         
WC4F4:
      lda  ($FD),y                      
      ora  ($FB),y                      ; Free 0 page for user program
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      lda  WC81B                        
      bmi  WC510                        
      cpy  #$3F                         
      bne  WC4F4                        
      jsr  WC95A                        
      jsr  WCAD7                        
      jsr  WC81F+2                      
WC50D:
      jmp  WC24C                        

WC510:
      cpy  #$BF                         
      bne  WC4F4                        
      jsr  WC95A                        
      jsr  WCAD7                        
      jsr  WC81F+2                      
      jmp  WC24C                        

WC520:
      jsr  WCB14                        
WC523:
      dec  WCA9E                        
      bmi  WC531                        
      jsr  WCAD7                        
      jmp  WC60E                        

WC52E:
      jsr  WCB14                        
WC531:
      inc  WCA9E                        
      lda  WCA9E                        
      cmp  #$15                         
      bcs  WC523                        
      jsr  WCAD7                        
      jmp  WC60E                        

WC541:
      jsr  WCB14                        
WC544:
      lda  WC81B                        
      bmi  WC54E                        
      beq  WC54E                        
WC54B:
      dec  WCA9D                        
WC54E:
      dec  WCA9D                        
      bmi  WC55C                        
WC553:
      jsr  WCAD7                        
      jmp  WC60E                        

WC559:
      jsr  WCB14                        
WC55C:
      lda  WC81B                        
      bmi  WC566                        
      beq  WC566                        
      inc  WCA9D                        
WC566:
      inc  WCA9D                        
      lda  WCA9D                        
      cmp  #$18                         
      bcs  WC544                        
      jsr  WCAD7                        
      jmp  WC60E                        

WC576:
      jsr  WCB14                        
      lda  #$00                         
      sta  WCA9D                        
      sta  WCA9E                        
      jsr  WCAD7                        
      jmp  WC24C                        

WC587:
      jsr  WCAA3                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      and  #$7F                         
      ora  WC5C4                        
      sta  ($FB),y                      ; Free 0 page for user program
      lda  WC81B                        
      bmi  WC5A6                        
      beq  WC5A6                        
      iny                               
      lda  ($FB),y                      ; Free 0 page for user program
      and  #$7F                         
      ora  WC5C4                        
      sta  ($FB),y                      ; Free 0 page for user program
WC5A6:
      ldx  WC5C5                        
      dex                               
      lda  WC816,x                      
      ldy  #$00                         
      sta  ($FD),y                      
      lda  WC81B                        
      bmi  WC5BE                        
      beq  WC5BE                        
      iny                               
      lda  WC816,x                      
      sta  ($FD),y                      
WC5BE:
      jsr  WCB6E                        
      jmp  WC24C                        

WC5C4:
  .byte $80
WC5C5:
  .byte $01
WC5C6:
      lda  #$01                         
      sta  WC5C5                        
      jsr  WCCAA                        
WC5CE:
      jmp  WC24C                        

WC5D1:
      lda  WC81B                        
      beq  WC5CE                        
      lda  #$02                         
      sta  WC5C5                        
      jsr  WCCAA                        
      jmp  WC24C                        

WC5E1:
      lda  WC81B                        
      beq  WC5CE                        
      lda  #$03                         
      sta  WC5C5                        
      jsr  WCCAA                        
      jmp  WC24C                        

WC5F1:
      lda  WC5C4                        
      eor  #$80                         
      sta  WC5C4                        
      jsr  WCCCB                        
      jmp  WC24C                        

WC5FF:
      brk                               
WC600:
      lda  WC5FF                        
      eor  #$01                         
      sta  WC5FF                        
      jsr  WC7FA                        
      jmp  WC24C                        

WC60E:
      lda  WC5FF                        
      beq  WC616                        
      jmp  WC587                        

WC616:
      jmp  WC24C                        

WC619:
      lda  WC81D                        
      ldx  WC81E                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      lda  WC81B                        
      and  #$80                         
      clc                               
      adc  #$3F                         
      tay                               
      lda  #$00                         
WC62E:
      sta  ($FB),y                      ; Free 0 page for user program
      dey                               
      bne  WC62E                        
      sta  ($FB),y                      ; Free 0 page for user program
      jsr  WC95A                        
      lda  #$00                         
      sta  WCA9D                        
      sta  WCA9E                        
      jsr  WCAD7                        
      jmp  WC24C                        

WC646:
      lda  $9D                          ; Flag: 80=direct mode 00=program mode
      pha                               
      lda  #$00                         
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  $D015                        ; Sprites Abilitator
      pha                               
      lda  #$00                         
      sta  $D015                        ; Sprites Abilitator
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$77                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  #$17                         
      ldx  #$11                         
      jsr  W880E                        
      lda  WC81C                        
      pha                               
      bcs  WC6E8                        
      lda  W87E4                        
      sta  WC81C                        
      jsr  WC943                        
      lda  #$17                         
      ldx  #$1E                         
      jsr  W880E                        
      bcs  WC6E8                        
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  W87E4                        
      sta  WC81C                        
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$94                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  #$0C                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      sta  W8739                        
      jsr  W873A                        
      bcs  WC6E8                        
      lda  WC81D                        
      ldx  WC81E                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      jsr  WC943                        
      ldx  fa
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  W880B+2                      
      ldx  #$E4                         
      ldy  #$87                         
      jsr  $FFBD                        ; Routine: Set file name
      lda  WC81D                        
      clc                               
      adc  #$40                         
      tax                               
      lda  WC81E                        
      adc  #$00                         
      tay                               
      lda  #$FB                         
      jsr  $FFD8                        ; Routine: Save the Ram to a device
WC6E8:
      pla                               
      sta  WC81C                        
      pla                               
      sta  $D015                        ; Sprites Abilitator
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      ldx  #$CE                         
      jsr  W85D9                        
      jsr  WC943                        
      pla                               
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      jmp  WC24C                        

WC70B:
      lda  $9D                          ; Flag: 80=direct mode 00=program mode
      pha                               
      lda  #$00                         
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  $D015                        ; Sprites Abilitator
      pha                               
      lda  #$00                         
      sta  $D015                        ; Sprites Abilitator
      lda  WC81C                        
      pha                               
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$A0                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  #$17                         
      ldx  $D3                          ; Column of cursor on the current line
      jsr  W880E                        
      bcs  WC78B                        
      lda  W87E4                        
      sta  WC81C                        
      jsr  WC943                        
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      ldx  #$CE                         
WC74E:
      jsr  W85D9                        
      lda  #$17                         
      sta  $D6                          ; Cursor line number
      lda  #$01                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$94                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  #$10                         
      sta  W8739                        
      jsr  W873A                        
      bcs  WC78B                        
      lda  #$02                         
      ldx  fa
      ldy  #$00                         
      jsr  $FFBA                        ; Routine: Set primary, secondary and logical addresses
      lda  W880B+2                      
      ldx  #$E4                         
      ldy  #$87                         
      jsr  $FFBD                        ; Routine: Set file name
      lda  #$00                         
      ldx  WC81D                        
      ldy  WC81E                        
      jsr  $FFD5                        ; Routine: Load the Ram from a device
WC78B:
      pla                               
      sta  WC81C                        
      jsr  WC943                        
      pla                               
      sta  $D015                        ; Sprites Abilitator
      pla                               
      sta  $9D                          ; Flag: 80=direct mode 00=program mode
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$10                         
      ldx  #$CE                         
      jsr  W85D9                        
      jsr  WC95A                        
      jsr  WCAD7                        
      jmp  WC24C                        

WC7B0:
      lda  #$00                         
      sta  $D015                        ; Sprites Abilitator
      lda  #$B1                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  #$5D                         
      ldx  #$CF                         
      jsr  W85D9                        
      lda  #$08                         
      sta  WC9AE                        
WC7C8:
      lda  #$89                         
      ldx  #$CF                         
      jsr  W85D9                        
      dec  WC9AE                        
      bne  WC7C8                        
      lda  #$0D                         
      sta  $D6                          ; Cursor line number
      lda  #$08                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$30                         
WC7E1:
      pha                               
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$9D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      inc  $D6                          ; Cursor line number
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      pla                               
      clc                               
      adc  #$01                         
      cmp  #$38                         
      bne  WC7E1                        
      jmp  ($7800)                      

WC7FA:
      lda  #$01                         
      sta  $D6                          ; Cursor line number
      lda  #$25                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  WC5FF                        
      bne  WC810                        
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      rts                               

WC810:
      lda  #$2A                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      rts                               

WC816:
  .byte $00
WC817:
  .byte $0B
WC818:
  .byte $0C
WC819:
  .byte $00
WC81A:
  .byte $00
WC81B:
  .byte $00
WC81C:
  .byte $80
WC81D:
  .byte $00
WC81E:
  .byte $20
WC81F:
  .byte $0F
WC820:
  .byte $00
WC821:
      lda  #$E8                         
      sta  $D000                        ; Position X sprite 0
      sta  $D002                        ; Position X sprite 1
      sta  $D004                        ; Position X sprite 2
      sta  $D006                        ; Position X sprite 3
      lda  #$BA                         
      sta  $D001                        ; Position Y sprite 0
      sta  $D003                        ; Position Y sprite 1
      sta  $D005                        ; Position Y sprite 2
      sta  $D007                        ; Position Y sprite 3
      lda  #$00                         
      sta  $D010                        ; Position X MSB sprites 0..7
      lda  WC816                        
      sta  $D027                        ; Color sprite 0
      lda  WC817                        
      sta  $D025                        ; Multicolor animation 0 register
      lda  WC818                        
      sta  $D026                        ; Multicolor animation 1 register
      lda  WC81F                        
      sta  $D021                        ; Background 0 color
      lda  WC820                        
      sta  $D020                        ; Border color
      lda  WC81C                        
      sta  $07F8                        ; Pointer to data sprites
      lda  WC819                        
      sta  $D01D                        ; (2X) horizontal expansion (X) sprite 0..7
      lda  WC81A                        
      sta  $D017                        ; (2X) vertical expansion (Y) sprite 0..7
      lda  WC81B                        
      bmi  WC880                        
      sta  $D01C                        ; Set multicolor mode for sprite 0..7
      lda  #$01                         
      sta  $D015                        ; Sprites Abilitator
      rts                               

WC880:
      lda  #$07                         
      sta  $D015                        ; Sprites Abilitator
      lda  #$00                         
      sta  $D01C                        ; Set multicolor mode for sprite 0..7
      ldx  $07F8                        ; Pointer to data sprites
      inx                               
      stx  $07F9                        ; Pointer to data sprites
      inx                               
      stx  $07FA                        ; Pointer to data sprites
      lda  WC817                        
      sta  $D028                        ; Color sprite 1
      lda  WC818                        
      sta  $D029                        ; Color sprite 2
      rts                               

WC8A2:
      ldy  WC81C                        
      lda  #$01                         
      ldx  #$20                         
      jsr  W86B0                        
      ldy  WC816                        
      lda  #$03                         
      ldx  #$23                         
      jsr  W86B0                        
      ldy  WC817                        
      lda  #$04                         
      ldx  #$23                         
      jsr  W86B0                        
      ldy  WC818                        
      lda  #$05                         
      ldx  #$23                         
      jsr  W86B0                        
      ldy  WC820                        
      lda  #$06                         
      ldx  #$23                         
      jsr  W86B0                        
      ldy  WC81F                        
      lda  #$07                         
      ldx  #$23                         
      jsr  W86B0                        
      jsr  WC8E4                        
      jmp  WC90E                        

WC8E4:
      lda  #$09                         
      sta  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  WC81B                        
      bmi  WC906                        
      bne  WC8FE                        
      lda  #$C3                         
      ldx  #$CD                         
      jsr  W85D9                        
      rts                               

WC8FE:
      lda  #$D0                         
      ldx  #$CD                         
      jsr  W85D9                        
      rts                               

WC906:
      lda  #$DD                         
      ldx  #$CD                         
      jsr  W85D9                        
      rts                               

WC90E:
      lda  #$0B                         
      sta  $D6                          ; Cursor line number
      lda  #$23                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  WC819                        
      beq  WC926                        
      lda  #$59                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WC92B                        

WC926:
      lda  #$4E                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
WC92B:
      inc  $D6                          ; Cursor line number
      dec  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  WC81A                        
      beq  WC93D                        
      lda  #$59                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      rts                               

WC93D:
      lda  #$4E                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      rts                               

WC943:
      lda  WC81C                        
      ldy  #$00                         
      ldx  #$06                         
WC94A:
      asl                               
      pha                               
      tya                               
      rol                               
      tay                               
      pla                               
      dex                               
      bne  WC94A                        
      sta  WC81D                        
      sty  WC81E                        
      rts                               

WC95A:
      lda  #$00                         
      sta  $D6                          ; Cursor line number
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  W82A8                        
      pha                               
      lda  WC816                        
      sta  W82A8                        
      lda  WC81D                        
      ldx  WC81E                        
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldy  #$00                         
      lda  #$03                         
      sta  WC9AE                        
      lda  WC81B                        
      bmi  WC9B7                        
WC983:
      lda  WC81B                        
      bne  WC9AF                        
      lda  ($FB),y                      ; Free 0 page for user program
      jsr  W8844                        
WC98D:
      dec  WC9AE                        
      bne  WC9A4                        
      lda  #$03                         
      sta  WC9AE                        
      lda  #$00                         
      sta  $D3                          ; Column of cursor on the current line
      inc  $D6                          ; Cursor line number
      tya                               
      pha                               
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      pla                               
      tay                               
WC9A4:
      iny                               
      cpy  #$3F                         
      bne  WC983                        
      pla                               
      sta  W82A8                        
      rts                               

WC9AE:
  .byte $03
WC9AF:
      lda  ($FB),y                      ; Free 0 page for user program
      jsr  WCA1F                        
      jmp  WC98D                        

WC9B7:
      lda  #$13                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      ldy  #$15                         
WC9BE:
      sty  $FD                          
      lda  #$38                         
      ldx  #$CE                         
      jsr  W85D9                        
      ldy  $FD                          
      dey                               
      bne  WC9BE                        
      lda  #$13                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      ldy  #$80                         
      ldx  #$3F                         
      lda  #$18                         
      sta  WCA6E+1                      
      lda  #$C8                         
      sta  WCA6E+2                      
WC9DF:
      lda  ($FB),y                      ; Free 0 page for user program
      jsr  WCA6C                        
      dec  WC9AE                        
      bne  WC9F7                        
      lda  #$03                         
      sta  WC9AE                        
      tya                               
      pha                               
      lda  #$0D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      pla                               
      tay                               
WC9F7:
      iny                               
      dex                               
      bne  WC9DF                        
      sec                               
      lda  WCA6E+1                      
      sbc  #$01                         
      sta  WCA6E+1                      
      lda  WCA6E+2                      
      sbc  #$00                         
      sta  WCA6E+2                      
      lda  #$13                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      ldx  #$3F                         
      tya                               
      sec                               
      sbc  #$7F                         
      tay                               
      bpl  WC9DF                        
      pla                               
      sta  W82A8                        
      rts                               

WCA1F:
      ldx  #$04                         
WCA21:
      asl                               
      bcs  WCA4C                        
      asl                               
      pha                               
      bcc  WCA33                        
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  WC817                        
      sta  $0286                        ; Current char color code
WCA33:
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      pla                               
      dex                               
      bne  WCA21                        
      lda  #$00                         
      sta  $0286                        ; Current char color code
      rts                               

WCA4C:
      asl                               
      pha                               
      bcs  WCA5E                        
      lda  WC816                        
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WCA33                        

WCA5E:
      lda  WC818                        
      sta  $0286                        ; Current char color code
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WCA33                        

WCA6C:
      stx  $FD                          
WCA6E:
      ldx  $FFFF                        
      stx  $0286                        ; Current char color code
      ldx  #$08                         
WCA76:
      asl                               
      pha                               
      bcc  WCA8C                        
      lda  #$12                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$20                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      jmp  WCA91                        

WCA8C:
      lda  #$1D                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
WCA91:
      pla                               
      dex                               
      bne  WCA76                        
      lda  #$00                         
      sta  $0286                        ; Current char color code
      ldx  $FD                          
      rts                               

WCA9D:
  .byte $00
WCA9E:
  .byte $00, $00, $04, $00, $D8
WCAA3:
      lda  #$00                         
      ldx  #$04                         
      sta  $FB                          ; Free 0 page for user program
      stx  $FC                          
      ldx  WCA9E                        
WCAAE:
      beq  WCAC1                        
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  #$28                         
      sta  $FB                          ; Free 0 page for user program
      lda  $FC                          
      adc  #$00                         
      sta  $FC                          
      dex                               
      jmp  WCAAE                        

WCAC1:
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  WCA9D                        
      sta  $FB                          ; Free 0 page for user program
      sta  $FD                          
      lda  $FC                          
      adc  #$00                         
      sta  $FC                          
      clc                               
      adc  #$D4                         
      sta  $FE                          ; Free 0 page for user program
      rts                               

WCAD7:
      jsr  WCAA3                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      bmi  WCB00                        
      lda  WC81B                        
      bmi  WCAE7                        
      bne  WCAF0                        
WCAE7:
      lda  #$2A                         
      sta  ($FB),y                      ; Free 0 page for user program
      lda  #$00                         
      sta  ($FD),y                      
      rts                               

WCAF0:
      lda  #$2A                         
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      lda  #$00                         
      dey                               
      sta  ($FD),y                      
      iny                               
      sta  ($FD),y                      
      rts                               

WCB00:
      lda  WC81B                        
      bmi  WCB07                        
      bne  WCB0C                        
WCB07:
      lda  #$AA                         
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB0C:
      lda  #$AA                         
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB14:
      jsr  WCAA3                        
      ldy  #$00                         
      lda  ($FB),y                      ; Free 0 page for user program
      bmi  WCB31                        
      lda  WC81B                        
      bmi  WCB24                        
      bne  WCB29                        
WCB24:
      lda  #$20                         
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB29:
      lda  #$20                         
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB31:
      lda  WC81B                        
      bmi  WCB38                        
      bne  WCB3D                        
WCB38:
      lda  #$A0                         
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB3D:
      lda  #$A0                         
      sta  ($FB),y                      ; Free 0 page for user program
      iny                               
      sta  ($FB),y                      ; Free 0 page for user program
      rts                               

WCB45:
      lda  #$00                         
      pha                               
      stx  WCB6D                        
      ldx  #$08                         
WCB4D:
      lda  ($FB),y                      ; Free 0 page for user program
      bmi  WCB57                        
WCB51:
      pla                               
      clc                               
      rol                               
WCB54:
      jmp  WCB63                        

WCB57:
      lda  ($FD),y                      
      and  #$0F                         
      cmp  W82A8                        
      bne  WCB51                        
      pla                               
      sec                               
      rol                               
WCB63:
      pha                               
      iny                               
      dex                               
      bne  WCB4D                        
      ldx  WCB6D                        
      pla                               
      rts                               

WCB6D:
      brk                               
WCB6E:
      lda  W82A8                        
      pha                               
      lda  WC816                        
      sta  W82A8                        
      lda  #$00                         
      ldx  #$04                         
      sta  $FB                          ; Free 0 page for user program
      sta  $FD                          
      stx  $FC                          
      lda  #$D8                         
      sta  $FE                          ; Free 0 page for user program
      lda  #$03                         
      sta  WC9AE                        
      lda  WC81D                        
      ldx  WC81E                        
      sta  WCBDB+1                      
      stx  WCBDB+2                      
      clc                               
      adc  #$40                         
      sta  WCBC9+1                      
      txa                               
      adc  #$00                         
      sta  WCBC9+2                      
      lda  WC81D                        
      clc                               
      adc  #$80                         
      sta  WCBCF+1                      
      txa                               
      adc  #$00                         
      sta  WCBCF+2                      
      ldy  #$00                         
      ldx  #$00                         
WCBB6:
      lda  WC81B                        
      bmi  WCBC3                        
      bne  WCBD8                        
      jsr  WCB45                        
      jmp  WCBDB                        

WCBC3:
      jsr  WCC0B                        
      lda  WCC67                        
WCBC9:
      sta  $FFFF,x                      
      lda  WCC68                        
WCBCF:
      sta  $FFFF,x                      
      lda  WCC66                        
      jmp  WCBDB                        

WCBD8:
      jsr  WCC69                        
WCBDB:
      sta  $FFFF,x                      
      dec  WC9AE                        
      bne  WCBFE                        
      clc                               
      lda  $FB                          ; Free 0 page for user program
      adc  #$28                         
      sta  $FB                          ; Free 0 page for user program
      sta  $FD                          
      lda  $FC                          
      adc  #$00                         
      sta  $FC                          
      clc                               
      adc  #$D4                         
      sta  $FE                          ; Free 0 page for user program
      ldy  #$00                         
      lda  #$03                         
      sta  WC9AE                        
WCBFE:
      inx                               
      cpx  #$3F                         
      bne  WCBB6                        
      pla                               
      sta  W82A8                        
      jsr  WCAD7                        
      rts                               

WCC0B:
      lda  #$00                         
      sta  WCC66                        
      sta  WCC67                        
      sta  WCC68                        
      txa                               
      pha                               
      ldx  #$08                         
WCC1A:
      lda  WCC66                        
      asl                               
      sta  WCC66                        
      lda  WCC67                        
      asl                               
      sta  WCC67                        
      lda  WCC68                        
      asl                               
      sta  WCC68                        
      lda  ($FB),y                      ; Free 0 page for user program
      bpl  WCC5F                        
      lda  ($FD),y                      
      and  #$0F                         
      cmp  WC816                        
      beq  WCC4C                        
      cmp  WC817                        
      beq  WCC57                        
      lda  WCC68                        
      ora  #$01                         
      sta  WCC68                        
      jmp  WCC5F                        

WCC4C:
      lda  WCC66                        
      ora  #$01                         
      sta  WCC66                        
      jmp  WCC5F                        

WCC57:
      lda  WCC67                        
      ora  #$01                         
      sta  WCC67                        
WCC5F:
      iny                               
      dex                               
      bne  WCC1A                        
      pla                               
      tax                               
      rts                               

WCC66:
      brk                               
WCC67:
      brk                               
WCC68:
      brk                               
WCC69:
      stx  WCB6D                        
      lda  #$00                         
      pha                               
      ldx  #$04                         
WCC71:
      lda  ($FB),y                      ; Free 0 page for user program
      bmi  WCC7C                        
      pla                               
      clc                               
      rol                               
      rol                               
      jmp  WCC9F                        

WCC7C:
      lda  ($FD),y                      
      and  #$0F                         
      cmp  WC816                        
      beq  WCC9A                        
      cmp  WC817                        
      beq  WCC92                        
      pla                               
      sec                               
      rol                               
      sec                               
      rol                               
      jmp  WCC9F                        

WCC92:
      pla                               
      clc                               
      rol                               
      sec                               
      rol                               
      jmp  WCC9F                        

WCC9A:
      pla                               
      sec                               
      rol                               
      clc                               
      rol                               
WCC9F:
      pha                               
      iny                               
      iny                               
      dex                               
      bne  WCC71                        
      ldx  WCB6D                        
      pla                               
      rts                               

WCCAA:
      lda  #$0E                         
      sta  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  #$52                         
      ldx  #$CE                         
      jsr  W85D9                        
      lda  WC5C5                        
      clc                               
      adc  #$30                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      lda  #$92                         
      jsr  $aB47                        ; Routine: Introduces a char in canal+ errors and char
      rts                               

WCCCB:
      lda  #$0F                         
      sta  $D6                          ; Cursor line number
      lda  #$1A                         
      sta  $D3                          ; Column of cursor on the current line
      jsr  $E56C                        ; Routine: Goto X=line, Y=col. of cursore
      lda  WC5C4                        
      bmi  WCCE3                        
      lda  #$5F                         
      ldx  #$CE                         
      jsr  W85D9                        
      rts                               

WCCE3:
      lda  #$6B                         
      ldx  #$CE                         
      jsr  W85D9                        
      rts                               

  .byte $93, $12, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $46
  .byte $4C, $4F, $50, $50, $59, $2D, $42, $45
  .byte $46, $45, $48, $4C, $45, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $92, $0D, $0D, $0D, $20, $46
  .byte $4C, $4F, $50, $50, $59, $2D, $53, $54
  .byte $41, $54, $55, $53, $3A, $00, $43, $4F
  .byte $4D, $4D, $41, $4E, $44, $3A, $00, $24
  .byte $0D, $0D, $11, $11, $20, $20, $20, $20
  .byte $3C, $3C, $3C, $20, $50, $52, $45, $53
  .byte $53, $20, $41, $4E, $59, $20, $4B, $45
  .byte $59, $20, $3E, $3E, $3E, $00, $30, $20
  .byte $00, $12, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $92, $00, $12, $20, $92
  .byte $11, $9D, $00, $42, $4C, $4F, $43, $4B
  .byte $3A, $00, $43, $4F, $4C, $4F, $52, $20
  .byte $23, $31, $3A, $00, $43, $4F, $4C, $4F
  .byte $52, $20, $23, $32, $3A, $00, $43, $4F
  .byte $4C, $4F, $52, $20, $23, $33, $3A, $00
  .byte $42, $4F, $52, $44, $45, $52, $20, $20
  .byte $3A, $00, $53, $43, $52, $45, $45, $4E
  .byte $20, $20, $3A, $00, $45, $58, $50, $41
  .byte $4E, $44, $20, $58, $3A, $00, $45, $58
  .byte $50, $41, $4E, $44, $20, $59, $3A, $00
  .byte $53, $49, $4E, $47, $4C, $45, $2D, $43
  .byte $4F, $4C, $4F, $52, $00, $4D, $55, $4C
  .byte $54, $49, $2D, $43, $4F, $4C, $4F, $52
  .byte $20, $00, $4F, $56, $45, $52, $4C, $41
  .byte $59, $20, $20, $20, $20, $20, $00, $20
  .byte $20, $20, $20, $20, $54, $52, $41, $4E
  .byte $53
WCDF4:
  .byte $46, $45, $52, $20, $42, $4C, $4F, $43
  .byte $4B
WCDFD:
  .byte $20
WCDFE:
  .byte $20, $20, $20, $20, $54, $4F, $20, $42
  .byte $4C, $4F, $43, $4B, $20, $20, $20, $20
  .byte $2E, $00, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $00, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20
WCE44:
  .byte $20
WCE45:
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $0D, $00, $12, $20, $43
  .byte $4F, $4C, $4F, $52, $20, $20, $20, $9D
  .byte $9D, $00, $12, $20, $20, $20, $43, $4C
  .byte $52, $20, $20, $20, $92, $00, $12, $20
  .byte $20, $20, $53, $45, $54, $20, $20, $20
  .byte $92, $00, $53, $41, $56, $45, $20, $46
  .byte $52, $4F, $4D, $20, $42, $4C, $4F, $43
  .byte $4B, $20, $20, $20, $20, $20, $54, $4F
  .byte $20, $42, $4C, $4F, $43, $4B, $00, $46
  .byte $49, $4C, $45, $4E, $41, $4D, $45, $20
  .byte $3A, $20, $00, $4C, $4F, $41, $44, $20
  .byte $46, $52, $4F, $4D, $20, $42, $4C, $4F
  .byte $43, $4B, $20, $00, $93, $12, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $53, $50, $52, $49
  .byte $54, $45, $2D, $54, $41, $42, $4C, $45
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $92, $0D
  .byte $20, $20, $20, $20, $20, $20, $20, $30
  .byte $20, $20, $20, $31, $20, $20, $20, $32
  .byte $20, $20, $20, $33, $20, $20, $20, $34
  .byte $20, $20, $20, $35, $20, $20, $20, $36
  .byte $20, $20, $20, $37, $20, $20, $20, $0D
  .byte $20, $20, $C0, $C0, $C0, $C0, $C0, $C0
  .byte $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
  .byte $C0
WCF16:
  .byte $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
  .byte $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
  .byte $C0, $C0, $C0, $C0, $0D, $20, $4F, $4E
  .byte $20, $20, $20, $3A, $0D, $20, $4D, $55
  .byte $4C, $54, $49, $3A, $0D, $20, $45, $58
  .byte $50, $2E, $58, $3A, $0D, $20, $45, $58
  .byte $50, $2E, $59, $3A, $0D, $20, $43, $4F
  .byte $4C, $4F, $52, $3A, $0D, $20, $42, $4C
  .byte $4F, $43, $4B, $3A, $11, $0D, $00, $12
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20
WCF6D:
  .byte $20
WCF6E:
  .byte $41, $4E, $49, $4D, $41, $54, $49, $4F
WCF76:
  .byte $4E, $20, $20, $20, $20, $20, $20, $20
  .byte $20, $20, $20, $20, $20, $20, $20, $20
  .byte $92, $11, $00, $20, $53, $50, $52, $49
  .byte $54, $45, $20, $20, $20, $46, $52, $4F
  .byte $4D, $20, $20, $20, $20, $20, $20, $54
  .byte $4F, $20, $20, $20, $20, $20, $20, $53
  .byte $50, $45, $45, $44, $0D, $00, $1E, $64
  .byte $3C, $64, $5A, $64, $78, $64, $96, $64
  .byte $B4, $64, $D2, $64, $F0, $64, $00, $1B
  .byte $1F, $D1, $D1, $01, $C8, $00, $15, $79
  .byte $F0, $00
WCFC8:
  .byte $00, $00, $00, $00, $00, $0F, $0F, $0F
  .byte $0F, $0B, $0C, $00, $00, $00, $00, $00
  .byte $00, $00, $00, $80, $80, $80, $80, $80
  .byte $80, $80, $80, $80, $80, $80, $80, $80
  .byte $80, $80, $80, $80, $80, $80, $80, $80
  .byte $80, $80, $80, $0A, $0A, $0A, $0A, $0A
  .byte $0A, $0A, $0A, $00, $00, $00, $00, $00
