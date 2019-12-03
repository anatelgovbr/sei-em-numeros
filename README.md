# SEI em Números - Qlik Sense

Painel de _Business Intelligence_ da Anatel sobre o SEI elaborado na ferramenta Qlik Sense.

## Tutorial

1. Registre-se no site da [Qlik](https://qlikid.qlik.com/register) para criar seu Qlik ID, com usuário e senha.
2. Faça o download do [Qlik Sense Desktop](https://www.qlik.com/pt-br/products/qlik-sense/desktop) e instale.
3. Execute a aplicação e entre com seu usuário e senha criados no **passo 1**
4. Copie o arquivo [SEI_em_Números.qvf](https://softwarepublico.gov.br/gitlab/anatel/sei-em-numeros/repository/archive.zip?ref=master) para a pasta **"Documentos\Qlik\Sense\Apps"** (Windows).
5. Volte para o Qlik Sense Desktop, o aplicativo **SEI em Números** deve aparecer disponível para execução.
6. Na primeira vez que for aberto será exibida uma mensagem dizendo que **"Este aplicativo não contém dados"**. Pressione o botão **"Abrir"**.
7. Será aberta a tela do **"Editor da carga de dados"** para que você crie a conexão com o seu banco de dados do SEI, no seu ambiente.
8. Pressione o botão **"Criar nova conexão"**, no canto superior direito da tela.
9. Selecione o conector correto para o seu banco de dados, na Anatel usamos o **MySQL Enterprise Edition** e continuaremos o tutorial usando este conector.
10. Preencha o host, o nome do banco do sei (p.ex producao_sei3), o usuário com permissões de consulta e sua senha.
	- Recomendamos a adição de dois campos na secção **"Advanced"**
		- Name: **QueryTimeout** 		| Value: **-1**
		- Name: **Timeout**					| Value: **0**
11. Dê um nome para sua conexão usando o campo **"Name"** ao final da modal, por exemplo **SEIPRODUCAO** e Crie/Salve a conexão.
12. Na seção **"Main"**, ao final do script padrão, adicione uma linha para informar o Qlik para usar a conexão criada:

    ```
    (...)
    SET MonthNames='jan;fev;mar;abr;mai;jun;jul;ago;set;out;nov;dez';
    SET LongMonthNames='janeiro;fevereiro;março;abril;maio;junho;julho;agosto;setembro;outubro;novembro;dezembro';
    SET DayNames='seg;ter;qua;qui;sex;sáb;dom';
    SET LongDayNames='segunda-feira;terça-feira;quarta-feira;quinta-feira;sexta-feira;sábado;domingo';
    
    LIB CONNECT TO 'SEIPRODUCAO';
    ```

13. Pressione o botão **"Salvar"** no canto superior esquerdo e em seguida o botão **"Carregar dados"** no canto superior direito.
14. Aguarde a carga de dados, quando estiver completa alterne para a **"Visão geral do aplicativo"** a partir do primeiro botão da barra de ferramentas, logo abaixo das guias.
15. Os painéis deverão estar funcionais com os dados do SEI da sua Instituição.

## _Queries_

Para ter acesso às _queries_ utilizadas na construção do _dashboard_ é muito simples:

1. Alterne para o **"Editor da carga de dados"** a partir do primeiro botão da barra de ferramentas, logo abaixo das guias.
2. Haverão várias seções na lateral esquerda do aplicativo, em fundo cinza escuro.
3. Navegue pelas seções para ter acesso às _queries_ utilizadas.
4. As _queries_ são executadas em sequência, na mesma ordem que as seções são exibidas, de cima para baixo, **NÃO ALTERE ESSA ORDEM** sob pena de a aplicação deixar de funcionar, pois há scripts que dependem de outros.
5. Os nomes das seções procuram representar ao máximo as entidades em que são buscados os dados ou aos painéis do _dashboard_.

## Observações Negociais:

### Painel: Documentos Preparatórios em Processos Concluídos

O mencionado painel tem como base a Hipótese Legal afeta a "Documento Preparatório", conforme Art. 7º, § 3º, da Lei nº 12.527/2011. Dessa forma, no **"Editor da carga de dados"** edite a seção "Documentos Preparatórios em Processo Concluídos" e substitua o id "33" pelo id_hipotese_legal correspondente no SEI da instituição.

### Painel: Protocolos Pendentes de Análise

O mencionado painel tem como base a Hipótese Legal afeta a "Protocolo -Pendente Análise de Restrição de Acesso", conforme Art. 6º, III, da Lei nº 12.527/2011, no caso de protocolização física de documentos pelo Protocolo da instituição e, para salvaguardar possível informação restrita, inclui-se os documentos com esta restrição para as áreas técnicas revisarem após análise do teor do documento. Dessa forma, no **"Editor da carga de dados"** edite a seção "Protocolos Pendentes de Análise" e substitua o id "43" pelo id_hipotese_legal correspondente no SEI da instituição.

### Painel: Publicações Oficiais

Este painel somente tem aplicabilidade/utilidade para instalações do SEI que utilizem a publicação em Boletim de Serviço Eletrônico, utilizando os recursos próprios do SEI afetos à Publicação Interna.

1. Para o correto funcionamento do painel **Publicações Oficiais** é necessário que sejam utilizados os Grupos de Tipos de Documentos, no SEI.
2. Os Grupos que foram convencionados na Anatel são **Publicáveis** e **Publicáveis que Sempre Exigem DOU**, de modo que:
	- Todos os Tipos de Documentos que podem ser publicados no Boletim de Serviço Eletrônico estejam no grupo **Publicáveis**; e
	- Todos os Tipos de Documentos que sempre exigem publicação no DOU estejam no grupo **Publicáveis que Sempre Exigem DOU**.

### Painéis: Peticionamentos e Intimações Eletrônicas

Estes painéis somente tem aplicabilidade/utilidade para instalações do SEI que utilizem o Módulo de Peticionamento e Intimação Eletrônicos na versão 2.0.0 ou superior.