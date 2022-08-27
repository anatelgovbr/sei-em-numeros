<?php

	require_once dirname(__FILE__).'/../web/SEI.php';
	session_start();
	SessaoSEI::getInstance(false);

	class BancoSEI_ extends InfraMySqli {
		private static $instance = null;
		private static $bolScript = false;
		private $strUsuario = null;
		private $strSenha = null;

		public static function getInstance() {
			if (self::$instance == null) {
				self::$instance = new BancoSEI_();
			}
			return self::$instance;
		}

		public function setBolScript($bolScript){
			self::$bolScript = $bolScript;
		}

		public function getServidor() {
			return ConfiguracaoSEI::getInstance()->getValor('BancoSEI','Servidor');
		}

		public function getPorta() {
			return ConfiguracaoSEI::getInstance()->getValor('BancoSEI','Porta');
		}

		public function getBanco() {
			return ConfiguracaoSEI::getInstance()->getValor('BancoSEI','Banco');
		}

		public function getUsuario(){
			if ($this->strUsuario != null) {
				return $this->strUsuario;
			}else{
				return ConfiguracaoSEI::getInstance()->getValor('BancoSEI', 'Usuario');
			}
		}

		public function getSenha(){
			if ($this->strSenha != null) {
				return $this->strSenha;
			}else{
				return ConfiguracaoSEI::getInstance()->getValor('BancoSEI', 'Senha');
			}
		}
		public function setUsuario($strUsuario){
			$this->strUsuario = $strUsuario;
		}

		public function setSenha($strSenha){
			$this->strSenha = $strSenha;
		}

		public function isBolManterConexaoAberta(){
			return true;
		}

		public function isBolForcarPesquisaCaseInsensitive(){
			return !ConfiguracaoSEI::getInstance()->getValor('BancoSEI', 'PesquisaCaseInsensitive', false, false);
		}

		public function isBolConsultaRetornoAssociativo(){
			return true;
		}

		public function isBolUsarPreparedStatement(){
			return ConfiguracaoSEI::getInstance()->getValor('BancoSEI', 'PreparedStatement', false, true);
		}
	}

	// Adicionado para requerer a autenticacao do usuario, nao presente SEI-3.1
	function solicitarAutenticacao(InfraIBanco $objInfraIBanco){

		$command = "/usr/bin/env bash -c 'read -p \"".addslashes("Usuario do Banco: ")."\" myuser && echo \$myuser'";
		$strUsuario = trim(shell_exec($command));
		if (empty($strUsuario)) {
			die("Usuario do banco deve ser informado.\n");
		}
		$objInfraIBanco->setUsuario($strUsuario);

		$command = "/usr/bin/env bash -c 'read -s -p \"".addslashes("Senha: ")."\" mypassword && echo \$mypassword'";
		$strSenha = trim(shell_exec($command));
		if (empty($strSenha)) {
			die("Senha do usuario do banco deve ser informada.\n");
		}
		$objInfraIBanco->setSenha($strSenha);

		shell_exec("/usr/bin/env bash -c 'read -p \"".addslashes("\nPressione ENTER para continuar...")."\"'");

	}

	try{

		$mesesCorte = null;

		// Ajustado para permitir a execucao tanto via linha de comando quanto via browser
		if(PHP_SAPI == 'cli'){

			if ($argc != 2){
				die("USO: ".basename(__FILE__) ." [parametro do numero de meses da assinatura nao encontrado]\n");
			}
			if (!is_numeric($argv[1]) || $argv[1] <= 0){
				die("Numero de meses invalido.\n");
			}
			$mesesCorte = $argv[1];

			// Solicita autenticacao
			solicitarAutenticacao(BancoSEI_::getInstance());

		}else{
			if(!is_numeric($_GET['meses_corte']) || $_GET['meses_corte'] <= 0){
				die("Numero de meses invalido.\n");
			}
			$mesesCorte = $_GET['meses_corte'];
		}

		InfraDebug::getInstance()->setBolLigado(false);
		InfraDebug::getInstance()->setBolDebugInfra(false);
		InfraDebug::getInstance()->setBolEcho(true);
		InfraDebug::getInstance()->limpar();

		$objInfraException = new InfraException();

		ini_set('max_execution_time', '0');
		ini_set('memory_limit', '-1');

		$numSeg = InfraUtil::verificarTempoProcessamento();

		$strIdentificacao = 'Remover Versoes Assinados - ';

		InfraDebug::getInstance()->gravar(InfraString::excluirAcentos($strIdentificacao.'Iniciando...'));

		// Vai buscar a data da primeira atividade no sistema. Sera a data final de execucao do script
		$objAtividadeDTO = new AtividadeDTO();
		$objAtividadeDTO->retDthAbertura();
		$objAtividadeDTO->setOrdDthAbertura(InfraDTO::$TIPO_ORDENACAO_ASC);
		$objAtividadeDTO->setNumMaxRegistrosRetorno(1);

		$objAtividadeRN = new AtividadeRN();
		$objAtividadeDTO = $objAtividadeRN->consultarRN0033($objAtividadeDTO);

		$numTotal = 0;

		if ($objAtividadeDTO) {

			$dtaInicial = InfraData::calcularData($mesesCorte, InfraData::$UNIDADE_MESES, InfraData::$SENTIDO_ATRAS);
			$dtaFinal = substr($objAtividadeDTO->getDthAbertura(), 0, 10);

			InfraDebug::getInstance()->gravar(InfraString::excluirAcentos('De ' . $dtaInicial.' ate '.$dtaFinal.' - diff: '.InfraData::compararDatas($dtaFinal, $dtaInicial) .' dias.'));

			$objAssinaturaRN = new AssinaturaRN();
			$objDocumentoRN = new DocumentoRN();

			while (InfraData::compararDatas($dtaFinal, $dtaInicial) >= 0):

				InfraDebug::getInstance()->gravar(InfraString::excluirAcentos(InfraData::compararDatas($dtaFinal, $dtaInicial) . ' dias' ));

				$objAssinaturaDTO = new AssinaturaDTO();
				$objAssinaturaDTO->setDistinct(true);
				// Adicionando IdAtividade para permitir a verificacao se o tipo de tarefa da atividade = assinatura doc
				$objAssinaturaDTO->retNumIdAtividade();
				$objAssinaturaDTO->retDblIdDocumento();
				$objAssinaturaDTO->adicionarCriterio(
					array('AberturaAtividade', 'AberturaAtividade'),
					array(InfraDTO::$OPER_MAIOR_IGUAL, InfraDTO::$OPER_MENOR_IGUAL),
					array($dtaInicial.' 00:00:00', $dtaInicial.' 23:59:59'),
					InfraDTO::$OPER_LOGICO_AND
				);
				$arrObjAssinaturaDTO = $objAssinaturaRN->listarRN1323($objAssinaturaDTO);

				$numDocs = 0;

				foreach ($arrObjAssinaturaDTO as $objAssinaturaDTO) {

					// Verifica se a tarefa da Atividade e do tipo assinatura de documento
					$objAtividadeDTO = new AtividadeDTO();
					$objAtividadeDTO->setNumIdTarefa(TarefaRN::$TI_ASSINATURA_DOCUMENTO);
					$objAtividadeDTO->setNumIdAtividade($objAssinaturaDTO->getNumIdAtividade());
					$countAtividade = (new AtividadeRN())->contarRN0035($objAtividadeDTO);

					// Verifica se o Documento esta bloqueado e e do tipo Interno
					$objDocumentoDTO = new DocumentoDTO();
					$objDocumentoDTO->setDblIdDocumento($objAssinaturaDTO->getDblIdDocumento());
					$objDocumentoDTO->setStrSinBloqueado('S');
					$objDocumentoDTO->setStrStaDocumento(DocumentoRN::$TD_EDITOR_INTERNO);
					$countDocumento = (new DocumentoRN())->contarRN0007($objDocumentoDTO);

					if($countAtividade > 0 && $countDocumento == 1){

						// Bloqueia a row na tabela documento para nao sofrer updates durente o expurgo
						$objDocumentoDTO = new DocumentoDTO();
						$objDocumentoDTO->setDblIdDocumento($objAssinaturaDTO->getDblIdDocumento());
						(new DocumentoRN())->bloquear($objDocumentoDTO);

						// Recupera as versoes das secoes do documento
						$objVersaoSecaoDocumentoDTO = new VersaoSecaoDocumentoDTO();
						$objVersaoSecaoDocumentoDTO->retDblIdVersaoSecaoDocumento();
						$objVersaoSecaoDocumentoDTO->retNumIdUsuario();
						$objVersaoSecaoDocumentoDTO->retNumIdUnidade();
						$objVersaoSecaoDocumentoDTO->retDthAtualizacao();
						$objVersaoSecaoDocumentoDTO->retNumVersao();
						$objVersaoSecaoDocumentoDTO->retStrSinUltima();
						$objVersaoSecaoDocumentoDTO->setDblIdDocumentoSecaoDocumento($objDocumentoDTO->getDblIdDocumento());
						$objVersaoSecaoDocumentoDTO->setOrdNumVersao(InfraDTO::$TIPO_ORDENACAO_DESC);

						$objVersaoSecaoDocumentoRN = new VersaoSecaoDocumentoRN();
						$arr = InfraArray::indexarArrInfraDTO($objVersaoSecaoDocumentoRN->listar($objVersaoSecaoDocumentoDTO), 'SinUltima', true);

						if (isset($arr['S'])){

							// Pega os dados da ultima versao
							$numVersao = $arr['S'][0]->getNumVersao();
							$numIdUsuario = $arr['S'][0]->getNumIdUsuario();
							$numIdUnidade = $arr['S'][0]->getNumIdUnidade();
							$dthAtualizacao = $arr['S'][0]->getDthAtualizacao();

							// Monta o array das versoes que serao atualizadas
							$arrIdAtualizacao = array();
							foreach($arr['S'] as $dto){
								if ($dto->getNumVersao()!=$numVersao){
									$arrIdAtualizacao[] = $dto->getDblIdVersaoSecaoDocumento();
								}
							}

							// Atualiza as demais versoes com a mesma versao, usuario, unidade e data de atualizacao da ultima versao
							if (count($arrIdAtualizacao)){
								$sql = 'update versao_secao_documento '.
									'set versao='.$numVersao .', id_usuario='.$numIdUsuario.', id_unidade='.$numIdUnidade.', dth_atualizacao='.BancoSEI::getInstance()->formatarGravacaoDth($dthAtualizacao).' '.
									'where id_versao_secao_documento in('.implode(',', $arrIdAtualizacao).')';
								BancoSEI::getInstance()->executarSql($sql);
							}
						}

						// Deleta as versoes que nao sao a ultima
						if (isset($arr['N'])){
							$arrIdExclusao = InfraArray::converterArrInfraDTO($arr['N'],'IdVersaoSecaoDocumento');
							$sql = 'delete from versao_secao_documento where id_versao_secao_documento in('.implode(',', $arrIdExclusao).')';
							BancoSEI::getInstance()->executarSql($sql);
						}

						$numDocs++;

					}

					if ($numDocs) {
						InfraDebug::getInstance()->gravar($dtaInicial.' ('.$numDocs.' documentos)');
						$numTotal += $numDocs;
					}

				}

				$dtaInicial = InfraData::calcularData(1, InfraData::$UNIDADE_DIAS, InfraData::$SENTIDO_ATRAS, $dtaInicial);

			endwhile;

		}

		$numSeg = InfraUtil::verificarTempoProcessamento($numSeg);

		InfraDebug::getInstance()->gravar(InfraString::excluirAcentos('Total de ' . InfraUtil::formatarMilhares($numTotal).' documentos em '.InfraData::formatarTimestamp($numSeg)));
		InfraDebug::getInstance()->gravar(InfraString::excluirAcentos('Operacao finalizada.'));

		exit;

	}catch(Exception $e){
		if ($e instanceof InfraException && $e->contemValidacoes()){
			die(InfraString::excluirAcentos($e->__toString())."\n");
		}

		echo(InfraException::inspecionar($e));

		try{LogSEI::getInstance()->gravar(InfraException::inspecionar($e));	}catch (Exception $e){}
	}
?>