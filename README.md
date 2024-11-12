# IATokenization: Tokenização de Acessos e Royalties

Este projeto é uma implementação de um contrato inteligente para a tokenização de acessos e gerenciamento de royalties, utilizando o Ethereum e a biblioteca OpenZeppelin. O contrato inteligente desenvolvido permite a criação e gestão de tokens ERC721, incluindo funcionalidades de controle de acesso para diferentes níveis de usuários e a definição de royalties para cada token criado.

## Sumário
- [Visão Geral do Projeto](#visão-geral-do-projeto)
- [Funcionalidades](#funcionalidades)
- [Arquitetura do Contrato Inteligente](#arquitetura-do-contrato-inteligente)
- [Funções e Métodos](#funções-e-métodos)
  - [setAccessLevel](#setAccessLevel)
  - [getAccessLevel](#getAccessLevel)
  - [mint](#mint)
  - [transferTokenWithRoyalties](#transferTokenWithRoyalties)
  - [setRoyalties](#setRoyalties)
  - [getRoyaltiesReceiver](#getRoyaltiesReceiver)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Como Executar o Projeto](#como-executar-o-projeto)
- [Licença](#licença)

## Visão Geral do Projeto
Este contrato inteligente foi desenvolvido para fornecer uma solução de tokenização para a gestão de acessos e royalties em uma plataforma de blockchain. Ele permite:
1. Criar tokens únicos (ERC721) e associá-los a um endereço específico.
2. Definir níveis de acesso para usuários.
3. Gerenciar royalties associados a tokens.
4. Realizar transferências de tokens com royalties.

## Funcionalidades
- **Controle de Acessos**: Permite definir diferentes níveis de acesso para os usuários, como "sem acesso", "acesso de leitura" e "acesso total".
- **Royalties**: Permite definir royalties para tokens específicos, incluindo o endereço do receptor dos royalties.
- **Tokenização**: Criação e emissão de tokens ERC721, associando-os a descrições únicas.
- **Transferência de Tokens com Royalties**: Facilita a transferência de tokens entre endereços, sem o cálculo direto de royalties no momento da transferência.

## Arquitetura do Contrato Inteligente
O contrato `IATokenization` herda a funcionalidade do contrato `ERC721URIStorage` da OpenZeppelin para gerenciar tokens não fungíveis (NFTs) e seus dados associados. Ele também usa a biblioteca `Counters` da OpenZeppelin para gerenciar o incremento de IDs de tokens.

- **Proprietário do Contrato**: Somente o criador do contrato (definido durante a implantação) pode configurar os níveis de acesso.
- **Mapeamento de Acesso**: Define os níveis de acesso para cada usuário.
- **Royalties por Token**: Cada token pode ter um percentual de royalties associado, e um endereço receptor desses royalties.

## Funções e Métodos

### `setAccessLevel`
- **Descrição**: Define o nível de acesso de um usuário. O proprietário do contrato pode atribuir um nível de acesso a qualquer endereço.
- **Parâmetros**:
  - `user`: Endereço do usuário.
  - `level`: Nível de acesso (0: Nenhum, 1: Leitura, 2: Acesso Total).
- **Requerimentos**: Apenas o proprietário do contrato pode chamar essa função.

### `getAccessLevel`
- **Descrição**: Retorna o nível de acesso de um usuário.
- **Parâmetros**:
  - `user`: Endereço do usuário.
- **Retorno**: Retorna o nível de acesso do usuário (0: Nenhum, 1: Leitura, 2: Acesso Total).

### `mint`
- **Descrição**: Cria um novo token e o emite para o endereço fornecido. O token é associado a uma descrição única.
- **Parâmetros**:
  - `to`: Endereço que receberá o token.
  - `description`: Descrição associada ao token.
- **Requerimentos**: Apenas usuários com acesso total podem emitir tokens.

### `transferTokenWithRoyalties`
- **Descrição**: Transfere a posse de um token para outro endereço. No momento, a função não realiza cálculos de royalties.
- **Parâmetros**:
  - `to`: Endereço que receberá o token.
  - `tokenId`: ID do token que está sendo transferido.
- **Requerimentos**: Não é necessário enviar ETH, já que os royalties não são calculados na transferência.

### `setRoyalties`
- **Descrição**: Define o percentual de royalties e o receptor de royalties para um token específico.
- **Parâmetros**:
  - `tokenId`: ID do token para o qual os royalties são definidos.
  - `royaltiesPercent`: Percentual de royalties a ser cobrado (10000 representa 100%).
  - `royaltiesReceiver`: Endereço do receptor dos royalties.
- **Requerimentos**: O percentual de royalties deve ser um valor válido (até 100%).

### `getRoyaltiesReceiver`
- **Descrição**: Retorna o endereço que receberá os royalties para um token específico.
- **Parâmetros**:
  - `tokenId`: ID do token.
- **Retorno**: Endereço do receptor dos royalties para o token.

## Tecnologias Utilizadas
- **Ethereum**: Plataforma de blockchain para execução do contrato inteligente.
- **Solidity**: Linguagem de programação utilizada para escrever os contratos inteligentes.
- **OpenZeppelin**: Biblioteca que fornece contratos inteligentes seguros e reutilizáveis, como `ERC721` e `Counters`.

## Como Executar o Projeto

1. **Configuração do Ambiente**:
   - Instale o [Remix IDE](https://remix.ethereum.org) ou configure o [Truffle](https://www.trufflesuite.com/truffle) ou [Hardhat](https://hardhat.org/) para desenvolvimento local de contratos inteligentes.
   
2. **Implantação no Ethereum**:
   - Compile e implante o contrato na rede Ethereum utilizando Remix ou uma das ferramentas mencionadas.

3. **Interação com o Contrato**:
   - Utilize a interface do Remix ou um script em JavaScript para interagir com o contrato implantado. Você pode chamar funções como `mint()`, `setAccessLevel()` e `setRoyalties()` a partir de uma carteira Ethereum.

## Licença
Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

