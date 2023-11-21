//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Safe} from "../src/Safe.sol";

contract SafeTest is Test {
    Safe safe;

    receive() external payable {}

    function setUp() public {
        safe = new Safe();
    }

    function test_Withdraw() public {
        //X balance of this contract
        vm.deal(address(this), 2 ether);
        uint256 preTransfer = address(this).balance;
        uint256 preSafeTransfer = address(safe).balance;
        console.log("Pre Transfer Balance ", preTransfer);
        console.log("Pre Safe  Transfer Balance ", preSafeTransfer);
        payable(address(safe)).transfer(1 ether);

        //Now X-1
        uint256 preBalance = address(this).balance;
        uint256 postTransferSafeBalance = address(safe).balance;
        console.log("Pre withdraw Balance ", preBalance);
        console.log("postTransferSafe Balance ", postTransferSafeBalance);
        safe.withdraw();

        //X
        uint256 postBalance = address(this).balance;
        console.log("Post withdraw Balance ", postBalance);
        assertEq(preBalance + 1 ether, postBalance);
    }

    function testFuzz_Withdraw(uint256 amount) public {
        uint256 preTransferBalance = address(this).balance;
        //x
        payable(address(safe)).transfer(amount);
        //x-amount
        uint256 preWithdrawBalance = address(this).balance;

        safe.withdraw();
        //x
        uint256 postWithdrawBal = address(this).balance;
        assertEq(postWithdrawBal, preTransferBalance);
    }
}
