# Script PHP para deletar versões de seção de documentos gerados no SEI
Script PHP para deletar versões de seção de documentos gerados no SEI, bloqueados (caneta preta) e assinados há mais de X meses da data da execução do script.

## Requisitos
- Para o SEI 3.1.x, utilizar o script constante na pasta "script_php_sei3.1"
- Para o SEI 4.0.x, , utilizar o script constante na pasta "script_php_sei4.0"

## Orientações
1. O presente script foi desenvolvido originalmente pelo TRF4 para o SEI 4.1.
	- **Atenção**: No SEI 4.1 vierá o script definitivo e terá coluna adicional no banco de dados para informar que determinado documento já passou pelo processamento de expurgo de versões de seção de documentos assinados, fazendo com que sua próxima execução seja mais rápida.
	- Até o SEI 4.1, utilizando os scripts aqui indicados, adaptados para o SEI 3.1 e para o SEI 4.0, toda execução do script levará MUITO tempo de processamento, pois analisará praticamente todos os documentos novamente.
2. Ao executar o script será solicitado um usuário/senha de banco que deve ter permissão de acesso total a base de dados, para criação ou exclusão de tabelas (permissão de DDL).
3. Rodar o script para limpeza (expurgo) de versões de seção de documentos gerados no SEI, bloqueados (caneta preta) e assinados há mais de X meses da data da execução do script:

		/usr/bin/php -c /etc/php.ini /opt/sei/scripts/sei_remover_versoes_secoes_documentos_assinados.php 6 2>&1 >> remover_versoes.log
		
	- Onde o "**6**" é o parâmetro do número de meses para trás, a contar da data da execução do script, a partir da qual o sistema fará a limpeza (expurgo) de versões de seção de documentos gerados no SEI, bloqueados (caneta preta) e assinados até o primeiro documento constante no banco que atenda às regras.

4. Dependendo da quantidade de documentos gerados, assinados e com caneta preta existentes na instalação do SEI, o tempo de execução do script pode levar muitas horas.
	- O script pode ser executado em qualquer horário, pois não prejudica o desempenho no uso da aplicação.
	- Em uma instalação com quase 6 milhões de linhas na tabela "versao_secao_documento" retornados pelo SELECT abaixo utilizando uma "dth_atualizacao" de 6 meses do dia da execução, o tempo total de execução do script PHP foi de cerca de 13 horas.

		SELECT
		-- d.id_documento
		-- ,d.sin_bloqueado
		-- ,d.sta_documento
		-- ,p.protocolo_formatado
		-- ,p.sta_protocolo
		-- ,sd.id_secao_documento
		count(vsd.id_versao_secao_documento)
		-- ,vsd.dth_atualizacao
		-- ,vsd.sin_ultima
		FROM documento d
		-- INNER JOIN protocolo p ON d.id_documento = p.id_protocolo
		INNER JOIN secao_documento sd ON d.id_documento = sd.id_documento
		INNER JOIN versao_secao_documento vsd ON sd.id_secao_documento = vsd.id_secao_documento AND vsd.sin_ultima ='N' AND vsd.dth_atualizacao < '2022-02-27 00:00:00'
		WHERE d.sta_documento ='I' AND d.sin_bloqueado ='S'
		ORDER BY d.id_documento ASC
		;

5. Após o término da execução, executar a linha de comando abaixo para visualziar o log:

		tail -n 1000 remover_versoes.log

6. As últimas linhas do log de execução do script deve conter a expressão:
		
		12435 - Remover Versões Assinados – XXXXXXX documentos em xxxxxxxx s
		12436 - "Operação Finalizada".

7. Com a limpeza realizada pelo script os procedimentos de backup e restore do banco de dados do SEI já ficam mais leves e rápidos.
	- Mas se quiser otimizar a tabela "versao_secao_documento" e perceber a diminuição geral de espaço na referida tabela, para o MySQL (por exemplo), é necessário executar o comando abaixo.
	- **Atenção**: o comando abaixo deve ser executado APENAS em janela de manutenção, pois deixa o SEI completamente inoperante durante sua execução, que pode durar algumas horas. Testar antes em uma cópia do banco para estimar com precisão quantas horas levará de execução desse comando no banco.
		
		OPTIMIZE TABLE versao_secao_documento;
		
