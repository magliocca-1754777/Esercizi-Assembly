.globl main
.data
Matrix: .word 0x80FFFFFF,0x80FFFFFF,0xFF822433,0xFFC79900,0xFF822433,0xFF822433,0xFF822433,0xFFC79900
N: .word 2  #righe
M: .word 4  #colonne
spazio: .asciiz " "
aCapo: .asciiz "\n"
.text
main:
la $a0,Matrix # Matrice
lw $a1,N  # $sa1 = N
lw $a2,M  # $a2 = M 
mul $a3,$a2,$a1 # N*M
sll $t6,$a3,2
add $t6,$a0,$t6 #indirizzo finale della matrice
sll $t7,$a2,2 
jal Reflect

Negative:
beq $a0,$t6,End #se $a0 è uguale all'ultimo indirizzo della matrice salta alla fine
add $t1,$a0,$zero #fa una copia di $a0
addi $t2,$t1,3   #salva in $t2 l'indirizzo dell'ultimo byte da leggere
addi $t8,$t8,1   #contatore
For:
lb $t3,($t1)    #salva in $t3 il byte da considerare
beq $t1,$t2,Exit #se $t1 è uguale all'indirizzo dell'ultimo byte della word esce
addi $s0,$zero,-1 #salva in $s0 FF
sub $s0,$s0,$t3   #FF - il byte considerato
sb $s0,($t1)      #salva in memoria il nuovo byte
addi $t1,$t1,1    #va al byte successivo
j For
Exit:
move $t5,$a0     #fa una copia di $a0

lw $a0,($a0)    #stampa in esadecimale l'elemento della matrice che si trova all'indirizzo $a0
li $v0,34       
syscall

la $a0,spazio   #stampa lo spazio
li $v0,4
syscall

bne $a2,$t8,Continue    #se il contatore è uguale alla lunghezza della riga va a capo
la $a0,aCapo
li $v0,4
syscall
addi $t8,$zero,0       #svuota il contatore

Continue:
move $a0,$t5           #ricarica in $a0 l'indirizzo temporaneamente in $t5
addi $a0,$a0,4         #va all'indirizzo della word successiva
j Negative

End:
li $v0,10           #termina il programma
syscall

Reflect:
subi $sp,$sp,8        
sw $ra,0($sp)
sw $a0,4($sp)

beq $a0,$t6,BaseCase   #se $a0 è uguale all'ultimo indirizzo della matrice salta al caso base
add $a3,$a0,$t7        #salva in $a3 l'indirizzo della riga successiva (n)
subi $s3,$a3,4         #salva in $s3 l'indirizzo dell'ultimo elemento della riga (n-1)
addi $s1,$a0,4

ForColonne:
beq $a0,$a3,EndFor    #se $a0 è uguale all'indirizzo alla fine della riga esce dal for
bge $a0,$s1,Next      #se $a0 è l'indirizzo a metà della riga salta a Next
lw $t1,($a0)          # Matrice[i]=Matrice[n-1]
lw $t3,($s3)
sw $t3,($a0)
sw $t1,($s3)
addi $s1,$s3,0       #fa una copia di $s3
subi $s3,$s3,4       #decrementa n
Next:
addi $a0,$a0,4      #incrementa i
j ForColonne
EndFor:
jal Reflect

lw $ra,0($sp)
lw $a0,4($sp)
addi $sp,$sp,8

jr $ra
BaseCase:
jr $ra
