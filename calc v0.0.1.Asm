
format PE GUI 4.0
entry inicio

include 'Win32a.inc'
ventana_1   equ     1
;numeros
btn0	    equ     100
btn1	    equ     101
btn2	    equ     102
btn3	    equ     103
btn4	    equ     104
btn5	    equ     105
btn6	    equ     106
btn7	    equ     107
btn8	    equ     108
btn9	    equ     109
;operaciones
btnAdd	    equ     110
btnRes	    equ     111
btnMul	    equ     112
btnDiv	    equ     113
btnIgual    equ     114
;funciones y otros
btnSqrt     equ     115
btnCuad     equ     116
btnElN	    equ     117
consola     equ     120
consola1    equ     121
btnSen	    equ     122
btnCos	    equ     123
btnTan	    equ     124
ca	    equ     125
btnPlot     equ     126
macro insert num
 {
	local primera,final,primera1,segundaP
	push ebx
	push eax
	push esi
	cmp [bandOp],1
	jae segundaP
		mov bl,num
		add bl,30h
		mov esi,buff
		add esi,[cont]
		mov [esi],ebx
		cmp [ma],0
		je primera
		mov eax,[ma]
		mov ebx,10
		mul ebx
		mov ebx,num
		add eax,ebx
		mov [ma],eax
		jmp final
	primera:
		mov ebx,num
		mov [ma],ebx
		jmp final
		
	segundaP:
		mov bl,num
		add bl,30h
		mov esi,buff
		add esi,[cont]
		mov [esi],ebx
		cmp [mb],0
		je primera1
		mov eax,[mb]
		mov ebx,10
		mul ebx
		mov ebx,num
		add eax,ebx
		mov [mb],eax
		jmp final
	primera1:
		mov ebx,num
		mov [mb],ebx
	final:
	pop esi
	pop eax
	pop ebx
 }
macro calcular
 {	
	local OSen,OCos,OTan,OElN,Ocuad,Oraiz,Osuma,Oresta,Omult,terminar,ciclo,codT
	finit
	cmp [mo],8
	je OSen
	cmp [mo],9
	je OCos
	cmp [mo],10
	je OTan
	cmp [mo],7
	je OElN
	cmp [mo],6
	je Ocuad
	cmp [mo],5
	je Oraiz
	cmp [mo],1
	je Osuma
	cmp [mo],2
	je Oresta
	cmp [mo],3
	je Omult
	
	fld [ma]
	fld [mb]
	fdivp st1,st	
	jmp terminar
	
	Omult:
	fild [ma]
	fild [mb]
	fmul st,st1
	jmp terminar
	
	Oresta:
	fild [ma]
	fild [mb]
	fsubp st1,st	
	jmp terminar
	
	Osuma:
	fild [ma]
	fild [mb]
	fadd st,st1
	jmp  terminar
	
	Oraiz:
	fild [mb]
	fsqrt 
	jmp terminar
	
	Ocuad:
	fild [ma]
	fmul st,st
	jmp terminar
	
	OElN:
	fild [ma]
	fld1 
	ciclo:
	cmp [mb],0
	je terminar
	fmul st,st1
	dec [mb]
	jmp ciclo
	
	OSen:
	fild [mb]
	fsin
	
	jmp terminar
	
	OCos:
	fild [mb]
	fcos
	jmp terminar
	
	OTan:
	fild [mb]
	fptan 
	
	fistp [mb]
	;fistp [ma]
	;jmp codT
	
	terminar:
	fwait 
	fst [num]
	fistp [ma]
	codT:
	mov [mb],0
 }
section '.data' data readable writeable

Ist	dd		0
pWnd	dd		0
hdc	dd		0
ps			PAINTSTRUCT
pts	rq 20
num dq ?
cad rb 100
format_Out	db '%.10f',0

msgSen db "Usted grafico un Seno",0
msgCos db "Usted grafico un Coseno",0
msgTan db "Usted grafico una Tangente",0
msgRaiz db "Usted grafico una Raiz",0
msgParabola db "Usted grafico una Parabola",0
msgGrafico db "Ventana Random",0

buff dd 100 dup(0)
cont dd 1 dup(0)
clearAll db "0",0
msgError db "Error ",0

