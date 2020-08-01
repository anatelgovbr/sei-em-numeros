-- Limpeza pos restore do SIP
	TRUNCATE prod_sip3.infra_auditoria;
	TRUNCATE prod_sip3.seq_infra_auditoria;
	TRUNCATE prod_sip3.infra_log;
	TRUNCATE prod_sip3.seq_infra_log;
	TRUNCATE prod_sip3.login;

-- Ajustes no SIP
	UPDATE prod_sip3.sistema SET pagina_inicial = 'https://seisu.anatel.gov.br/sip' WHERE sigla = 'SIP';
	UPDATE prod_sip3.sistema SET pagina_inicial = 'https://seisu.anatel.gov.br/sei/inicializar.php', web_service = 'http://seisu.anatel.gov.br/sei/controlador_ws.php?servico=sip' WHERE sigla = 'SEI';
	UPDATE prod_sip3.orgao SET sin_autenticar = 'N' WHERE (`id_orgao` = '0');
	
	USE prod_sip3;
	SET FOREIGN_KEY_CHECKS = 1;

-- Limpeza pos restore do SEI
	TRUNCATE prod_sei3.infra_auditoria;
	TRUNCATE prod_sei3.seq_infra_auditoria;
	TRUNCATE prod_sei3.infra_log;
	TRUNCATE prod_sei3.seq_infra_log;
	TRUNCATE prod_sei3.infra_navegador;
	TRUNCATE prod_sei3.seq_infra_navegador;

	UPDATE `prod_sei3`.`infra_parametro` SET `valor` = 'naoresponda_sei_su@anatel.gov.br' WHERE (`nome` = 'SEI_EMAIL_SISTEMA');
	UPDATE prod_sei3.acesso_externo SET hash_interno = 'hash_fake';
	UPDATE prod_sei3.anotacao SET descricao = 'Texto Anotação Fake';
	UPDATE prod_sei3.servico SET servidor = '*';
	
	-- Limpeza de conteúdo dos documentos em diversos pontos no banco, inclusive de minutas e versões anteriores do documento
	UPDATE prod_sei3.documento_conteudo SET conteudo = NULL WHERE conteudo IS NOT NULL;
	UPDATE prod_sei3.documento_conteudo SET crc_assinatura = '11111111' WHERE crc_assinatura IS NOT NULL;
	UPDATE prod_sei3.documento_conteudo SET qr_code_assinatura = NULL WHERE qr_code_assinatura IS NOT NULL;
	UPDATE prod_sei3.versao_secao_documento SET conteudo = '<p>Conteúdo removido.</p>' WHERE conteudo IS NOT NULL;
	
	-- Altera a Senha de todos os Usuários Externos para teste123
	UPDATE prod_sei3.usuario SET senha = '$2a$12$GH/OQlX6.mZaTJfcSo4Fx.53ltB5WJc6Z2k0y2Fy4u0oBs1JOgGZC' WHERE (senha IS NOT NULL);
		
	USE prod_sei3;
	SET FOREIGN_KEY_CHECKS = 1;