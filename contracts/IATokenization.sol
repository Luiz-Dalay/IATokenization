// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importando os contratos do OpenZeppelin para criação do token ERC721 e controle de contadores
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Definição do contrato IATokenization, que herda de ERC721URIStorage (para armazenar URIs de metadados dos tokens)
contract IATokenization is ERC721URIStorage {
    using Counters for Counters.Counter;
    // Contador para gerar IDs únicos para os tokens
    Counters.Counter private _tokenIdCounter;

    // Endereço do proprietário do contrato
    address public owner;

    // Mapeamentos para controle de acesso e royalties
    mapping(address => uint256) public accessLevels; // Níveis de acesso dos usuários
    mapping(uint256 => uint256) public tokenRoyalties; // Royalties associados aos tokens (percentual em base 10000)

    // Enum para representar os níveis de acesso
    enum AccessLevel { NO_ACCESS, READ_ACCESS, FULL_ACCESS }

    // Construtor do contrato, definindo o nome e símbolo do token ERC721
    constructor() ERC721("IAToken", "IAT") {
        owner = msg.sender;  // O criador do contrato é o proprietário
    }

    // Modifier para permitir que apenas o proprietário execute certas funções
    modifier onlyOwner() {
        require(msg.sender == owner, "Voce nao e o proprietario");
        _; // Continua a execução da função
    }

    // Modifier para garantir que o chamador tenha acesso total
    modifier onlyFullAccess() {
        require(accessLevels[msg.sender] == uint256(AccessLevel.FULL_ACCESS), "Acesso total necessario");
        _; // Continua a execução da função
    }

    // Modifier para garantir que o chamador tenha pelo menos acesso de leitura
    modifier onlyReadAccess() {
        require(accessLevels[msg.sender] >= uint256(AccessLevel.READ_ACCESS), "Acesso de leitura necessario");
        _; // Continua a execução da função
    }

    // Função para definir o nível de acesso de um usuário. Somente o proprietário pode chamar essa função
    function setAccessLevel(address user, uint256 level) external onlyOwner {
        require(level <= uint256(AccessLevel.FULL_ACCESS), "Nivel de acesso invalido");
        accessLevels[user] = level;
    }

    // Função para obter o nível de acesso de um usuário
    function getAccessLevel(address user) external view returns (uint256) {
        return accessLevels[user];
    }

    // Função para obter o valor de royalties de um token específico
    function getRoyalties(uint256 tokenId) public view returns (uint256) {
        return tokenRoyalties[tokenId];
    }

    // Função interna para fornecer a base para as URIs de metadados dos tokens
    function _baseURI() internal pure override returns (string memory) {
        return "https://example.com/metadata/";
    }

    // Função para criar um novo token (minting) e atribuir acesso de leitura ao destinatário
    function mint(address to, string memory description) external onlyFullAccess {
        uint256 tokenId = _tokenIdCounter.current(); // Obtem o ID do próximo token
        _tokenIdCounter.increment(); // Incrementa o contador para o próximo token
        
        // Cria o token e associa uma URI ao token
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, string(abi.encodePacked(_baseURI(), description)));

        // Atribui acesso de leitura ao destinatário do token
        accessLevels[to] = uint256(AccessLevel.READ_ACCESS);  // Acesso de leitura por padrão
    }

    // Função para transferir um token, sem considerar royalties neste processo
    function transferTokenWithRoyalties(address to, uint256 tokenId) external payable {
        // Verifica que nenhum ETH está sendo enviado para a transferência
        require(msg.value == 0, "No ETH should be sent");  // Caso não deseje enviar ETH, verifique isso

        // Realiza a transferência do token
        safeTransferFrom(msg.sender, to, tokenId);
    }

    // Mapeamento para armazenar o endereço do receptor de royalties para cada token
    mapping(uint256 => address) private tokenRoyaltiesReceiver;

    // Função para definir os royalties de um token, incluindo o percentual e o receptor
    function setRoyalties(uint256 tokenId, uint256 royaltiesPercent, address royaltiesReceiver) external {
        // Verifica se o percentual de royalties é válido (não pode ser maior que 100%)
        require(royaltiesPercent <= 10000, "Percentual de royalties invalido.");
        // Verifica se o endereço do receptor de royalties é válido
        require(royaltiesReceiver != address(0), "Endereco do receptor de royalties invalido.");
        
        // Armazena o percentual de royalties e o endereço do receptor
        tokenRoyalties[tokenId] = royaltiesPercent;
        tokenRoyaltiesReceiver[tokenId] = royaltiesReceiver;
    }

    // Função para obter o endereço que receberá os royalties de um token
    function getRoyaltiesReceiver(uint256 tokenId) public view returns (address) {
        address receiver = tokenRoyaltiesReceiver[tokenId];
        // Verifica se o receptor de royalties foi definido
        require(receiver != address(0), "Receptor de royalties nao definido para este token.");
        return receiver;
    }
}