bandNum dd 1 dup (0)
ma dd 1 dup (0)
mb dd 1 dup (0)

bandOp db 1 dup(0)
mo db 1 dup(0)
 
section '.code' code readable executable

inicio:
	invoke GetModuleHandle,0
	mov [Ist],eax
	invoke DialogBoxParam,eax,ventana_1,0,DlgProc,0 
fin:
	invoke ExitProcess,0

proc DlgProc,hWnd,uMsg,wParam,lParam
	push edi esi ebx
	
	mov eax,[uMsg]
	cmp	eax,WM_COMMAND
	je	jCOMMAND
	cmp	eax,WM_INITDIALOG
	je	jINITDIALOG
	cmp	eax,WM_CLOSE
	je	jCLOSE
	xor eax,eax
	jmp finish
	

jINITDIALOG:
	mov eax,[hWnd]
	mov [pWnd],eax
	mov eax,1
	jmp finish
	
jCOMMAND:
	mov eax,[wParam]
	cmp	eax,1000
	je	salir
	cmp eax,ca
	je borrarTodo
	cmp eax,btnIgual
	je Igual
	cmp eax,btn9
	je ing9
	cmp eax,btn8
	je ing8
	cmp eax,btn7
	je ing7
	cmp eax,btn6
	je ing6
	cmp eax,btn5
	je ing5
	cmp eax,btn4
	je ing4
	cmp eax,btn3
	je ing3
	cmp eax,btn2
	je ing2
	cmp eax,btn1
	je ing1
	cmp eax,btn0
	je ing0
	cmp eax,btnAdd
	je opAdd
	cmp eax,btnRes
	je opRes
	cmp eax,btnMul
	je opMul
	cmp eax,btnDiv
	je opDiv
	cmp eax,btnSqrt
	je opRaiz
	cmp eax,btnCuad
	je opCuad
	cmp eax,btnElN
	je opElN
	cmp eax,btnSen
	je opSen
	cmp eax,btnCos
	je opCos
	cmp eax,btnTan
	je opTan
	cmp eax,btnPlot
	je plotear
	xor eax,eax
	jmp finish

	
ing0:
	insert 0
	jmp p9
ing1:
	insert 1
	jmp p9
ing2:
	insert 2
	jmp p9
ing3:
	insert 3
	jmp p9
ing4:
	insert 4
	jmp p9
ing5:
	insert 5
	jmp p9
ing6:
	insert 6
	jmp p9
ing7:
	insert 7
	jmp p9
ing8:
	insert 8
	jmp p9
ing9:
	insert 9
	jmp p9
	
p9:
	mov [bandNum],1
	inc [cont]
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	
	mov eax,1
	jmp finish
	
opAdd:
	cmp [bandOp],0
	je sa
	calcular
	sa:
	mov esi,buff
	add esi,[cont]
	
	cmp [bandNum],1
	je contiA
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiA:
	inc [bandOp]
	mov [mo],1
	mov ebx,2bh
	mov [esi],ebx
	jmp continueO

opRes:
	cmp [bandOp],0
	je sr
	calcular
	sr:
	mov esi,buff
	add esi,[cont]
	
	cmp [bandNum],1
	je contiR
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiR:
	inc [bandOp]
	mov [mo],2
	mov ebx,2dh
	mov [esi],ebx
	jmp continueO

opMul:
	cmp [bandOp],0
	je sm
	calcular
	sm:
	mov esi,buff
	add esi,[cont]
	
	cmp [bandNum],1
	je contiM
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiM:
	inc [bandOp]
	mov [mo],3
	mov ebx,2ah
	mov [esi],ebx
	jmp continueO
	
opDiv:
	cmp [bandOp],0
	je sd
	calcular
	sd:
	mov esi,buff
	add esi,[cont]
	cmp [bandNum],1
	je contiD
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiD:
	inc [bandOp]
	mov [mo],4
	mov ebx,2fh
	mov [esi],ebx
	jmp continueO

opElN:
	cmp [bandOp],0
	je se
	calcular
	se:
	mov esi,buff
	add esi,[cont]
	
	cmp [bandNum],1
	je contiE
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiE:
	inc [bandOp]
	mov [mo],7
	mov ebx,5eh
	mov [esi],ebx
	
	
	continueO:
	mov [bandNum],0
	inc [cont]
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s2
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s2:
	mov eax,1
	jmp finish
	
