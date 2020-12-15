.data
taxa: .float  0.05
peso1: .float 0.000000
saida: .ascii  "\nsaida: \n"
.text
main:
	# INICIO - inicializa valores utilizados no codigo, relacionados a main
    addiu   $sp,$sp,-72
    sw      $fp,68($sp)
    move    $fp,$sp
	# FIM - inicializa valores utilizados no codigo, relacionados a main

	# INICIO - inicializa conjunto de dados, vetor com os numeros de 1 a 5
	li      $2,1                        
	sw      $2,40($fp)		# coloca o valor 1 na posição 0 do vetor
	li      $2,2                       
	sw      $2,44($fp) 		# coloca o valor 2 na posição 1 do vetor
	li      $2,3                        
	sw      $2,48($fp) 		# coloca o valor 3 na posição 2 do vetor
	li      $2,4                        
	sw      $2,52($fp) 		# coloca o valor 4 na posição 3 do vetor
	li      $2,5                       
	sw      $2,56($fp) 		# coloca o valor 5 na posição 4 do vetor
	# FIM - inicializa conjunto de dados, vetor com os numeros de 1 a 5
	
	# INICIO - inicializa a taxa de aprendizado do neuronio com o valor 0.05
	la     $2,taxa
	lwc1    $f0,0($2)
	nop
	swc1    $f0,24($fp)
	# FIM - inicializa a taxa de aprendizado do neuronio com o valor 0.05

	# INICIO - inicializa a epoca do neuronio com o valor de 5 iteracoes
	li      $2,5                        
	sw      $2,28($fp)
	# FIM - inicializa a epoca do neuronio com o valor de 5 iteracoes

	# INICIO - inicializa os pesos das entradas, o primeiro com valor de 0.000000 e o segundo com valor 0.800000
	sw      $0,8($fp)
	la     $2,peso1
	lwc1    $f0,0($2)
	nop
	swc1    $f0,12($fp)
	# FIM - inicializa os pesos das entradas, o primeiro com valor de 0.000000 e o segundo com valor 0.800000

	sw      $0,32($fp) # inicializa o valor de erro como 0
	sw      $0,36($fp) # inicializa o valor de soma como 0
	sw      $0,16($fp) # inicializa o i da iteracao como 0
$L3:
	# INICIO - define a condicao e o passo da iteracao
	lw      $3,16($fp)
	lw      $2,28($fp)
	nop
	slt     $2,$3,$2
	beq     $2,$0,$L2
	nop
	# FIM - define a condicao e o passo da iteracao

	# INICIO - multiplica a primeira entrada pelo primeiro peso
	lw      $2,16($fp)
	nop
	sll     $2,$2,2
	addiu   $3,$fp,8
	addu    $2,$3,$2
	lw      $2,32($2)
	nop
	mtc1    $2,$f0
	nop
	cvt.s.w $f2,$f0
	lwc1    $f0,8($fp)
	nop
	mul.s   $f2,$f2,$f0
	# FIM - multiplica a primeira entrada pelo primeiro peso

	# INICIO - multiplica a segunda entrada pelo segundo peso
	lw      $2,16($fp)
	nop
	sll     $2,$2,2
	addiu   $3,$fp,8
	addu    $2,$3,$2
	lw      $2,32($2)
	nop
	mtc1    $2,$f0
	nop
	cvt.s.w $f4,$f0
	lwc1    $f0,12($fp)
	nop
	mul.s   $f0,$f4,$f0
	# FIM - multiplica a segunda entrada pelo segundo peso
	
	# INICIO - soma as duas multiplicacoes realizadas anteriormente
	add.s   $f0,$f2,$f0
	swc1    $f0,36($fp)
	# FIM - soma as duas multiplicacoes realizadas anteriormente

	# INICIO - calculo do erro
		# INICIO - realiza a soma das entradas sem os pesos
			# INICIO - separa a primeira entrada especifica da iteracao do conjunto de dados
			lw      $2,16($fp)
			nop
			sll     $2,$2,2
			addiu   $3,$fp,8
			addu    $2,$3,$2
			lw      $3,32($2)
			# FIM - separa a entrada especifica da iteracao do conjunto de dados

			# INICIO - separa a segunda entrada especifica da iteracao do conjunto de dados
			lw      $2,16($fp)
			nop
			sll     $2,$2,2
			addiu   $4,$fp,8
			addu    $2,$4,$2
			lw      $2,32($2)
			
			# FIM - separa a segunda entrada especifica da iteracao do conjunto de dados
			
		nop
		addu    $2,$3,$2
		# FIM - realiza a soma das entradas sem os pesos
		# INICIO - realiza a subtracao da soma das entradas sem os pesos pela soma das entradas com os pesos
		mtc1    $2,$f0
		nop
		cvt.s.w $f2,$f0
		lwc1    $f0,36($fp)
		nop
		sub.s   $f0,$f2,$f0
		swc1    $f0,32($fp)
		# FIM - realiza a subtracao da soma das entradas sem os pesos pela soma das entradas com os pesos
	# FIM - calculo do erro

	# INICIO - atualizacao do peso1
		lwc1    $f2,32($fp) 	# separa o erro
		lwc1    $f0,24($fp) 	# separa a taxa de aprendizado
		nop
		mul.s   $f2,$f2,$f0 	# multiplica a taxa pelo erro
		# INICIO - realiza a separacao da entrada especifica, ou seja da posicao do vetor do conjunto de dados
		lw      $2,16($fp)
		nop
		sll     $2,$2,2
		addiu   $3,$fp,8
		addu    $2,$3,$2
		lw      $2,32($2)
		nop
		mtc1    $2,$f0
		nop
		cvt.s.w $f0,$f0
		# FIM - realiza a separacao da entrada especifica, ou seja da posicao do vetor do conjunto de dados
		mul.s   $f0,$f2,$f0  	# multiplica a entrada especifica pelo resultado da multiplicacao da taxa pelo erro
		lwc1    $f2,8($fp) 
		nop
		add.s   $f0,$f2,$f0 	# realiza a adicao do valor atual do peso1 com o resultado da multiplicacao anterior
		swc1    $f0,8($fp)
	# FIM - atualizacao do peso1

	# INICIO - atualizacao do peso2
		lwc1    $f2,32($fp)		# separa o erro
		lwc1    $f0,24($fp)		# separa a taxa de aprendizado
		nop
		mul.s   $f2,$f2,$f0		# multiplica a taxa pelo erro
		# INICIO - realiza a separacao da entrada especifica, ou seja da posicao do vetor do conjunto de dados
		lw      $2,16($fp)
		nop
		sll     $2,$2,2
		addiu   $3,$fp,8
		addu    $2,$3,$2
		lw      $2,32($2)
		nop
		mtc1    $2,$f0
		nop
		cvt.s.w $f0,$f0
		# FIM - realiza a separacao da entrada especifica, ou seja da posicao do vetor do conjunto de dados
		mul.s   $f0,$f2,$f0		# multiplica a entrada especifica pelo resultado da multiplicacao da taxa pelo 
		lwc1    $f2,12($fp)
		nop
		add.s   $f0,$f2,$f0		# realiza a adicao do valor atual do peso1 com o resultado da multiplicacao anterior
		swc1    $f0,12($fp)
	# FIM - atualizacao do peso2
	
	# INICIO - realiza a adicao da iteracao do loop e verifica a condicao para rodar novamente
	lw      $2,16($fp)
	nop
	addiu   $2,$2,1 		# adiciona 1 ao valor do index
	sw      $2,16($fp)
	b       $L3				# retorna ao bloco L3
	nop
	# FIM - realiza a adicao da iteracao do loop e verifica a condicao para rodar novamente

	# INICIO - inicializa o outro loop para mostrar as saidas obtidas
