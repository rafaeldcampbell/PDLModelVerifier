# Verificador de Modelos PDL
### Projeto para a disciplina de Linguagem de Programação
#### Prof. Bruno Lopes, 2019-1


O projeto consiste em um verificador de modelos PDL. O objetivo central é permitir que o usuário entre com um modelo, composto por uma lista das arestas indexadas e um programa que deseja testar, recebendo as respostas "True" caso o modelo se verifique e "False" caso contrário.
O projeto está todo implementado em Haskell, sendo necessário um compilador GHC para executá-lo. Para isso, basta seguir:
1. Primeiro, instale um compilador GHC. Nos recomendamos o ["Haskell Plataform"](https://www.haskell.org/platform/), pois o pacote conta com outras funcionalidades.
2. Abrir o terminal GHCi. Caso tenha seguido por nossa sugestão, a aplicação para Windows se chama `"WinGHCi"`.
3. No ambiente, carregue o arquivo `"test.hs"`, seguindo:
```Haskell
:l "test.hs"
```
4. Em seguida, basta entrar com o teste que se deseja fazer, seguindo a forma:
> runTest <grafo_de_lugares> <programa_a_ser_testado>

Ex.:
```Haskell
runTest [('1', '2', 'a'), ('2', '3', 'b')] {- (A ^ B); -}
         (Node '^' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'b' Empty Empty) Empty))
```
**Obs.:** O arquivo também conta com uma lista de 9 testes pré-definidos que podem ser executados. Para isso, basta executar `"run"+(0-9)`. Por exemplo: `run4`.

Para facilitar o desenvolvimento, alguns padrões foram convencionados. Aqui nós apresentaremos uma breve explicação para permitir ao usuário escrever os próprios testes.

### Grafo de lugares
O grafo consiste em um vetor de tuplas da forma:
> (<lugar_de_saída>, <lugar_de_chegada>, <label_da_aresta>)

Só é importante lembrar que todos os elementos da tupla são `Char` e que os lugares devem ser números de 0 a 9.
Ex.:
```Haskell
('1', '2', 'a')
('2', '3', 'b')
```

### Árvore de Teste

O teste usa uma estrutura de árvore definida como:

```Haskell
data Tree = Empty | Node Char (Tree) (Tree)
```

Ele pode ser definido como

> `Empty` (Para quando estiver vazia) <br>
> `Node 'no' (subArvore_da_esquerda) (subArvore_da_direita)` (Para qualquer nó da árvore)

Os nós serão tanto os operadores (nos nós não-folha) quanto as execuções (nos nós folha), podendo ser também uma verificação de estado (como o `p` em `?p`). Para estes nós, outros padrões são definidos e devem ser seguidos rigorosamente.

1. Todo programa em sequência (ainda que seja uma sequência de uma única execução) deve ser sub-árvore à esquerda de um nó `';'`. Por exemplo:
```Haskell
{- a; -}
(Node ';' (Node 'a' Empty Empty) Empty)
```

Para continuar a sequencia, deve-se garantir que todos os filhos à direita sejam `Empty` ou `';'`, com os filhos à esquerda sendo as execuções em sequência. Por exemplo:
```Haskell
{- a;b;c; -}
(Node ';' (Node 'a' Empty Empty) (Node ';' (Node 'b' Empty Empty) (Node ';' (Node 'c' Empty Empty) Empty)))
```

2. Para operadores, deve ser usado como nó um dos símbolos correspondentes aos operadores em PDL e seus parâmetros serão nós em suas sub-àrvores.

| Símbolo PDL   | Nome                      |  Nó  |
| :------------:|:-------------------------:|:----:|
|       ->      | Implicação                | '>'  |
|       U       | Escolha não-determinística| 'v'  |
|       ^       | Conjunção                 | '^'  |
|       !       | Negação                   | '!'  |
|       <>      | Ao menos um               | '<'  |
|       ;       | Sequência                 | ';'  |
|       ?       | Teste *                   | '?'  |

(*) Para este projeto, estamos considerando uma função avaliadora vazia, logo, todo teste retorna `falso`.

Ex.:
```Haskell
{- (a; U b;) -}
(Node 'v' (Node ';' (Node 'a' Empty Empty) Empty) (Node ';' (Node 'b' Empty Empty)))
```

Também foi convencionado que, para operadores unários, usa-se somente a sub-árvore da esquerda, mantendo o valor `Empty` à direita. No caso dos operadores binários (como no exemplo acima), cada elemento deve ficar em um de seus filhos.

Ex.:
```Haskell
{- !a; -}
(Node '!' (Node ';' (Node 'a' Empty Empty) Empty) Empty)
```
