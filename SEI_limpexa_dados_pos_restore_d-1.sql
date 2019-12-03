-- Limpeza pos restore do SEI
	truncate prod_sei3.infra_auditoria;
	truncate prod_sei3.seq_infra_auditoria;
	truncate prod_sei3.infra_log;
	truncate prod_sei3.seq_infra_log;
	truncate prod_sei3.infra_navegador;
	truncate prod_sei3.seq_infra_navegador;

	update prod_sei3.acesso_externo set hash_interno = 'hash_fake';
	update prod_sei3.anotacao set descricao = 'Texto Anotação Fake';
	update prod_sei3.servico set servidor = '*';
	
	-- A linha abaixo limpa o conteúdo de documentos, EXCETO dos Publicados no BSE
	update prod_sei3.documento_conteudo dc
		left join (select distinct id_documento from prod_sei3.publicacao) as dp using (id_documento)
    set conteudo_assinatura = null
		where dc.conteudo_assinatura is not null and dp.id_documento is null;
	
	-- Limpeza de conteúdo dos documentos em diversos pontos no banco, inclusive de minutas e versões anteriores do documento
	update prod_sei3.documento_conteudo set conteudo = null
		where conteudo is not null;
	update prod_sei3.documento_conteudo set crc_assinatura = '11111111'
		where crc_assinatura is not null;
	update prod_sei3.documento_conteudo set qr_code_assinatura = null
		where qr_code_assinatura is not null;
	update prod_sei3.versao_secao_documento set conteudo = '<p>Conte&uacute;do removido.</p>'
		where conteudo is not null;

-- Limpeza pos restore do SIP
	truncate prod_sip3.infra_auditoria;
	truncate prod_sip3.seq_infra_auditoria;
	truncate prod_sip3.infra_log;
	truncate prod_sip3.seq_infra_log;
	truncate prod_sip3.login;

-- Ajustes no SIP
    UPDATE prod_sip3.sistema SET pagina_inicial = "https://seisu.anatel.gov.br/sip" where sigla like "SIP";
    UPDATE prod_sip3.sistema SET pagina_inicial = "https://seisu.anatel.gov.br/sei/inicializar.php", web_service = "http://seisu.anatel.gov.br/sei/controlador_ws.php?servico=sip" where sigla like "SEI";
	UPDATE prod_sip3.orgao SET sin_autenticar = 'N' WHERE (`id_orgao` = '0');