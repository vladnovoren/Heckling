.186
.model tiny
.code
org 100h


start:
        call greeting
        mov dx, offset enter_passwrd_buf
        call enter_str
        mov si, offset enter_passwrd_buf
        add si, 2
        mov di, offset right_passwrd
        call cmp_strings
        cmp ax, 1
        je permission_denied_start
        call accessed
        jmp end_of_passwd_check_start
permission_denied_start:
        call permission_denied
end_of_passwd_check_start:
        mov ah, 4ch
        xor al, al
        int 21h

; буферы
enter_passwrd_buf db 254, 255 dup(0), '$'

right_passwrd db 3, 3, 3, 3, 3, 0dh
right_passwrd_len dd $ - right_passwrd

greeting_str db "Hello, enter password.", 0dh, 0ah, '$'

permission_denied_str db "Wrong password, permission denied.", 0dh, 0ah, '$'
accessed_str db "Accessed.", 0dh,  0ah, '$'

;--------------------------------------------------------------------------------
; сравнение строк
; si - смещение первой строки
; di - смещение второй строки
; результат записывается в ax:
; 0 - строки равны
; 1 - строки не равны
; destrlist:
; ax, bx
;--------------------------------------------------------------------------------
cmp_strings proc
        dec si
        dec di
cmp_strings_loop:
        inc si
        inc di
        mov al, byte ptr [si]
        mov bl, byte ptr [di]
        cmp al, bl
        jne strings_arent_equal
        cmp al, 0dh
        je strings_are_equal
        jmp cmp_strings_loop
strings_arent_equal:
        mov ax, 1
        ret
strings_are_equal:
        mov ax, 0
        ret
cmp_strings endp


;--------------------------------------------------------------------------------
; ввод пароля и проверка
;--------------------------------------------------------------------------------
enter_and_check_password proc
        call greeting
        ret
enter_and_check_password endp


;--------------------------------------------------------------------------------
; вывод строки из dx
; dx - смещение строки с '$' в конце
; destrlist:
; ax
;--------------------------------------------------------------------------------
out_str proc
        xor ax, ax
        mov ah, 09h
        int 21h
        ret
out_str endp


;--------------------------------------------------------------------------------
; вывод приветствия
;--------------------------------------------------------------------------------
greeting proc
        mov dx, offset greeting_str
        push ax
        call out_str
        pop ax
        ret
greeting endp


;--------------------------------------------------------------------------------
; вывод строки, что пароль неверен
;--------------------------------------------------------------------------------
permission_denied proc
        mov dx, offset permission_denied_str
        push ax
        call out_str
        pop ax
        ret
permission_denied endp


;--------------------------------------------------------------------------------
; вывод строки, что пароль верен
;--------------------------------------------------------------------------------
accessed proc
        mov dx, offset accessed_str
        push ax
        call out_str
        pop ax
        ret
accessed endp


;--------------------------------------------------------------------------------
; ввод строки по смещению из dx
; destrlist:
; ax
;--------------------------------------------------------------------------------
enter_str proc
        xor ax, ax
        mov ah, 0ah
        int 21h
        ret
enter_str endp



end start