$L2:
	sw      $0,20($fp)
$L5:
	lw      $3,20($fp)
	lw      $2,28($fp)
	nop
	slt     $2,$3,$2
	beq     $2,$0,$L4 		# define a condicao do loop, a qual se nao for respeitada pulara para o bloco L4
	nop
	# FIM - inicializa o outro loop para mostrar as saidas obtidas

	# INICIO - calcula as saidas com os pesos obtidos no treinamento
		# INICIO - separa a posicao do vetor do conjunto de dados especifica da entrada da iteracao atual
		lw      $2,20($fp)
		nop
		sll     $2,$2,2
		addiu   $3,$fp,8
		addu    $2,$3,$2
		lw      $2,32($2)
		nop
		mtc1    $2,$f0
		nop
		cvt.s.w $f2,$f0
		# FIM - separa a posicao do vetor do conjunto de dados especifica da entrada da iteracao atual
	lwc1    $f0,8($fp) 		# separa o valor do primeiro peso
	nop
	mul.s   $f2,$f2,$f0 	# multiplica a posicao do vetor(entrada) pelo primeiro peso
		# INICIO - separa a posicao do vetor do conjunto de dados especifica da entrada da iteracao atual
		lw      $2,20($fp)
		nop
		sll     $2,$2,2
		addiu   $3,$fp,8
		addu    $2,$3,$2
		lw      $2,32($2)
		nop
		mtc1    $2,$f0
		nop
		cvt.s.w $f4,$f0
		# FIM - separa a posicao do vetor do conjunto de dados especifica da entrada da iteracao atual
	lwc1    $f0,12($fp) 	# separa o valor do segundo peso
	nop
	mul.s   $f0,$f4,$f0 	# multiplica a posicao do vetor(entrada) pelo segundo peso
	add.s   $f0,$f2,$f0		# soma a multiplicacao das duas entradas pelos seus respectivos pesos
	swc1    $f0,36($fp)
	# FIM - calcula as saidas com os pesos obtidos no treinamento

	li $v0, 4
	la $a0, saida			# imprime "saida"
	syscall
	mov.s $f12, $f0		
	li $v0, 2				# imprime o valor da saida correspondente a iteracao atual
	syscall

	# INICIO - realiza a adicao da iteracao do loop e verifica a condicao para rodar novamente
	lw      $2,20($fp)
	nop
	addiu   $2,$2,1			# adiciona 1 ao valor do index
	sw      $2,20($fp)
	b       $L5				# retorna ao bloco L5
	nop
	# FIM - realiza a adicao da iteracao do loop e verifica a condicao para rodar novamente
$L4:
	# INICIO - retorna 0 para funcao main e finaliza o programa
	move    $2,$0
	move    $sp,$fp
	lw      $fp,68($sp)
	addiu   $sp,$sp,72

	nop
	jr $ra
	# FIM - retorna 0 para funcao main e finaliza o programa

