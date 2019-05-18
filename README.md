# CompScript
Script para compilar o projecto e executar os testes fornecidos

## Compatibilidade
O script só corre em Linux.

**Pessoas que têm a librts numa directoria que não é a default, comentem a linha 1, editem e descomentem a linha 2. Quem está a usar a VM não tem de fazer isto.**

## Instalação e resultados
* Fazer download (ali ao lado)
* Copiar para a pasta onde está o código do projecto (onde está o Makefile):
```sh
$ unzip ~/Downloads/CompScript-master.zip -d ~/path/para/a/pasta/do/projecto
```
* Dar permissões de execução:
```sh
$ chmod +x ./run.sh
```
* Executar:
```sh
$ ./run.sh
```

É gerado o ficheiro **"results.txt"** na directoria actual que mostra "Passed!" para cada teste sem erros e "Failed!" com as diferenças de output para cada teste que falhou. Teste que tiveram o output esperado, mas que não têm o return code 0 contam como 0.5. Exemplo:
```
B-12-20-N-ok.m19
        Passed

B-13-21-N-ok.m19
        Passed

B-14-22-N-ok.m19
        Failed:
1c1
< 1
---
> 0

B-15-23-N-ok.m19
        Failed at compiling file
```

## Estrutura
O script espera estar na pasta com o código do projecto e o Makefile, e que um nível acima esteja uma pasta chamada **tests** que tem os ficheiros de teste. Exemplo:
```
compiladores
├── m19
│   ├── run.sh
│   ├── Makefile
│   └── ast
│       └── ...
|
└── tests
    ├── expected
    │   ├── A-01-1-N-ok.out
    │   ├── A-02-2-N-ok.out
    │   ├── A-03-3-N-ok.out
    │   └── ...
    ├── A-01-1-N-ok.m19
    ├── A-02-2-N-ok.m19
    ├── A-03-3-N-ok.m19
    └── ...
```
