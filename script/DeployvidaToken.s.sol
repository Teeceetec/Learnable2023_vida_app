//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {vida} from "../src/vida.sol";

contract Deployvida is Script {
    string public constant TOKEN_NAME = "vida";
    string public constant TOKEN_SYMBOL = "VD";
    uint8 public constant DECIMALS = 18;
    uint256 public constant TOTAL_SUPPLY = 70000000;

    function run() external returns (vida) {
        vm.startBroadcast();
        vida vid = new vida(TOKEN_NAME, TOKEN_SYMBOL, DECIMALS, TOTAL_SUPPLY);
        vm.stopBroadcast();
        return vid;
    }
}
