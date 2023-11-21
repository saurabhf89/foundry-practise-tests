//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;
import {Test, console} from "lib/forge-std/src/Test.sol";

interface IERC20 {
    function allowance(address, address) external view returns (uint256);

    function approve(address usr, uint256 wad) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function totalSupply() external view returns (uint256);
}

interface IUniswapV2 {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

contract MintDaiTest is Test {
    IERC20 public dai;
    address private constant Router01 =
        0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testMintDai() public {
        address Alice = makeAddr("user");

        console.log("Balance before mint : ", dai.balanceOf(Alice));
        emit log_named_uint("Balance before mint :", dai.balanceOf(Alice));
        deal(address(dai), Alice, 1000000e18, true);
        console.log("Balance after mint : ", dai.balanceOf(Alice));
        emit log_named_uint("Balance after mint :", dai.balanceOf(Alice));
    }

    function testSwapDaiToWbtc() public {
        address Bob = makeAddr("Bob");
        deal(address(dai), Bob, 1000000e18, true);
        address to = Bob;
        //dai.transferFrom(Bob, address(this), 1000000e18);
        console.log("bal before ", dai.balanceOf(Bob));
        vm.prank(Bob);
        dai.approve(Router01, 1000000e18); //
        address[] memory path = new address[](3);
        path[0] = address(dai);
        path[1] = WETH;
        path[2] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        //external returns (bool);
        vm.prank(Bob);
        IUniswapV2(Router01).swapExactTokensForTokens(
            1000000e18,
            1,
            path,
            to,
            block.timestamp
        );
        console.log("bal aftr ", dai.balanceOf(Bob));
        console.log(
            "wbtc aftr swap ",
            IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599).balanceOf(Bob)
        );
    }
}
