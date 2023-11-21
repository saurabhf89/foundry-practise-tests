//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";

interface IWeth {
    function balanceOf(address _owner) external view returns (uint256 balance);

    function deposit() external payable;
}

contract ForkWethTest is Test {
    IWeth public weth;

    function setUp() external {
        weth = IWeth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testWethBalance() public {
        console.log("Balance before deposit: ", weth.balanceOf(address(this)));
        //log_with
        emit log_named_uint(
            "Balance before deposit: ",
            weth.balanceOf(address(this))
        );

        weth.deposit{value: 100}();

        console.log("After deposit Balance :", weth.balanceOf(address(this)));
        emit log_named_uint(
            "After deposit Balance :",
            weth.balanceOf(address(this))
        );
    }
}