opRaiz:
	cmp [mo],0
	jne finish
	mov esi,buff
	add esi,[cont]
	mov ebx,53h
	mov [esi],ebx
	inc esi
	mov ebx,71h
	mov [esi],ebx
	inc esi
	mov ebx,72h
	mov [esi],ebx
	inc esi
	mov ebx,74h
	mov [esi],ebx
	add [cont],4
	mov [mo],5
	inc [bandOp]
	
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s3
	calcular
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s3:
	mov eax,1
	jmp finish
	
opSen:
	cmp [mo],0
	jne finish
	mov esi,buff
	add esi,[cont]
	mov ebx,53h
	mov [esi],ebx
	inc esi
	mov ebx,65h
	mov [esi],ebx
	inc esi
	mov ebx,6eh
	mov [esi],ebx
	add [cont],3
	mov [mo],8
	inc [bandOp]
	
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s8
	calcular
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s8:
	mov eax,1
	jmp finish
	
opCos:
	
	cmp [mo],0
	jne finish
	mov esi,buff
	add esi,[cont]
	mov ebx,43h
	mov [esi],ebx
	inc esi
	mov ebx,6fh
	mov [esi],ebx
	inc esi
	mov ebx,73h
	mov [esi],ebx
	add [cont],3
	mov [mo],9
	inc [bandOp]
	
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s9
	calcular
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s9:
	mov eax,1
	jmp finish
	
opTan:
	cmp [mo],0
	jne finish
	mov esi,buff
	add esi,[cont]
	mov ebx,54h
	mov [esi],ebx
	inc esi
	mov ebx,61h
	mov [esi],ebx
	inc esi
	mov ebx,6eh
	mov [esi],ebx
	add [cont],3
	mov [mo],10
	inc [bandOp]
	
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s10
	calcular
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s10:
	mov eax,1
	jmp finish
	
opCuad:
	cmp [bandOp],0
	je sc
	calcular
	sc:
	mov esi,buff
	add esi,[cont]
	cmp [bandNum],1
	je contiC
	mov ebx,30h
	mov [esi],ebx
	inc [cont]
	inc esi
	contiC:
	inc [bandOp]
	mov [mo],6
	mov ebx,5eh
	mov [esi],ebx
	inc esi
	mov ebx,32h
	mov [esi],ebx
	add [cont],2
	
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,buff
	cmp [bandOp],1
	je s4
	calcular
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	s4:
	mov eax,1
	jmp finish	


	
Igual:
	
	calcular
	cmp [ma],080000000h
	je Error
	cmp [mo],1
	je dispEnt
	cmp [mo],2
	je dispEnt
	cmp [mo],3
	je dispEnt
	cmp [mo],6
	je dispEnt
	cmp [mo],7
	je dispEnt
	invoke sprintf,cad,format_Out,dword[num],dword[num+4]
	invoke SendDlgItemMessage,[pWnd],consola,WM_SETTEXT,0,cad
	jmp pBM
	dispEnt:
	invoke SetDlgItemInt,[pWnd],consola,[ma],1
	pBM:
	stdcall borrarMem	
	mov eax,1
	jmp finish

borrarTodo:
	invoke SendDlgItemMessage,[pWnd],consola1,WM_SETTEXT,0,clearAll
	invoke SendDlgItemMessage,[pWnd],consola,WM_SETTEXT,0,clearAll
	stdcall borrarMem
	
	invoke GetDlgItem,[pWnd],1001
	push eax
	invoke ShowWindow,eax,SW_HIDE
	pop eax
	invoke ShowWindow,eax,SW_SHOW
	
	mov eax,1
	jmp finish

Error:
	invoke SendDlgItemMessage,[pWnd],consola,WM_SETTEXT,0,msgError
	mov eax,1
	jmp finish
	
