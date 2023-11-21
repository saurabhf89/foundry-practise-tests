// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//import "lib/forge-std/src/Test.sol";

////import "../src/Counter.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
