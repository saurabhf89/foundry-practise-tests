//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {SafeFuzz} from "../src/SafeFuzz.sol";

contract InvariantSafeTest is Test {
    SafeFuzz safeFuzz;

    function setUp() external {
        safeFuzz = new SafeFuzz();
        vm.deal(address(safeFuzz), 10 ether);
    }

    function invariant_withdrawDepositedBalance() external payable {
        safeFuzz.deposit{value: 1 ether}();
        uint256 balanceBefore = safeFuzz.balance(address(this));

        assertEq(balanceBefore, 1 ether);

        safeFuzz.withdraw();

        uint256 balanceAfter = safeFuzz.balance(address(this));
        assertGt(balanceBefore, balanceAfter);
    }

    receive() external payable {}
}
