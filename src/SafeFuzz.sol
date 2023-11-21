//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

contract SafeFuzz {
    address public seller = msg.sender;
    mapping(address => uint256) public balance;

    function deposit() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balance[msg.sender];
        balance[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Sending etrher failed"); //if(success)
    }

    // function sendEther(address to, uint amount) public {
    //     (bool success, ) = payable(to).call{value: amount}("");
    //     require(success, "send ether failed");
    // }
}
