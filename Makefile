main:
	flex reconhecedor.l
	gcc -o compilador lex.yy.c 
	./compilador
