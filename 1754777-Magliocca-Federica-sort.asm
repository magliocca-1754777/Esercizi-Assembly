.globl main
.data
array: .word 3,3,-1,5,1,4,8,2
lunghezza: .asciiz "\ndammi un intero:"
errore: .asciiz "l'intero inserito è troppo grande, scegline uno più piccolo"
aCapo: .asciiz "\n"
nuovoArray: .word 0
.text
main:
la $a0,lunghezza    #stampa la stringa "dammi un intero"
li $v0,4
syscall

li $v0,5           #legge l'intero in input
syscall
move $a1,$v0

ble $a1,8,Go       #se l'intero in input è minore della lunghezza dell'array il programma viene eseguito 
                   #altrimenti stampa una stringa di errore e richiede un altro input all'utente
la $a0,errore
li $v0,4
syscall      
j main

Go:
la $a0,array       #salva in $a0 l'indirizzo dell'array

jal BubbleSort

Copy:
sll $t2,$a1,2       #lunghezza*4
add $t3,$a0,$t2     #salva in $t3 l'indirizzo dell'ultimo carattere da considerare
addi $a2,$zero,0    #lunghezza del nuovo array
la $v0,nuovoArray   #salva in $v0 l'indirizzo base del nuovo array
add $s3,$v0,$zero   #fa una copia di $v0
add $v1,$zero,$zero  #svuota $v1

ForArray:
beq $a0,$t3,Fine     #se l'indirizzo del carattere considerato è uguale all'indirizzo dell'ultimo carattere da considerare salta a Fine
lw $t1,($a0)         #carica in $t1 il carattere dell'array all'indirizzo $a0
addi $s0,$zero,0     #svouta $s0
la $a3,nuovoArray    #salva in $a3 l'indirizzo del nuovo array

ForNuovoArray:
beq $s0,$a2,Exit    #se $s0 è uguale alla lunghezza del nuovo array esce dal for
lw $t2,($a3)        #carica in $t2 il carattere del nuovo array all'indirizzo $a3
seq $s2,$t1,$t2     #se $t1 e $t2 sono uguali salva 1 in $s2 altrimenti 0
addi $a3,$a3,4      #va all'inidirzzo successivo
addi $s0,$s0,1      #incrementa $s0
j ForNuovoArray

Exit:
bne $s2,$zero,Next  #se $2 è uguale a 1 salta a Next
sw $t1,($s3)        #salva il carattere dell'array nel nuovo array

move $t5,$a0        #salva $a0 in $t5

move $a0,$t1        #salva in $a0 il carattere appena aggiunto al nuovo array e lo stampa
li $v0,1   
syscall

la $a0,aCapo       #va a capo
li $v0,4
syscall

move $a0,$t5        #ricarica in $a0 l'indirizzo dell'array temporaneamente salvato in $t5
addi $s3,$s3,4      #va all'indirizzo successivo del nuovo array
addi $a2,$a2,1      #incrementa la lunghezza del nuovo array dopo aver aggiunto un elemento
addi $v1,$v1,1      #incrementa $v1
Next:
addi $s2,$zero,0    #svouta $s2
addi $a0,$a0,4      #va all'indirizzo successivo dell'array
j ForArray

Fine:
li $v0,10           #termina il programma
syscall

BubbleSort:
subi $sp,$sp,12     
sw $ra,0($sp)
sw $a0,4($sp)
sw $a1,8($sp)

subi $a1,$a1,1     #decrementa la lunghezza dell'array
add $a2,$a0,$zero   #copia $a0 in $a2
beq $a1,$zero,CasoBase  #se $a1 è uguale a 0 salta al caso base
addi $t2,$zero,0     #inizializza $t2

For:
beq $t2,$a1,End     #se $t2 è uguale alla lunghezza dell'array salta a End
lw $s0,($a0)        #salva in $s0 il carattere dell'array
addi $t1,$a0,4      #salva in $t1 l'indirizzo del carattere successivo
lw $s1,($t1)        #salva in $s1 il carattere successivo
blt $s0,$s1,Continue  #se $s0 è minore di $1 continua il for
sw $s1,($a0)        #scambia il carattere con il successivo
sw $s0,($t1)

Continue:
addi $a0,$a0,4     #va all'indirizzo successivo dell'array
addi $t2,$t2,1     #incrementa $t2 
j For

End:
add $a0,$a2,$zero  #ricarica in $a0 l'indirizzo base dell'array
jal BubbleSort

lw $ra,0($sp)      
lw $a0,4($sp)
lw $a1,8($sp)
addi $sp,$sp,12

jr $ra

CasoBase:
jr $ra