plotear:
	stdcall generarEje
	
	cmp [mo],6
	je parabola
	cmp [mo],5
	je  raiz
	cmp [mo],8
	je seno
	cmp [mo],9
	je coseno
	cmp [mo],10
	je tangente
	jmp stP
	parabola:
	invoke CreatePen,PS_SOLID,2,0ff0000h
	invoke SelectObject,[hdc],eax
	invoke Arc,[hdc],165,-1000,435,200,165,-500,300,200
	invoke Arc,[hdc],165,-1000,435,200,300,200,435,-500
	invoke	MessageBox ,HWND_DESKTOP,msgParabola,msgGrafico,MB_OK
	jmp stP
	
	raiz:
	invoke CreatePen,PS_SOLID,2,0ffff0h
	invoke SelectObject,[hdc],eax
	invoke Arc,[hdc],300,-100,7500,500,3750,-100,300,200
	invoke	MessageBox ,HWND_DESKTOP,msgRaiz,msgGrafico,MB_OK
	jmp stP
	seno:
	stdcall graficSen
	invoke	MessageBox ,HWND_DESKTOP,msgSen,msgGrafico,MB_OK
	jmp stP
	
	coseno:
	stdcall graficCos
	invoke	MessageBox ,HWND_DESKTOP,msgCos,msgGrafico,MB_OK
	jmp stP
	
	tangente:
	stdcall graficTan
	invoke	MessageBox ,HWND_DESKTOP,msgTan,msgGrafico,MB_OK
	stP:
	
	invoke EndPaint,[pWnd],ps
	mov eax,1
	jmp finish

salir:
	invoke SendMessage,[hWnd],WM_CLOSE,0,0
	mov eax,1
	jmp finish
	
jCLOSE: 
	invoke EndDialog,[hWnd],0
	mov eax,1
	
finish:
	pop ebx esi edi
	ret
endp
proc graficTan
	;punto1
	mov dword[pts],60
	mov dword[pts+4],0
	;punto 2
	mov dword[pts+8],40
	mov dword[pts+12],300
	;punto 3
	mov dword[pts+16],-60
	mov dword[pts+20],100
	;punto 4
	mov dword[pts+24],-80
	mov dword[pts+28],400
	
	invoke CreatePen,PS_SOLID,2,0FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,4
	
	;punto1
	mov dword[pts],215
	mov dword[pts+4],0
	;punto 2
	mov dword[pts+8],195
	mov dword[pts+12],300
	;punto 3
	mov dword[pts+16],95
	mov dword[pts+20],100
	;punto 4
	mov dword[pts+24],75
	mov dword[pts+28],400
	
	invoke CreatePen,PS_SOLID,2,0FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,4
	
	;punto1
	mov dword[pts],370
	mov dword[pts+4],0
	;punto 2
	mov dword[pts+8],350
	mov dword[pts+12],300
	;punto 3
	mov dword[pts+16],250
	mov dword[pts+20],100
	;punto 4
	mov dword[pts+24],230
	mov dword[pts+28],400
	
	invoke CreatePen,PS_SOLID,2,0FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,4
	
	;punto1
	mov dword[pts],525
	mov dword[pts+4],0
	;punto 2
	mov dword[pts+8],505
	mov dword[pts+12],300
	;punto 3
	mov dword[pts+16],405
	mov dword[pts+20],100
	;punto 4
	mov dword[pts+24],385
	mov dword[pts+28],400
	
	invoke CreatePen,PS_SOLID,2,0FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,4
	
	;punto1
	mov dword[pts],680
	mov dword[pts+4],0
	;punto 2
	mov dword[pts+8],660
	mov dword[pts+12],300
	;punto 3
	mov dword[pts+16],560
	mov dword[pts+20],100
	;punto 4
	mov dword[pts+24],540
	mov dword[pts+28],400
	
	invoke CreatePen,PS_SOLID,2,0FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,4
	
	ret
	endp

proc graficCos
	mov dword[pts],0	
	mov dword[pts+4],150
	;punto 2
	mov dword[pts+8],50
	mov dword[pts+12],150
	;punto 3
	mov dword[pts+16],90
	mov dword[pts+20],335
	;punto 4
	mov dword[pts+24],220
	mov dword[pts+28],200
	;punto 5
	mov dword[pts+32],300
	mov dword[pts+36],134
	;punto 6
	mov dword[pts+40],300
	mov dword[pts+44],134
	;punto 7
	mov dword[pts+48],380
	mov dword[pts+52],200
	;punto 8
	mov dword[pts+56],510
	mov dword[pts+60],335
	;punto 9
	mov dword[pts+64],550
	mov dword[pts+68],150
	;punto 10
	mov dword[pts+72],600
	mov dword[pts+76],150
	
	invoke CreatePen,PS_SOLID,2,0FF000h
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,10
	ret
	endp

