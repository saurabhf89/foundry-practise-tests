//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import "../src/UniswapV2AddLiquidity.sol";
IERC20 constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
IERC20 constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
IERC20 constant pair = IERC20(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);

contract UniswapV2AddRemoveLiTest is Test {
    UniswapV2AddLiquidity uni = new UniswapV2AddLiquidity();

    function safeApprove(IERC20 token, address spender, uint amount) internal {
        (bool success, bytes memory returnData) = address(token).call(
            abi.encodeCall(IERC20.approve, (spender, amount))
        );
        require(
            success &&
                (returnData.length == 0 || abi.decode(returnData, (bool))),
            "Approve fail"
        );
    }

    function testAddLiquidity() public {
        deal(address(USDT), address(this), 1e6 * 1e6);
        assertEq(
            USDT.balanceOf(address(this)),
            1e6 * 1e6,
            "USDT bal incorrect"
        );
        deal(address(WETH), address(this), 1e6 * 1e18);
        assertEq(
            WETH.balanceOf(address(this)),
            1e6 * 1e18,
            "WETH bal incorrect"
        );

        safeApprove(USDT, address(uni), 1e64);
        safeApprove(WETH, address(uni), 1e64);

        uni.addLiquidity(address(WETH), address(USDT), 1e18, 1600 * 1e6);
    }

    function testRemoveLiquidity() public {
        //address =makeAddr();

        deal(address(pair), address(uni), 1e10);
        assertEq(pair.balanceOf(address(uni)), 1e10, "pair bal incorrect");
        //deal(address(WETH), address(this), 1e6 * 1e18);
        assertEq(WETH.balanceOf(address(uni)), 0, "WETH bal non zero");
        assertEq(USDT.balanceOf(address(uni)), 0, "USDT bal non zero");

        // safeApprove(pair, address(uni), 1e64);
        //safeApprove(WETH, address(uni), 1e64);

        uni.removeLiquidity(address(WETH), address(USDT));
        assertEq(pair.balanceOf(address(uni)), 0, "LP tokens non zero!! ");
        //deal(address(WETH), address(this), 1e6 * 1e18);
        //assertFalse((WETH.balanceOf(address(uni)) != 0), "WETH bal non zero");
        // assertFalse((USDT.balanceOf(address(uni)) != 0), "USDT bal non zero");
    }
}
