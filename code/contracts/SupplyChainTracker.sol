// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SupplyChainTracker {
    
    // Definição da estrutura que representa um produto
    struct Product {
        uint id;                   // ID único do produto
        string name;               // Nome do produto
        string description;        // Descrição do produto
        string currentLocation;    // Localização atual do produto na cadeia de suprimentos
        address owner;             // Endereço do proprietário do produto
        bool exists;               // Flag para verificar se o produto existe
    }
    
    uint private nextProductId = 1;                    // Contador interno do ID do produto
    mapping(uint => Product) private products;         // Mapeamento de ID para o produto

    // Eventos de rastreamento
    event ProductRegistered(uint id, string name, address owner);
    event LocationUpdated(uint id, string newLocation);
    event OwnershipTransferred(uint id, address newOwner);

    // Modificador para garantir que apenas o proprietário atual possa executar certas funções
    modifier onlyOwner(uint productId) {
        require(products[productId].owner == msg.sender, "Only the current owner can perform this action");
        _;
    }
    
    // Função para registrar um produto na blockchain
    function registerProduct(string memory _name, string memory _description, string memory _initialLocation) public {
        uint productId = nextProductId;
        
        products[productId] = Product(productId, _name, _description, _initialLocation, msg.sender, true);
        
        nextProductId++; 
        emit ProductRegistered(productId, _name, msg.sender);
    }

    // Função para atualizar a localização de um produto, acessível apenas pelo proprietário atual
    function updateLocation(uint productId, string memory newLocation) public onlyOwner(productId) {
        require(products[productId].exists, "Product not found");

        products[productId].currentLocation = newLocation;
        emit LocationUpdated(productId, newLocation);
    }

    // Função para transferir a posse de um produto para outro proprietário
    function transferOwnership(uint productId, address newOwner) public onlyOwner(productId) {
        require(products[productId].exists, "Product not found");

        products[productId].owner = newOwner;
        emit OwnershipTransferred(productId, newOwner);
    }
    
    // Função para consultar as informações de um produto
    function getProductInfo(uint productId) public view returns (string memory name, string memory description, string memory currentLocation, address owner) {
        require(products[productId].exists, "Product not found");
        
        Product memory product = products[productId];
        return (product.name, product.description, product.currentLocation, product.owner);
    }
}