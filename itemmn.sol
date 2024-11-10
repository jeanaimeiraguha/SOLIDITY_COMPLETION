// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Item {
        string name;
        string description;
        uint price;
        uint quantity;
        address seller;
        bool isAvailable;
    }

    mapping(uint => Item) public items; // Mapping from item ID to Item
    mapping(address => uint[]) public sellerItems; // Mapping from seller address to item IDs

    uint public itemCount;

    // Event to notify when an item is listed or updated
    event ItemListed(uint itemId, string name, uint price, uint quantity, address seller);
    event ItemSold(uint itemId, address buyer, uint price);

    // Function to list an item
    function listItem(string memory _name, string memory _description, uint _price, uint _quantity) public {
        require(_price > 0, "Price must be greater than zero");
        require(_quantity > 0, "Quantity must be greater than zero");

        itemCount++;
        items[itemCount] = Item({
            name: _name,
            description: _description,
            price: _price,
            quantity: _quantity,
            seller: msg.sender,
            isAvailable: true
        });

        sellerItems[msg.sender].push(itemCount);
        emit ItemListed(itemCount, _name, _price, _quantity, msg.sender);
    }

    // Function to edit an item (only for the owner)
    modifier onlyOwner(uint _itemId) {
        require(items[_itemId].seller == msg.sender, "You are not the owner of this item");
        _;
    }

    function editItem(uint _itemId, string memory _name, string memory _description, uint _price, uint _quantity) public onlyOwner(_itemId) {
        Item storage item = items[_itemId];
        item.name = _name;
        item.description = _description;
        item.price = _price;
        item.quantity = _quantity;
        emit ItemListed(_itemId, _name, _price, _quantity, msg.sender);
    }

    // Function to delete an item (only for the owner)
    function deleteItem(uint _itemId) public onlyOwner(_itemId) {
        delete items[_itemId];
        emit ItemListed(_itemId, "", 0, 0, msg.sender);
    }
}
