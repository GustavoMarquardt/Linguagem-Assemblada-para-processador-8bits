%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int endereco = 0;
int labelAdress [16];
char idLabel [16][30];
int contLabel = 0;
int i = 0;
char *hexToBinary(int hexDigit);
char* decimalToBinary(int decimal);
void escreveBinario(char* binario);

int linha = 0;
char* instrucao = "";
%}

NUMERO [0-9]
PALAVRA [a-zA-Z]
HEXADECIMAL   "x"([0-9A-F])*
DECIMAL   "d"([0-9])*
SPACE [ \t]
ENDL [ \n]
LABEL "_"({PALAVRA}+":")

%%
"E" { printf("Endereco: %d\n", endereco);}
{LABEL} {
    printf("Label encontrada: %s\n", yytext);
    labelAdress[contLabel] = endereco;
    strcpy(idLabel[contLabel], yytext);
    printf("%d\n", labelAdress[contLabel]);
    printf("%s\n", idLabel[contLabel]);
    contLabel++;
}
{DECIMAL}* {printf("DECIMAL reconhecido, mas nao e instrucao\n"); exit(0);}
{HEXADECIMAL}* {printf("HEXADECIMAL RECONHECIDO, mas nao e instrucao\n"); exit(0);}
";".* { /* Ignorar todo o conteúdo após ; até o final da linha */ }

