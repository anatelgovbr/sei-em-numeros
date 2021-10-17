# Scripts para criar Nova Tabela de Assuntos Arquivísticos
Scripts para criar Nova Tabela de Assuntos Arquivísticos com todos os Assuntos de Atividade-Meio da Portaria nº 47/2020 do Arquivo Nacional.

## Requisitos
- SEI 3.1.x instalado/atualizado.
- A Base de Referência para o Poder Executivo para o SEI 4.0.x já está com a Tabela de Assuntos Arquivísticos atualizada segundo a Portaria nº 47/2020 do Arquivo Nacional.
	- Vide: https://github.com/spbgovbr/sei-db-ref-executivo

## Orientações
1. Antes de tudo, vide na página do Arquivo Nacional: https://www.gov.br/arquivonacional/pt-br/servicos/gestao-de-documentos/orientacao-tecnica-1/codigo-de-classificacao-e-tabela-de-temporalidade-e-destinacao-de-documentos-de-arquivo
	- Portaria nº 47, de 14 de fevereiro de 2020: https://www.in.gov.br/en/web/dou/-/portaria-n-47-de-14-de-fevereiro-de-2020-244298005
	- Código de classificação e Tabela de temporalidade e destinação de documentos relativos às atividades-meio do Poder Executivo federal (versão corrigida em junho de 2020): https://www.gov.br/arquivonacional/pt-br/servicos/gestao-de-documentos/orientacao-tecnica-1/codigo-de-classificacao-e-tabela-de-temporalidade-e-destinacao-de-documentos-de-arquivo/cod_classif_e_tab_temp_2019_m_book_digital_25jun2020_1.pdf
2. Os scripts estão na pasta "tabela_assuntos_port47-2020-AN": https://github.com/anatelgovbr/sei-em-numeros/tree/master/tabela_assuntos_port47-2020-AN
	- Em todos os scripts tem um cabeçalho de orientações para sua execução.
	- Atenção especial para o item: "4) Verifique ANTES o alinhamento do maior ID na tabela principal com a seq_ correspondente, onde o maior ID deve ser o último na seq_ e o AUTO INCREMENT sobre ele deve ser esse maior ID +1. Se precisar, realinhe o maior valor na tabea seq_, pois, do contrário, vai dar erro de PK duplicada no insert na tabela principal."
3. O script "1_Cria-Nova-Tabela_Assuntos_Port47-2020-AN.sql" apenas cria o nome e descrição da Nova Tabela de Assuntos.
	- Os outros dois scripts abaixo utilizam como "id_tabela_assuntos" o valor "2".
	- Caso na instalação do SEI já tenha criado outras Tabelas de Assunto, trocar o valor em questão no próximo script a ser executado para o próximo ID, que será assumido pela Tabela de Assuntos criada por este script acima.
4. O script "2_Insere-Assuntos-na-Nova-Tabela_Assuntos_Port47-2020-AN_Sem-Subclasse080.sql" cria todos os Assuntos previstos na Portaria nº 47/2020 do Arquivo Nacional já os associando à nova Tabela de Assuntos criada no script do item 3 acima, SEM a Subclasse 080, pois ela somente pode ser utilizada no âmbito do Ministério da Defesa, nos Comandos Militares e nas organizações que os integram.
	- Se seu órgão não faz parte do Ministério da Defesa, Comandos Militares e organizações que os integram, UTILIZE ESTE SCRIPT!
5. O script "3_Insere-Assuntos-na-Nova-Tabela_Assuntos_Port47-2020-AN_Com-Subclasse080.sql" cria todos os Assuntos previstos na Portaria nº 47/2020 do Arquivo Nacional já os associando à nova Tabela de Assuntos criada no script do item 3 acima, COM a Subclasse 080, que deve ser utilizada SOMENTE no âmbito do Ministério da Defesa, Comandos Militares e organizações que os integram.
	- Não utilizar este script se seu órgão não for do âmbito do Ministério da Defesa, Comandos Militares e organizações que os integram.
	- Mesmo criando os Assuntos da Subclasse 080 neste script, eles são criados Desativados. Para utilizá-los deve antes Reativar todos estes assuntos.
6. Executados os dois scripts com sucesso, no SEI, no menu Administração > Tabela de Assuntos aparecerá a nova Tabela criada com o nome "Portaria nº 47/2020-AN e Atividades-Fim do Órgão" e os novos Assuntos associados a ela aparecerão na tela aberta pelo botão de ação "Assuntos da Tabela".
	- Em seguida, ainda deve:
		- Criar os Assuntos de Atividade-Fim do órgão, de sua Tabela de Assuntos de Atividade-Fim temporária ou oficial, no caso de já ter tabela aprovada oficialmente pelo Arquivo Nacional (lista consta na página acima do Arquivo Nacional).
		- Realizar na Tabela atual o “Mapeamento” dos Assuntos atuais que Classificam para os Novos Assuntos equivalentes que Classificam.
	- Somente depois de realizados os passos acima será possível acionar o botão de ação sobre a Nova Tabela "Ativar Tabela de Assuntos", momento no qual o SEI faz efetivamente a migração da Tabela atual para a nova.
