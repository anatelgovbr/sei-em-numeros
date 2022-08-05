-- Limpeza pos restore do SIP
	TRUNCATE sip.infra_auditoria;
	TRUNCATE sip.seq_infra_auditoria;
	TRUNCATE sip.infra_log;
	TRUNCATE sip.seq_infra_log;
	TRUNCATE sip.login;

-- Ajustes no SIP
	UPDATE sip.sistema SET pagina_inicial = 'https://seisu.anatel.gov.br/sip' WHERE sigla = 'SIP';
	UPDATE sip.sistema SET pagina_inicial = 'https://seisu.anatel.gov.br/sei/inicializar.php', web_service = 'http://seisu.anatel.gov.br/sei/controlador_ws.php?servico=sip' WHERE sigla = 'SEI';
	UPDATE sip.orgao SET sin_autenticar = 'N' WHERE (id_orgao = '0');
	
	USE sip;
	SET FOREIGN_KEY_CHECKS = 1;

-- Limpeza pos restore do SEI
	USE sei;
	TRUNCATE sei.infra_auditoria;
	TRUNCATE sei.seq_infra_auditoria;
	TRUNCATE sei.infra_log;
	TRUNCATE sei.seq_infra_log;
	TRUNCATE sei.infra_navegador;
	TRUNCATE sei.seq_infra_navegador;
	
	UPDATE sei.infra_parametro SET valor = 'naoresponda_sei_su@anatel.gov.br' WHERE (nome = 'SEI_EMAIL_SISTEMA');
	UPDATE sei.acesso_externo SET hash_interno = 'hash_fake';
	UPDATE sei.anotacao SET descricao = 'Texto Anotação Fake';
	UPDATE sei.servico SET servidor = '*';
	
	UPDATE sei.contato SET endereco = 'Endereco_fake' WHERE endereco IS NOT NULL;
	UPDATE sei.contato SET complemento = 'Complemento_fake' WHERE complemento IS NOT NULL;
	UPDATE sei.contato SET rg = '222' WHERE rg IS NOT NULL;
	UPDATE sei.contato SET orgao_expedidor = 'SSP_fake' WHERE orgao_expedidor IS NOT NULL;
	UPDATE sei.contato SET dta_nascimento = '1990-01-01 00:00:00' WHERE dta_nascimento IS NOT NULL;
	UPDATE sei.contato SET matricula_oab = '111_fake' WHERE matricula_oab IS NOT NULL;
	UPDATE sei.contato SET matricula = '333_fake' WHERE matricula IS NOT NULL;
	UPDATE sei.contato SET telefone_celular = '(dd) 12345-6789' WHERE telefone_celular IS NOT NULL;
	UPDATE sei.contato SET telefone_comercial = '(dd) 1234-5678' WHERE telefone_comercial IS NOT NULL;
	UPDATE sei.contato SET telefone_residencial = '(dd) 1234-5678' WHERE telefone_residencial IS NOT NULL;
	UPDATE sei.contato SET numero_passaporte = '444_fake' WHERE numero_passaporte IS NOT NULL;

	-- Altera a Senha de todos os Usuários Externos para teste123
	UPDATE sei.usuario SET senha = '$2a$12$GH/OQlX6.mZaTJfcSo4Fx.53ltB5WJc6Z2k0y2Fy4u0oBs1JOgGZC' WHERE (senha IS NOT NULL);
	
	-- Apenas se tiver o módulo de Peticionamento e Intimação Eletrônicos
	UPDATE sei.md_pet_int_aceite SET ip = '1.1.1.1';

	-- Apenas se tiver o módulo SEI Correios - Ajustes na Integração do Módulo Correios com o Webservice SIGEP para não gerar Objetos válidos de Produção em testes no SEI SU
	UPDATE sei.md_cor_contrato SET
		numero_contrato_correio = '9992157880',
		numero_cartao_postagem = '0067599079',
		url_webservice = 'https://apphom.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl',
		numero_cnpj = '34028316000103',
		codigo_administrativo = '17000190',
		usuario = 'sigep',
		senha = 'n5f9t8'
		WHERE id_md_cor_contrato = '1';

	-- Apenas se tiver o módulo SEI Julgar - A linha abaixo limpa o conteúdo da Descrição na tabela DESTAQUE do SEI Julgar
	UPDATE sei.destaque SET descricao = 'Conteúdo removido.' WHERE descricao IS NOT NULL;
	
	-- Apenas se tiver o módulo SEI Pesquisa - A linha abaixo altera a "Chave para criptografia dos links de processos e documentos" do SEI Pesquisa Pública para "ch@c3_cr1pt0gr@f1a"
	UPDATE sei.md_pesq_parametro SET valor = 'ch@c3_cr1pt0gr@f1a' WHERE (nome = 'CHAVE_CRIPTOGRAFIA');
	
	-- Apenas se tiver os módulos correspondentes - Desativa Agendamentos de módulos específicos
	UPDATE sei.infra_agendamento_tarefa SET sin_ativo = 'N' WHERE (comando = 'MdEstatisticasAgendamentoRN::coletarIndicadores');
	UPDATE sei.infra_agendamento_tarefa SET sin_ativo = 'N' WHERE (comando = 'PENAgendamentoRN::atualizarInformacoesPEN');
	UPDATE sei.infra_agendamento_tarefa SET sin_ativo = 'N' WHERE (comando = 'PENAgendamentoRN::processarTarefasPEN');

	-- Desativa Agendamentos específicos do core do SEI
	UPDATE sei.infra_agendamento_tarefa SET sin_ativo = 'N' WHERE (comando = 'AgendamentoRN::removerAquivosExternosExcluidos');
	UPDATE sei.infra_agendamento_tarefa SET sin_ativo = 'N' WHERE (comando = 'AgendamentoRN::removerAquivosNaoUtilizados');


	-- Limpeza de conteúdo dos documentos em diversos pontos no banco e generalização do CRC e QR Code para o documento
	UPDATE sei.documento_conteudo SET conteudo = NULL WHERE conteudo IS NOT NULL;
	UPDATE sei.documento_conteudo SET crc_assinatura = '11111111' WHERE crc_assinatura IS NOT NULL;
	UPDATE sei.documento_conteudo SET qr_code_assinatura = NULL WHERE qr_code_assinatura IS NOT NULL;
	
	-- Limpeza do conteúdo de documentos
	UPDATE sei.documento_conteudo SET conteudo_assinatura = NULL WHERE conteudo_assinatura IS NOT NULL;
	
	-- Limpeza do conteúdo de versões das seções dos documentos em geral
	UPDATE sei.versao_secao_documento SET conteudo = '<p>Conteúdo removido.</p>' WHERE conteudo IS NOT NULL;
			
	USE sei;
	SET FOREIGN_KEY_CHECKS = 1;