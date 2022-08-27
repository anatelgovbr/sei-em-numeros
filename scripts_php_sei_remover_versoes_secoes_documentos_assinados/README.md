# Script PHP para deletar versões de seção de documentos gerados no SEI
Script PHP para deletar versões de seção de documentos gerados no SEI, assinados e já bloqueados (caneta preta) a partir de determinado mês para trás do dia da execução do script.

## Requisitos
- Para o SEI 3.1.x, utilizar o script constante na pasta "script_php_sei3.1"
- Para o SEI 4.0.x, , utilizar o script constante na pasta "script_php_sei4.0"

## Orientações
1. Antes de tudo, vide na página do Arquivo Nacional: https://www.gov.br/arquivonacional/pt-br/servicos/gestao-de-documentos/orientacao-tecnica-1/codigo-de-classificacao-e-tabela-de-temporalidade-e-destinacao-de-documentos-de-arquivo
	- Portaria nº 47, de 14 de fevereiro de 2020: https://www.in.gov.br/en/web/dou/-/portaria-n-47-de-14-de-fevereiro-de-2020-244298005
	- Código de classificação e Tabela de temporalidade e destinação de documentos relativos às atividades-meio do Poder Executivo federal (versão corrigida em junho de 2020): https://www.gov.br/arquivonacional/pt-br/servicos/gestao-de-documentos/orientacao-tecnica-1/codigo-de-classificacao-e-tabela-de-temporalidade-e-destinacao-de-documentos-de-arquivo/cod_classif_e_tab_temp_2019_m_book_digital_25jun2020_1.pdf
2. Os scripts estão na pasta "tabela_assuntos_port47-2020-AN": https://github.com/anatelgovbr/sei-em-numeros/tree/master/tabela_assuntos_port47-2020-AN
	- Em todos os scripts tem um cabeçalho de orientações para sua execução.
	- Atenção especial para o item: "4) Verifique ANTES o alinhamento do maior ID na tabela principal com a seq_ correspondente, onde o maior ID deve ser o último na seq_ e o AUTO INCREMENT sobre ele deve ser esse maior ID +1. Se precisar, realinhe o maior valor na tabea seq_, pois, do contrário, vai dar erro de PK duplicada no insert na tabela principal."
