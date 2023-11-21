//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";

interface ICounter {
    function setNumber(uint256) external;

    function increment() external;
}

contract InterfaceTestCounter is Test {
    function testIncrementingCounter() public {}
}