proc graficSen
	mov dword[pts],0	
	mov dword[pts+4],195
	;punto 2
	mov dword[pts+8],140
	mov dword[pts+12],35
	;punto 3
	mov dword[pts+16],150
	mov dword[pts+20],370
	;punto 4
	mov dword[pts+24],300
	mov dword[pts+28],200
	;punto 5
	mov dword[pts+32],450
	mov dword[pts+36],30
	;punto 6
	mov dword[pts+40],460
	mov dword[pts+44],365
	;punto 7
	mov dword[pts+48],600
	mov dword[pts+52],205
	
	invoke CreatePen,PS_SOLID,2,0FF00FFh
	invoke SelectObject,[hdc],eax
	invoke PolyBezier,[hdc],pts,7
	
	ret
	endp

proc generarEje
	invoke GetDC,[pWnd]
	mov [hdc],eax
	invoke CreatePen,PS_SOLID,2,0FFFFFFh
	invoke SelectObject,[hdc],eax
	invoke MoveToEx,[hdc],300,0,0
	invoke LineTo,[hdc],300,400
	invoke MoveToEx,[hdc],0,200,0
	invoke LineTo,[hdc],600,200
	
	invoke CreatePen,PS_SOLID,1,0FFFFFFh
	invoke SelectObject,[hdc],eax
	
	invoke MoveToEx,[hdc],0,0,0
	invoke LineTo,[hdc],0,400
	invoke MoveToEx,[hdc],50,0,0
	invoke LineTo,[hdc],50,400
	invoke MoveToEx,[hdc],100,0,0
	invoke LineTo,[hdc],100,400
	invoke MoveToEx,[hdc],150,0,0
	invoke LineTo,[hdc],150,400
	invoke MoveToEx,[hdc],200,0,0
	invoke LineTo,[hdc],200,400
	invoke MoveToEx,[hdc],250,0,0
	invoke LineTo,[hdc],250,400
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	invoke MoveToEx,[hdc],350,0,0
	invoke LineTo,[hdc],350,400
	invoke MoveToEx,[hdc],400,0,0
	invoke LineTo,[hdc],400,400
	invoke MoveToEx,[hdc],450,0,0
	invoke LineTo,[hdc],450,400
	invoke MoveToEx,[hdc],500,0,0
	invoke LineTo,[hdc],500,400
	invoke MoveToEx,[hdc],550,0,0
	invoke LineTo,[hdc],550,400
	invoke MoveToEx,[hdc],600,0,0
	invoke LineTo,[hdc],600,400
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	invoke MoveToEx,[hdc],0,0,0
	invoke LineTo,[hdc],600,0
	invoke MoveToEx,[hdc],0,50,0
	invoke LineTo,[hdc],600,50
	invoke MoveToEx,[hdc],0,100,0
	invoke LineTo,[hdc],600,100
	invoke MoveToEx,[hdc],0,150,0
	invoke LineTo,[hdc],600,150
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	invoke MoveToEx,[hdc],0,250,0
	invoke LineTo,[hdc],600,250
	invoke MoveToEx,[hdc],0,300,0
	invoke LineTo,[hdc],600,300
	invoke MoveToEx,[hdc],0,350,0
	invoke LineTo,[hdc],600,350
	invoke MoveToEx,[hdc],0,400,0
	invoke LineTo,[hdc],600,400
	
	ret
	endp

proc borrarMem
	mov [ma],0
	mov [mb],0
	mov [mo],0
	mov [cont],0
	mov [bandOp],0
	mov [bandNum],0
	ret
	endp
section '.idata' import data readable writeable
	library kernel32,'KERNEL32.DLL',user32,'USER32.DLL',gdi32,'GDI32.DLL',msvcrt,'MSVCRT.DLL' 
	include 'api\kernel32.inc'
	include 'api\user32.inc'
	include 'api\gdi32.inc'
	import msvcrt,\ 
	sprintf,	  'sprintf',\
	sscanf, 	  'sscanf' 
  

section '.rsrc' resource from 'calc v0.0.1.res' data readable