LDA{SPACE}{HEXADECIMAL} { 
    printf("Instrucao: LDA seguido de espaco e numero hexadecimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'x');
     if (posicao_x != NULL) {
        int valor_hexadecimal = (int)strtol(posicao_x + 1, NULL, 16);
        printf("valor em decimal %d\n",valor_hexadecimal);
        if(valor_hexadecimal >= 16 || valor_hexadecimal < 0){
            printf("Valor menor do que 0 ou maior do que 16\n");
            exit(0);
        }
        char* binario = hexToBinary(valor_hexadecimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"0000");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor hexadecimal: %x\n", valor_hexadecimal);
    } else {
        printf("Padrão 'x' não encontrado na instrução.\n");
        exit(0);
    }
    }
LDA{SPACE}{DECIMAL} { 
    printf("Instrucao: LDA seguido de espaco e numero decimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'d');
     if (posicao_x != NULL) {
        int valor_decimal = (int)strtol(posicao_x + 1, NULL, 10);
        if(valor_decimal >= 10 || valor_decimal < 0){
            printf("Valor menor do que 0 ou maior do que 10\n");
            exit(0);
        }
        char* binario = hexToBinary(valor_decimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"0000");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor hexadecimal: %x\n", valor_decimal);
    } else {
        printf("Padrão 'x' não encontrado na instrução.\n");
        exit(0);
    }
}
LDA { printf("Instrucao: LDA reconhecido esta faltando valores na frente\n"); exit(0);}


LDB{SPACE}{HEXADECIMAL} { 
    printf("Instrucao: LDB seguido de espaco e numero hexadecimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'x');
     if (posicao_x != NULL) {
        int valor_hexadecimal = (int)strtol(posicao_x + 1, NULL, 16);
        if(valor_hexadecimal >= 16 || valor_hexadecimal < 0){
            printf("Valor menor do que 0 ou maior do que 16\n");
            exit(0);
        }
        char* binario = hexToBinary(valor_hexadecimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"0001");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor hexadecimal: %x\n", valor_hexadecimal);
    } else {
        printf("Padrão 'x' não encontrado na instrução.\n");
        exit(0);
    }
}
LDB{SPACE}{DECIMAL} { 
    printf("Instrucao: LDB seguido de espaco e numero decimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'d');
     if (posicao_x != NULL) {
        int valor_decimal = (int)strtol(posicao_x + 1, NULL, 10);
        if(valor_decimal >= 10 || valor_decimal < 0){
            printf("Valor menor do que 0 ou maior do que 10\n");
            exit(0);
        }
       char* binario = hexToBinary(valor_decimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"0001");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor hexadecimal: %x\n", valor_decimal);
    } else {
        printf("Padrão 'x' não encontrado na instrução.\n");
        exit(0);
    }
    }
LDB { printf("Instrucao: LDB reconhecido esta faltando valores na frente\n"); exit(0);}

JC{SPACE}{LABEL} {
    printf("JC seguido de um endereco para jump\n");
    for(i = 0; i < 16;i++){
        printf("Verificando %s-%s\n",yytext+3,idLabel[i]);
        if(strcmp(yytext+3,idLabel[i]) == 0){
            printf("%s\n\n", idLabel[i]);
            printf("%d",labelAdress[i]);
            char* binario = hexToBinary(labelAdress[i]);
            printf("binario %s\n",binario);
            char instrucao[10];
            strcpy(instrucao,"1011");
            strcat(instrucao,binario);
            escreveBinario(instrucao);
            break;
        }
        if(i == 15){
            printf("Label nao encontrada\n");
            exit(0);
        }
    }
}

JC {printf("Instrucao: JC esta faltando valores na frente\n");exit(0);}

JZ{SPACE}{LABEL} {
    printf("JZ seguido de um endereco para jump\n");
    for(i = 0; i < 16;i++){
        printf("Verificando %s-%s\n",yytext+3,idLabel[i]);
        if(strcmp(yytext+3,idLabel[i]) == 0){
            printf("%s\n\n", idLabel[i]);
            char* binario = hexToBinary(labelAdress[i]);
            printf("binario %s\n",binario);
            char instrucao[10];
            strcpy(instrucao,"1100");
            strcat(instrucao,binario);
            escreveBinario(instrucao);
            break;
        }
        if(i == 15){
            printf("Label nao encontrada\n");
            exit(0);
        }
    }
}
JZ {printf("Instrucao: JZ esta faltando valores na frente\n");exit(0);}

"LDAR RB" { 
    printf("Instrucao: LDAR seguido do registrador escolhido B copia RB para A\n"); 
    endereco++; 
    escreveBinario("10010000");
    }
"LDAR RC" { 
    printf("Instrucao: LDAR seguido do registrador escolhido C copia RC para A\n"); 
    endereco++; 
    escreveBinario("10010001");
    }

"LDBR RA" { 
    printf("Instrucao: LDBR seguido do registrador escolhido A copia RA para B\n"); 
    endereco++; 
    escreveBinario("10100000");
    
    }
"LDBR RC" { 
    printf("Instrucao: LDBR seguido do registrador escolhido C copia RC para B\n"); 
    endereco++; 
    escreveBinario("10100001");
    
    }


LDAR { printf("Instrucao: LDAR reconhecido esta faltando valores na frente\n"); exit(0);}
LDBR { printf("Instrucao: LDBR reconhecido esta faltando valores na frente\n"); exit(0);}

RAR{SPACE}{DECIMAL} { printf("Instrucao: RAR seguido de espaco e numero decimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'d');
     if (posicao_x != NULL) {
        int valor_decimal = (int)strtol(posicao_x + 1, NULL, 10);
        if(valor_decimal >= 4 || valor_decimal < 0){
            printf("Valor menor do que 0 ou maior do que 10\n");
            exit(0);
        }
        char* binario = hexToBinary(valor_decimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"1101");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor decimal: %x\n", valor_decimal);
    } else {
        printf("Padrao 'x' não encontrado na instrucao.\n");
        exit(0);
    }
}
RAR { printf("Instrucao: RAR reconhecido esta faltando valores na frente\n"); exit(0);}

RAL{SPACE}{DECIMAL} { printf("Instrucao: RAL seguido de espaco e numero decimal\n"); 
    endereco++;
    printf("%s\n",yytext);
    char *posicao_x = strchr(yytext,'d');
     if (posicao_x != NULL) {
        int valor_decimal = (int)strtol(posicao_x + 1, NULL, 10);
        if(valor_decimal >= 4 || valor_decimal < 0){
            printf("Valor menor do que 0 ou maior do que 10\n");
            exit(0);
        }
        char* binario = hexToBinary(valor_decimal);
        printf("binario %s\n",binario);
        char instrucao[10];
        strcpy(instrucao,"1110");
        strcat(instrucao,binario);
        escreveBinario(instrucao);
        printf("Valor decimal: %x\n", valor_decimal);
    } else {
        printf("Padrao 'x' não encontrado na instrucao.\n");
        exit(0);
    }
}
RAL { printf("Instrucao: RAL reconhecido esta faltando valores na frente\n");exit(0);}

"ADD" {printf("ADD reconhecido\n");
        endereco++;
        escreveBinario("00100000");
}
"SUB" {printf("SUB reconhecido\n");
    endereco++;
    escreveBinario("00110000");
}
"NOTA" {printf("NOTA reconhecido\n");
    endereco++;
    escreveBinario("01000000");
}
"NOTB" {printf("NOTB reconhecido\n");
    endereco++;
    escreveBinario("01010000");
}
"XOR" {printf("XOR reconhecido\n");
    endereco++;
    escreveBinario("01100000");
}
"OR" {printf("OR reconhecido\n");
    endereco++;
    escreveBinario("01110000");
}

"AND" {printf("AND reconhecido\n");
    endereco++;
    escreveBinario("10000000");
}
"RSTR" {printf("RSTR reconhecido\n");
    endereco = 11110000 ;
    escreveBinario("11110000");
}
{PALAVRA}+|({PALAVRA}+" "{PALAVRA}+)* {printf("Nenhuma funcao reconhecida\n");exit(0);}
.|\n { /* Ignorar outros caracteres */ }

%% 
int main() {
    FILE *arquivo = fopen("index.txt", "r");
    if (!arquivo) {
        fprintf(stderr, "Erro ao abrir o arquivo.\n");
        return 1;
    }

    // Configurar yyin para ler do arquivo
    yyin = arquivo;
    
    // Chame yylex para iniciar a análise léxica
    yylex();

    // Feche o arquivo após a conclusão
    fclose(arquivo);

    return 0;
}

int yywrap() {
    return 1; // Indica o fim da análise léxica
}


char* hexToBinary(int hexDigit) {
    printf("hexDigit %d\n",hexDigit);
    switch (hexDigit) {
        case 0: return "0000";
        case 1: return "0001";
        case 2: return "0010";
        case 3: return "0011";
        case 4: return "0100";
        case 5: return "0101";
        case 6: return "0110";
        case 7: return "0111";
        case 8: return "1000";
        case 9: return "1001";
        case 10: return "1010";
        case 11: return "1011";
        case 12: return "1100";
        case 13: return "1101";
        case 14: return "1110";
        case 15: return "1111";
        default: return NULL;  // Dígito inválido
    }
}



char* decimalToBinary(int decimal) {
    printf("decimal %d\n",decimal);
    switch (decimal) {
        case 0: return "0000";
        case 1: return "0001";
        case 2: return "0010";
        case 3: return "0011";
        case 4: return "0100";
        case 5: return "0101";
        case 6: return "0110";
        case 7: return "0111";
        case 8: return "1000";
        case 9: return "1001";
        case 10: return "1010";
        case 11: return "1011";
        case 12: return "1100";
        case 13: return "1101";
        case 14: return "1110";
        case 15: return "1111";
        default: return NULL;  // Dígito inválido
    }
}

void escreveBinario(char* binario) {
    if (binario != NULL && strlen(binario) > 0) {
        FILE *arquivo = fopen("binario.txt", "a"); 
        if (arquivo != NULL) {
            fprintf(arquivo, "%s\n", binario);
            linha++;
            fclose(arquivo);
        } else {
            printf("Erro: Não foi possível abrir o arquivo binario.txt para escrita.\n");
        }
    } else {
        printf("Erro: String binária nula ou vazia.\n");
    }
}