//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;
import {Test, console} from "lib/forge-std/src/Test.sol";

interface IERC20 {
    function approve(address usr, uint256 wad) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function totalSupply() external view returns (uint256);
}

//NOTE
//@audit-ok
//@note
//@audit-issue reentrancy
interface IUniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

interface IUniswapV2 {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
}

contract UniswapV2AddLiquidity {
    address private constant FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant V2Router01 =
        0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;
    event Log(string message, uint256 val);

    function safeTransferFrom(
        IERC20 token,
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        (bool success, bytes memory data) = address(token).call(
            abi.encodeCall(IERC20.transferFrom, (_from, _to, _amount))
        );

        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "Transfer from Failed"
        );
    }

    function safeApprove(
        IERC20 token,
        address _spender,
        uint256 _amount
    ) public {
        (bool success, bytes memory data) = address(token).call(
            abi.encodeCall(IERC20.approve, (_spender, _amount))
        );

        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "Approve Failed"
        );
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint _amountA,
        uint _amountB
    ) external {
        //transferring tokens to contract
        //IERC20(tokenA).transferFrom(msg.sender, address(this), _amountA);
        //IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
        safeTransferFrom(IERC20(tokenA), msg.sender, address(this), _amountA);
        safeTransferFrom(IERC20(tokenB), msg.sender, address(this), _amountB);
        //IERC20(tokenA).approve(V2Router01, amountA);
        //IERC20(tokenB).approve(V2Router01, amountB);
        safeApprove(IERC20(tokenA), V2Router01, _amountA);
        safeApprove(IERC20(tokenB), V2Router01, _amountB);

        (uint amountA, uint amountB, uint liquidity) = IUniswapV2(V2Router01)
            .addLiquidity(
                tokenA,
                tokenB,
                _amountA,
                _amountB,
                1,
                1,
                address(this),
                block.timestamp
            );

        emit Log("TokenA deposited:", amountA);
        emit Log("TokenB deposited:", amountB);
        emit Log("Liquidity received :", liquidity);
    }

    function removeLiquidity(address _tokenA, address _tokenB) external {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        uint liquidity = IERC20(pair).balanceOf(address(this));
        emit Log("LP tokens to remove :", liquidity);

        safeApprove(IERC20(pair), V2Router01, liquidity);

        (uint amountA, uint amountB) = IUniswapV2(V2Router01).removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        );

        emit Log("TokenA sent back:", amountA);
        emit Log("TokenB sent back :", amountB);
    }
}
