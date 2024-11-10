    // Function to purchase an item
    function purchaseItem(uint _itemId) public payable {
        Item storage item = items[_itemId];
        require(item.isAvailable, "Item not available");
        require(item.quantity > 0, "Item out of stock");
        require(msg.value == item.price, "Incorrect payment amount");

        item.quantity--;
        payable(item.seller).transfer(msg.value);
        emit ItemSold(_itemId, msg.sender, item.price);
        
        // If the item is sold out, mark it as unavailable
        if (item.quantity == 0) {
            item.isAvailable = false;
        }
    }
}
