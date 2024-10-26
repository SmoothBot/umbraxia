// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Items} from "../src/items.sol";

contract Items is Script {
    Items public items;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        items = new Items();

        vm.stopBroadcast();
    }
}
