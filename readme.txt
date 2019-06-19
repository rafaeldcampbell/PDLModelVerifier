Para executar o código, será necessário um compilador Haskell.
Nós sugerimos "Haskell Plataform", que já conta com um ambiente interativo.
Depois de instalado o pacote, abra a aplicação do GHCi (em Windows, WinGHCi).
Abrindo a janela do compilador, primeiro carregue o programa executando:
===> :l "test.hs"
Em seguida, está disponível uma lista com 9 testes pré-definidos, nomeados como:
run + (1-9)
Para executar um dos testes, basta digitar seu nome. Por exemplo:
=====> run2
As respostas são devolvidas como "True" para verdadeiro e "False" para falso.

Caso se deseje inserir um novo teste, deve-se chamar a função runTest passando
como parâmetro um grafo e um programa em árvore a ser testado.

Para o grafo, só é necessário que se construa uma lista de tuplas na forma:
(Nó inicial, Nó final, Execução)
Para definir um grafo que só tem os lugares 1 e 2, tendo apenas uma aresta de
'a' de 1 para 2, podemos escrever algo como:
=======> [('1', '2', 'a')]

Para o teste, deve-se criar uma árvore de execução. Os elementos da árvore seguem
dois modelos:
====> Empty {- Se estiver vazio -}
====> Node 'Nó' (SubArvore da esquerda) (SubArvore da direita) {- Se estiver preenchido -}
No geral, os Nós sempre tem seu símbolo em 'Nó' e os elementos onde opera como filhos.
Os simbolos são:
? -> teste
! -> Negação
v -> Escolha não determinística
^ -> Conjunção
< -> Ao menos uma execução
; -> Sequência
> -> Implicação
Para melhor execução, alguns padrões foram convencionados.
1º Para toda sequencia de elementos (mesmo que de um elemento só), o primeiro nó
é sempre o ';'. Caso se deseje listar várias execuções, deve-se colocar na subárvore
da direita outro ';' (e assim por diante), mantendo os nós listados sempre na subarvore
da esquerda. Exemplo de A;B;C:

====> (Node ';' (Node 'A' Empty Empty) (Node ';' (Node 'B' Empty Empty) (Node ';' (Node 'C' Empty Empty) Empty)))

No caso dos operadores binários, os elementos a serem avaliados são colocados um em cada subárvore.
Exemplo de A v B:

====> (Node 'v' (Node ';' (Node 'A' Empty Empty) Empty) (Node ';' (Node 'B' Empty Empty) Empty))

E, no caso dos operadores unários, mantém-se o elemento a ser avaliado à esquerda, deixando 
a subárvore da direita vazia. Exemplo de !A:

====> (Node '!' (Node ';' (Node 'A' Empty Empty) Empty) Empty)