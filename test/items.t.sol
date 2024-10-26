// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Items.sol";

contract ItemsTest is Test {
    Items itemsContract;
    address owner;
    address nonOwner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this);
        nonOwner = address(0x1);
        user1 = address(0x2);
        user2 = address(0x3);
        
        // Deploy the Items contract with `owner` as the deployer
        itemsContract = new Items();
    }

    function testCreateItem() public {
        // Check initial state
        assertEq(itemsContract.items(), 0, "Initial items count should be zero");

        // Create an item
        string memory desc = "Sword of Power";
        itemsContract.createItem(desc, user1);

        // Check updated state
        assertEq(itemsContract.items(), 1, "Items count should be one");
        assertEq(itemsContract.itemDesc(0), desc, "Item description should match");
        assertEq(itemsContract.itemOwner(0), user1, "Item owner should be user1");
    }

    function testFailNonOwnerCannotCreateItem() public {
        // Try to create an item as a non-owner, expecting a failure
        vm.prank(nonOwner);
        itemsContract.createItem("Shield of Invulnerability", user2);
    }

    function testMintItemByOwner() public {
        // Create an item as the owner
        itemsContract.createItem("Sword of Justice", user1);

        // Mint item as the owner
        itemsContract.mintItem(user1, 0);

        // Check balance
        assertEq(itemsContract.balanceOf(user1, 0), 1, "User1 should own one unit of item type 0");
    }

    function testMintItemByItemOwner() public {
        // Create an item and set user1 as the item owner
        itemsContract.createItem("Shield of Valor", user1);

        // Mint item as user1 (who is the owner of the item)
        vm.prank(user1);
        itemsContract.mintItem(user1, 0);

        // Check balance
        assertEq(itemsContract.balanceOf(user1, 0), 1, "User1 should own one unit of item type 0");
    }

    function testFailMintItemByNonOwner() public {
        // Create an item with user1 as the item owner
        itemsContract.createItem("Axe of Fury", user1);

        // Try to mint item as a non-owner (should fail)
        vm.prank(nonOwner);
        itemsContract.mintItem(nonOwner, 0);
        itemsContract.mintItem(nonOwner, 0);

        assertEq(itemsContract.balanceOf(nonOwner, 0), 0, "Non-owner should not own any units of item type 0");
    }

    function testFailMintItemWithInvalidItemType() public {
        // Try to mint an item that doesn’t exist
        vm.expectRevert();
        itemsContract.mintItem(user1, 999);
    }
}
