// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter count;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        count = new Counter();

        vm.stopBroadcast();
    }
}
