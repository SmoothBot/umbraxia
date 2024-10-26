
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Items is ERC1155, Ownable {
    uint256 public items = 0;
    mapping(uint256 => string) public itemDesc;
    mapping(uint256 => address) public itemOwner;

    event ItemCreated(uint256 indexed id, string desc, address owner);

    // todo update uri
    constructor() 
        ERC1155("https://game.example/api/item/{id}.json")
        Ownable(msg.sender)
    {}

    function createItem(string calldata desc, address owner) public onlyOwner {
        itemDesc[items] = desc;
        itemOwner[items] = owner;
        emit ItemCreated(items, desc, owner);
        items++;
    }

    // mint item
    function mintItem(address account, uint256 itemType) public {
        require(
            msg.sender == itemOwner[itemType] || 
            msg.sender == owner(),
             "only item owner can mint"
        );
        _mint(account, itemType, 1, "");
    }
}