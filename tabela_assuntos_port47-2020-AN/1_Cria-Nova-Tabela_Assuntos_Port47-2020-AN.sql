-- ATENÇÃO:
	-- 1) Observe que o script abaixo inicia com a desativação do autocommit.
	-- 2) Ao final do script tem o comando de ROLLBACK comentado. Descomentar e executar caso apresente algum ERRO.
	-- 3) Executando tudo OK, então executar ao final em separado os comandos COMMIT e SET autocommit=1.
	-- 4) Verifique ANTES o alinhamento do maior ID na tabela principal com a seq_ correspondente, onde o maior ID deve ser o último na seq_ e o AUTO INCREMENT sobre ele deve ser esse maior ID +1. Se precisar, realinhe o maior valor na tabea seq_, pois, do contrário, vai dar erro de PK duplicada no insert na tabela principal.

USE sei;
SET autocommit=0;

START TRANSACTION;
INSERT INTO seq_tabela_assuntos (campo) VALUES (0);
INSERT INTO tabela_assuntos (id_tabela_assuntos,nome,descricao,sin_atual) VALUES (LAST_INSERT_ID(),'Portaria nº 47/2020-AN e Atividades-Fim do Órgão','Tabela de Assuntos Arquivísticos de Atividades-Meio aprovada pela Portaria AN nº 47, de 14 de fevereiro de 2020, do Arquivo Nacional e Assuntos Arquivísticos de Atividades-Fim do Órgão','N');


-- ROLLBACK;
COMMIT;
SET autocommit=1;