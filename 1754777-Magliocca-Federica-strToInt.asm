.globl main
.data
stringa: .asciiz "dammi una stringa:"
base: .asciiz "\ndammi una base:"
comma: .asciiz ", "
.text
main: 
li $v0,4            #stampa la stringa "dammi una stringa"
la $a0,stringa
syscall

addi $t0,$a0,60    #salva in $t0 l'indirizzo della stringa inserita in input
li $v0,8           #legge la stringa inserita
la $a0,($t0)
li $a1,8
syscall

li $v0,4          #stampa la stringa "dammi una base"
la $a0,base
syscall

li $v0,5          #legge l'intero in input
syscall

la $a0,($t0)      #salva in $a0 l'indirizzo della stringa in input
add $a1,$v0,$zero  #salva in $a1 la base

jal StrToInt

move $a0,$v0    #stampa il contentuto di $v0
li $v0,36
syscall

li $v0,17      #termina il programma
li $a0,0    
syscall

StrToInt:
subi $sp,$sp,12
sw $t3,8($sp)
sw $ra,4($sp)
sw $a0,0($sp)

lb $t1,($a0)       #salva in $t1 il primo carattere della stringa
addi $t4,$zero,10  
beq $t1,$t4,CasoBase   #se $t1 è uguale a \n salta al  caso base
beq $t1,$zero,CasoBase #se $t1 è uguale a \0 salta al caso base

CheckDigit:
slti $t2,$t1,0x30      #0x30 è '0'
bgt  $t2,$zero,Errore  #se $t1 è minore di 0x30 non è nè una lettera nè un numero
slti $t2,$t1,0x39      #0x39 è '9'
beq  $t2,$zero,CheckUpperCase  #se $t1 è maggiore di 0x39 può essere una lettera
subi $t3,$t1,48                
blt  $t3,$a1,Continue   #se $t1 è minore della base il carattere è valido 

CheckUpperCase:
slti $t2,$t1,0x41      #0x41 è 'A'
bgt  $t2,$zero,Errore  #se $t1 è minore di 0x41 non è una lettera
slti $t2,$t1,0x5B      #0x5B è 'Z'
beq  $t2,$zero,CheckLowerCase  #se $t1 è maggiore di 0x5B può essere una lettera minuscola
subi $t3,$t1,55
blt  $t3,$a1,Continue  #se $t1 è minore della base il carattere è valido

CheckLowerCase:
slti $t2,$t1,0x61      #0x61 è 'a'
bgt  $t2,$zero,Errore  #se $t1 è minore di 0x61 non è una lettera minuscola
slti $t2,$t1,0x7B      #0x7B è 'z'
beq  $t2,$zero,Errore  #se $t1 è maggiore di 0x7B è un altro simbolo
subi $t3,$t1,87
blt  $t3,$a1,Continue  #se $t1 è minore della base il carattere è valido

Errore:
add $v0,$zero,$zero    
add $v1,$zero,$zero

subi $v0,$zero,1    #salva in $v0 -1
addi $v1,$zero,1    # salva in $v1 1

move $a0,$v0        #stampa il contenuto di $v0
li $v0,1
syscall

li $v0,17          #termina il programma con un errore
li $a0,33
syscall

Continue:
addi $a0,$a0,1       #va al carattere sucessivo
jal StrToInt

lw $a0,0($sp)
lw $ra,4($sp)
lw $t3,8($sp)
addi $sp,$sp,12

add $s1,$s0,$zero    
addi $t5,$zero,1    #salva in $t5 1
blt $s1,$zero,Fine  
While:              #calcola b^i
ble $s1,$zero,Stop  #se $s1 è minore di 0 esce dal while
mul $t5,$t5,$a1     #moltiplica 1 per la base
subi $s1,$s1,1      #$1=$1-1
j While
Stop:
mul $t5,$t5,$t3    #moltiplica l'ultimo carattere per b^i
add $v0,$v0,$t5    #aggiunge a $v0 ai*b^i
addi $t5,$zero,0   #svuota $t5
addi $s0,$s0,1     #passa al carattere precedente

Fine:
jr $ra

CasoBase:
add $v0,$zero,$zero  #salva in $v0 0
add $v1,$zero,$zero  #salva in $v1 0
jr $ra




